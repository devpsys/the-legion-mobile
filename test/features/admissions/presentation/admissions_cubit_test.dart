import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/features/admissions/presentation/bloc/admissions_cubit.dart';
import 'package:the_legion_mobile/features/admissions/presentation/bloc/admissions_state.dart';

void main() {
  late AdmissionsCubit cubit;

  setUp(() => cubit = AdmissionsCubit());
  tearDown(() => cubit.close());

  void load() => cubit.load();

  group('loading', () {
    test('starts empty', () {
      expect(cubit.state.status, AdmissionsStatus.initial);
      expect(cubit.state.candidate, isNull);
      expect(cubit.state.needsEmailConfirmation, isFalse);
    });

    test('loads the candidate and the portal content', () {
      load();

      expect(cubit.state.status, AdmissionsStatus.ready);
      expect(cubit.state.candidate, isNotNull);
      expect(cubit.state.candidate!.displayName, 'Musa Ibrahim');
      expect(cubit.state.cycles, isNotEmpty);
      expect(cubit.state.bulletins, isNotEmpty);
      expect(cubit.state.jambResultPending, isTrue);
    });

    test('is idempotent', () {
      load();
      final first = cubit.state;
      load();

      expect(cubit.state, first, reason: 'a second load must not reset');
    });

    test('counts the cycles open now', () {
      load();

      expect(cubit.state.openCyclesAt(DateTime(2026, 10)), hasLength(2));
    });

    test('names the first cycle, or falls back while loading', () {
      expect(cubit.state.cycleLabelFor('Admissions'), 'Admissions');
      load();
      expect(cubit.state.cycleLabelFor('Admissions'), '2026/2027 Cycle');
    });
  });

  group('the email confirmation gate', () {
    setUp(load);

    test('is shown because the address is unconfirmed', () {
      expect(cubit.state.needsEmailConfirmation, isTrue);
    });

    test('hides when the candidate dismisses it', () {
      cubit.dismissEmailBanner();

      expect(cubit.state.needsEmailConfirmation, isFalse);
      expect(
        cubit.state.emailConfirmation,
        EmailConfirmationStatus.idle,
        reason: 'dismissing is not the same as sending',
      );
    });

    test('comes back through restore', () {
      cubit
        ..dismissEmailBanner()
        ..resendEmailLink()
        ..restoreEmailBanner();

      expect(cubit.state.needsEmailConfirmation, isTrue);
      expect(cubit.state.emailConfirmation, EmailConfirmationStatus.idle);
    });

    test('resending moves through sending to sent', () async {
      final seen = <EmailConfirmationStatus>[];
      // Subscribe first: a cubit only delivers states emitted after the
      // listener exists, so registering afterwards would see nothing.
      final subscription = cubit.stream.listen(
        (state) => seen.add(state.emailConfirmation),
      );
      addTearDown(subscription.cancel);

      cubit.resendEmailLink();
      // `Cubit.stream` delivers on a microtask; let one pass before reading.
      await Future<void>.delayed(Duration.zero);

      expect(seen, [
        EmailConfirmationStatus.sending,
        EmailConfirmationStatus.sent,
      ]);
      expect(cubit.state.emailConfirmation, EmailConfirmationStatus.sent);
    });

    test(
      'a sent link stays visible so the candidate sees the confirmation',
      () {
        cubit.resendEmailLink();

        expect(cubit.state.hasSentEmailLink, isTrue);
        expect(cubit.state.needsEmailConfirmation, isTrue);
      },
    );

    test('the banner is not a nag while it is sending', () {
      expect(cubit.state.isSendingEmailLink, isFalse);
      cubit.resendEmailLink();
      expect(
        cubit.state.isSendingEmailLink,
        isFalse,
        reason: 'settles at once',
      );
    });
  });

  group('reset', () {
    test('returns the cubit to its initial state', () {
      load();
      cubit
        ..dismissEmailBanner()
        ..reset();

      expect(cubit.state, const AdmissionsState());
    });
  });
}

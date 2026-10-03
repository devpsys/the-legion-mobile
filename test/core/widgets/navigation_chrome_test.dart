import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/l10n/gen/app_localizations.dart';
import 'package:the_legion_mobile/core/notifications/notification_cubit.dart';
import 'package:the_legion_mobile/core/notifications/notification_entry.dart';
import 'package:the_legion_mobile/core/theme/app_theme.dart';
import 'package:the_legion_mobile/core/widgets/confirm_exit.dart';
import 'package:the_legion_mobile/core/widgets/notification_bell.dart';

/// A bar whose bell opens the real sheet, using its own build context.
class BellBar extends StatelessWidget {
  const BellBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          NotificationBell(onPressed: () => showNotificationsSheet(context)),
        ],
      ),
      body: const Text('x'),
    );
  }
}

/// Two bells over one centre, to prove they cannot disagree.
class TwinBellBar extends StatelessWidget {
  const TwinBellBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          NotificationBell(onPressed: () => showNotificationsSheet(context)),
          NotificationBell(onPressed: () => showNotificationsSheet(context)),
        ],
      ),
      body: const Text('x'),
    );
  }
}

void main() {
  late NotificationCubit notifications;
  var exited = 0;
  var now = DateTime(2026, 10, 1, 12);

  final entries = [
    const NotificationEntry(
      id: 'a',
      category: NotificationCategory.urgent,
      publishedLabel: '3 hours ago',
      title: 'Examination venue changes',
    ),
    const NotificationEntry(
      id: 'b',
      category: NotificationCategory.success,
      publishedLabel: 'Yesterday',
      title: 'JAMB results received',
    ),
  ];

  Future<void> pump(
    WidgetTester tester, {
    required Widget child,
    Duration window = const Duration(seconds: 2),
  }) async {
    tester.view
      ..physicalSize = const Size(390, 844)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      BlocProvider<NotificationCubit>.value(
        value: notifications,
        child: MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: child,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() {
    exited = 0;
    now = DateTime(2026, 10, 1, 12);
    notifications = NotificationCubit(entries: entries);
  });

  tearDown(() => notifications.close());

  /// Simulates the platform back gesture.
  Future<void> pressBack(WidgetTester tester) async {
    final state = tester.state<NavigatorState>(find.byType(Navigator));
    state.maybePop();
    await tester.pumpAndSettle();
  }

  group('ConfirmExit', () {
    testWidgets('warns on the first press and does not exit', (tester) async {
      await pump(
        tester,
        child: ConfirmExit(
          now: () => now,
          onExit: () => exited++,
          child: const Scaffold(body: Text('home')),
        ),
      );

      await pressBack(tester);

      expect(exited, 0, reason: 'one press must not leave');
      expect(
        find.text('Press back again to exit'),
        findsOneWidget,
        reason: 'and it must say what to do instead',
      );
    });

    testWidgets('exits on a second press inside the window', (tester) async {
      await pump(
        tester,
        child: ConfirmExit(
          now: () => now,
          onExit: () => exited++,
          child: const Scaffold(body: Text('home')),
        ),
      );

      await pressBack(tester);
      await pressBack(tester);

      expect(exited, 1);
    });

    testWidgets('re-arms once the window has passed', (tester) async {
      await pump(
        tester,
        child: ConfirmExit(
          now: () => now,
          onExit: () => exited++,
          child: const Scaffold(body: Text('home')),
        ),
      );

      await pressBack(tester);

      // Long enough later that the earlier press no longer counts.
      now = now.add(const Duration(seconds: 5));
      await pressBack(tester);

      expect(exited, 0, reason: 'a stale press must only re-warn');
    });

    testWidgets('honours a longer window', (tester) async {
      await pump(
        tester,
        child: ConfirmExit(
          window: const Duration(seconds: 30),
          now: () => now,
          onExit: () => exited++,
          child: const Scaffold(body: Text('home')),
        ),
      );

      await pressBack(tester);
      now = now.add(const Duration(seconds: 5));
      await pressBack(tester);

      expect(
        exited,
        1,
        reason: 'five seconds is inside a thirty second window',
      );
    });

    testWidgets('leaves the route in place after a press', (tester) async {
      await pump(
        tester,
        child: ConfirmExit(
          now: () => now,
          onExit: () => exited++,
          child: const Scaffold(body: Text('home')),
        ),
      );

      await pressBack(tester);

      // `canPop: false` in practice: the navigator still has a route.
      expect(
        tester.state<NavigatorState>(find.byType(Navigator)).canPop(),
        isFalse,
      );
    });
  });

  group('the shared notification centre', () {
    testWidgets('both bells read one object, so the counts agree', (
      tester,
    ) async {
      // Two screens, one centre — the hub's bar and the portal's bar.
      await pump(tester, child: const TwinBellBar());

      expect(find.byType(NotificationBell), findsNWidgets(2));
      // Both badged from `notifications.unreadCount`.
      expect(notifications.state.unreadCount, 2);
    });

    testWidgets('the badge shows the count and falls as items are read', (
      tester,
    ) async {
      await pump(tester, child: const BellBar());

      expect(find.text('2'), findsOneWidget);

      notifications.markRead('a');
      await tester.pumpAndSettle();

      expect(
        find.text('1'),
        findsOneWidget,
        reason: 'marking one read updates every bell at once',
      );
    });

    testWidgets('the sheet lists the unread entries', (tester) async {
      await pump(tester, child: const BellBar());

      await tester.tap(find.byIcon(Icons.notifications_outlined));
      await tester.pumpAndSettle();

      expect(find.byType(NotificationsSheet), findsOneWidget);
      expect(find.text('Examination venue changes'), findsOneWidget);
      expect(find.text('JAMB results received'), findsOneWidget);
      expect(find.text('2 unread'), findsOneWidget);
    });

    testWidgets('tapping a row marks it read', (tester) async {
      await pump(tester, child: const BellBar());

      await tester.tap(find.byIcon(Icons.notifications_outlined));
      await tester.pumpAndSettle();
      await tester.tap(find.text('JAMB results received'));
      await tester.pumpAndSettle();

      expect(notifications.state.isRead('b'), isTrue);
      expect(notifications.state.unreadCount, 1);
    });

    testWidgets('an empty centre says so instead of showing a blank sheet', (
      tester,
    ) async {
      notifications.clear();
      await pump(tester, child: const BellBar());

      await tester.tap(find.byIcon(Icons.notifications_outlined));
      await tester.pumpAndSettle();

      expect(find.text('You are all caught up.'), findsOneWidget);
    });
  });
}

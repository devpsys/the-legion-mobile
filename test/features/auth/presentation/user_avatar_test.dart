import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/constants/app_assets.dart';
import 'package:the_legion_mobile/core/l10n/gen/app_localizations.dart';
import 'package:the_legion_mobile/core/theme/app_theme.dart';
import 'package:the_legion_mobile/features/auth/data/datasources/fake/fake_auth_remote_data_source.dart';
import 'package:the_legion_mobile/features/auth/domain/entities/user.dart';
import 'package:the_legion_mobile/features/auth/presentation/widgets/user_avatar.dart';

void main() {
  const user = User(
    id: 'u1',
    email: 'ada@the-legion.dev',
    displayName: 'Ada Lovelace',
  );

  Future<void> pumpAvatar(WidgetTester tester, Widget avatar) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: Center(child: avatar)),
      ),
    );
    await tester.pump();
  }

  /// The provider of the [Image] the widget rendered, if any.
  ImageProvider? providerOf(WidgetTester tester) =>
      tester.widget<Image>(find.byType(Image)).image;

  group('bundled portrait', () {
    testWidgets('is registered in the asset bundle and decodes', (
      tester,
    ) async {
      final bytes = (await rootBundle.load(AppAssets.studentAvatar)).buffer
          .asUint8List();

      expect(bytes, isNotEmpty);

      await tester.runAsync(() async {
        final codec = await ui.instantiateImageCodec(bytes);
        final frame = await codec.getNextFrame();
        // 256px covers the largest avatar in the app (56px at 3x) with room to
        // spare, without shipping a 1MB photo.
        expect(frame.image.width, 256);
        expect(frame.image.height, 256);
        frame.image.dispose();
        codec.dispose();
      });
    });

    test('the fake backend hands it to the demo account', () async {
      final remote = FakeAuthRemoteDataSource(latency: Duration.zero);
      final response = await remote.login(
        email: 'ada@the-legion.dev',
        password: FakeAuthRemoteDataSource.defaultPassword,
      );

      expect(response.user.avatarUrl, AppAssets.studentAvatar);
    });

    test('the demo account can opt out and fall back to initials', () async {
      final remote = FakeAuthRemoteDataSource(
        latency: Duration.zero,
        demoAvatarReference: null,
      );
      final response = await remote.login(
        email: 'ada@the-legion.dev',
        password: FakeAuthRemoteDataSource.defaultPassword,
      );

      expect(response.user.avatarUrl, isNull);
    });
  });

  group('UserAvatar', () {
    testWidgets('loads a bundled asset when the reference is one', (
      tester,
    ) async {
      await pumpAvatar(
        tester,
        UserAvatar(user: user.copyWithAvatar(AppAssets.studentAvatar)),
      );

      expect(providerOf(tester), isA<AssetImage>());
    });

    testWidgets('loads a network image for a remote reference', (tester) async {
      await pumpAvatar(
        tester,
        UserAvatar(user: user.copyWithAvatar('https://cdn.test/ada.png')),
      );

      expect(providerOf(tester), isA<NetworkImage>());
      expect(UserAvatar.isAsset('assets/images/student_avatar.png'), isTrue);
      expect(UserAvatar.isAsset('https://cdn.test/ada.png'), isFalse);
    });

    testWidgets('shows initials when there is no picture', (tester) async {
      await pumpAvatar(tester, const UserAvatar(user: user));

      expect(find.byType(Image), findsNothing);
      expect(find.text('AL'), findsOneWidget);
    });

    testWidgets('sizes itself to the requested box', (tester) async {
      await pumpAvatar(tester, const UserAvatar(user: user, size: 32));

      expect(tester.getSize(find.byType(UserAvatar)), const Size(32, 32));
    });
  });
}

/// Small helper so the tests read as intent rather than as constructors.
extension on User {
  User copyWithAvatar(String? avatarUrl) => User(
    id: id,
    email: email,
    displayName: displayName,
    avatarUrl: avatarUrl,
  );
}

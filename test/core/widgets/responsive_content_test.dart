import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/l10n/gen/app_localizations.dart';
import 'package:the_legion_mobile/core/theme/app_theme.dart';
import 'package:the_legion_mobile/core/widgets/responsive_content.dart';

void main() {
  Widget wrap(Widget child, {Size size = const Size(400, 800)}) {
    return MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MediaQuery(
        data: MediaQueryData(size: size),
        child: Scaffold(body: child),
      ),
    );
  }

  testWidgets('centers a narrow child and applies page padding', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(const ResponsiveContent(child: SizedBox(height: 40, width: 100))),
    );

    final content = tester.getSize(find.byType(SizedBox).first);
    expect(content.width, 100);
    expect(find.byType(ResponsiveContent), findsOneWidget);
  });

  testWidgets('constrains the child on wide viewports', (tester) async {
    await tester.pumpWidget(
      wrap(
        const ResponsiveContent(
          child: SizedBox(height: 40, width: double.infinity),
        ),
        size: const Size(1600, 900),
      ),
    );

    final constrained = tester.getSize(find.byType(SizedBox).first);
    // 1600 - 2 * AppSpacing.md (16)
    expect(constrained.width, lessThanOrEqualTo(1600 - 32));
  });
}

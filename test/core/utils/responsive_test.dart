import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/utils/responsive.dart';

void main() {
  group('resolveScreenSize', () {
    test('maps phone widths to compact', () {
      expect(resolveScreenSize(360), ScreenSize.compact);
      expect(resolveScreenSize(599), ScreenSize.compact);
    });

    test('maps large phones in landscape to medium', () {
      expect(resolveScreenSize(600), ScreenSize.medium);
    });

    test('maps tablets to expanded', () {
      expect(resolveScreenSize(900), ScreenSize.expanded);
      expect(resolveScreenSize(834), ScreenSize.medium);
    });

    test('maps desktop windows to large', () {
      expect(resolveScreenSize(1600), ScreenSize.large);
    });

    test('breakpoints are inclusive', () {
      expect(
        resolveScreenSize(AppDimensions.expandedBreakpoint),
        ScreenSize.expanded,
      );
      expect(
        resolveScreenSize(AppDimensions.largeBreakpoint),
        ScreenSize.large,
      );
    });
  });

  group('ScreenSize helpers', () {
    test('compactOnly matches phones', () {
      expect(ScreenSize.compact.isCompact, isTrue);
      expect(ScreenSize.medium.isCompact, isFalse);
      expect(ScreenSize.medium.isCompactOrMedium, isTrue);
      expect(ScreenSize.compact.isAtLeastExpanded, isFalse);
      expect(ScreenSize.expanded.isAtLeastExpanded, isTrue);
    });
  });
}

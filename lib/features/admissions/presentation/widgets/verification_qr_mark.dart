import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';

/// The square mark printed beside a letter's reference: a framed QR-shaped
/// pattern derived from the verification code.
///
/// A stand-in, not a scanner-readable symbol. The app carries no QR encoder
/// yet, and the design calls for the mark to be there on the page; so the
/// three finder squares are drawn where a reader expects them and the field
/// between is filled from a hash of the code — the same code always draws the
/// same mark, and two letters never share one. Swap [QrMarkPainter] for a
/// real encoder when one is added and nothing else on the letter moves.
class VerificationQrMark extends StatelessWidget {
  const VerificationQrMark({required this.code, super.key});

  /// The verification code the mark stands for.
  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimensions.qrTile,
      height: AppDimensions.qrTile,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: AppRadii.elementRadius,
        border: Border.all(color: AppColors.paperStroke),
      ),
      child: CustomPaint(painter: QrMarkPainter(code: code)),
    );
  }
}

/// Paints the mark for [VerificationQrMark].
///
/// Public so a test can paint it to a recorder and assert on the pattern.
class QrMarkPainter extends CustomPainter {
  const QrMarkPainter({required this.code});

  final String code;

  /// Modules per side: the smallest QR symbol's grid.
  static const int modules = 21;

  /// Side of a finder square, in modules.
  static const int finder = 7;

  @override
  void paint(Canvas canvas, Size size) {
    final module = size.shortestSide / modules;
    final paint = Paint()..color = AppColors.inkBrand;
    var seed = _fnv1a(code);

    for (var row = 0; row < modules; row++) {
      for (var column = 0; column < modules; column++) {
        final bool dark;
        if (_inFinderZone(row, column)) {
          dark = _finderModule(row, column);
        } else {
          seed = _next(seed);
          dark = seed.isOdd;
        }
        if (!dark) continue;
        canvas.drawRect(
          Rect.fromLTWH(column * module, row * module, module, module),
          paint,
        );
      }
    }
  }

  /// `true` inside one of the three finder squares or the one-module gap
  /// that separates each from the data field.
  static bool _inFinderZone(int row, int column) {
    const zone = finder + 1;
    final top = row < zone;
    final bottom = row >= modules - zone;
    final left = column < zone;
    final right = column >= modules - zone;
    return (top && left) || (top && right) || (bottom && left);
  }

  /// The finder square's ring-gap-core pattern at [row], [column].
  static bool _finderModule(int row, int column) {
    final r = row < finder + 1 ? row : row - (modules - finder);
    final c = column < finder + 1 ? column : column - (modules - finder);
    // The separator gap around every square.
    if (r < 0 || c < 0 || r >= finder || c >= finder) return false;
    final ring = r == 0 || c == 0 || r == finder - 1 || c == finder - 1;
    final core = r >= 2 && r <= finder - 3 && c >= 2 && c <= finder - 3;
    return ring || core;
  }

  /// FNV-1a over the code's units: a stable seed on every platform, where
  /// `String.hashCode` is not promised to be.
  static int _fnv1a(String value) {
    var hash = 0x811C9DC5;
    for (final unit in value.codeUnits) {
      hash = ((hash ^ unit) * 0x01000193) & 0xFFFFFFFF;
    }
    return hash;
  }

  /// One step of a 32-bit linear congruential generator.
  static int _next(int seed) => (seed * 1664525 + 1013904223) & 0xFFFFFFFF;

  @override
  bool shouldRepaint(QrMarkPainter oldDelegate) => oldDelegate.code != code;
}

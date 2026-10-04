import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../../../core/widgets/verification_qr_mark.dart';
import '../models/fees_models.dart';

/// The always-light paper of an official e-receipt.
///
/// Drawn as a light document even when the app chrome is dark, so a print
/// or PDF matches what the bursary issues on paper.
class ReceiptDocument extends StatelessWidget {
  const ReceiptDocument({required this.receipt, super.key});

  final OfficialReceipt receipt;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    // Paper is always light for print fidelity.
    const paper = Brightness.light;
    final onPaper = AppColors.textPrimary(paper);
    final muted = AppColors.textMuted(paper);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.paperStroke),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: DefaultTextStyle(
          style: TextStyle(
            color: onPaper,
            fontFamily: AppTextStyles.fontFamily,
            fontSize: AppTextStyles.bodyMediumSize,
            height: AppTextStyles.documentLineHeight,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.feesInstitution,
                          style: TextStyle(
                            color: onPaper,
                            fontWeight: AppTextStyles.bold,
                            fontSize: AppTextStyles.headlineSmallSize,
                          ),
                        ),
                        Text(
                          l10n.feesReceiptOffice,
                          style: TextStyle(color: muted),
                        ),
                        Text(
                          l10n.feesReceiptUnit,
                          style: TextStyle(color: muted),
                        ),
                      ],
                    ),
                  ),
                  StatusTag(
                    label: l10n.feesReceiptBadge,
                    tone: AppTone.success,
                    isUppercase: true,
                  ),
                ],
              ),
              AppSpacing.verticalGap(AppSpacing.xl),
              ReceiptMetaRow(
                label: l10n.feesReceiptNumber,
                value: receipt.receiptNumber,
                isCode: true,
                onPaper: onPaper,
                muted: muted,
              ),
              ReceiptMetaRow(
                label: l10n.feesReceiptDate,
                value: AppDateFormats.longDateTime(locale)
                    .format(receipt.issuedOn),
                onPaper: onPaper,
                muted: muted,
              ),
              ReceiptMetaRow(
                label: l10n.feesReceiptSession,
                value: receipt.session,
                onPaper: onPaper,
                muted: muted,
              ),
              ReceiptMetaRow(
                label: l10n.feesReceiptCentralRrr,
                value: receipt.rrr,
                isCode: true,
                onPaper: onPaper,
                muted: muted,
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              Text(
                l10n.feesReceiptStudentHeading,
                style: TextStyle(
                  color: onPaper,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.sm),
              ReceiptMetaRow(
                label: l10n.feesStudentName,
                value: receipt.studentName,
                onPaper: onPaper,
                muted: muted,
              ),
              ReceiptMetaRow(
                label: l10n.feesMatricNumber,
                value: receipt.matricNumber,
                isCode: true,
                onPaper: onPaper,
                muted: muted,
              ),
              ReceiptMetaRow(
                label: l10n.feesDepartment,
                value: l10n.feesReceiptFacultyProgram(
                  receipt.department,
                  receipt.faculty,
                ),
                onPaper: onPaper,
                muted: muted,
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              Center(
                child: Column(
                  children: [
                    VerificationQrMark(code: receipt.verificationCode),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    Text(
                      l10n.feesReceiptScanToVerify,
                      style: TextStyle(
                        color: muted,
                        fontSize: AppTextStyles.bodySmallSize,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              ReceiptLineHeader(onPaper: onPaper, muted: muted),
              const Divider(),
              for (final line in receipt.lines)
                ReceiptLineRow(line: line, onPaper: onPaper, muted: muted),
              if (receipt.toWalletMinorUnits != null) ...[
                ReceiptMetaRow(
                  label: l10n.feesReceiptToWallet,
                  value: formatNaira(receipt.toWalletMinorUnits!),
                  onPaper: onPaper,
                  muted: muted,
                ),
              ],
              const Divider(),
              ReceiptTotalRow(
                totalMinorUnits: receipt.totalMinorUnits,
                onPaper: onPaper,
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              ReceiptMetaRow(
                label: l10n.feesReceiptChannel,
                value: receipt.channelLabel,
                onPaper: onPaper,
                muted: muted,
              ),
              if (receipt.authCode != null)
                ReceiptMetaRow(
                  label: l10n.feesReceiptAuthCode,
                  value: receipt.authCode!,
                  isCode: true,
                  onPaper: onPaper,
                  muted: muted,
                ),
              ReceiptMetaRow(
                label: l10n.feesReceiptClearingRef,
                value: receipt.clearingReference,
                isCode: true,
                onPaper: onPaper,
                muted: muted,
              ),
              AppSpacing.verticalGap(AppSpacing.xl),
              Center(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppTone.success.foreground(paper),
                      style: BorderStyle.solid,
                      width: AppDimensions.hairline * 2,
                    ),
                    borderRadius: AppRadii.elementRadius,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    child: Text(
                      l10n.feesReceiptStamp.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTone.success.foreground(paper),
                        fontWeight: AppTextStyles.bold,
                        letterSpacing: AppTextStyles.trackingCaps,
                        fontSize: AppTextStyles.labelSmallSize,
                      ),
                    ),
                  ),
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.xl),
              Text(
                l10n.feesReceiptSignatory,
                style: TextStyle(
                  color: onPaper,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                l10n.feesReceiptSignatoryTitle,
                style: TextStyle(color: muted),
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              Text(
                l10n.feesReceiptVerifyUrl,
                style: TextStyle(
                  color: muted,
                  fontSize: AppTextStyles.bodySmallSize,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.xs),
              Text(
                formatReceiptVerificationCode(receipt.verificationCode),
                style: AppTextStyles.codeMedium.copyWith(
                  color: onPaper,
                  fontWeight: AppTextStyles.bold,
                  letterSpacing: AppTextStyles.trackingCode,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One label/value pair on the light receipt paper.
class ReceiptMetaRow extends StatelessWidget {
  const ReceiptMetaRow({
    required this.label,
    required this.value,
    required this.onPaper,
    required this.muted,
    this.isCode = false,
    super.key,
  });

  final String label;
  final String value;
  final Color onPaper;
  final Color muted;
  final bool isCode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: TextStyle(color: muted)),
          ),
          AppSpacing.horizontalGap(AppSpacing.md),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: isCode
                  ? AppTextStyles.codeMedium.copyWith(
                      color: onPaper,
                      fontWeight: AppTextStyles.semiBold,
                    )
                  : TextStyle(color: onPaper, fontWeight: AppTextStyles.medium),
            ),
          ),
        ],
      ),
    );
  }
}

/// Column headers for the fee table: Fee · Status · Amount.
///
/// Status and Amount size to their labels so they never wrap letter-by-letter
/// on a narrow phone; Fee takes whatever width remains.
class ReceiptLineHeader extends StatelessWidget {
  const ReceiptLineHeader({
    required this.onPaper,
    required this.muted,
    super.key,
  });

  final Color onPaper;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final style = TextStyle(color: muted, fontWeight: AppTextStyles.semiBold);

    return Row(
      children: [
        Expanded(child: Text(l10n.feesReceiptFee, style: style)),
        AppSpacing.horizontalGap(AppSpacing.md),
        Text(l10n.feesReceiptLineStatus, style: style),
        AppSpacing.horizontalGap(AppSpacing.lg),
        Text(l10n.feesAmount, style: style),
      ],
    );
  }
}

/// One fee line: name and session on the left, PAID and amount unwrapped on
/// the right at their natural widths.
class ReceiptLineRow extends StatelessWidget {
  const ReceiptLineRow({
    required this.line,
    required this.onPaper,
    required this.muted,
    super.key,
  });

  final OfficialReceiptLine line;
  final Color onPaper;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const paper = Brightness.light;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.label,
                  style: TextStyle(
                    color: onPaper,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
                Text(
                  line.session,
                  style: TextStyle(
                    color: muted,
                    fontSize: AppTextStyles.bodySmallSize,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.md),
          Text(
            l10n.feesReceiptLinePaid.toUpperCase(),
            softWrap: false,
            maxLines: 1,
            style: TextStyle(
              color: AppTone.success.foreground(paper),
              fontWeight: AppTextStyles.bold,
              fontSize: AppTextStyles.labelSmallSize,
              letterSpacing: AppTextStyles.trackingCaps,
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.lg),
          Text(
            formatNaira(line.amountMinorUnits),
            softWrap: false,
            maxLines: 1,
            textAlign: TextAlign.right,
            style: AppTextStyles.tabular(
              AppTextStyles.codeMedium.copyWith(
                color: onPaper,
                fontWeight: AppTextStyles.semiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Total row: label, SETTLED tag, and the figure on one line without wrapping
/// the amount.
class ReceiptTotalRow extends StatelessWidget {
  const ReceiptTotalRow({
    required this.totalMinorUnits,
    required this.onPaper,
    super.key,
  });

  final int totalMinorUnits;
  final Color onPaper;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      children: [
        Expanded(
          child: Text(
            l10n.feesReceiptTotalCleared,
            style: TextStyle(color: onPaper, fontWeight: AppTextStyles.bold),
          ),
        ),
        AppSpacing.horizontalGap(AppSpacing.sm),
        StatusTag(
          label: l10n.feesReceiptSettled,
          tone: AppTone.success,
          isUppercase: true,
        ),
        AppSpacing.horizontalGap(AppSpacing.md),
        Text(
          formatNaira(totalMinorUnits),
          softWrap: false,
          maxLines: 1,
          style: AppTextStyles.tabular(
            AppTextStyles.codeLarge.copyWith(
              color: onPaper,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

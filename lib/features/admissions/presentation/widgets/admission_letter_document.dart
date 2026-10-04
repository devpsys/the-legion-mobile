import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/brand_crest_tile.dart';
import '../models/application_detail_models.dart';
import 'emphasised_text.dart';
import 'verification_qr_mark.dart';

/// The admission letter as a sheet of paper on the screen.
///
/// White in both themes, with its own ink colours: this is a document, not a
/// surface of the app, and the copy a candidate holds up to a landlord should
/// look like the one the registry printed. Everything on it is drawn from the
/// record — nothing is typed into the letter that is not also on the detail.
///
/// Every colour and size here is a token, and the type is the system's two
/// faces: the design's serif and cursive are not bundled, so the headline and
/// the signatures are set in Inter, the signatures in italic.
class AdmissionLetterDocument extends StatelessWidget {
  const AdmissionLetterDocument({
    required this.letter,
    required this.reference,
    required this.addresseeName,
    required this.programmeName,
    required this.department,
    required this.faculty,
    super.key,
  });

  final AdmissionLetter letter;

  /// The application's tracking code, quoted as the letter's reference;
  /// `null` for a record that was never given one.
  final String? reference;

  /// The candidate the letter is addressed to; `null` while the portal has
  /// not named them, in which case only the address is shown.
  final String? addresseeName;

  final String programmeName;
  final String department;

  /// Named in the body when the catalogue still carries the programme.
  final String? faculty;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final terms = letter.terms;
    final faculty = this.faculty;
    final dateFormat = AppDateFormats.long(l10n.localeName);
    final acceptBy = dateFormat.format(terms.acceptBy);
    final fee = formatNaira(terms.acceptanceFeeMinorUnits);
    final level = l10n.admissionsOfferLevelValue(terms.level);
    final body = faculty == null
        ? l10n.admissionsLetterBodyNoFaculty(
            department,
            level,
            programmeName,
            terms.session,
          )
        : l10n.admissionsLetterBody(
            department,
            faculty,
            level,
            programmeName,
            terms.session,
          );

    final bodyStyle = theme.textTheme.bodyMedium!.copyWith(
      color: AppColors.inkBody,
      height: AppTextStyles.documentLineHeight,
    );
    final emphasis = bodyStyle.copyWith(
      color: AppColors.ink,
      fontWeight: AppTextStyles.bold,
    );

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.paperStroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const LetterHead(),
          AppSpacing.verticalGap(AppSpacing.lg),
          const LetterDoubleRule(),
          AppSpacing.verticalGap(AppSpacing.lg),
          LetterReferenceBlock(
            reference: reference,
            issuedOn: dateFormat.format(letter.issuedOn),
            verificationCode: letter.verificationCode,
          ),
          AppSpacing.verticalGap(AppSpacing.xl),
          LetterAddressee(
            name: addresseeName,
            addressLines: letter.addressLines,
          ),
          AppSpacing.verticalGap(AppSpacing.xl),
          LetterHeadline(session: terms.session),
          AppSpacing.verticalGap(AppSpacing.lg),
          EmphasisedText(
            body,
            style: bodyStyle,
            emphasisStyle: emphasis,
            emphasis: [programmeName],
            textAlign: TextAlign.justify,
          ),
          AppSpacing.verticalGap(AppSpacing.lg),
          Text(
            l10n.admissionsLetterConditionsIntro,
            style: theme.textTheme.labelLarge?.copyWith(color: AppColors.ink),
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          LetterConditionRow(
            index: 1,
            text: l10n.admissionsLetterConditionAccept(acceptBy),
            emphasis: [acceptBy],
          ),
          LetterConditionRow(
            index: 2,
            text: l10n.admissionsLetterConditionFee(fee),
            emphasis: [fee],
          ),
          LetterConditionRow(
            index: 3,
            text: l10n.admissionsLetterConditionCredentials,
          ),
          LetterConditionRow(
            index: 4,
            text: l10n.admissionsLetterConditionRules(programmeName),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          Text(l10n.admissionsLetterClosing, style: bodyStyle),
          AppSpacing.verticalGap(AppSpacing.xxl),
          LetterSignatories(signatories: letter.signatories),
          AppSpacing.verticalGap(AppSpacing.xl),
          LetterFooter(
            verificationUrl: letter.verificationUrl,
            verificationCode: letter.verificationCode,
          ),
        ],
      ),
    );
  }
}

/// The letterhead: the crest, the university and the office writing.
class LetterHead extends StatelessWidget {
  const LetterHead({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;

    return Row(
      children: [
        const BrandCrestTile(),
        AppSpacing.horizontalGap(AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.admissionsLetterUniversity,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: AppColors.inkBrand,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.xs),
              Text(
                l10n.admissionsLetterOffice,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.inkMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The heavy rule over a hairline that closes a letterhead.
class LetterDoubleRule extends StatelessWidget {
  const LetterDoubleRule({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: AppDimensions.ruleHeavy, color: AppColors.inkBrand),
        AppSpacing.verticalGap(AppDimensions.doubleRule),
        Container(height: AppDimensions.hairline, color: AppColors.inkBrand),
      ],
    );
  }
}

/// Reference and date on the left, the verification mark on the right.
class LetterReferenceBlock extends StatelessWidget {
  const LetterReferenceBlock({
    required this.reference,
    required this.issuedOn,
    required this.verificationCode,
    super.key,
  });

  /// `null` when the record carries no tracking code; the block then opens
  /// with the date.
  final String? reference;

  /// Already formatted, in the letter's long date form.
  final String issuedOn;

  final String verificationCode;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final reference = this.reference;
    final labelStyle = theme.textTheme.bodySmall?.copyWith(
      color: AppColors.inkMuted,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (reference != null) ...[
                Text(l10n.admissionsLetterRef, style: labelStyle),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  reference,
                  style: AppTextStyles.tabular(
                    AppTextStyles.codeMedium.copyWith(
                      color: AppColors.ink,
                      fontWeight: AppTextStyles.bold,
                      letterSpacing: AppTextStyles.trackingCode,
                    ),
                  ),
                ),
                AppSpacing.verticalGap(AppSpacing.md),
              ],
              Text(l10n.admissionsLetterDate, style: labelStyle),
              AppSpacing.verticalGap(AppSpacing.xs),
              Text(
                issuedOn,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.ink,
                  fontWeight: AppTextStyles.semiBold,
                ),
              ),
            ],
          ),
        ),
        AppSpacing.horizontalGap(AppSpacing.md),
        Column(
          children: [
            VerificationQrMark(code: verificationCode),
            AppSpacing.verticalGap(AppSpacing.xs),
            Text(
              l10n.admissionsLetterScanToVerify,
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.inkSubtle,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Who the letter is to, and where.
class LetterAddressee extends StatelessWidget {
  const LetterAddressee({
    required this.name,
    required this.addressLines,
    super.key,
  });

  final String? name;
  final List<String> addressLines;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final name = this.name;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (name != null) ...[
          Text(
            name,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.ink,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.xs),
        ],
        for (final line in addressLines)
          Text(
            line,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.inkBody,
              height: AppTextStyles.relaxedLineHeight,
            ),
          ),
      ],
    );
  }
}

/// The letter's subject line, centred and underlined as the registry sets it.
class LetterHeadline extends StatelessWidget {
  const LetterHeadline({required this.session, super.key});

  final String session;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;

    return Text(
      l10n.admissionsLetterHeadline(session).toUpperCase(),
      textAlign: TextAlign.center,
      style: theme.textTheme.labelLarge?.copyWith(
        color: AppColors.inkBrand,
        fontWeight: AppTextStyles.bold,
        letterSpacing: AppTextStyles.trackingCaps,
        decoration: TextDecoration.underline,
        decorationColor: AppColors.inkBrand,
      ),
    );
  }
}

/// One numbered condition of the offer.
class LetterConditionRow extends StatelessWidget {
  const LetterConditionRow({
    required this.index,
    required this.text,
    this.emphasis = const [],
    super.key,
  });

  /// One-based, as printed.
  final int index;

  final String text;

  /// Values in [text] to set in bold — a date, a fee.
  final List<String> emphasis;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final style = theme.textTheme.bodyMedium!.copyWith(
      color: AppColors.inkBody,
      height: AppTextStyles.relaxedLineHeight,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppSpacing.xl,
            child: Text(
              l10n.admissionsLetterConditionNumber(index),
              style: style.copyWith(color: AppColors.inkMuted),
            ),
          ),
          Expanded(
            child: EmphasisedText(
              text,
              style: style,
              emphasisStyle: style.copyWith(
                color: AppColors.ink,
                fontWeight: AppTextStyles.bold,
              ),
              emphasis: emphasis,
            ),
          ),
        ],
      ),
    );
  }
}

/// The officers who sign, side by side where the paper is wide enough and
/// one under the other where it is not.
class LetterSignatories extends StatelessWidget {
  const LetterSignatories({required this.signatories, super.key});

  final List<LetterSignatory> signatories;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xl,
      runSpacing: AppSpacing.xl,
      children: [
        for (final signatory in signatories)
          LetterSignatoryBlock(signatory: signatory),
      ],
    );
  }
}

/// One signature over its rule, with the name and office under it.
class LetterSignatoryBlock extends StatelessWidget {
  const LetterSignatoryBlock({required this.signatory, super.key});

  final LetterSignatory signatory;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final onBehalfOf = signatory.onBehalfOf;

    return SizedBox(
      width: AppDimensions.signatureBlockWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: AppDimensions.signatureHeight,
            child: Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Text(
                signatory.signature,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: AppColors.ink,
                  fontStyle: FontStyle.italic,
                  fontWeight: AppTextStyles.regular,
                ),
              ),
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.xs),
          Container(height: AppDimensions.hairline, color: AppColors.ink),
          AppSpacing.verticalGap(AppSpacing.sm),
          Text(
            signatory.name,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.ink,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          Text(
            signatory.title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.inkMuted,
            ),
          ),
          if (onBehalfOf != null)
            Text(
              onBehalfOf,
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.inkSubtle,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }
}

/// The foot of the letter: where to verify it and with what.
class LetterFooter extends StatelessWidget {
  const LetterFooter({
    required this.verificationUrl,
    required this.verificationCode,
    super.key,
  });

  final String verificationUrl;
  final String verificationCode;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final style = theme.textTheme.bodySmall?.copyWith(
      color: AppColors.inkMuted,
      height: AppTextStyles.relaxedLineHeight,
    );

    return Container(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.paperRule,
            width: AppDimensions.hairline,
          ),
        ),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppSpacing.xs,
        runSpacing: AppSpacing.xs,
        children: [
          Text(l10n.admissionsLetterVerifyPrefix, style: style),
          Text(
            verificationUrl,
            style: style?.copyWith(
              color: AppColors.inkBrand,
              fontWeight: AppTextStyles.medium,
            ),
          ),
          Text(l10n.admissionsLetterVerifyWithCode, style: style),
          LetterCodeChip(code: verificationCode),
          Text(l10n.admissionsLetterVerifySuffix, style: style),
        ],
      ),
    );
  }
}

/// The verification code as it is printed: mono, boxed, on the paper's inset.
class LetterCodeChip extends StatelessWidget {
  const LetterCodeChip({required this.code, super.key});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.paperInset,
        borderRadius: AppRadii.tagRadius,
        border: Border.all(color: AppColors.paperStroke),
      ),
      child: Text(
        code,
        style: AppTextStyles.codeSmall.copyWith(
          color: AppColors.ink,
          fontWeight: AppTextStyles.bold,
          letterSpacing: AppTextStyles.trackingCode,
        ),
      ),
    );
  }
}

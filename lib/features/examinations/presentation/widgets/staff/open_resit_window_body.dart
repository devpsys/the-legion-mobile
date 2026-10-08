import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/router/route_names.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/money.dart';
import '../../../../../core/utils/responsive.dart';
import '../../bloc/staff/exam_office_cubit.dart';
import '../../models/staff/exam_office_models.dart';
import 'exam_office_block.dart';
import 'exam_office_date_field.dart';
import 'exam_office_field.dart';

/// The open-a-resit-window form. The close date must fall after the open date.
class OpenResitWindowBody extends StatefulWidget {
  const OpenResitWindowBody({super.key});

  @override
  OpenResitWindowBodyState createState() => OpenResitWindowBodyState();
}

/// State of [OpenResitWindowBody].
class OpenResitWindowBodyState extends State<OpenResitWindowBody> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _fee = TextEditingController();
  DateTime? _opens;
  DateTime? _closes;
  int _cap = 6;
  Set<ResitDraftError> _errors = const {};

  @override
  void dispose() {
    _name.dispose();
    _fee.dispose();
    super.dispose();
  }

  void _submit() {
    final errors = context.read<ExamOfficeCubit>().openResitWindow(
      ResitWindowDraft(
        name: _name.text,
        opensOn: _opens,
        closesOn: _closes,
        feePerUnitMinorUnits: parseNaira(_fee.text),
        unitCap: _cap == 0 ? null : _cap,
      ),
    );
    if (errors.isEmpty) {
      context.goNamed(Routes.examOfficeResitsName);
      return;
    }
    setState(() => _errors = errors);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final datesMissing = _errors.contains(ResitDraftError.datesRequired);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExamOfficeBlock(
          title: l10n.examOfficeWindowFormTitle,
          description: l10n.examOfficeWindowFormBody,
          children: [
            ExamOfficeField(
              label: l10n.examOfficeWindowNameLabel,
              controller: _name,
              errorText: _errors.contains(ResitDraftError.nameRequired)
                  ? l10n.examOfficeWindowNameRequired
                  : null,
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            ExamOfficeDateField(
              label: l10n.examOfficeWindowOpensLabel,
              value: _opens,
              errorText: datesMissing && _opens == null
                  ? l10n.examOfficeDateRequired
                  : null,
              onChanged: (value) => setState(() => _opens = value),
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            ExamOfficeDateField(
              label: l10n.examOfficeWindowClosesLabel,
              value: _closes,
              errorText: _errors.contains(ResitDraftError.closeBeforeOpen)
                  ? l10n.examOfficeWindowCloseBeforeOpen
                  : datesMissing && _closes == null
                  ? l10n.examOfficeDateRequired
                  : null,
              onChanged: (value) => setState(() => _closes = value),
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            ExamOfficeField(
              label: l10n.examOfficeWindowFeeLabel,
              controller: _fee,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              prefixText: nairaSymbol,
              errorText: _errors.contains(ResitDraftError.feeInvalid)
                  ? l10n.examOfficeWindowFeeInvalid
                  : null,
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            ExamOfficeStepper(
              label: l10n.examOfficeWindowCapLabel,
              value: _cap,
              max: 12,
              suffix: _cap == 0 ? l10n.examOfficeWindowNoCap : null,
              onChanged: (value) => setState(() => _cap = value),
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.lg),
        SizedBox(
          height: AppDimensions.primaryActionHeight,
          child: FilledButton(
            onPressed: _submit,
            child: Text(l10n.examOfficeWindowOpenAction),
          ),
        ),
      ],
    );
  }
}

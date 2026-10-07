import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/utils/money.dart';
import '../../bloc/staff/housing_cubit.dart';
import '../../models/staff/housing_models.dart';
import 'housing_field.dart';

/// One room type's price, editable in naira.
class PriceRow extends StatefulWidget {
  const PriceRow({required this.price, super.key});

  final RoomPrice price;

  @override
  PriceRowState createState() => PriceRowState();
}

/// State of [PriceRow]: the typed amount and whether it reads as money.
class PriceRowState extends State<PriceRow> {
  late final TextEditingController _controller;
  bool _invalid = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: formatNairaFigure(widget.price.minorUnits),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final amount = parseNaira(_controller.text);
    setState(() => _invalid = amount == null);
    if (amount == null) return;
    context.read<HousingCubit>().setPrice(widget.price.roomType, amount);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: HousingField(
            label: widget.price.roomType,
            controller: _controller,
            prefixText: nairaSymbol,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            errorText: _invalid ? l10n.housingPriceInvalid : null,
          ),
        ),
        IconButton.filled(
          onPressed: _save,
          tooltip: l10n.housingSave,
          icon: const Icon(Icons.check),
        ),
      ],
    );
  }
}

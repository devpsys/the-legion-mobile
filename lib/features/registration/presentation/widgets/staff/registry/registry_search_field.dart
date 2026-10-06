import 'package:flutter/material.dart';

import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/utils/responsive.dart';

/// Search box of the students directory; the query lives in the cubit.
class RegistrySearchField extends StatefulWidget {
  const RegistrySearchField({
    required this.initialQuery,
    required this.onChanged,
    super.key,
  });

  final String initialQuery;
  final ValueChanged<String> onChanged;

  @override
  RegistrySearchFieldState createState() => RegistrySearchFieldState();
}

/// State of [RegistrySearchField].
class RegistrySearchFieldState extends State<RegistrySearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onChanged('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return TextField(
      controller: _controller,
      onChanged: (value) {
        widget.onChanged(value);
        setState(() {});
      },
      textInputAction: TextInputAction.search,
      autocorrect: false,
      decoration: InputDecoration(
        hintText: l10n.staffRegistrySearchHint,
        prefixIcon: const Icon(
          Icons.search,
          size: AppDimensions.iconMedium,
        ),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                onPressed: _clear,
                tooltip: l10n.staffRegistrySearchClear,
                icon: const Icon(
                  Icons.close,
                  size: AppDimensions.iconDense,
                ),
              ),
      ),
    );
  }
}

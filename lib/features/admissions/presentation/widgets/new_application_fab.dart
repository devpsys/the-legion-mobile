import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';

/// The one action on the Applications tab: start an application.
///
/// Floating rather than sitting under the title, because the record scrolls —
/// a control pinned above a long list is out of reach by the time a candidate
/// who has read to the bottom decides to start another one. The size, colour
/// and corner radius all come from the theme's FAB tokens, so it reads as the
/// same navy action the header used to carry.
class NewApplicationFab extends StatelessWidget {
  const NewApplicationFab({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      // Extended rather than an icon alone: the label is what a screen reader
      // announces, and "add" says nothing about what is being added.
      icon: const Icon(Icons.add),
      label: Text(context.l10n.admissionsNewApplication),
    );
  }
}

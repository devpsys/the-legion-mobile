import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../extensions/context_extensions.dart';
import '../widgets/message_feedback.dart';

/// Blocks the system back gesture and asks for a second press to exit.
///
/// Android's back gesture is the app's only "close" affordance — there is no
/// window to close — so pressing it once must not throw the user out of a
/// half-finished screen. The first press warns, and a second press inside
/// [window] leaves. On iOS and web the OS owns back, so this never runs there.
///
/// Wrap the root of the authenticated stack and nowhere else: `canPop: false`
/// is correct at the bottom of the stack and wrong on any screen the user is
/// meant to leave.
class ConfirmExit extends StatefulWidget {
  const ConfirmExit({
    required this.child,
    this.window = const Duration(seconds: 2),
    this.now,
    this.onExit,
    super.key,
  });

  final Widget child;

  /// How long the first press arms the second.
  final Duration window;

  /// Injected so the arming window is testable without waiting.
  final DateTime Function()? now;

  /// Injected so a test can observe the exit instead of leaving the process.
  final VoidCallback? onExit;

  @override
  ConfirmExitState createState() => ConfirmExitState();
}

class ConfirmExitState extends State<ConfirmExit> {
  /// When the first press armed the second; `null` when not armed.
  DateTime? _armedAt;

  DateTime Function() get _now => widget.now ?? DateTime.now;

  /// `true` while a second press inside [ConfirmExit.window] exits.
  bool get isArmed {
    final armedAt = _armedAt;
    if (armedAt == null) return false;
    return _now().difference(armedAt) < widget.window;
  }

  /// First press arms and warns; a second inside the window exits.
  void onBack() {
    if (isArmed) {
      (widget.onExit ?? SystemNavigator.pop)();
      return;
    }
    setState(() => _armedAt = _now());
    context.showMessage(context.l10n.homeBackAgainToExit);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        onBack();
      },
      child: widget.child,
    );
  }
}

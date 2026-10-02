import 'dart:async';

import 'package:flutter/foundation.dart';

/// Bridges a state stream (a `Cubit`/`Bloc` stream) to GoRouter's
/// `refreshListenable`, so navigation reacts to authentication changes without
/// any widget performing a manual redirect.
class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(Stream<Object?> source) {
    _subscription = source.listen((_) => notifyListeners());
  }

  late final StreamSubscription<Object?> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}

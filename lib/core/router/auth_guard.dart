/// Read-only view of the session state used by the router.
///
/// Declared in `core` and implemented by the auth feature's cubit so routing
/// stays decoupled from any concrete feature and remains trivially testable.
abstract interface class AuthGuard {
  /// `true` once the persisted session has been restored (successfully or not).
  bool get isSessionResolved;

  /// `true` when a valid session exists.
  bool get isAuthenticated;
}

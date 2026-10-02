/// Supplies (and invalidates) the credentials used by the HTTP client.
///
/// Declared in `core` and implemented by a feature so that the networking
/// infrastructure never depends on a concrete feature, while remaining fully
/// testable with a stub.
abstract interface class AuthTokenProvider {
  /// Returns the access token to attach to outgoing requests, or `null` when
  /// the user is anonymous.
  Future<String?> accessToken();

  /// Invoked when the API rejects a request with `401 Unauthorized` so the
  /// feature owning the session can clear it.
  Future<void> onUnauthorized();
}

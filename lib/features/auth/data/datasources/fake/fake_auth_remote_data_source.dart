import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/error/exceptions.dart';
import '../../models/auth_tokens_model.dart';
import '../../models/login_response_model.dart';
import '../../models/user_model.dart';
import '../remote/auth_remote_data_source.dart';

/// In-memory stand-in for the auth API.
///
/// Used while the backend is still being built so the presentation layer can
/// be developed, demoed and tested end to end without any network call.
/// Swap it for [AuthRemoteDataSourceImpl] by building with
/// `--dart-define=USE_FAKE_DATA_SOURCES=false`.
///
/// Demo credentials: **any** email address with the password
/// [acceptedPassword] (`legion123`). Add addresses to [rejectedEmails] to
/// exercise the error and rate-limit screens while designing them.
class FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  FakeAuthRemoteDataSource({
    this.latency = defaultLatency,
    this.acceptedPassword = defaultPassword,
    this.rejectedEmails = const <String>{},
    this.demoDisplayName = defaultDisplayName,
    this.demoAvatarReference = AppAssets.studentAvatar,
  });

  /// Artificial round-trip time so loading states are actually visible.
  static const Duration defaultLatency = Duration(milliseconds: 600);

  /// Password accepted for every email address.
  static const String defaultPassword = 'legion123';

  static const String defaultDisplayName = 'Ada Lovelace';

  /// Portrait handed to the demo account: a bundled asset key, which is what
  /// the real API will eventually answer with an `https` URL for. Set to
  /// `null` to see the initials fallback instead.
  final String? demoAvatarReference;

  /// Fixed timestamp keeps cached sessions deterministic.
  static final DateTime demoAccountCreatedAt = DateTime.utc(2024, 9, 1);

  static const String demoUserId = 'usr_demo_0001';

  /// Lifetime handed to the fake tokens.
  static const Duration sessionLifetime = Duration(hours: 8);

  final Duration latency;
  final String acceptedPassword;
  final Set<String> rejectedEmails;
  final String demoDisplayName;

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    if (latency > Duration.zero) {
      await Future<void>.delayed(latency);
    }

    if (rejectedEmails.contains(email.toLowerCase()) ||
        password != acceptedPassword) {
      throw const UnauthorizedException(
        'Invalid email or password',
        statusCode: 401,
      );
    }

    return LoginResponseModel(
      user: UserModel(
        id: demoUserId,
        email: email,
        displayName: demoDisplayName,
        avatarUrl: demoAvatarReference,
        createdAt: demoAccountCreatedAt,
      ),
      tokens: AuthTokensModel(
        accessToken: 'fake_access_token',
        refreshToken: 'fake_refresh_token',
        expiresAt: DateTime.now().add(sessionLifetime),
      ),
    );
  }
}

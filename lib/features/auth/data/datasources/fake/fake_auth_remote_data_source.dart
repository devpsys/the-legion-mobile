import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/validation.dart';
import '../../../domain/entities/registration.dart';
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
///
/// Registration opens an account for any address not already on the
/// register — [takenEmails], plus whatever this instance has registered since
/// it was created — and signs the new applicant straight in.
class FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  FakeAuthRemoteDataSource({
    this.latency = defaultLatency,
    this.acceptedPassword = defaultPassword,
    this.rejectedEmails = const <String>{},
    Set<String> takenEmails = defaultTakenEmails,
    this.demoDisplayName = defaultDisplayName,
    this.demoAvatarReference = AppAssets.studentAvatar,
  }) : _register = {for (final email in takenEmails) email.toLowerCase()};

  /// Addresses that already have an account, so the "already registered"
  /// path can be exercised: the demo student's own.
  static const Set<String> defaultTakenEmails = {'ada@the-legion.dev'};

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

  /// Prefix of the ids handed to accounts opened through [register].
  static const String applicantIdPrefix = 'usr_applicant_';

  final Duration latency;
  final String acceptedPassword;
  final Set<String> rejectedEmails;
  final String demoDisplayName;

  /// Lower-cased addresses with an account, seeded from `takenEmails`.
  final Set<String> _register;

  /// Every address with an account: the seeded ones and those this instance
  /// has opened since. Exposed for assertions in tests.
  Set<String> get registeredEmails => Set.unmodifiable(_register);

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    await _roundTrip();

    if (rejectedEmails.contains(email.toLowerCase()) ||
        password != acceptedPassword) {
      throw const UnauthorizedException(
        'Invalid email or password',
        statusCode: 401,
      );
    }

    return _session(
      UserModel(
        id: demoUserId,
        email: email,
        displayName: demoDisplayName,
        avatarUrl: demoAvatarReference,
        createdAt: demoAccountCreatedAt,
      ),
    );
  }

  @override
  Future<LoginResponseModel> register(Registration registration) async {
    await _roundTrip();

    final email = registration.email.toLowerCase();
    if (_register.contains(email)) {
      throw const ValidationException(
        field: ValidationField.email,
        validationCode: ValidationCode.emailAlreadyRegistered,
        message: 'An account already exists for this email address',
        statusCode: AuthRemoteDataSourceImpl.conflictStatusCode,
      );
    }
    _register.add(email);

    // A new applicant has no portrait yet: the avatar falls back to initials.
    return _session(
      UserModel(
        id: '$applicantIdPrefix${_register.length}',
        email: registration.email,
        displayName: registration.displayName,
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> _roundTrip() async {
    if (latency > Duration.zero) {
      await Future<void>.delayed(latency);
    }
  }

  LoginResponseModel _session(UserModel user) => LoginResponseModel(
    user: user,
    tokens: AuthTokensModel(
      accessToken: 'fake_access_token',
      refreshToken: 'fake_refresh_token',
      expiresAt: DateTime.now().add(sessionLifetime),
    ),
  );
}

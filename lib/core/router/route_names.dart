/// Single source of truth for every navigation path.
///
/// Widgets must navigate with `context.goNamed(Routes.loginName)` /
/// `context.pushNamed(...)` and never with an inline string literal, so deep
/// links and web URLs can be changed in one place.
abstract final class Routes {
  // Paths
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/home/profile';

  // Account recovery flow
  static const String forgotPassword = '/forgot-password';
  static const String verifyRecoveryCode = '/forgot-password/verify';
  static const String setNewPassword = '/forgot-password/new-password';
  static const String recoverySuccess = '/forgot-password/success';

  // Candidate admissions portal
  static const String admissions = '/admissions';
  static const String admissionsProgrammes = '/admissions/programmes';
  static const String admissionsApplications = '/admissions/applications';

  /// Path template of one application's detail screen; `:id` is the record's
  /// own id. The concrete location is built with [admissionsApplicationDetail].
  static const String admissionsApplicationDetailTemplate =
      '/admissions/applications/:id';

  /// The detail screen's location for one record, e.g.
  /// `/admissions/applications/app-00057`.
  ///
  /// Derived from the template so the two cannot drift apart, and used for the
  /// deep-link check that keeps the portal behind a session.
  static String admissionsApplicationDetail(String id) =>
      admissionsApplicationDetailTemplate.replaceFirst(':id', id);

  /// Path template of the admission letter, a step above the detail: the
  /// document the offer and the matriculation both link to.
  static const String admissionsAdmissionLetterTemplate =
      '$admissionsApplicationDetailTemplate/letter';

  /// The letter's location for one record, e.g.
  /// `/admissions/applications/app-00042/letter`.
  static String admissionsAdmissionLetter(String id) =>
      admissionsAdmissionLetterTemplate.replaceFirst(':id', id);

  /// Opening an applicant account. Signed-out only, like the recovery flow:
  /// somebody with a session has an account.
  static const String createAccount = '/create-account';

  /// Public verification of an admission letter — for whoever is handed one.
  ///
  /// Outside every shell: no session, no tab bar, no bell. A code may arrive
  /// in the query (`?code=…`), which is what the letter's QR mark encodes.
  static const String verifyAdmission = '/verify/admission';

  /// Name of the query parameter [verifyAdmission] reads a code from.
  static const String verifyAdmissionCodeParam = 'code';

  // Route names, used for navigation so paths can change freely.
  static const String splashName = 'splash';
  static const String loginName = 'login';
  static const String homeName = 'home';
  static const String profileName = 'profile';
  static const String forgotPasswordName = 'forgotPassword';
  static const String verifyRecoveryCodeName = 'verifyRecoveryCode';
  static const String setNewPasswordName = 'setNewPassword';
  static const String recoverySuccessName = 'recoverySuccess';
  static const String admissionsName = 'admissions';
  static const String admissionsProgrammesName = 'admissionsProgrammes';
  static const String admissionsApplicationsName = 'admissionsApplications';
  static const String admissionsApplicationDetailName =
      'admissionsApplicationDetail';
  static const String admissionsAdmissionLetterName =
      'admissionsAdmissionLetter';
  static const String verifyAdmissionName = 'verifyAdmission';
  static const String createAccountName = 'createAccount';

  /// Every screen inside the candidate portal, as far as it is expressible as
  /// a literal path.
  ///
  /// The portal's back handling and the deep-link check are written against
  /// these: `PopScope` decides where back leads, and `resolveRedirect` must
  /// send an anonymous visitor to sign-in rather than into the portal, so a
  /// new portal section has to be listed here or it becomes reachable without
  /// a session. The application detail is a child of
  /// [admissionsApplications] — its own location is built by
  /// [admissionsApplicationDetail] and inherits that protection from the
  /// prefix.
  static const Set<String> admissionsPaths = {
    admissions,
    admissionsProgrammes,
    admissionsApplications,
  };

  /// Reachable only while signed out — recovery is pointless once
  /// authenticated, so the redirect sends those deep links to the app shell.
  static const Set<String> recoveryPaths = {
    forgotPassword,
    verifyRecoveryCode,
    setNewPassword,
    recoverySuccess,
  };

  /// The doors into the app: sign-in and the screens beside it that only a
  /// signed-out visitor has a use for. An authenticated session is sent on
  /// to the hub from any of them.
  static const Set<String> entryPaths = {
    login,
    createAccount,
    ...recoveryPaths,
  };

  /// Reachable by anyone, signed in or not.
  ///
  /// Distinct from [recoveryPaths]: verification is for a person who may
  /// never have an account, and a student scanning their own letter should
  /// not be bounced to the hub for having one.
  static const Set<String> publicPaths = {verifyAdmission};
}

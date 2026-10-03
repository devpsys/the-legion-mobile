// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'The Legion';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonDismiss => 'Dismiss';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonLoading => 'Loading';

  @override
  String get commonComingSoon =>
      'This service goes live with the next release.';

  @override
  String get commonGreetingMorning => 'Good morning';

  @override
  String get commonGreetingAfternoon => 'Good afternoon';

  @override
  String get commonGreetingEvening => 'Good evening';

  @override
  String get errorsNetwork =>
      'No internet connection. Check your network and try again.';

  @override
  String get errorsServer =>
      'Something went wrong on our side. Please try again.';

  @override
  String get errorsUnauthorized => 'You are not authorized to continue.';

  @override
  String get errorsCache => 'Local data could not be read or written.';

  @override
  String get errorsUnexpected =>
      'Something unexpected happened. Please try again.';

  @override
  String get validationRequired => 'This field is required.';

  @override
  String get validationInvalidEmail => 'Enter a valid email address.';

  @override
  String get validationPasswordTooShort =>
      'Password must be at least 8 characters.';

  @override
  String get validationInvalidCredentials => 'Incorrect email or password.';

  @override
  String get validationInvalidRequest => 'The submitted data is invalid.';

  @override
  String get sessionRestoring => 'Restoring your session';

  @override
  String get loginSsoBadge => 'SSO';

  @override
  String get loginHeaderSubtitle =>
      'The Legion University — one sign-in for admissions, students, staff and administration.';

  @override
  String get loginCardTitle => 'Sign in';

  @override
  String get loginCardSubtitle => 'Use your institutional email and password.';

  @override
  String get loginEmailLabel => 'Institutional email';

  @override
  String get loginEmailHint => 'you@legion.edu.ng';

  @override
  String get loginEmailHelper =>
      'Use your @legion.edu.ng address or applicant email.';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordHint => 'Enter institutional password';

  @override
  String get loginShowPassword => 'Show password';

  @override
  String get loginHidePassword => 'Hide password';

  @override
  String get loginRememberMe => 'Keep me signed in';

  @override
  String get loginForgotPassword => 'Forgot password?';

  @override
  String get loginSubmit => 'Sign in';

  @override
  String get loginSubmitting => 'Signing in';

  @override
  String get loginOrDivider => 'or institutional access';

  @override
  String get loginActionCreateAccount => 'Create an applicant account';

  @override
  String get loginActionVerifyLetter => 'Verify an admission letter';

  @override
  String get loginAuditTitle => 'Statutory Audit Protocol';

  @override
  String get loginAuditBody =>
      'Unauthorized access attempts to academic records or financial portfolios are monitored and reported under statutory federal frameworks.';

  @override
  String get loginCopyright =>
      'Secure Institutional Verification © The Legion University';

  @override
  String get rateLimitTitle => 'Too many sign-in attempts';

  @override
  String get rateLimitRetryIn => 'Try again in';

  @override
  String get rateLimitTag => 'Security alert';

  @override
  String get rateLimitFieldLocked => 'Field locked';

  @override
  String get rateLimitRetryAction => 'Try again in';

  @override
  String get rateLimitRetryActionReady => 'Try sign in again';

  @override
  String get rateLimitLockoutTitle => 'Institutional lockout';

  @override
  String get rateLimitLockoutCode => 'SEC-403';

  @override
  String get rateLimitLockoutBody =>
      'Your account is temporarily locked after repeated failed sign-ins. Wait for the countdown or contact the registry to have it restored.';

  @override
  String get rateLimitAdminRoute => 'Direct administrative route';

  @override
  String get rateLimitRegistryEmail => 'registry@legion.edu.ng';

  @override
  String get rateLimitRegistryPhone => '+234 1 234 5678';

  @override
  String get rateLimitStatutoryRef =>
      'Statutory Regulation Ref: NG-EDU-VER-2024';

  @override
  String get recoveryPortalTitle => 'Legion Sovereign Portal';

  @override
  String get recoverySovereignId => 'Legion Sovereign ID';

  @override
  String get recoverySecurityLevel => 'SEC-L4';

  @override
  String recoveryStepOf(Object current, Object total) {
    return 'Step $current of $total';
  }

  @override
  String get recoveryRegistryAuthority => 'Legion Registry Authority';

  @override
  String get recoveryRegistryMonogram => 'LR';

  @override
  String get recoveryAccessDirectorate => 'Identity & Access Directorate';

  @override
  String get recoveryVerified => 'Verified';

  @override
  String get recoveryRequestTitle => 'Reset your password';

  @override
  String get recoveryRequestSubtitle =>
      'Enter your registered institutional email or candidate registration number to initiate identity verification.';

  @override
  String get recoveryIdentifierLabel => 'Institutional email or ID';

  @override
  String get recoveryIdentifierHint =>
      'e.g. amaka.bello@legion.edu.ng or 23/CSC/0412';

  @override
  String get recoveryIdentifierHelper =>
      'For applicants, use the email registered on your application.';

  @override
  String get recoverySecurityProtocol => 'Institutional Security Protocol';

  @override
  String get recoverySecurityProtocolBody =>
      'A 6-digit one-time verification code will be dispatched to your recovery phone number and official inbox.';

  @override
  String get recoverySendCode => 'Send recovery code';

  @override
  String get recoveryRememberedPassword => 'Remembered your password? Sign in';

  @override
  String get recoveryVerifyTitle => 'Verify your identity';

  @override
  String get recoveryVerifySent => 'We sent a 6-digit security code to';

  @override
  String get recoveryVerifyAndSms => 'and SMS to';

  @override
  String get recoveryCodeLabel => 'Cryptographic authentication token';

  @override
  String get recoveryExpiresIn => 'Code expires in';

  @override
  String get recoveryVerifyCode => 'Verify code';

  @override
  String recoveryCodeInvalid(Object remaining) {
    return 'That code is not correct. $remaining attempts remaining before your recovery is locked for 15 minutes.';
  }

  @override
  String get recoveryCodeInvalidTitle => 'Incorrect code';

  @override
  String get recoveryCodeLockedTitle => 'Recovery temporarily locked';

  @override
  String recoveryCodeLockedBody(Object remaining) {
    return 'Too many incorrect codes. Recovery unlocks in $remaining.';
  }

  @override
  String get recoveryAttemptsTitle => 'Protect your account';

  @override
  String recoveryAttemptsBody(Object attempts, Object minutes) {
    return 'For your protection, $attempts incorrect verification attempts will temporarily lock your credentials for $minutes minutes.';
  }

  @override
  String recoveryStage(Object stage) {
    return 'Authentication Stage $stage';
  }

  @override
  String get recoveryNoCode => 'Didn\'t receive the code?';

  @override
  String get recoveryResendCode => 'Resend code';

  @override
  String get recoveryResendIn => '(available in';

  @override
  String get recoveryDifferentMethod => 'Try a different recovery method';

  @override
  String get recoveryCancelAndReturn => 'Cancel and return to sign in';

  @override
  String get recoveryResetPasswordTitle => 'Reset Password';

  @override
  String get recoveryNewPasswordSubtitle =>
      'Choose a new password that satisfies the institutional policy below.';

  @override
  String get recoveryNewPasswordLabel => 'New password';

  @override
  String get recoveryNewPasswordHint => 'Enter new password';

  @override
  String get recoveryConfirmPassword => 'Confirm new password';

  @override
  String get recoveryConfirmPasswordHint => 'Repeat new password';

  @override
  String get recoveryPolicyRequirement => 'Institutional Policy Requirement';

  @override
  String get recoveryPolicyCompliant => 'Policy Compliant';

  @override
  String get recoveryStrengthCompliant => 'Policy Compliant';

  @override
  String recoveryStrengthProgress(Object met, Object total) {
    return 'Policy $met of $total';
  }

  @override
  String get recoveryRequirementLength => 'At least 8 characters';

  @override
  String get recoveryRequirementUppercase =>
      'Contains at least one uppercase letter';

  @override
  String get recoveryRequirementNumber => 'Contains at least one number';

  @override
  String get recoveryRequirementSpecial =>
      'Contains at least one special character (!@#\$%^&*)';

  @override
  String get recoveryPasswordMismatch => 'The passwords do not match.';

  @override
  String get recoveryPasswordPolicyError =>
      'Choose a password that satisfies every institutional requirement.';

  @override
  String get recoveryTerminateSessions =>
      'Sign out of all other active browser sessions and devices';

  @override
  String get recoveryUpdatePassword => 'Update password';

  @override
  String get recoveryImmediateEffect =>
      'Your new password will take effect immediately across all university portals, including Course Registration and Bursary.';

  @override
  String get recoverySuccessTitle => 'Password updated successfully';

  @override
  String recoverySuccessBody(Object revocation) {
    return 'Your institutional security credentials have been updated$revocation.';
  }

  @override
  String get recoveryAuditSummary => 'Official Audit Summary';

  @override
  String get recoveryStatusCommitted => 'STATUS: COMMITTED';

  @override
  String get recoveryAuditAccount => 'Account';

  @override
  String get recoveryAuditEmail => 'Primary Email';

  @override
  String get recoveryAuditTimestamp => 'Timestamp';

  @override
  String get recoveryAuditHash => 'Security Audit Hash';

  @override
  String get recoveryAuditSessions => 'Active Sessions';

  @override
  String get recoverySessionsRevoked =>
      'Revoked on all other devices (1 device authorized)';

  @override
  String get recoverySessionsKept =>
      'Other sessions remain active (1 device authorized)';

  @override
  String get recoveryAdvisoryTitle => 'Institutional Advisory Notice';

  @override
  String recoveryAdvisoryBody(Object hotline) {
    return 'A cryptographic notification has been logged to your university inbox. If you did not authorize this change, freeze your account immediately via the Emergency Registry Hotline ($hotline).';
  }

  @override
  String get recoverySignInWithNewPassword => 'Sign in with new password';

  @override
  String get recoveryAuditGuidelines => 'View security audit guidelines';

  @override
  String get navOverview => 'Overview';

  @override
  String get navProfile => 'Profile';

  @override
  String get homeTitle => 'Hub';

  @override
  String get homeHubTitle => 'The Legion Hub';

  @override
  String get homeMenuTooltip => 'Open navigation menu';

  @override
  String get homeNotificationsTooltip => 'Notifications';

  @override
  String get homeCurrentTerm => 'Current Term';

  @override
  String get homeDaysLeft => 'days left';

  @override
  String get homeTermInProgress => 'Term in progress';

  @override
  String homeTermEndsOn(Object date) {
    return 'Ends $date';
  }

  @override
  String get homeDoThisNext => 'Do this next';

  @override
  String get homeSequentialFlow => 'Sequential priority flow';

  @override
  String get homeStepActionable => 'Actionable';

  @override
  String get homeStepBlocked => 'Blocked';

  @override
  String get homeStepWaiting => 'Waiting';

  @override
  String get homeStepDone => 'Done';

  @override
  String homeDueOn(Object date) {
    return 'Due $date';
  }

  @override
  String get homeEverythingElse => 'Everything else';

  @override
  String homeModuleCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Modules',
      one: '1 Module',
    );
    return '$_temp0';
  }

  @override
  String homeModuleRows(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count modules',
      one: '1 module',
    );
    return '$_temp0';
  }

  @override
  String get homeAnnouncements => 'Announcements';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get homeReadMore => 'Read more';

  @override
  String get homeCategoryUrgent => 'Urgent';

  @override
  String get homeCategoryNotice => 'Notice';

  @override
  String get homeCategoryInformation => 'Information';

  @override
  String get homeAccountServices => 'Account & Services';

  @override
  String get homeQuickActions => 'Quick Actions';

  @override
  String get homeSignOut => 'Sign out';

  @override
  String get homeSignOutBody =>
      'You will need your institutional matriculation email and portal password to sign back in.';

  @override
  String get homeDiagnosticsTitle => 'Build diagnostics';

  @override
  String get homeEnvironmentLabel => 'Environment';

  @override
  String get homeApiBaseUrlLabel => 'API base URL';

  @override
  String get homeNetworkLoggingLabel => 'Network logging';

  @override
  String get homeViewportLabel => 'Viewport';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileSignedInAs => 'Signed in as';

  @override
  String get profileMemberSince => 'Member since';

  @override
  String get profileSignOut => 'Sign out';

  @override
  String get profileNotAvailable => 'Profile details are unavailable.';

  @override
  String get routeNotFoundTitle => 'Page not found';

  @override
  String get routeNotFoundBody =>
      'The page you requested does not exist or has moved.';

  @override
  String get routeErrorBackHome => 'Back to overview';

  @override
  String get admissionsTitle => 'Admissions';

  @override
  String get admissionsApplicantLabel => 'Applicant';

  @override
  String admissionsGreeting(Object greeting, Object name) {
    return '$greeting, $name';
  }

  @override
  String admissionsConfirmEmailBody(Object email) {
    return 'Confirm your email address ($email) to submit applications and claim a JAMB result.';
  }

  @override
  String get admissionsConfirmEmailSent =>
      'Confirmation link sent. Check your inbox.';

  @override
  String get admissionsResendLink => 'Resend link';

  @override
  String get admissionsResendingLink => 'Sending…';

  @override
  String get admissionsYourApplications => 'Your applications';

  @override
  String get admissionsApply => 'Apply';

  @override
  String get admissionsNoApplicationsTitle => 'No applications yet';

  @override
  String admissionsNoApplicationsBody(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count admission cycles are open. Browse programmes to apply.',
      one: '1 admission cycle is open. Browse programmes to apply.',
    );
    return '$_temp0';
  }

  @override
  String get admissionsBrowseProgrammes => 'Browse programmes';

  @override
  String get admissionsApplicationsTitle => 'My applications';

  @override
  String get admissionsNewApplication => 'New application';

  @override
  String admissionsSecondChoice(Object programme) {
    return 'Second choice: $programme';
  }

  @override
  String admissionsRespondBy(Object date) {
    return 'Respond by $date';
  }

  @override
  String admissionsUpdatedOn(Object date) {
    return 'Updated $date';
  }

  @override
  String get admissionsMatriculation => 'Matriculation';

  @override
  String get admissionsOpenStudentPortal => 'Open the student portal';

  @override
  String admissionsCycleClosedNote(Object date) {
    return 'Admissions for this cycle closed on $date.';
  }

  @override
  String get admissionsAgeJustNow => 'Just now';

  @override
  String admissionsAgeMinutes(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String admissionsAgeHours(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String get admissionsJambTag => 'JAMB CAPS Import';

  @override
  String get admissionsJambTitle => 'You chose us in JAMB';

  @override
  String get admissionsJambBody =>
      'Your result is waiting. Claim it to add it to your records and start an application.';

  @override
  String get admissionsClaimResult => 'Claim your result';

  @override
  String get admissionsAnnouncements => 'Announcements';

  @override
  String get admissionsSeeAll => 'See all';

  @override
  String get admissionsReadMore => 'Read more';

  @override
  String get admissionsStatusDraft => 'Draft';

  @override
  String get admissionsStatusSubmitted => 'Submitted';

  @override
  String get admissionsStatusUnderReview => 'Under review';

  @override
  String get admissionsStatusOffered => 'Admission offered';

  @override
  String get admissionsStatusAccepted => 'Offer accepted';

  @override
  String get admissionsStatusDeclined => 'Offer declined';

  @override
  String get admissionsStatusRejected => 'Rejected';

  @override
  String get admissionsStatusWithdrawn => 'Withdrawn';

  @override
  String get admissionsStatusExpired => 'Offer expired';

  @override
  String get admissionsStatusMatriculated => 'Matriculated';

  @override
  String get admissionsTabOverview => 'Overview';

  @override
  String get admissionsTabProgrammes => 'Programmes';

  @override
  String get admissionsTabApplications => 'Applications';

  @override
  String get admissionsTabJamb => 'JAMB';

  @override
  String homeUnreadCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unread',
      one: '1 unread',
    );
    return '$_temp0';
  }

  @override
  String get homeNoNotifications => 'You are all caught up.';

  @override
  String get homeBackAgainToExit => 'Press back again to exit';

  @override
  String get admissionsBackTooltip => 'Back to the hub';

  @override
  String get admissionsProgrammesTitle => 'Programmes';

  @override
  String admissionsProgrammesAvailable(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count available',
      one: '1 available',
    );
    return '$_temp0';
  }

  @override
  String get admissionsProgrammesSubtitle =>
      'Explore degree programmes and check your eligibility before applying.';

  @override
  String get admissionsProgrammesSearchHint =>
      'Search programmes, faculties or course codes…';

  @override
  String admissionsProgrammesNoResults(Object query) {
    return 'No programme matches “$query”. Try a course code, a faculty, or clear the search.';
  }

  @override
  String admissionsProgrammesNoResultsFaculty(Object faculty) {
    return 'There is no programme in $faculty in this cycle.';
  }

  @override
  String get admissionsProgrammesNoResultsAll =>
      'There is no programme in this cycle.';

  @override
  String get admissionsProgrammesSwitchCycle => 'Switch cycle';

  @override
  String get admissionsProgrammesCyclePickerTitle => 'Admissions cycles';

  @override
  String get admissionsProgrammesCyclePickerBody =>
      'Choose the cycle you want to see deadlines and fees for.';

  @override
  String admissionsProgrammesCycleCloses(Object date) {
    return 'Closes $date';
  }

  @override
  String admissionsProgrammesCycleClosed(Object date) {
    return 'Closed $date';
  }

  @override
  String get admissionsProgrammeFormFee => 'Form fee';

  @override
  String admissionsProgrammeDuration(num years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years years',
      one: '1 year',
    );
    return '$_temp0';
  }

  @override
  String admissionsProgrammeClosedOn(Object date) {
    return 'Closed on $date';
  }

  @override
  String admissionsProgrammeDeadlineAhead(Object date) {
    return 'Applications close $date, ahead of the cycle';
  }

  @override
  String get admissionsProgrammeAdmissionsActive => 'Admissions active';

  @override
  String admissionsProgrammeClosesIn(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return 'Closes in $_temp0';
  }

  @override
  String get admissionsProgrammeArchived => 'Archived session';

  @override
  String get admissionsProgrammeApply => 'View programme & apply';

  @override
  String get admissionsProgrammeViewDetails => 'View details';

  @override
  String get admissionsVerdictEligible => 'You meet the requirements';

  @override
  String get admissionsVerdictNeedsChecking =>
      'Some requirements need checking';

  @override
  String get admissionsVerdictNotEligible =>
      'You don’t yet meet the requirements';

  @override
  String get admissionsVerdictClosed => 'Applications have closed';

  @override
  String get admissionsVerdictClosedSummary =>
      'Applications closed for the current session. The quota is full.';

  @override
  String get admissionsFacultyScience => 'Science';

  @override
  String get admissionsFacultyArts => 'Arts';

  @override
  String get admissionsFacultyLaw => 'Law';

  @override
  String get admissionsFacultyEngineering => 'Engineering';

  @override
  String admissionsFacultyFilterAll(Object count) {
    return 'All faculties ($count)';
  }

  @override
  String get admissionsStudyModeUndergraduate => 'Full-time undergraduate';

  @override
  String get admissionsStudyModeDirectEntry => 'Direct Entry / Full-time';

  @override
  String admissionsFacultyFilterNamed(Object count, Object faculty) {
    return '$faculty ($count)';
  }
}

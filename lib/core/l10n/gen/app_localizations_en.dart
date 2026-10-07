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
  String get validationPasswordNeedsLettersAndNumbers =>
      'Use both letters and numbers in your password.';

  @override
  String get validationPasswordMismatch => 'The passwords do not match.';

  @override
  String get validationInvalidPhone => 'Enter a valid phone number.';

  @override
  String get validationEmailAlreadyRegistered =>
      'An account already exists for this email address. Sign in instead.';

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
  String get createAccountBackTooltip => 'Back to sign in';

  @override
  String get createAccountBrandCaption => 'The Legion University Admissions';

  @override
  String get createAccountTitle => 'Create an applicant account';

  @override
  String get createAccountSubtitle =>
      'Apply for admission, claim your JAMB result and track your offer. Students and staff get their accounts from the university.';

  @override
  String get fieldRequiredMarker => '*';

  @override
  String createAccountOptionalLabel(Object label) {
    return '$label (optional)';
  }

  @override
  String get createAccountFirstName => 'First name';

  @override
  String get createAccountFirstNameHint => 'e.g. Oluwaseun';

  @override
  String get createAccountSurname => 'Surname';

  @override
  String get createAccountSurnameHint => 'e.g. Adeyemi';

  @override
  String get createAccountOtherNames => 'Other names';

  @override
  String get createAccountOtherNamesHint => 'e.g. Michael';

  @override
  String get createAccountEmail => 'Email address';

  @override
  String get createAccountEmailHint => 'candidate@example.com';

  @override
  String get createAccountEmailHelper => 'We\'ll send a link to confirm it.';

  @override
  String get createAccountPhone => 'Phone number';

  @override
  String get createAccountPhoneHint => '+234 803 123 4567';

  @override
  String get createAccountPassword => 'Password';

  @override
  String get createAccountPasswordHint => 'Enter password';

  @override
  String get createAccountPasswordHelper =>
      '8 or more characters, with letters and numbers.';

  @override
  String get createAccountConfirmPassword => 'Confirm password';

  @override
  String get createAccountConfirmPasswordHint => 'Repeat password';

  @override
  String get createAccountSubmit => 'Create account';

  @override
  String get createAccountSubmitting => 'Creating account';

  @override
  String get createAccountHaveAccount => 'Already have an account?';

  @override
  String get createAccountSignIn => 'Sign in';

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
  String get navFees => 'Fees';

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
  String get admissionsProgrammeAlreadyApplied => 'Already applied this cycle';

  @override
  String get admissionsProgrammeApply => 'Apply';

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
  String get admissionsStudyModeDiploma => 'Full-time diploma';

  @override
  String admissionsFacultyFilterNamed(Object count, Object faculty) {
    return '$faculty ($count)';
  }

  @override
  String get admissionsDetailTitle => 'Application';

  @override
  String get admissionsDetailCaption => 'Application detail';

  @override
  String get admissionsDetailBackTooltip => 'Back to my applications';

  @override
  String admissionsDetailSubmitBy(Object date, Object time) {
    return 'Submit by $date, $time';
  }

  @override
  String get admissionsDetailNotFound =>
      'This application is no longer on your record.';

  @override
  String get admissionsChecklistTitle => 'Before you submit';

  @override
  String get admissionsChecklistSubtitle =>
      'Complete each item, then come back to submit.';

  @override
  String get admissionsChecklistProgress => 'Progress';

  @override
  String admissionsChecklistProgressValue(Object done, Object total) {
    return '$done of $total complete';
  }

  @override
  String admissionsChecklistEmailDetail(Object email) {
    return 'Open the confirmation link we emailed to $email.';
  }

  @override
  String get admissionsNotTracked => 'Not tracked';

  @override
  String get admissionsChecklistResendEmail => 'Resend confirmation email';

  @override
  String get admissionsChecklistResendNote =>
      'We send one every time you ask. Check your spam folder.';

  @override
  String get admissionsChecklistActionResend => 'Resend';

  @override
  String get admissionsChecklistActionComplete => 'Complete';

  @override
  String get admissionsChecklistActionClaim => 'Claim';

  @override
  String get admissionsChecklistActionUpload => 'Upload';

  @override
  String get admissionsChecklistActionInvite => 'Invite';

  @override
  String get admissionsChecklistActionCheck => 'Check';

  @override
  String get admissionsChoicesTitle => 'Programme choices';

  @override
  String get admissionsChoicesFirstLabel => 'First choice *';

  @override
  String get admissionsChoicesSecondLabel => 'Second choice';

  @override
  String get admissionsChoicesOptional => 'optional';

  @override
  String get admissionsChoicesNone => 'None';

  @override
  String get admissionsChoicesFee => 'Form fee for your first choice:';

  @override
  String get admissionsChoicesSave => 'Save choices';

  @override
  String get admissionsRefereesTitle => 'Referees';

  @override
  String get admissionsRefereesSubtitle =>
      'At least 2 required. Each receives an emailed link to a short confidential form.';

  @override
  String get admissionsRefereeAwaiting => 'Awaiting';

  @override
  String get admissionsRefereeResend => 'Resend';

  @override
  String get admissionsRefereeRemoveTooltip => 'Remove referee';

  @override
  String get admissionsRefereeInviteTitle => 'Invite a referee';

  @override
  String get admissionsRefereeInviteSubtitle =>
      'They get a link by email. They never see your application.';

  @override
  String get admissionsRefereeNameLabel => 'Name *';

  @override
  String get admissionsRefereeEmailLabel => 'Email *';

  @override
  String get admissionsRefereePhoneLabel => 'Phone (optional)';

  @override
  String get admissionsRefereeOccupationLabel => 'Occupation (optional)';

  @override
  String get admissionsRefereeNameHint => 'Dr/Prof Full Name';

  @override
  String get admissionsRefereeEmailHint => 'official.email@institution.edu.ng';

  @override
  String get admissionsRefereePhoneHint => '+234...';

  @override
  String get admissionsRefereeOccupationHint =>
      'e.g. Senior Lecturer, ABU Zaria';

  @override
  String get admissionsRefereeSend => 'Send invitation';

  @override
  String get admissionsSubmitTitle => 'Submit';

  @override
  String get admissionsSubmitDeclaration =>
      'I confirm that the information in my application and records is true and complete. I understand that false information will lead to my admission being withdrawn.';

  @override
  String get admissionsSubmitAction => 'Submit application';

  @override
  String admissionsSubmitBlocked(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Complete the checklist first. $count items are outstanding',
      one: 'Complete the checklist first. 1 item is outstanding',
    );
    return '$_temp0';
  }

  @override
  String get admissionsSubmitNeedsDeclaration =>
      'Tick the confirmation above to submit.';

  @override
  String get admissionsHistoryTitle => 'History';

  @override
  String get admissionsHistorySubtitle => 'Append-only record';

  @override
  String get admissionsWithdrawAction => 'Withdraw application';

  @override
  String get admissionsWithdrawTitle => 'Withdraw this application?';

  @override
  String get admissionsWithdrawBody =>
      'The application is closed for good and cannot be reopened. You can start another while the cycle is still open.';

  @override
  String admissionsDepartmentInFaculty(Object department, Object faculty) {
    return '$department, Faculty of $faculty';
  }

  @override
  String admissionsFacultyAndMode(Object faculty, Object mode) {
    return 'Faculty of $faculty • $mode';
  }

  @override
  String get admissionsOfferLetter => 'Admission letter';

  @override
  String get admissionsOfferEyebrow => 'Admission offered';

  @override
  String get admissionsOfferLevel => 'Level';

  @override
  String admissionsOfferLevelValue(Object level) {
    return '$level Level';
  }

  @override
  String get admissionsOfferSession => 'Session';

  @override
  String get admissionsOfferFormFee => 'Form fee';

  @override
  String admissionsOfferFormFeePaid(Object date) {
    return '(paid $date)';
  }

  @override
  String get admissionsOfferAcceptanceFee => 'Acceptance fee';

  @override
  String get admissionsOfferAcceptanceFeeDue => '(due after you accept)';

  @override
  String admissionsOfferAcceptBy(Object date) {
    return 'Accept by $date';
  }

  @override
  String get admissionsOfferAcceptByNote =>
      'After that date the offer lapses and the place is offered to somebody else.';

  @override
  String admissionsOfferCondition(Object fee) {
    return 'You accept on this page. You then pay the acceptance fee of $fee under Payments. The registry then issues your matric number.';
  }

  @override
  String get admissionsOfferAccept => 'Accept offer';

  @override
  String get admissionsOfferReadLetter => 'Read the admission letter first';

  @override
  String get admissionsOfferDecline => 'Decline offer';

  @override
  String get admissionsDecisionContext => 'Candidate portal • Final decision';

  @override
  String admissionsDecisionCycleChip(Object session) {
    return 'Cycle $session';
  }

  @override
  String get admissionsDecisionUnsuccessful => 'Admission unsuccessful';

  @override
  String get admissionsDecisionProgrammeApplied => 'Programme applied';

  @override
  String get admissionsDecisionReference => 'Reference';

  @override
  String get admissionsDecisionSubmittedOn => 'Submitted';

  @override
  String get admissionsDecisionDecidedOn => 'Decision date';

  @override
  String admissionsDecisionDateTime(Object date, Object time) {
    return '$date • $time';
  }

  @override
  String get admissionsDecisionFindingTitle =>
      'Official admissions committee finding';

  @override
  String admissionsDecisionFindingBody(Object cycle) {
    return 'The Central Admissions Committee of The Legion, having evaluated all verified credentials for the $cycle exercise, regrets to communicate that your application has not been recommended for matriculation.';
  }

  @override
  String get admissionsDecisionDeterminationLabel => 'Primary determination';

  @override
  String get admissionsAuditTitle => 'Departmental metric audit';

  @override
  String get admissionsAuditCaption => 'Statutory minimums';

  @override
  String get admissionsAuditSubmitted => 'Submitted';

  @override
  String get admissionsAuditRequired => 'Required';

  @override
  String get admissionsCriterionUtme => 'UTME composite score';

  @override
  String get admissionsCriterionOlevelEnglish => 'O\'level English literature';

  @override
  String get admissionsCriterionDirectEntry => 'Direct entry accreditation';

  @override
  String get admissionsOutcomeMet => 'Met';

  @override
  String get admissionsOutcomeBelowCutoff => 'Below cutoff';

  @override
  String get admissionsOutcomeDeficit => 'Deficit';

  @override
  String get admissionsOutcomeIncomplete => 'Incomplete';

  @override
  String get admissionsAttestationEyebrow => 'Attestation and record';

  @override
  String get admissionsAttestationOffice => 'Office of the Registrar';

  @override
  String get admissionsAttestationDirectorate =>
      'Admissions Directorate • The Legion';

  @override
  String get admissionsAttestationHash => 'Verification hash';

  @override
  String get admissionsAttestationImmutable => 'Immutable';

  @override
  String admissionsAttestationConclusive(Object cycle) {
    return 'Decisions pronounced by the Central Admissions Board are conclusive for the specified academic year. Re-evaluation within the $cycle exercise is closed.';
  }

  @override
  String get admissionsNextCycleHeadline => 'Applications are open';

  @override
  String get admissionsNextCycleBody =>
      'You may submit a fresh profile for the forthcoming academic session, explore alternative departments, or address credential requirements.';

  @override
  String get admissionsStartNewApplication => 'Start a new application';

  @override
  String get admissionsDownloadDecisionNotice =>
      'Download the decision notice (PDF)';

  @override
  String get admissionsInquiriesTitle => 'Administrative inquiries';

  @override
  String get admissionsReturnToApplications => 'Return to my applications';

  @override
  String get admissionsHelpDesk => 'Admissions help desk';

  @override
  String get admissionsMatriculatedTitle => 'You\'re matriculated';

  @override
  String get admissionsMatriculatedUse =>
      'Use it in all correspondence with the university.';

  @override
  String get admissionsMatriculatedComplete =>
      'Your admission is complete. Your student portal is open.';

  @override
  String get admissionsMatriculatedDownloadLetter =>
      'Download your admission letter';

  @override
  String get admissionsExpiredTitle => 'Offer expired';

  @override
  String admissionsExpiredBody(Object date, Object programme) {
    return 'The offer of $programme expired on $date.';
  }

  @override
  String get admissionsExpiredNote =>
      'The place has been offered to somebody else. Your application and records stay on your account, and you can apply again in the next cycle.';

  @override
  String get admissionsWithdrawnTitle => 'Application withdrawn';

  @override
  String admissionsWithdrawnBody(Object date) {
    return 'You withdrew this application on $date.';
  }

  @override
  String admissionsWithdrawnReason(Object reason) {
    return '“Reason: $reason”';
  }

  @override
  String get admissionsWithdrawnNote =>
      'You can start a new application in any open cycle.';

  @override
  String get admissionsClosedRejectedTitle => 'Application not successful';

  @override
  String admissionsClosedRejectedBody(Object programme) {
    return 'Your application to $programme was not successful in this round.';
  }

  @override
  String get admissionsClosedRejectedNote =>
      'You are welcome to apply again in the next cycle, and your records and documents stay on your account.';

  @override
  String get admissionsLetterCaption => 'Admission letter';

  @override
  String get admissionsLetterBackTooltip => 'Back to the application';

  @override
  String get admissionsLetterSavePdf => 'Save PDF';

  @override
  String get admissionsLetterShare => 'Share';

  @override
  String get admissionsLetterCopyCode => 'Copy';

  @override
  String get admissionsLetterCodeCopied => 'Verification code copied';

  @override
  String get admissionsLetterKeepNote =>
      'Keep this letter. It is the document a landlord or employer will ask to see.';

  @override
  String get admissionsLetterNotIssued =>
      'No letter has been issued for this application.';

  @override
  String get admissionsLetterUniversity => 'The Legion University';

  @override
  String get admissionsLetterOffice => 'Office of the Registrar | Admissions';

  @override
  String get admissionsLetterRef => 'Ref:';

  @override
  String get admissionsLetterDate => 'Date:';

  @override
  String get admissionsLetterScanToVerify => 'Scan to verify';

  @override
  String admissionsLetterHeadline(Object session) {
    return 'Offer of provisional admission: $session session';
  }

  @override
  String admissionsLetterBody(
    Object department,
    Object faculty,
    Object level,
    Object programme,
    Object session,
  ) {
    return 'I am pleased to inform you that you have been offered provisional admission to study for the award of $programme in the $department, Faculty of $faculty, entering at $level Level, for the $session academic session.';
  }

  @override
  String admissionsLetterBodyNoFaculty(
    Object department,
    Object level,
    Object programme,
    Object session,
  ) {
    return 'I am pleased to inform you that you have been offered provisional admission to study for the award of $programme in the $department, entering at $level Level, for the $session academic session.';
  }

  @override
  String get admissionsLetterConditionsIntro =>
      'This offer is subject to the following conditions:';

  @override
  String admissionsLetterConditionNumber(Object index) {
    return '$index.';
  }

  @override
  String admissionsLetterConditionAccept(Object date) {
    return 'You accept the offer on the admissions portal by $date.';
  }

  @override
  String admissionsLetterConditionFee(Object fee) {
    return 'You pay the acceptance fee of $fee.';
  }

  @override
  String get admissionsLetterConditionCredentials =>
      'The originals of your credentials are verified at registration. The offer will be withdrawn if any information you supplied proves false.';

  @override
  String admissionsLetterConditionRules(Object programme) {
    return 'You meet the requirements for $programme and abide by the rules and regulations of the university.';
  }

  @override
  String get admissionsLetterClosing => 'Please accept my congratulations.';

  @override
  String get admissionsLetterVerifyPrefix => 'Verify this letter at';

  @override
  String get admissionsLetterVerifyWithCode => 'with code';

  @override
  String get admissionsLetterVerifySuffix => ', or scan the QR code.';

  @override
  String get admissionsVerifyBrandCaption => 'Admissions verification';

  @override
  String get admissionsVerifyTitle => 'Verify an admission';

  @override
  String get admissionsVerifySubtitle =>
      'Enter the verification code printed at the foot of the admission letter.';

  @override
  String get admissionsVerifyCodeLabel => 'Verification code';

  @override
  String get admissionsVerifyCodeHint => 'e.g. 7KQ2M9XW4HPA';

  @override
  String get admissionsVerifyAction => 'Verify';

  @override
  String get admissionsVerifyGenuine => 'Genuine admission';

  @override
  String get admissionsVerifyName => 'Name';

  @override
  String get admissionsVerifyProgramme => 'Programme';

  @override
  String get admissionsVerifyLevel => 'Level';

  @override
  String get admissionsVerifySession => 'Session';

  @override
  String get admissionsVerifyStatus => 'Status';

  @override
  String get admissionsVerifyMatricNumber => 'Matric number';

  @override
  String get admissionsVerifyIssuedOn => 'Offered on';

  @override
  String get admissionsVerifyNotFoundTitle => 'No admission matches this code';

  @override
  String get admissionsVerifyNotFoundBody =>
      'Check the code at the foot of the letter and try again. If it still does not match, the letter was not issued by the university.';

  @override
  String get admissionsVerifyPrivacyNote =>
      'This page shows only what is printed on the letter.';

  @override
  String get admissionsVerifySignIn => 'Sign in to the portal';

  @override
  String get admissionsJambEyebrow => 'CAPS result import';

  @override
  String get admissionsJambHeading => 'Claim your JAMB result';

  @override
  String get admissionsJambIntro =>
      'The Legion University receives official examination results directly from the Joint Admissions and Matriculation Board (JAMB) Central Admissions Processing System (CAPS). Match your record to link your score to your application.';

  @override
  String get admissionsJambRegistrationLabel => 'JAMB registration number';

  @override
  String get admissionsJambRegistrationHint => 'e.g. 202630112233AB';

  @override
  String get admissionsJambRegistrationHelper =>
      '12-digit number followed by 2 letters, as printed on your JAMB slip.';

  @override
  String get admissionsJambSurnameLabel => 'Surname';

  @override
  String get admissionsJambSurnameHint => 'As on your JAMB slip';

  @override
  String get admissionsJambSurnameHelper =>
      'Must match exactly as registered with JAMB.';

  @override
  String get admissionsJambDateOfBirthLabel => 'Date of birth';

  @override
  String get admissionsJambDateOfBirthHint => 'DD / MM / YYYY';

  @override
  String get admissionsJambDateOfBirthHelper =>
      'Used to verify you are the legitimate candidate.';

  @override
  String get admissionsJambDateOfBirthPickerTitle => 'Your date of birth';

  @override
  String get admissionsJambPermanentWarning =>
      'Check your registration number carefully. Linking a JAMB result is permanent and cannot be undone from the portal.';

  @override
  String get admissionsJambFindAction => 'Find my result';

  @override
  String get admissionsJambMatching => 'Checking CAPS';

  @override
  String get admissionsJambConfirmAction => 'Confirm and link result';

  @override
  String get admissionsJambHelpLink =>
      'Need help claiming? Contact admissions registry';

  @override
  String get admissionsJambRecordEyebrow => 'Verification status';

  @override
  String get admissionsJambRecordTitle => 'Official CAPS record';

  @override
  String get admissionsJambRecordFound => 'Record found';

  @override
  String get admissionsJambRecordLinked => 'Linked';

  @override
  String get admissionsJambCandidate => 'Candidate';

  @override
  String get admissionsJambExaminationYear => 'Examination year';

  @override
  String admissionsJambExaminationValue(Object year) {
    return '$year UTME';
  }

  @override
  String get admissionsJambAggregate => 'Aggregate score';

  @override
  String get admissionsJambSubjects => 'Subject breakdown';

  @override
  String admissionsJambBindingNotice(Object reference) {
    return 'This record will be permanently linked to $reference.';
  }

  @override
  String admissionsJambLinkedNotice(Object reference) {
    return 'This record is permanently linked to $reference.';
  }

  @override
  String get admissionsJambLinkedMessage =>
      'Your JAMB result is now on your record.';

  @override
  String get admissionsJambNotFoundTitle => 'No record matches these details';

  @override
  String get admissionsJambNotFoundBody =>
      'Check the registration number, surname and date of birth against your JAMB slip and try again. If they are right and it still does not match, CAPS has not sent us your result yet.';

  @override
  String get feesInstitution => 'The Legion University';

  @override
  String get feesBackTooltip => 'Back to the hub';

  @override
  String get feesEyebrow => 'Bursary & Financial Services';

  @override
  String get feesTitle => 'Student fees';

  @override
  String feesStudentLine(Object level, Object matricNumber, Object name) {
    return '$name · $matricNumber · $level';
  }

  @override
  String feesLevel(Object level) {
    return '$level Level';
  }

  @override
  String get feesOutstandingLabel => 'Total outstanding balance';

  @override
  String feesDueOn(Object date) {
    return 'Due $date';
  }

  @override
  String get feesNothingOutstanding => 'Nothing is owed on your account.';

  @override
  String feesPayOutstanding(Object amount) {
    return 'Pay outstanding ($amount)';
  }

  @override
  String get feesPaymentChannelsNote =>
      'Bank transfer, card and Remita RRR are supported, with instant bursary clearance.';

  @override
  String feesInvoicesHeading(Object session) {
    return '$session invoices';
  }

  @override
  String feesPendingCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pending',
      one: '1 pending',
      zero: 'All settled',
    );
    return '$_temp0';
  }

  @override
  String get feesNoInvoices => 'No invoices have been raised for this session.';

  @override
  String get feesStatusUnpaid => 'Unpaid';

  @override
  String get feesStatusPartPaid => 'Part paid';

  @override
  String get feesStatusSettled => 'Settled';

  @override
  String get feesStatusCancelled => 'Cancelled';

  @override
  String get feesTotalBilled => 'Total billed';

  @override
  String get feesAmountCleared => 'Amount cleared';

  @override
  String get feesRemainingBalance => 'Remaining balance';

  @override
  String get feesPaymentProgress => 'Payment progress';

  @override
  String feesPercent(Object percent) {
    return '$percent%';
  }

  @override
  String feesPayBalance(Object amount) {
    return 'Pay $amount';
  }

  @override
  String feesPayAmount(Object amount) {
    return 'Pay $amount';
  }

  @override
  String get feesBreakdown => 'Breakdown';

  @override
  String get feesAmount => 'Amount';

  @override
  String get feesHistoryHeading => 'Payment history & receipts';

  @override
  String get feesViewAll => 'View all';

  @override
  String get feesNoPayments => 'No payments have been recorded yet.';

  @override
  String get feesPaymentSuccessful => 'Successful';

  @override
  String get feesPaymentPending => 'Awaiting confirmation';

  @override
  String feesPaymentLine(Object channel, Object date) {
    return '$date · $channel';
  }

  @override
  String get feesChannelCard => 'Card';

  @override
  String get feesChannelRemitaRrr => 'Remita RRR';

  @override
  String feesChannelWithReference(Object channel, Object reference) {
    return '$channel $reference';
  }

  @override
  String get feesReceiptPdf => 'Receipt PDF';

  @override
  String get feesBursaryNoticeTitle => 'Institutional bursary notice:';

  @override
  String get feesBursaryNoticeBody =>
      'All official payments must be validated with an official university bursary receipt bearing a cryptographic QR code. Cash payments to staff are strictly prohibited.';

  @override
  String get feesCheckoutTitle => 'Make payment';

  @override
  String get feesCheckoutSubtitle =>
      'Official bursary payment gateway · The Legion University';

  @override
  String get feesCheckoutBackTooltip => 'Back to your fees';

  @override
  String get feesSecure => 'Secure';

  @override
  String get feesPaymentDetails => 'Payment details';

  @override
  String feesTerm(Object session) {
    return 'Term: $session';
  }

  @override
  String get feesInvoiceReference => 'Invoice reference';

  @override
  String get feesDescription => 'Description';

  @override
  String get feesGatewayCharge => 'Gateway processing charge (statutory)';

  @override
  String get feesGatewayChargeInfo =>
      'A statutory charge collected by the payment gateway, not by the university.';

  @override
  String get feesTotalPayable => 'Total amount payable';

  @override
  String get feesTotalPayableNote =>
      'Includes statutory automated clearing fees';

  @override
  String get feesSelectAmount => 'Select payment amount';

  @override
  String get feesPayFull => 'Pay full balance';

  @override
  String get feesPayFullDetail =>
      'Clears your course enrolment hold immediately';

  @override
  String get feesPayInstalment => 'Pay a custom instalment';

  @override
  String feesMinimumInstalment(Object amount) {
    return 'Minimum permitted instalment: $amount';
  }

  @override
  String get feesSpecifiedAmount => 'Specified payment amount';

  @override
  String get feesInstalmentMissing => 'Enter the amount you want to pay.';

  @override
  String feesInstalmentBelowMinimum(Object amount) {
    return 'Enter at least $amount.';
  }

  @override
  String feesInstalmentAboveBalance(Object amount) {
    return 'Enter no more than $amount, the balance owed.';
  }

  @override
  String get feesPaymentMethod => 'Payment method';

  @override
  String get feesVerifiedIntegrations => 'Verified integrations';

  @override
  String get feesMethodGateway => 'Card & instant bank transfer';

  @override
  String get feesMethodGatewayDetail =>
      'Remita & Interswitch secure gateway. Automated clearance within 60 seconds.';

  @override
  String get feesMethodInstant => 'Instant';

  @override
  String get feesMethodBankBranch => 'Bank branch via RRR invoice';

  @override
  String get feesMethodBankBranchClearing => '1–24h clearing';

  @override
  String get feesMethodBankBranchDetail =>
      'Pay at any commercial bank branch across Nigeria using your active reference.';

  @override
  String feesRrrLabel(Object reference) {
    return 'RRR: $reference';
  }

  @override
  String get feesCopy => 'Copy';

  @override
  String get feesReferenceCopied => 'Reference copied.';

  @override
  String get feesMethodVirtualAccount =>
      'NIP dedicated student virtual account';

  @override
  String feesMethodVirtualAccountDetail(Object matricNumber) {
    return 'Single-use account generated specifically for matric $matricNumber.';
  }

  @override
  String get feesChipDebitCard => 'Debit card';

  @override
  String get feesChipUssd => 'USSD';

  @override
  String get feesChipDirectDebit => 'Direct debit';

  @override
  String get feesPayerVerification => 'Payer verification';

  @override
  String get feesVerifiedRecord => 'Verified record';

  @override
  String get feesStudentName => 'Student name';

  @override
  String get feesMatricNumber => 'Matriculation number';

  @override
  String get feesDepartment => 'Academic department';

  @override
  String feesDepartmentValue(Object department, Object level) {
    return '$department ($level)';
  }

  @override
  String get feesEmail => 'Institutional email';

  @override
  String get feesProceed => 'Proceed to pay';

  @override
  String feesProceedToPay(Object amount) {
    return 'Proceed to pay $amount';
  }

  @override
  String get feesProceedNote =>
      'Encrypted 256-bit TLS connection. Your payment updates your student portal and unlocks course registration immediately.';

  @override
  String get feesCheckoutNothingToPay =>
      'There is nothing to pay on these invoices.';

  @override
  String get feesCardCheckoutTitle => 'Card checkout';

  @override
  String get feesCardCheckoutEyebrow => 'The Legion · Bursary gateway';

  @override
  String get feesCardCheckoutBackTooltip => 'Back to payment details';

  @override
  String get feesPciCompliant => 'PCI-DSS compliant';

  @override
  String get feesFeeBreakdown => 'Fee breakdown';

  @override
  String get feesItemisedSchedule => 'Itemised schedule';

  @override
  String get feesSecurePayment => 'Secure payment';

  @override
  String get feesTlsActive => 'TLS 1.3 active';

  @override
  String get feesSecurePaymentNote =>
      '256-bit TLS encrypted sovereign bursary settlement.';

  @override
  String get feesSupportedNetworks => 'Supported networks';

  @override
  String get feesNetworkMastercard => 'Mastercard';

  @override
  String get feesNetworkVerve => 'Verve';

  @override
  String get feesNetworkVisa => 'Visa';

  @override
  String get feesCardInformation => 'Card information';

  @override
  String get feesCardInformationDetail =>
      'Enter your debit or credit card details below to complete your academic fee settlement.';

  @override
  String get feesCardNumber => 'Card number';

  @override
  String get feesCardNumberHint => 'ACCT-000003';

  @override
  String get feesCardExpiry => 'Expiry date';

  @override
  String get feesCardExpiryHint => 'MM/YY';

  @override
  String get feesCardCvv => 'CVV / Security code';

  @override
  String get feesCardCvvHint => '123';

  @override
  String get feesCardCvvHelp => '3 digits';

  @override
  String get feesCardPin => 'Card PIN';

  @override
  String get feesCardPinHint => '••••';

  @override
  String get feesCardPinNote =>
      'Required to authorise domestic debit cards via Interswitch / NIBSS before 3D-Secure verification.';

  @override
  String get feesSaveCard => 'Save card for future session payments';

  @override
  String get feesCardTokenNote =>
      'Card details are encrypted and tokenised according to CBN regulatory standards.';

  @override
  String feesPayAmountAction(Object amount) {
    return 'Pay $amount';
  }

  @override
  String get feesPayRedirectNote =>
      'You will be redirected to your bank\'s 3D-Secure authentication screen.';

  @override
  String get feesCancelToFees => 'Cancel and return to fees';

  @override
  String get feesCbnLicensed => 'Central Bank of Nigeria licensed PSP';

  @override
  String get feesEndToEndEncryption => 'End-to-end encryption';

  @override
  String feesTransactionReference(Object reference) {
    return 'Transaction reference: $reference';
  }

  @override
  String get feesGatewayReturnBackTooltip => 'Back to fees';

  @override
  String get feesGatewayReturnShareTooltip => 'Share receipt';

  @override
  String get feesGatewayStatusPending => 'Awaiting confirmation';

  @override
  String get feesGatewayStatusSucceeded => 'Payment successful';

  @override
  String get feesGatewayStatusFailed => 'Payment failed';

  @override
  String get feesGatewayStatusExpired => 'Payment expired';

  @override
  String get feesGatewayPendingDetail =>
      'The gateway has not confirmed this payment yet. You can close this page. Your reference is kept below.';

  @override
  String feesGatewaySucceededDetail(Object date) {
    return 'Remita settlement confirmed · $date';
  }

  @override
  String get feesGatewayFailedDetail =>
      'The gateway declined this attempt. No money was taken. Try again from your fees.';

  @override
  String get feesGatewayExpiredDetail =>
      'This payment window closed before the gateway answered. No money was taken.';

  @override
  String get feesGatewayYouCanClose => 'You can close this page.';

  @override
  String get feesCoursePortalUnlocked => 'Course portal unlocked';

  @override
  String get feesCoursePortalActive => 'Active';

  @override
  String get feesCoursePortalDetail =>
      'Harmattan semester registration clearance is now linked to your academic dossier.';

  @override
  String get feesRemitaRrr => 'Remita RRR';

  @override
  String get feesGatewayReference => 'Gateway reference';

  @override
  String get feesPaymentChannel => 'Payment channel';

  @override
  String get feesPaidFor => 'Paid for';

  @override
  String get feesViewOfficialReceipt => 'View official receipt';

  @override
  String get feesProceedToRegistration => 'Proceed to course registration';

  @override
  String get feesGatewayVerifiedStamp =>
      'Cryptographically verified by The Legion Treasury';

  @override
  String get feesGatewaySupport =>
      'Support inquiries: bursary@thelegion.edu.ng';

  @override
  String get feesGatewayReturnNotFound => 'No payment matches this reference.';

  @override
  String get feesReceiptBackTooltip => 'Back';

  @override
  String feesReceiptTitle(Object number) {
    return 'Clearance receipt $number';
  }

  @override
  String get feesReceiptVerifiedCleared => 'Verified & cleared';

  @override
  String get feesReceiptKeepNote =>
      'Keep this receipt for your exam docket, hostel clearance and any bursary enquiry.';

  @override
  String get feesReceiptSavePdf => 'Print or save as PDF';

  @override
  String get feesReceiptShare => 'Share receipt';

  @override
  String get feesReceiptCopyCode => 'Copy verification code';

  @override
  String get feesReceiptCodeCopied => 'Verification code copied.';

  @override
  String get feesReceiptOffice => 'Office of the Bursar';

  @override
  String get feesReceiptUnit => 'FIS & Treasury verification unit';

  @override
  String get feesReceiptBadge => 'Official e-receipt';

  @override
  String get feesReceiptNumber => 'Receipt number';

  @override
  String get feesReceiptDate => 'Date';

  @override
  String get feesReceiptSession => 'Academic session';

  @override
  String get feesReceiptCentralRrr => 'Central RRR';

  @override
  String get feesReceiptStudentHeading => 'Student & payer';

  @override
  String feesReceiptFacultyProgram(Object department, Object faculty) {
    return '$faculty · $department';
  }

  @override
  String get feesReceiptItem => 'Item';

  @override
  String get feesReceiptFee => 'Fee';

  @override
  String get feesReceiptLineStatus => 'Status';

  @override
  String get feesReceiptLinePaid => 'Paid';

  @override
  String get feesReceiptTotalCleared => 'Total paid & cleared';

  @override
  String get feesReceiptSettled => 'Settled';

  @override
  String get feesReceiptToWallet => 'To wallet';

  @override
  String get feesReceiptChannel => 'Settlement channel';

  @override
  String get feesReceiptAuthCode => 'Authorisation code';

  @override
  String get feesReceiptClearingRef => 'Clearing reference';

  @override
  String get feesReceiptStamp => 'Electronically cleared & audited';

  @override
  String get feesReceiptSignatory => 'Alhaji Bello Danbatta';

  @override
  String get feesReceiptSignatoryTitle => 'University Bursar & CFO';

  @override
  String get feesReceiptVerifyUrl =>
      'Verify at thelegion.edu.ng/verify/receipt';

  @override
  String get feesReceiptScanToVerify => 'Scan to verify payment';

  @override
  String get feesReceiptNotFound => 'No receipt matches this reference.';

  @override
  String get feesVerifyBrandCaption => 'Bursary receipt verification';

  @override
  String get feesVerifyTitle => 'Verify a receipt';

  @override
  String get feesVerifySubtitle =>
      'Enter the verification code printed at the foot of the official bursary receipt.';

  @override
  String get feesVerifyOffice =>
      'Office of the Registrar · Directorate of Bursary Services';

  @override
  String get feesVerifyCodeLabel => 'Receipt reference key';

  @override
  String get feesVerifyCodeHint => 'e.g. 9K8L-4M2P-TX77';

  @override
  String get feesVerifyAction => 'Verify receipt';

  @override
  String get feesVerifyGenuine => 'Genuine bursary receipt';

  @override
  String get feesVerifyReceiptNumber => 'Receipt number';

  @override
  String get feesVerifyAmount => 'Amount paid';

  @override
  String get feesVerifyPaidBy => 'Paid by';

  @override
  String get feesVerifyPaidFor => 'For';

  @override
  String get feesVerifyPaidOn => 'Payment date';

  @override
  String get feesVerifyNotFoundTitle => 'No receipt matches this code';

  @override
  String get feesVerifyNotFoundBody =>
      'Check the code at the foot of the receipt and try again. If it still does not match, the receipt was not issued by the university.';

  @override
  String get feesVerifyPrivacyTitle => 'Privacy & redaction';

  @override
  String get feesVerifyPrivacyBody =>
      'This page shows only what is confirmed on the official bursary ledger: receipt number, amount, payer name, purpose and date. It does not show email, phone, address, matric number, bank account or gateway references.';

  @override
  String get feesVerifySignIn => 'Sign in to the student portal';

  @override
  String get navRegistration => 'Registration';

  @override
  String get navStudyPlan => 'Study plan';

  @override
  String get navCourseForm => 'Form';

  @override
  String get navRequests => 'Requests';

  @override
  String get registrationBackTooltip => 'Back to the hub';

  @override
  String get registrationTitle => 'Course registration';

  @override
  String get registrationBreadcrumbStudent => 'Student';

  @override
  String registrationSessionLine(Object session, Object term) {
    return '$session · $term';
  }

  @override
  String registrationSessionHeadline(Object session, Object term) {
    return '$session session · $term';
  }

  @override
  String registrationStudentProgramme(Object faculty, Object programme) {
    return '$programme · $faculty';
  }

  @override
  String registrationMatricLevel(Object level, Object matricNumber) {
    return '$matricNumber · $level';
  }

  @override
  String registrationMatricLevelSuffix(Object level, Object matricNumber) {
    return '· $matricNumber · $level';
  }

  @override
  String registrationLevel(Object level) {
    return '$level Level';
  }

  @override
  String get registrationUnitsRegisteredLabel => 'Units registered';

  @override
  String registrationCountingUnitsTitle(Object units) {
    return 'Counting units: $units';
  }

  @override
  String registrationCountingUnitsBody(Object minimum) {
    return 'You are at your minimum of $minimum exactly. Dropping any course leaves you below minimum.';
  }

  @override
  String registrationCatalogueTitleSection(Object section, Object title) {
    return '$title · Section $section';
  }

  @override
  String get registrationNoLecturesLab =>
      'No lectures or lab sessions scheduled';

  @override
  String registrationMeetingCourseVenue(Object code, Object venue) {
    return '$code · $venue';
  }

  @override
  String registrationMeetingTime(Object end, Object start) {
    return '$start - $end';
  }

  @override
  String get registrationWindowOpen => 'Open';

  @override
  String get registrationWindowOpenForYou => 'Open for you';

  @override
  String get registrationWindowAddDropOnly => 'Add/drop only';

  @override
  String get registrationWindowUpcoming => 'Opens soon';

  @override
  String get registrationWindowClosed => 'Closed';

  @override
  String get registrationUnitsLabel => 'Units';

  @override
  String registrationUnitsValue(Object maximum, Object registered) {
    return '$registered / $maximum';
  }

  @override
  String registrationUnitsHint(Object minimum) {
    return 'Min $minimum · Limit per plan';
  }

  @override
  String get registrationApprovalLabel => 'Approval';

  @override
  String get registrationApprovalHint => 'Adviser review';

  @override
  String get registrationFormShortLabel => 'Form';

  @override
  String get registrationFormPendingSubmit => 'Pending submit';

  @override
  String get registrationPendingLabel => 'Awaiting approval';

  @override
  String get registrationPendingHint => 'Level adviser queue';

  @override
  String registrationPendingCoursesValue(Object count) {
    return '$count';
  }

  @override
  String get registrationPendingCoursesHint => 'courses';

  @override
  String get registrationFormLabel => 'Course form';

  @override
  String get registrationFormNotSubmitted => 'Not submitted';

  @override
  String get registrationFormDraft => 'Draft';

  @override
  String get registrationFormSubmitted => 'Submitted';

  @override
  String get registrationFormHint => 'Submit when complete';

  @override
  String get registrationTabSelected => 'Selected & Timetable';

  @override
  String get registrationTabCatalogue => 'Catalogue & Add';

  @override
  String get registrationLedgerCourseTitle => 'Course / Title';

  @override
  String get registrationLedgerUnits => 'Units';

  @override
  String get registrationLedgerAction => 'Action';

  @override
  String get registrationActionBlocked => 'Blocked';

  @override
  String get registrationActionArchived => 'Archived';

  @override
  String get registrationActionNone => '—';

  @override
  String registrationMatricBulletLevel(String level, String matricNumber) {
    return '$level • $matricNumber';
  }

  @override
  String registrationUnitsDegreePlan(int minimum) {
    return 'Min $minimum · Degree plan';
  }

  @override
  String get registrationDeckTitle => 'Registration Deck';

  @override
  String registrationUnitsCap(Object maximum) {
    return '/ $maximum units';
  }

  @override
  String registrationCoursesTotal(Object count) {
    return '$count total';
  }

  @override
  String registrationStandardLoad(Object maximum, Object minimum) {
    return 'Standard load: $minimum-$maximum';
  }

  @override
  String get registrationLectureLabSchedule => 'Lecture & Lab Timetable';

  @override
  String get registrationWeekdaySat => 'Sat';

  @override
  String get registrationWeekdaySaturday => 'Saturday';

  @override
  String registrationEventCountShort(Object count) {
    return '$count ev';
  }

  @override
  String registrationEventsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count events',
      one: '1 event',
    );
    return '$_temp0';
  }

  @override
  String get registrationFree => 'Free';

  @override
  String get registrationActiveDay => 'Active day';

  @override
  String get registrationCatalogueSearchHint =>
      'Search by course code, title, or department';

  @override
  String get registrationCatalogueDepartmental => 'Departmental Catalog';

  @override
  String registrationNeedsPrerequisite(String code) {
    return 'Needs $code.';
  }

  @override
  String registrationNotOpenDetail(int units) {
    return 'No lecturer assigned · $units units';
  }

  @override
  String registrationCatalogueFullDetail(String title, int units) {
    return '$title · $units units';
  }

  @override
  String get registrationGateNotTracked => 'Not tracked';

  @override
  String registrationYourCourses(Object count) {
    return 'Your courses ($count)';
  }

  @override
  String get registrationYourCoursesTitle => 'Your Courses';

  @override
  String registrationUnitsRegistered(Object units) {
    return '$units units registered';
  }

  @override
  String registrationMinUnitsNote(Object minimum) {
    return 'Your degree plan asks for at least $minimum units this term.';
  }

  @override
  String get registrationYourWeek => 'Your Week';

  @override
  String get registrationLectureSchedule => 'Lecture schedule';

  @override
  String get registrationNoLectures => 'No lectures scheduled';

  @override
  String get registrationWeekdayMon => 'Mon';

  @override
  String get registrationWeekdayTue => 'Tue';

  @override
  String get registrationWeekdayWed => 'Wed';

  @override
  String get registrationWeekdayThu => 'Thu';

  @override
  String get registrationWeekdayFri => 'Fri';

  @override
  String get registrationAddCourses => 'Add Courses';

  @override
  String get registrationSubmittedForms => 'Submitted forms';

  @override
  String get registrationNoForms =>
      'No course form has been submitted for this window yet.';

  @override
  String get registrationHelpLine =>
      'Registration closed? Ask for late registration or add/drop from Requests.';

  @override
  String get registrationDeclaration =>
      'I confirm these courses conform to my degree structure and satisfy prerequisite conditions. Once submitted, changes require formal adviser clearance.';

  @override
  String get registrationSubmitForm => 'Submit course form';

  @override
  String get registrationSaveChanges => 'Save changes';

  @override
  String get registrationDrop => 'Drop';

  @override
  String get registrationAdd => 'Add';

  @override
  String get registrationAddAnyway => 'Add anyway';

  @override
  String get registrationRequestWaiver => 'Request it';

  @override
  String get registrationCancel => 'Cancel';

  @override
  String get registrationKeepIt => 'Keep it';

  @override
  String get registrationDropAnyway => 'Drop anyway';

  @override
  String get registrationStatusApproved => 'Approved';

  @override
  String get registrationStatusAwaiting => 'Awaiting approval';

  @override
  String get registrationStatusRejected => 'Rejected';

  @override
  String get registrationStatusDropped => 'Dropped';

  @override
  String get registrationStatusClashAccepted => 'Clash accepted';

  @override
  String get registrationCatalogueFull => 'Full';

  @override
  String get registrationCatalogueNotOpen => 'Not open yet';

  @override
  String get registrationCatalogueOutsidePlan => 'Outside your degree plan';

  @override
  String get registrationCatalogueClash => 'Timetable clash';

  @override
  String get registrationClashSheetTitle => 'Timetable clash';

  @override
  String registrationClashSheetBody(Object detail) {
    return '$detail You can still add it if your adviser accepts the clash.';
  }

  @override
  String registrationDropSheetTitle(Object code) {
    return 'Drop $code?';
  }

  @override
  String registrationDropSheetBody(Object minimum, Object units) {
    return 'Dropping this course leaves you on $units units, below the $minimum-unit minimum for this term.';
  }

  @override
  String registrationSectionUnits(Object section, Object units) {
    return '$units units · Section $section';
  }

  @override
  String registrationCourseUnits(Object units) {
    return '$units units';
  }

  @override
  String registrationViewForm(Object version) {
    return 'View form $version';
  }

  @override
  String get studyPlanTitle => 'Study plan';

  @override
  String get studyPlanUndergraduate => 'Undergraduate degree';

  @override
  String get studyPlanActiveStatus => 'Active Status';

  @override
  String get studyPlanUnitsPassed => 'Units passed';

  @override
  String get studyPlanUnitsPlanned => 'Units planned';

  @override
  String get studyPlanAwardUnits => 'Awarded on';

  @override
  String get studyPlanStillToPass => 'Still to pass';

  @override
  String studyPlanStillToPassValue(Object count) {
    return '$count courses';
  }

  @override
  String get studyPlanUnitsEarnedHint => 'earned';

  @override
  String get studyPlanUnitsCurrentTermHint => 'current term';

  @override
  String get studyPlanUnitsHint => 'units';

  @override
  String get studyPlanCoursesHint => 'courses';

  @override
  String studyPlanAwardCaption(int units) {
    return 'Degree plan requirement: $units units';
  }

  @override
  String studyPlanStillToPassCaption(int count) {
    return 'Across remaining levels: $count courses';
  }

  @override
  String get studyPlanProgrammeConclusion => 'Programme conclusion:';

  @override
  String studyPlanMatricLevelShort(String matricNumber, int level) {
    return '$matricNumber · ${level}L';
  }

  @override
  String get studyPlanWorthKnowing => 'Worth knowing now';

  @override
  String studyPlanAdvisoriesCount(int count) {
    return '$count Advisories';
  }

  @override
  String get studyPlanAdviserSaid => 'What your adviser said';

  @override
  String studyPlanAdviserByline(Object date, Object name) {
    return '$name · $date';
  }

  @override
  String get studyPlanTermByTerm => 'Your plan, term by term';

  @override
  String studyPlanTermsListed(int count) {
    return '$count Terms Listed';
  }

  @override
  String get studyPlanNowBadge => 'Now';

  @override
  String get studyPlanLedgerCourse => 'Course';

  @override
  String get studyPlanLedgerTitle => 'Title';

  @override
  String get studyPlanLedgerUnits => 'Units';

  @override
  String get studyPlanDegreeAsks => 'What your degree asks of you';

  @override
  String get studyPlanDegreeAsksSubtitle =>
      'Audit breakdown across all four academic levels.';

  @override
  String get studyPlanPassed => 'Passed';

  @override
  String get studyPlanCurrentLevel => 'Current Level';

  @override
  String get studyPlanTakingNow => 'Taking now';

  @override
  String get studyPlanStillToTake => 'Still to take';

  @override
  String get studyPlanACourse => 'Plan a course';

  @override
  String get studyPlanACourseSubtitle =>
      'Select an unallocated course and assign it to a future session.';

  @override
  String get studyPlanCourseLabel => 'Course';

  @override
  String get studyPlanTargetTermLabel => 'Target term';

  @override
  String get studyPlanSelectCourse => 'Select an outstanding course';

  @override
  String get studyPlanSelectTerm => 'Select academic term';

  @override
  String get studyPlanAddToPlan => 'Add to plan';

  @override
  String get studyPlanHowThisWorks => 'How this works';

  @override
  String get studyPlanHowThisWorksBody =>
      'Nothing on this page records what you have done. What is left is read from your degree plan and your results each time you open it, so clearing a carry-over changes it without you touching anything. What you store is only when you mean to take what remains.';

  @override
  String get studyPlanComingSoon =>
      'Planning a course into a future term goes live with the next release.';

  @override
  String courseFormTitle(Object version) {
    return 'Course form $version';
  }

  @override
  String get courseFormShortTitle => 'Course Form';

  @override
  String get courseFormSavePdf => 'Save PDF';

  @override
  String get courseFormShare => 'Share';

  @override
  String get courseFormOffice => 'Office of the Registrar · Academic Affairs';

  @override
  String get courseFormHeading => 'Course registration form';

  @override
  String get courseFormOfficialBadge => 'Official endorsed record';

  @override
  String get courseFormStudentHeading => 'Student identification';

  @override
  String get courseFormFullName => 'Full name';

  @override
  String get courseFormMatric => 'Matriculation number';

  @override
  String get courseFormLevel => 'Level';

  @override
  String get courseFormProgramme => 'Programme of study';

  @override
  String get courseFormFacultyDept => 'Faculty & department';

  @override
  String courseFormFacultyDeptValue(Object department, Object faculty) {
    return '$department, $faculty';
  }

  @override
  String get courseFormSubmissionLog => 'Submission log';

  @override
  String courseFormSubmissionLogLine(Object submittedOn, Object version) {
    return 'Submission Log: $version · $submittedOn WAT';
  }

  @override
  String get courseFormRegisteredCourses => 'Registered courses';

  @override
  String get courseFormTotalUnits => 'Total units';

  @override
  String get courseFormTotalRegisteredUnits => 'Total Registered Units';

  @override
  String get courseFormUnitsAbbrev => 'UNITS';

  @override
  String courseFormSectionLabel(Object section) {
    return 'Section $section';
  }

  @override
  String courseFormUnitsStatus(Object status, Object units) {
    return '$units units · $status';
  }

  @override
  String get courseFormDeclarationHeading => 'Student declaration';

  @override
  String get courseFormDeclarationBody =>
      '“I confirm these are the courses I will take this semester and that I have read the registration rules.”';

  @override
  String get courseFormAuthDigital => 'Auth: Digital Acceptance';

  @override
  String get courseFormStatusValidated => 'Status: Validated';

  @override
  String get courseFormSignatures =>
      'Required physical signatures & endorsements';

  @override
  String get courseFormVerifyFooter =>
      'Verify authenticity with the document id below.';

  @override
  String get courseFormVerifyAuthenticity => 'Verify authenticity';

  @override
  String get courseFormRegistrarArchive => 'Registrar secure archive';

  @override
  String get courseFormAcademicReg => 'Academic Reg.';

  @override
  String get courseFormPresentHint =>
      'Present this stamped copy to the departmental officer if requested.';

  @override
  String get courseFormEmptyTitle => 'No course form yet';

  @override
  String get courseFormEmptyBody =>
      'Submit your course form from the Registration tab once your courses and the declaration are ready.';

  @override
  String registrationCountingUnits(Object minimum, Object units) {
    return 'Counting units: $units. You are at your minimum of $minimum exactly. Dropping any course leaves you below minimum.';
  }

  @override
  String get registrationYourWeekTitle => 'Your Week';

  @override
  String get registrationAddToCalendar => 'Add to calendar';

  @override
  String get registrationCalendarShared =>
      'Week schedule ready to add to your calendar.';

  @override
  String get registrationCalendarShareFailed =>
      'Could not share the week schedule.';

  @override
  String get registrationCalendarEmpty =>
      'There are no lectures this week to add.';

  @override
  String get registrationAddCoursesTitle => 'Add Courses';

  @override
  String get registrationAddDropBanner =>
      'Students already registered for this semester can add or drop courses in this window.';

  @override
  String get registrationEmptyCoursesTitle => 'No courses yet';

  @override
  String get registrationEmptyCoursesBody =>
      'Add the courses for this semester from the catalogue below.';

  @override
  String get registrationCatalogueTitle => 'Add Courses';

  @override
  String get registrationCatalogueSubtitle => 'Departmental Catalog';

  @override
  String get registrationMissingPrerequisite => 'Missing a prerequisite';

  @override
  String get registrationWeekdayMonday => 'Monday';

  @override
  String get registrationWeekdayTuesday => 'Tuesday';

  @override
  String get registrationWeekdayWednesday => 'Wednesday';

  @override
  String get registrationWeekdayThursday => 'Thursday';

  @override
  String get registrationWeekdayFriday => 'Friday';

  @override
  String registrationMeetingLine(Object end, Object start, Object venue) {
    return '$start – $end · $venue';
  }

  @override
  String get registrationFormSubmittedHint => 'On record with the registry';

  @override
  String courseFormVersionLine(Object submittedOn, Object version) {
    return '$version · $submittedOn';
  }

  @override
  String courseFormSessionLine(Object session, Object term) {
    return 'Course registration form · $session, $term';
  }

  @override
  String get courseFormStudentSignature => 'Student Signature:';

  @override
  String get courseFormAdviserSignature => 'Level Adviser:';

  @override
  String get courseFormHodSignature => 'Head of Department:';

  @override
  String get courseFormSignatureDate => 'Date';

  @override
  String get courseFormSignatureDateBlank => 'Date: ________________';

  @override
  String get courseFormSignaturePrintNote =>
      '* Signature lines are for the printed copy.';

  @override
  String courseFormDocId(Object id) {
    return 'DOC ID: $id';
  }

  @override
  String courseFormFormId(Object id) {
    return 'FORM ID: $id';
  }

  @override
  String get courseFormSealed => 'Sealed & issued';

  @override
  String get courseFormUnitsColumn => 'Units / Status';

  @override
  String get studyPlanSubtitle =>
      'What is left of your degree, and when you mean to take it.';

  @override
  String studyPlanTermUnits(Object maximum, Object planned) {
    return '$planned of $maximum units';
  }

  @override
  String get studyPlanHowThisWorksTitle => 'How this works';

  @override
  String get requestsTitle => 'Requests';

  @override
  String get requestsBreadcrumb => 'Requests';

  @override
  String get requestsSubtitle =>
      'Ask for an exception to the registration rules or a change of programme.';

  @override
  String get requestsExistingTitle => 'Existing requests';

  @override
  String requestsExistingCount(int count) {
    return '$count recorded';
  }

  @override
  String requestsSubmittedTitle(int count) {
    return 'Submitted requests ($count)';
  }

  @override
  String requestsSessionLabel(String session) {
    return 'Academic session $session';
  }

  @override
  String requestsFiledOn(String date) {
    return 'filed $date';
  }

  @override
  String get requestsWithdraw => 'Withdraw this request';

  @override
  String get requestsWithdrawTitle => 'Withdraw this request?';

  @override
  String requestsWithdrawBody(String title) {
    return 'The registry will stop reviewing “$title”. You can file again later if you still need the exception.';
  }

  @override
  String get requestsWithdrawConfirm => 'Withdraw';

  @override
  String requestsDecisionNote(String note) {
    return 'Decision note: $note';
  }

  @override
  String get requestsStatusPending => 'Pending';

  @override
  String get requestsStatusRejected => 'Rejected';

  @override
  String get requestsStatusWithdrawn => 'Withdrawn';

  @override
  String get requestsNewTitle => 'New request';

  @override
  String get requestsNewSubtitle =>
      'Submit a formal petition for departmental review.';

  @override
  String get requestsWhatDoYouNeed => 'What do you need?';

  @override
  String get requestsCourseLabel => 'Course';

  @override
  String get requestsPrerequisiteLabel => 'Prerequisite to waive';

  @override
  String get requestsReasonsLabel => 'Your reasons';

  @override
  String get requestsReasonsHint =>
      'Explain your circumstances. Attach supporting documents under My account → Documents.';

  @override
  String get requestsWaiveNote =>
      'Waiving a prerequisite does not change your result. It only lets you register for the course now.';

  @override
  String get requestsSend => 'Send request';

  @override
  String get requestsSent => 'Your request was sent for review.';

  @override
  String get requestsAboutTitle => 'About requests';

  @override
  String get requestsAboutBody =>
      'An approval moves a rule in the academic record system. It is read automatically when you register or when grades are computed.';

  @override
  String get requestsTypeLateRegistration => 'Late registration';

  @override
  String get requestsTypeAddDropAfterDeadline =>
      'Add or drop courses after the deadline';

  @override
  String get requestsTypeOverload => 'Register more units than allowed';

  @override
  String get requestsTypeUnderload => 'Register fewer units than the minimum';

  @override
  String get requestsTypeWaivePrerequisite => 'Waive a prerequisite';

  @override
  String get requestsTypeChangeOfProgramme => 'Change of programme';

  @override
  String get requestsTypeHintLateRegistration =>
      'Lets the student register after the ordinary window has closed.';

  @override
  String get requestsTypeHintAddDropAfterDeadline =>
      'Lets the student change courses after add/drop has closed.';

  @override
  String get requestsTypeHintOverload =>
      'Lets the student register above the unit ceiling for their level.';

  @override
  String get requestsTypeHintUnderload =>
      'Lets the student register below the unit minimum for their level.';

  @override
  String get requestsTypeHintWaivePrerequisite =>
      'Lets the student register for the course without the prerequisite.';

  @override
  String get requestsTypeHintChangeOfProgramme =>
      'Asks the faculty to move the student onto a different programme.';

  @override
  String get requestsIdCardEntryTitle => 'Student ID card';

  @override
  String get requestsIdCardEntryBody =>
      'Request a first card or a replacement, track printing, and collect from the registry.';

  @override
  String get requestsIdCardEntryAction => 'Open ID card';

  @override
  String get requestsEmptyTitle => 'No requests yet';

  @override
  String get requestsEmptyBody =>
      'File a petition below when you need an exception to the registration rules.';

  @override
  String get requestsReasonsRequired => 'Add your reasons before sending.';

  @override
  String get idCardTitle => 'Student ID card';

  @override
  String get idCardBreadcrumb => 'ID card';

  @override
  String get idCardActiveCredential => 'Active credential';

  @override
  String get idCardRequestFormSubtitle =>
      'Procure an updated physical student identity card.';

  @override
  String get idCardFirstIssueFormSubtitle =>
      'Submit a request to have your first card printed.';

  @override
  String idCardProgrammeLevel(String programme, String level) {
    return '$programme ($level)';
  }

  @override
  String get idCardStatusNone => 'No active card';

  @override
  String get idCardStatusRequested => 'Requested';

  @override
  String get idCardStatusReadyForCollection => 'Ready for collection';

  @override
  String get idCardStatusCollected => 'Collected';

  @override
  String get idCardStatusReplaced => 'Replaced';

  @override
  String get idCardNoActiveBody =>
      'You do not currently hold an active student ID card. Submit a request below to have your first card printed.';

  @override
  String idCardPreviousLostBody(String serial) {
    return 'Your previous card $serial was reported lost or stolen. Request a replacement card below.';
  }

  @override
  String idCardRequestedBody(String date, String reason) {
    return 'Requested $date ($reason). We\'ll notify you when it\'s printed.';
  }

  @override
  String get idCardReadyBody =>
      'Your card is printed. Collect it from the registry with another form of identification.';

  @override
  String idCardFeeUnpaidBody(String amount) {
    return 'Replacement fee: $amount. Pay it under Payments; the card is printed once it\'s paid.';
  }

  @override
  String get idCardFeePaid => 'Replacement fee paid.';

  @override
  String get idCardFeeFree => 'Your first card is free.';

  @override
  String idCardCollectBy(String date) {
    return 'Collect it by $date.';
  }

  @override
  String get idCardVerificationPending =>
      'Your verification code is issued when the card is printed.';

  @override
  String get idCardCancelRequest => 'Cancel request';

  @override
  String get idCardCancelTitle => 'Cancel this ID card request?';

  @override
  String idCardCancelBody(String serial) {
    return 'The registry will stop printing $serial. You can request a card again later.';
  }

  @override
  String get idCardCancelConfirm => 'Cancel request';

  @override
  String get idCardRequestReplacement => 'Request a replacement';

  @override
  String get idCardRequestYourCard => 'Request your card';

  @override
  String get idCardPhotoHint =>
      'Your card carries your passport photo. Upload a profile photo before requesting a replacement card.';

  @override
  String get idCardPhotoUpload => 'Upload a profile photo';

  @override
  String get idCardReasonLabel => 'Reason';

  @override
  String get idCardReasonFirstCard => 'First card';

  @override
  String get idCardReasonLostOrStolen => 'Lost or stolen';

  @override
  String get idCardReasonDamaged => 'Damaged';

  @override
  String get idCardReasonNameOrProgramme => 'Name or programme update';

  @override
  String idCardReplacementFeeLine(String amount) {
    return 'A replacement costs $amount.';
  }

  @override
  String get idCardFreeBadge => 'Free';

  @override
  String get idCardRequestCard => 'Request card';

  @override
  String get idCardRequestLockedActive =>
      'Clear or cancel the pending request to submit anew.';

  @override
  String get idCardRequestLockedPhoto =>
      'Action locked until profile photo is approved';

  @override
  String get idCardRequestLockedReason =>
      'Choose a reason before requesting a card.';

  @override
  String get idCardRequestedSnack => 'Your ID card request was sent.';

  @override
  String get idCardHistoryTitle => 'Card history';

  @override
  String idCardHistoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count records',
      one: '1 record',
      zero: '0 records',
    );
    return '$_temp0';
  }

  @override
  String get idCardHistoryEmptyTitle => 'No cards yet';

  @override
  String get idCardHistoryEmptyBody => 'Your first card is free.';

  @override
  String idCardHistoryLine(String reason, String requested, String expires) {
    return '$reason · requested $requested · expires $expires';
  }

  @override
  String idCardHistoryLineExpired(
    String reason,
    String requested,
    String expires,
  ) {
    return '$reason · requested $requested · expired $expires';
  }

  @override
  String idCardHistoryFirstCard(String requested, String expires) {
    return 'First card · requested $requested · expires $expires';
  }

  @override
  String get idCardAboutTitle => 'About ID cards';

  @override
  String get idCardAboutBody =>
      'Your first card is free. Carry it on campus and to examinations. Printing a new card cancels the old one, so report a lost card straight away.';

  @override
  String get disciplineTitle => 'Disciplinary matters';

  @override
  String get disciplineBreadcrumb => 'Disciplinary matters';

  @override
  String get disciplineBreadcrumbRecord => 'Record';

  @override
  String get disciplineSubtitle =>
      'Cases involving you, their outcome, and any sanctions.';

  @override
  String get disciplineEntryTitle => 'Disciplinary matters';

  @override
  String get disciplineEntryBody =>
      'Cases involving you, their outcome, and any sanctions on your record.';

  @override
  String get disciplineEntryAction => 'Open discipline';

  @override
  String get disciplineCasesTitle => 'Cases';

  @override
  String disciplineCasesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recorded',
      one: '1 recorded',
      zero: '0 recorded',
    );
    return '$_temp0';
  }

  @override
  String get disciplineCasesSortedNewest => 'Sorted by newest';

  @override
  String get disciplineSanctionsTitle => 'Sanctions';

  @override
  String disciplineSanctionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recorded',
      one: '1 recorded',
      zero: '0 recorded',
    );
    return '$_temp0';
  }

  @override
  String disciplineSanctionsActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count active',
      one: '1 active',
      zero: '0 active',
    );
    return '$_temp0';
  }

  @override
  String get disciplineEmptyTitle => 'No disciplinary cases';

  @override
  String get disciplineEmptyBody => 'You have a clean record.';

  @override
  String get disciplineAboutTitle => 'About disciplinary records';

  @override
  String get disciplineAboutBody =>
      'Cases and sanctions recorded under University Disciplinary Statutes remain part of your academic dossier. Active sanctions are enforced across portal functions.';

  @override
  String get disciplineStandingActive => 'Active';

  @override
  String get disciplineStandingSuspended => 'Suspended';

  @override
  String get disciplineStandingExpelled => 'Expelled';

  @override
  String get disciplineSuspendedBanner =>
      'Your student status is Suspended, so you cannot register, request an ID card or file a request. Contact the registry.';

  @override
  String get disciplineCaseStatusUnderInvestigation => 'Under investigation';

  @override
  String get disciplineCaseStatusHearingScheduled => 'Hearing scheduled';

  @override
  String get disciplineCaseStatusDecided => 'Decided';

  @override
  String get disciplineCaseStatusUnderAppeal => 'Under appeal';

  @override
  String get disciplineSeverityMinor => 'Minor';

  @override
  String get disciplineSeverityMajor => 'Major';

  @override
  String get disciplineCategoryExamination => 'Examination misconduct';

  @override
  String get disciplineCategoryHarassment => 'Harassment';

  @override
  String get disciplineFindingLiable => 'Found liable';

  @override
  String get disciplineFindingNotLiable => 'Not liable';

  @override
  String get disciplineSanctionWarning => 'Warning';

  @override
  String get disciplineSanctionProbation => 'Probation';

  @override
  String get disciplineSanctionSuspension => 'Suspension';

  @override
  String get disciplineSanctionExpulsion => 'Expulsion';

  @override
  String get disciplineSanctionActive => 'Active';

  @override
  String get disciplineSanctionServed => 'Served';

  @override
  String get disciplineSanctionLifted => 'Lifted';

  @override
  String get disciplineEvidenceDocument => 'Document';

  @override
  String get disciplineEvidenceStatement => 'Written statement';

  @override
  String disciplineOpenedOn(String date) {
    return 'opened $date';
  }

  @override
  String disciplineCaseMeta(String severity, String category, String opened) {
    return '$severity · $category · $opened';
  }

  @override
  String disciplineCaseTitle(String reference) {
    return 'Case $reference';
  }

  @override
  String disciplineDecidedOn(String date) {
    return 'decided $date';
  }

  @override
  String get disciplineHearingScheduledTitle => 'Hearing scheduled';

  @override
  String get disciplineHearingHeldTitle => 'Hearing held';

  @override
  String get disciplineHearingSessionMandatory => 'Session mandatory';

  @override
  String disciplineHearingAtVenue(String venue) {
    return 'at $venue';
  }

  @override
  String get disciplineAllegationTitle => 'The allegation';

  @override
  String get disciplineAllegationCategory => 'Category';

  @override
  String get disciplineAllegationIncident => 'Incident';

  @override
  String get disciplineAllegationReportedBy => 'Reported by';

  @override
  String disciplineIncidentLine(String date, String venue, String session) {
    return '$date · $venue, during $session';
  }

  @override
  String disciplineReportedLine(String reporter, String date) {
    return '$reporter, on $date';
  }

  @override
  String get disciplineEvidenceTitle => 'Evidence on file';

  @override
  String disciplineEvidenceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: '0 items',
    );
    return '$_temp0';
  }

  @override
  String get disciplineEvidenceInspectHint =>
      'You may inspect the evidence at the disciplinary office before the hearing.';

  @override
  String get disciplineAppealTitle => 'Appeal this decision';

  @override
  String disciplineAppealUntil(String date) {
    return 'You can appeal until $date.';
  }

  @override
  String get disciplineAppealWindowDays => '14 days from the decision.';

  @override
  String get disciplineAppealGroundsLabel => 'Grounds of appeal';

  @override
  String get disciplineAppealGroundsHint =>
      'Explain why the decision or sanction is wrong, including any new evidence.';

  @override
  String disciplineAppealGroundsRequired(int min) {
    return 'Set out your grounds of appeal in at least $min characters.';
  }

  @override
  String disciplineAppealGroundsCounter(int count, int min) {
    return '$count/$min';
  }

  @override
  String get disciplineAppealLodge => 'Lodge appeal';

  @override
  String get disciplineAppealOnceNote =>
      'You can only appeal once. Once lodged, an appeal cannot be edited or withdrawn.';

  @override
  String get disciplineAppealClosedTitle => 'Closed';

  @override
  String disciplineAppealClosedBody(String date) {
    return 'The appeal period ended on $date.';
  }

  @override
  String disciplineAppealClosedDetail(String date) {
    return 'The decision was made on $date. The appeal period is fourteen days from the decision.';
  }

  @override
  String get disciplineAppealWrittenStill =>
      'A written appeal may still be delivered to the disciplinary office.';

  @override
  String get disciplineAppealLiableOnly =>
      'Only a decision finding you liable can be appealed.';

  @override
  String get disciplineAppealLodgedTitle => 'Your appeal';

  @override
  String disciplineAppealLodgedOn(String date) {
    return 'Lodged $date';
  }

  @override
  String get disciplineAppealAwaiting => 'Awaiting decision';

  @override
  String get disciplineAppealFiledBanner =>
      'Appeal filed · Awaiting Disciplinary Appeals Committee review';

  @override
  String get disciplineAppealAbeyanceNote =>
      'Sanctions held in abeyance pending appeal outcome under Statute 14(b). Academic participation remains fully active.';

  @override
  String get disciplineAppealReviewNote =>
      'The appeal committee will review it. You will be notified of the outcome.';

  @override
  String get disciplineAppealConfirmTitle => 'Lodge this appeal?';

  @override
  String get disciplineAppealConfirmBody =>
      'You can only appeal once. Once submitted, your grounds cannot be edited or withdrawn.';

  @override
  String get disciplineAppealConfirmAction => 'Lodge appeal';

  @override
  String get disciplineAppealLodgedSnack => 'Your appeal was lodged.';

  @override
  String get disciplineDecisionFinalized => 'Decision finalized';

  @override
  String disciplineDecisionFinalizedBody(String date) {
    return 'Appeal window closed on $date. Sanction in effect under Statute 14.';
  }

  @override
  String get disciplineCaseNotFound => 'This case is not on your record.';

  @override
  String disciplineSanctionCaseRef(String reference) {
    return '$reference';
  }

  @override
  String get requestsStatusApproved => 'Approved';

  @override
  String get staffApprovalsTaskTitle => 'Approvals';

  @override
  String get staffApprovalsTitle => 'Registration approvals';

  @override
  String get staffApprovalsSubtitle =>
      'Submitted course forms for this semester from the students you advise or oversee.';

  @override
  String get staffApprovalsBreadcrumb => 'Course registrations';

  @override
  String get staffApprovalsBreadcrumbRoot => 'Staff';

  @override
  String get staffApprovalsFilterAwaiting => 'Awaiting approval';

  @override
  String get staffApprovalsFilterApproved => 'Approved';

  @override
  String get staffApprovalsFilterAll => 'All submissions';

  @override
  String get staffApprovalsQueueTitle => 'Action queue';

  @override
  String get staffApprovalsQueueProcessed => 'Processed';

  @override
  String get staffApprovalsEmptyTitle => 'Nothing waiting';

  @override
  String get staffApprovalsEmptyBody =>
      'There are no course forms in this filter right now.';

  @override
  String get staffApprovalsFlagAtMinimum => 'At minimum';

  @override
  String get staffApprovalsFlagClash => 'Clash acknowledged';

  @override
  String get staffApprovalsReviewForm => 'Review form';

  @override
  String get staffApprovalsViewForm => 'View form';

  @override
  String get staffApprovalsStudyPlan => 'Study plan';

  @override
  String get staffApprovalsAboutTitle => 'About approvals';

  @override
  String get staffApprovalsAboutBody =>
      'Approve or reject pending courses on each student\'s form. Rejected lines need a reason the student will see.';

  @override
  String get staffApprovalsRequestsEntryTitle => 'Student requests';

  @override
  String get staffApprovalsRequestsEntryBody =>
      'Decide overload, waiver, late add/drop, and programme-change petitions.';

  @override
  String get staffApprovalsDecisionTaskTitle => 'Course form';

  @override
  String get staffApprovalsDecisionTitle => 'Course form review';

  @override
  String get staffApprovalsDirectTitle =>
      'Department registers courses directly';

  @override
  String get staffApprovalsDirectBody =>
      'This programme does not use the approval queue. Courses are already on the record.';

  @override
  String get staffApprovalsAtMinimumTitle => 'At the unit minimum';

  @override
  String get staffApprovalsCoursesTitle => 'Courses';

  @override
  String get staffApprovalsSelectAll => 'Select all pending';

  @override
  String get staffApprovalsApproveSelected => 'Approve selected';

  @override
  String get staffApprovalsRejectSelected => 'Reject selected';

  @override
  String get staffApprovalsSelectFirst => 'Select at least one pending course.';

  @override
  String get staffApprovalsRejectCoursesTitle => 'Reject selected courses?';

  @override
  String get staffApprovalsRejectCoursesConfirm => 'Reject courses';

  @override
  String get staffApprovalsRejectReasonLabel => 'Note to the student';

  @override
  String get staffApprovalsRejectReasonHint =>
      'Required. The student sees this word for word.';

  @override
  String get staffApprovalsRejectRequestTitle => 'Reject this request?';

  @override
  String get staffApprovalsRejectRequestConfirm => 'Reject request';

  @override
  String get staffApprovalsReasonRequired =>
      'Add a note for the student before rejecting.';

  @override
  String get staffApprovalsRequestsTaskTitle => 'Student requests';

  @override
  String get staffApprovalsRequestsTitle => 'Student requests';

  @override
  String get staffApprovalsRequestsSubtitle =>
      'Approving a request applies it straight away: see what each type does before deciding.';

  @override
  String get staffApprovalsRequestsBreadcrumb => 'Student requests';

  @override
  String get staffApprovalsRequestsListTitle => 'Pending and decided';

  @override
  String get staffApprovalsRequestsEmptyTitle => 'No requests here';

  @override
  String get staffApprovalsRequestsEmptyBody => 'Nothing matches this filter.';

  @override
  String get staffApprovalsRequestFilterAll => 'All statuses';

  @override
  String get staffApprovalsRequestFilterPending => 'Pending';

  @override
  String get staffApprovalsRequestFilterDecided => 'Decided';

  @override
  String get staffApprovalsStudentNote => 'Student\'s reasons';

  @override
  String get staffApprovalsRequestReasonLabel =>
      'Note to the student (needed to reject)';

  @override
  String get staffApprovalsRequestReasonHint => 'Required when rejecting.';

  @override
  String get staffApprovalsRequestApprove => 'Approve';

  @override
  String get staffApprovalsRequestReject => 'Reject';

  @override
  String get staffApprovalsAdvisingTaskTitle => 'Study plan';

  @override
  String get staffApprovalsAdvisingTitle => 'Study plan advising';

  @override
  String get staffApprovalsAdvisingSubtitle =>
      'Their intent, not a registration. Advise against unit limits and prerequisites.';

  @override
  String get staffApprovalsAdvisingProgressTitle => 'Progress';

  @override
  String get staffApprovalsAdvisingWarningsTitle =>
      'What the plan would run into';

  @override
  String get staffApprovalsAdvisingTermsTitle => 'What they mean to take';

  @override
  String get staffApprovalsAdviceLabel => 'Your advice';

  @override
  String get staffApprovalsAdviceHint =>
      'Notes the student and future advisers can read.';

  @override
  String get staffApprovalsAdviceSave => 'Save advice';

  @override
  String get staffApprovalsAdviceSaved => 'Advice saved.';

  @override
  String get staffApprovalsAdviceRequired => 'Write advice before saving.';

  @override
  String get staffRegistryBreadcrumbRoot => 'Registry';

  @override
  String get staffRegistryStudentsBreadcrumb => 'Students';

  @override
  String get staffRegistryStudentsTaskTitle => 'Students';

  @override
  String get staffRegistryStudentsTitle => 'Students';

  @override
  String get staffRegistryStudentsSubtitle =>
      'Matriculated students and their current academic standing across faculties.';

  @override
  String get staffRegistryStudentsListTitle => 'Directory';

  @override
  String get staffRegistryStudentsEmptyTitle => 'No students match';

  @override
  String get staffRegistryStudentsEmptyBody =>
      'Clear the search or filters and try again.';

  @override
  String get staffRegistryIdCardsEntryTitle => 'ID cards';

  @override
  String get staffRegistryStatMatriculated => 'Matriculated';

  @override
  String get staffRegistryStatusActive => 'Active';

  @override
  String get staffRegistryStatusSuspended => 'Suspended';

  @override
  String get staffRegistryStatusWithdrawn => 'Withdrawn';

  @override
  String get staffRegistryStatusExpelled => 'Expelled';

  @override
  String get staffRegistryStatusGraduated => 'Graduated';

  @override
  String get staffRegistryFilterAll => 'Any status';

  @override
  String get staffRegistrySearchHint =>
      'Search name, matric, email, or programme';

  @override
  String get staffRegistrySearchClear => 'Clear search';

  @override
  String get staffRegistryPromoteAction => 'Batch promote';

  @override
  String get staffRegistryPromoteTitle =>
      'Move the selected students to this level?';

  @override
  String get staffRegistryPromoteLevelLabel => 'New level';

  @override
  String get staffRegistryRecordTaskTitle => 'Student record';

  @override
  String get staffRegistryRecordTitle => 'Student record';

  @override
  String get staffRegistryRecordSubtitle =>
      'Statutory record and registration history.';

  @override
  String get staffRegistryRecordDetails => 'Statutory record';

  @override
  String get staffRegistryNoDegreePlanTitle => 'No degree plan linked';

  @override
  String get staffRegistryNoDegreePlanBody =>
      'Link a curriculum before advising or registering this student.';

  @override
  String get staffRegistryFeeOwingTitle => 'Replacement fee unpaid';

  @override
  String get staffRegistryFeeOwingBody =>
      'The student\'s ID card replacement cannot be printed until the fee is paid.';

  @override
  String get staffRegistryOpenStudyPlan => 'Open study plan';

  @override
  String get staffRegistryTermsTitle => 'Registration history';

  @override
  String get staffRegistryTermsEmptyTitle => 'No registrations yet';

  @override
  String get staffRegistryTermsEmptyBody =>
      'Course registrations will appear here once started.';

  @override
  String get staffRegistryTermConfirmed => 'Confirmed';

  @override
  String get staffRegistryTermNotConfirmed => 'Provisional';

  @override
  String get staffRegistryFieldEmail => 'Email';

  @override
  String get staffRegistryFieldDepartment => 'Department';

  @override
  String get staffRegistryFieldDegreePlan => 'Degree plan';

  @override
  String get staffRegistryFieldDegreePlanNone => 'None linked';

  @override
  String get staffRegistryFieldEntry => 'Entry';

  @override
  String get staffRegistryFieldJamb => 'JAMB number';

  @override
  String get staffRegistryFieldMatriculated => 'Matriculated';

  @override
  String get staffRegistryFieldPhoto => 'Photo';

  @override
  String get staffRegistryPhotoVerified => 'Photo verified';

  @override
  String get staffRegistryPhotoMissing => 'No photo on file';

  @override
  String get staffRegistryIdCardsBreadcrumb => 'ID cards';

  @override
  String get staffRegistryIdCardsTaskTitle => 'ID cards';

  @override
  String get staffRegistryIdCardsTitle => 'ID cards';

  @override
  String get staffRegistryIdCardsSubtitle =>
      'Print requested cards, then hand them over when students collect.';

  @override
  String get staffRegistryIdCardsListTitle => 'Production queue';

  @override
  String get staffRegistryIdCardsEmptyTitle => 'No cards here';

  @override
  String get staffRegistryIdCardsEmptyBody => 'Nothing in this tab right now.';

  @override
  String get staffRegistryIdCardsAboutTitle => 'About ID card production';

  @override
  String get staffRegistryIdCardsAboutBody =>
      'A replacement cannot be marked printed while unpaid. Expiry and verification codes are issued only when you mark printed.';

  @override
  String get staffRegistryFeeNotRequired => 'Free';

  @override
  String get staffRegistryFeeUnpaid => 'Unpaid';

  @override
  String get staffRegistryFeePaid => 'Paid';

  @override
  String get staffRegistryBlockedUnpaid =>
      'The replacement fee isn\'t paid, so this card cannot be printed.';

  @override
  String get staffRegistryBlockedNoPhoto =>
      'No photo on file, so this card cannot be printed.';

  @override
  String get staffRegistryMarkPrinted => 'Mark printed';

  @override
  String get staffRegistryMarkCollected => 'Collected';

  @override
  String get staffRegistryPreview => 'View card';

  @override
  String get staffRegistryCancelCard => 'Cancel';

  @override
  String get staffRegistryMarkPrintedBlocked =>
      'Action locked until the fee is paid and a photo is on file.';

  @override
  String get staffRegistryCancelTitle => 'Cancel this card request?';

  @override
  String get staffRegistryCancelConfirm => 'Cancel request';

  @override
  String get staffRegistryCancelReasonLabel => 'Reason';

  @override
  String get staffRegistryCancelReasonHint =>
      'Required. Kept on the card history.';

  @override
  String get staffRegistryCancelReasonRequired =>
      'Add a reason before cancelling.';

  @override
  String get staffRegistryPreviewTaskTitle => 'Print preview';

  @override
  String get staffRegistryPreviewTitle => 'Card preview';

  @override
  String get staffRegistryPreviewSubtitle =>
      'Preview. Mark the card printed to issue its expiry date and verification QR code.';

  @override
  String get staffRegistryPreviewCardCaption => 'Student identity card';

  @override
  String get staffRegistryPreviewNoExpiry => 'Expires —';

  @override
  String get staffRegistryPreviewStatus => 'Status';

  @override
  String get staffRegistryPreviewCode => 'Verification code';

  @override
  String get staffRegistryPreviewNoPhotoTitle => 'No photo on file';

  @override
  String get staffRegistryPreviewBlocked =>
      'This card cannot be marked printed yet.';

  @override
  String get staffRegistryPreviewVerify =>
      'Public verification uses the code issued after Mark printed.';

  @override
  String get verifyIdCardBrandCaption => 'The Legion University';

  @override
  String get verifyIdCardOffice => 'Student Registry';

  @override
  String get verifyIdCardTitle => 'Student ID card check';

  @override
  String get verifyIdCardSubtitle =>
      'The result of scanning the QR code on a student ID card.';

  @override
  String get verifyIdCardCodeLabel => 'Verification code';

  @override
  String get verifyIdCardCodeHint => '16-character code from the card';

  @override
  String get verifyIdCardAction => 'Check card';

  @override
  String get verifyIdCardSignIn => 'Sign in to the portal';

  @override
  String get verifyIdCardValidTitle => 'Valid card';

  @override
  String get verifyIdCardInvalidTitle => 'This card is not valid';

  @override
  String get verifyIdCardInvalidBody =>
      'The code matches a card that is no longer valid for the holder.';

  @override
  String get verifyIdCardNotFoundTitle => 'No card matches this code';

  @override
  String get verifyIdCardNotFoundBody =>
      'Check the code on the card and try again.';

  @override
  String get verifyIdCardFieldName => 'Name';

  @override
  String get verifyIdCardFieldMatric => 'Matric number';

  @override
  String get verifyIdCardFieldProgramme => 'Programme';

  @override
  String get verifyIdCardFieldSerial => 'Card';

  @override
  String get verifyIdCardFieldExpires => 'Expires';

  @override
  String get verifyIdCardPrivacyTitle => 'Privacy';

  @override
  String get verifyIdCardPrivacyBody =>
      'This page shows only name, matric number, programme, card number and expiry. It does not show a photograph, email, phone, level, department, case, sanction or fee.';

  @override
  String staffApprovalsSummaryTitle(int count) {
    return '$count forms waiting';
  }

  @override
  String staffApprovalsSummaryBody(int count) {
    return '$count courses awaiting approval.';
  }

  @override
  String staffApprovalsQueueCount(int count) {
    return '$count students';
  }

  @override
  String staffApprovalsQueuePending(int count) {
    return '$count courses';
  }

  @override
  String staffApprovalsQueueMeta(
    String matricNumber,
    String programmeCode,
    String level,
  ) {
    return '$matricNumber · $programmeCode · $level';
  }

  @override
  String staffApprovalsDecisionSubtitle(String session) {
    return '$session';
  }

  @override
  String staffApprovalsAtMinimumBody(int minimum) {
    return 'This student is at the minimum of $minimum units. Rejecting courses may leave them under the floor.';
  }

  @override
  String staffApprovalsCoursesCount(int count) {
    return '$count courses';
  }

  @override
  String staffApprovalsCourseMeta(String section, int units) {
    return 'Section $section · $units units';
  }

  @override
  String staffApprovalsDecidedBy(String name, String date) {
    return '$name, $date';
  }

  @override
  String staffApprovalsSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String staffApprovalsApprovedMessage(int count) {
    return '$count courses approved.';
  }

  @override
  String staffApprovalsRejectedMessage(int count) {
    return '$count courses rejected.';
  }

  @override
  String staffApprovalsRejectCoursesBody(int count, String name) {
    return 'Reject $count courses for $name? The student will see your note.';
  }

  @override
  String staffApprovalsRejectRequestBody(String name) {
    return 'Reject the request from $name? The student will see your note.';
  }

  @override
  String staffApprovalsRequestsCount(int count) {
    return '$count requests';
  }

  @override
  String staffApprovalsRequestApprovedMessage(String name) {
    return 'Approved for $name.';
  }

  @override
  String staffApprovalsRequestRejectedMessage(String name) {
    return 'Rejected for $name.';
  }

  @override
  String staffApprovalsAdvisingProgressValue(int passed, int threshold) {
    return '$passed of $threshold units toward the award';
  }

  @override
  String staffApprovalsAdvisingPlanned(int planned, int remaining) {
    return '$planned units planned · $remaining courses still to pass';
  }

  @override
  String staffApprovalsAdvisingWarningsCount(int count) {
    return '$count warnings';
  }

  @override
  String staffApprovalsAdvisingTermsCount(int count) {
    return '$count terms';
  }

  @override
  String staffApprovalsAdvisingTermUnits(int planned, int maximum) {
    return '$planned of $maximum';
  }

  @override
  String staffApprovalsAdvisingOverCeiling(int maximum) {
    return 'Over the unit ceiling of $maximum. Something must move.';
  }

  @override
  String staffRegistryIdCardsEntryBody(int count) {
    return '$count cards in production.';
  }

  @override
  String staffRegistrySelectedCount(int count) {
    return '$count selected';
  }

  @override
  String staffRegistryStudentsCount(int count) {
    return '$count students';
  }

  @override
  String staffRegistryStudentMeta(
    String matricNumber,
    String programmeCode,
    String detail,
  ) {
    return '$matricNumber · $programmeCode · $detail';
  }

  @override
  String staffRegistryPromoteBody(int count) {
    return 'Move $count students to a new level?';
  }

  @override
  String staffRegistryPromoteConfirm(int level) {
    return 'Promote to $level Level';
  }

  @override
  String staffRegistryPromotedMessage(int count, int level) {
    return 'Moved $count students to $level Level.';
  }

  @override
  String staffRegistryTermsCount(int count) {
    return '$count terms';
  }

  @override
  String staffRegistryTermMeta(String level, int units) {
    return '$level · $units units';
  }

  @override
  String staffRegistryCourseLine(String code, String section, int units) {
    return '$code Section $section · $units units';
  }

  @override
  String staffRegistryIdCardsCount(int count) {
    return '$count cards';
  }

  @override
  String staffRegistryTabRequested(int count) {
    return 'Requested ($count)';
  }

  @override
  String staffRegistryTabReadyForCollection(int count) {
    return 'Ready for collection ($count)';
  }

  @override
  String staffRegistryTabCollected(int count) {
    return 'Collected ($count)';
  }

  @override
  String staffRegistryRequestedOn(String date) {
    return 'Requested $date';
  }

  @override
  String staffRegistryPrintedOn(String date) {
    return 'Printed $date';
  }

  @override
  String staffRegistryPrintedMessage(String serial) {
    return '$serial marked ready for collection.';
  }

  @override
  String staffRegistryCollectedMessage(String serial) {
    return '$serial marked collected.';
  }

  @override
  String staffRegistryCancelBody(String serial) {
    return 'Cancel the request for $serial?';
  }

  @override
  String staffRegistryCancelledMessage(String serial) {
    return 'Cancelled $serial.';
  }

  @override
  String staffRegistryPreviewExpires(String date) {
    return 'Expires $date';
  }

  @override
  String get navAccommodation => 'Accommodation';

  @override
  String get navAccommodationHistory => 'History';

  @override
  String get accommodationBackTooltip => 'Back';

  @override
  String get accommodationTitle => 'Accommodation';

  @override
  String accommodationSubtitle(Object term) {
    return 'Hostel accommodation for $term.';
  }

  @override
  String get accommodationBreadcrumbStudent => 'Student';

  @override
  String accommodationMatricLevel(Object level, Object matricNumber) {
    return '$matricNumber · $level Level';
  }

  @override
  String get accommodationBookFor => 'Book for';

  @override
  String accommodationEverythingBelow(Object term) {
    return 'Everything below is for $term.';
  }

  @override
  String accommodationRoomBed(Object bed, Object room) {
    return 'Room $room · Bed $bed';
  }

  @override
  String accommodationBedFull(Object bed, Object hostelBlock, Object room) {
    return '$hostelBlock · Room $room · Bed $bed';
  }

  @override
  String accommodationRoomOnly(Object hostelBlock, Object room) {
    return '$hostelBlock · Room $room';
  }

  @override
  String accommodationBlockRoom(Object block, Object room) {
    return '$block · Room $room';
  }

  @override
  String accommodationRoomLine(Object hostelBlock, Object room) {
    return '$hostelBlock · Room $room';
  }

  @override
  String accommodationDuration(Object hours, Object minutes) {
    return '$hours hours and $minutes minutes';
  }

  @override
  String get accommodationStatusNotScheduled => 'Not scheduled';

  @override
  String get accommodationStatusNeedsTerms => 'Terms to accept';

  @override
  String get accommodationStatusBookingOpen => 'Booking open';

  @override
  String get accommodationStatusHeld => 'Reserved, awaiting payment';

  @override
  String get accommodationStatusOffered => 'Offered, awaiting the student';

  @override
  String get accommodationStatusConfirmed => 'Confirmed';

  @override
  String get accommodationStatusCheckedIn => 'Checked in';

  @override
  String accommodationNotScheduledTitle(Object term) {
    return 'Booking for $term hasn\'t been scheduled.';
  }

  @override
  String get accommodationNotScheduledBody =>
      'It is normally published in September. Check back, or ask the housing office.';

  @override
  String accommodationCalendarTitle(Object term) {
    return '$term housing calendar';
  }

  @override
  String get accommodationCalendarBody =>
      'Booking hasn\'t opened, so these rooms cannot be booked yet.';

  @override
  String get accommodationNeedsTermsTitle => 'Accept the accommodation terms';

  @override
  String accommodationNeedsTermsBody(Object term, Object version) {
    return 'Booking for $term opens once you accept version $version of the accommodation terms.';
  }

  @override
  String get accommodationNeedsTermsAction => 'Read and accept the terms';

  @override
  String get accommodationRoomsTitle => 'Rooms you can book';

  @override
  String accommodationRoomsVisible(Object count) {
    return '$count rooms visible';
  }

  @override
  String get accommodationRoomsIntro =>
      'Beds are held for you until the fee is paid. You get the first free bed in the room.';

  @override
  String get accommodationRoomsSearchHint => 'Search hostel, block or room';

  @override
  String get accommodationRoomsEmptyTitle => 'No rooms to show';

  @override
  String get accommodationRoomsEmptyBody =>
      'No room matches, or every room is full. Check back, or ask the housing office about the waitlist.';

  @override
  String get accommodationRoomsFilterTitle => 'Hostels are filtered for you';

  @override
  String get accommodationRoomsFilterBody =>
      'Hostels that are not open to your gender, programme or level are left out automatically.';

  @override
  String get accommodationRoomsPageTitle => 'Rooms';

  @override
  String get accommodationRoomsClosedTitle => 'Rooms are not open for booking';

  @override
  String accommodationRoomsClosedBody(Object term) {
    return '$term is not open for booking, so there are no rooms to choose from.';
  }

  @override
  String get accommodationRoomsBackToHub => 'Back to accommodation';

  @override
  String accommodationFreeBeds(Object count) {
    return '$count free';
  }

  @override
  String accommodationOfBeds(Object total) {
    return 'of $total beds';
  }

  @override
  String get accommodationPerTerm => '/ term';

  @override
  String get accommodationSingleSlotNote =>
      'Single remaining slot. Roommate pairing is unavailable.';

  @override
  String get accommodationBookRoom => 'Book room';

  @override
  String get accommodationRoomOpen => 'Open';

  @override
  String get accommodationRoomSingleSlot => 'Last bed';

  @override
  String get accommodationRoomUnavailable => 'Unavailable';

  @override
  String get accommodationRoomMaintenance => 'Maintenance';

  @override
  String get accommodationHoldTitle => 'Confirm room hold';

  @override
  String get accommodationHoldSession => 'Term';

  @override
  String get accommodationHoldFee => 'Bed fee';

  @override
  String get accommodationHoldExpiry => 'Hold expires';

  @override
  String accommodationHoldMinutes(Object minutes) {
    return '$minutes minutes after issue';
  }

  @override
  String get accommodationHoldBody =>
      'Continuing raises an invoice in your payments ledger straight away. The bed stays held for you while payment is confirmed.';

  @override
  String get accommodationHoldConfirm => 'Raise invoice and hold bed';

  @override
  String get accommodationHoldCancel => 'Cancel selection';

  @override
  String get accommodationPortalLock => 'Portal lock';

  @override
  String accommodationLeftToPay(Object duration) {
    return '$duration left to pay';
  }

  @override
  String accommodationLeftToAnswer(Object duration) {
    return '$duration left to answer';
  }

  @override
  String get accommodationLockLapses =>
      'The hold lapses automatically at the deadline.';

  @override
  String get accommodationTotalFee => 'Total allocation fee';

  @override
  String get accommodationSessionFee => 'Total session fee';

  @override
  String accommodationPayBy(Object amount, Object date) {
    return 'Pay $amount by $date.';
  }

  @override
  String get accommodationGraceTitle => 'Grace period clause';

  @override
  String accommodationGraceBody(Object date) {
    return 'If it is late, the bed is still kept until $date and then released. A fee paid during that grace still confirms the bed.';
  }

  @override
  String accommodationInvoice(Object reference) {
    return 'Invoice $reference';
  }

  @override
  String get accommodationOpenPayments => 'Open in Payments';

  @override
  String accommodationPay(Object amount) {
    return 'Pay $amount';
  }

  @override
  String get accommodationCancelBooking => 'Cancel booking';

  @override
  String get accommodationCancelWalletNote =>
      'If you cancel, anything you have paid goes to your wallet — it is not refunded to your card.';

  @override
  String get accommodationCancelTitle => 'Cancel this booking?';

  @override
  String accommodationCancelBody(Object bed) {
    return 'Cancelling releases $bed straight away and it goes to the next student. Anything you have paid goes to your wallet.';
  }

  @override
  String get accommodationCancelConfirm => 'Cancel booking';

  @override
  String get accommodationCancelKeep => 'Keep my allocation';

  @override
  String get accommodationCancelConfirmedTitle =>
      'Cancel this booking and release the bed?';

  @override
  String get accommodationCancelFreeBody =>
      'There is no fee to refund. You lose the bed and it goes to the next student.';

  @override
  String get accommodationCancelPaidBody =>
      'You lose the bed and it goes to the next student. What you paid goes to your wallet, less any cancellation charge.';

  @override
  String get accommodationCancelForfeit => 'Confirm forfeiture';

  @override
  String get accommodationCancelKeepBed => 'Keep bed';

  @override
  String get accommodationSessionCoverTitle => 'Session booking';

  @override
  String accommodationSessionCoverBody(Object first, Object second) {
    return 'One booking covers $first and $second: the same bed throughout, invoiced once.';
  }

  @override
  String get accommodationWaitlistOffer => 'Waitlist allocation';

  @override
  String accommodationOfferReference(Object reference) {
    return 'Offer #$reference';
  }

  @override
  String get accommodationAnswerOnce =>
      'You can only answer this once. If you do nothing, it is offered to the next student.';

  @override
  String accommodationOfferBody(Object date) {
    return 'This bed is offered to you from the waitlist. It is not yours, and nothing is charged, until you accept. Answer by $date or it goes to the next student.';
  }

  @override
  String accommodationOtherTermUnaffected(Object term) {
    return 'Your bed in $term is not affected by this.';
  }

  @override
  String accommodationAcceptRaises(Object amount) {
    return 'Accepting raises an invoice of $amount.';
  }

  @override
  String get accommodationAcceptBed => 'Accept the bed';

  @override
  String get accommodationDecline => 'Decline';

  @override
  String get accommodationDeclineTitle => 'Decline this bed?';

  @override
  String get accommodationDeclineBody =>
      'You leave the waitlist and it goes to the next student. This cannot be reversed.';

  @override
  String get accommodationDeclineConfirm => 'Confirm decline';

  @override
  String get accommodationDeclineKeep => 'Keep my offer';

  @override
  String get accommodationOtherOffersTitle => 'How other offers work';

  @override
  String get accommodationOtherOffersRoommate =>
      'Roommate named you: a bed reserved by an approved room buddy. You must confirm, or it is released.';

  @override
  String get accommodationOtherOffersRetain =>
      'Keeping your bed from last term: a priority booking window before booking opens to everybody, or it is released.';

  @override
  String get accommodationScholarshipQuota => 'Scholarship quota';

  @override
  String accommodationYoursFor(Object bed, Object term) {
    return '$bed is yours for $term.';
  }

  @override
  String get accommodationSlipCode => 'Slip code';

  @override
  String get accommodationSlipCopy => 'Copy slip code';

  @override
  String get accommodationSlipCopied => 'Slip code copied.';

  @override
  String get accommodationSlipHint =>
      'Bring your slip and your ID card to the hall office when you check in.';

  @override
  String get accommodationSlipDownload => 'Allocation slip';

  @override
  String get accommodationSlipDownloadPdf => 'Download allocation slip (PDF)';

  @override
  String get accommodationPrice => 'Price';

  @override
  String get accommodationPriceFree => 'Free';

  @override
  String get accommodationFreeNote =>
      'A scholarship exemption applies. No fee is due.';

  @override
  String get accommodationOfficialResident => 'Official resident';

  @override
  String accommodationResidentDesignated(Object bed) {
    return 'Your official designated room is $bed.';
  }

  @override
  String accommodationCheckedInLine(Object bed, Object date) {
    return 'Checked in $date. Your official designated room is $bed.';
  }

  @override
  String get accommodationClearanceHint =>
      'Present this slip code or your student ID card at the porter lodge or the gate when asked.';

  @override
  String get accommodationResidenceRecord => 'Residence record';

  @override
  String get accommodationCheckInDate => 'Check-in';

  @override
  String get accommodationTenancyTerm => 'Tenancy term';

  @override
  String accommodationValidUntil(Object date) {
    return 'Valid until $date';
  }

  @override
  String get accommodationKeyTag => 'Key tag';

  @override
  String get accommodationLocker => 'Locker';

  @override
  String accommodationPorterTitle(Object hostel) {
    return '$hostel porter lodge';
  }

  @override
  String get accommodationPorterDetail => 'Campus ext. #41';

  @override
  String get accommodationPorterBody =>
      'For maintenance requests, plumbing checks or a replacement key, tell the porter on duty or call the extension.';

  @override
  String get accommodationNextTitle => 'What happens next';

  @override
  String accommodationNextStage(Object stage, Object total) {
    return 'Stage $stage of $total';
  }

  @override
  String get accommodationStepBooked => 'Booked';

  @override
  String get accommodationStepBookedBody =>
      'The bed is reserved for you in the hostel inventory.';

  @override
  String get accommodationStepPay => 'Pay the fee';

  @override
  String get accommodationStepPaid => 'Fee paid';

  @override
  String get accommodationStepCleared => 'Confirmed';

  @override
  String accommodationStepBy(Object date) {
    return 'By $date';
  }

  @override
  String accommodationStepFrom(Object date) {
    return 'From $date';
  }

  @override
  String get accommodationStepPayBody =>
      'Paying the fee confirms your bed and issues your allocation slip.';

  @override
  String get accommodationStepClearedBody =>
      'Cleared straight away by your scholarship exemption.';

  @override
  String get accommodationStepCheckIn => 'Check in at the hall office';

  @override
  String get accommodationStepCheckInBody =>
      'Collect your key from the hall warden with your slip and ID card.';

  @override
  String get accommodationSwapIncoming => 'Incoming proposal';

  @override
  String accommodationSwapExpires(Object date) {
    return 'Exp: $date';
  }

  @override
  String accommodationSwapBody(Object bed) {
    return 'The student in $bed has asked to swap beds with you. Swap beds? Any difference in price is invoiced or credited to your wallet.';
  }

  @override
  String get accommodationSwapAccept => 'Swap';

  @override
  String get accommodationSwapDecline => 'Decline';

  @override
  String get accommodationSwapTitle => 'Swap beds with another student';

  @override
  String get accommodationSwapIntro =>
      'Enter the matric number of the student you want to swap with. Both of you must hold a reserved or confirmed bed in the same term.';

  @override
  String get accommodationSwapMatricLabel => 'Their matric number';

  @override
  String get accommodationSwapMatricHint => '25/CSC/0202';

  @override
  String get accommodationSwapVerify => 'Verify';

  @override
  String get accommodationSwapNotFound =>
      'No student with a bed this term has that matric number.';

  @override
  String accommodationSwapFound(Object name) {
    return 'Found student: $name';
  }

  @override
  String get accommodationSwapPropose => 'Propose swap';

  @override
  String get accommodationTermsPageTitle => 'Accommodation terms';

  @override
  String get accommodationTermsGovernance => 'Residential code and tenancy';

  @override
  String get accommodationTermsHeadline => 'Accommodation terms';

  @override
  String get accommodationTermsGate =>
      'You must accept these terms before you can book a room.';

  @override
  String get accommodationTermsTitle => 'The agreement';

  @override
  String accommodationTermsVersion(Object version) {
    return 'v$version';
  }

  @override
  String accommodationTermsIntro(Object term, Object version) {
    return 'Version $version. Accept them to book a room for $term.';
  }

  @override
  String get accommodationTermsCheckbox =>
      'I have read and accept the accommodation terms.';

  @override
  String get accommodationTermsTickError =>
      'Tick the box to accept the accommodation terms.';

  @override
  String get accommodationTermsAccept => 'Accept terms';

  @override
  String accommodationTermsAccepted(Object version) {
    return 'You have accepted version $version of the accommodation terms.';
  }

  @override
  String get accommodationTermsRecordNote =>
      'Accepting records this version and the date against your account.';

  @override
  String accommodationTermsSeal(Object reference) {
    return 'Deanery of Student Affairs · $reference';
  }

  @override
  String get accommodationClauseLoadBearing =>
      'If the fee is late, the bed is released.';

  @override
  String get accommodationHistoryLinkTitle => 'Accommodation history';

  @override
  String get accommodationHistoryLinkBody =>
      'Rooms and beds you held in earlier terms.';

  @override
  String get accommodationHistoryNoCurrent => 'No current allocation';

  @override
  String accommodationHistoryNoBed(Object term) {
    return 'No bed allocated for $term';
  }

  @override
  String get accommodationHistoryNoBedBody =>
      'The allocation window may be closed, or you have not applied for a bed. When a waitlist offer or a booking window opens, it will appear here.';

  @override
  String get accommodationHistoryCurrentBody =>
      'This is your bed for the selected term.';

  @override
  String get accommodationHistoryOpenings =>
      'View housing openings and notices';

  @override
  String get accommodationHistoryTitle => 'Accommodation history';

  @override
  String accommodationHistoryCount(Object count) {
    return '$count records';
  }

  @override
  String get accommodationHistoryIntro =>
      'Rooms and beds you held in earlier terms. Use this record for clearance or proof of earlier residence.';

  @override
  String accommodationHistoryBed(Object bed, Object hostelBlock, Object room) {
    return '$hostelBlock / Room $room · Bed $bed';
  }

  @override
  String accommodationHistorySession(Object label) {
    return 'Session $label';
  }

  @override
  String get accommodationHistoryCheckedOut => 'Checked out';

  @override
  String get accommodationHistoryCancelledCharge => 'Cancelled with a charge';

  @override
  String get accommodationHistoryCancelled => 'Cancelled';

  @override
  String get accommodationHistoryExpired => 'Expired';

  @override
  String get accommodationHistoryEmptyTitle => 'No previous accommodation';

  @override
  String get accommodationHistoryEmptyBody =>
      'You have not held a bed in a hostel before.';

  @override
  String get accommodationHistoryExport => 'Export accommodation history';

  @override
  String accommodationHistoryDisplaying(Object count) {
    return 'Showing all $count past records.';
  }

  @override
  String get accommodationSupportTitle =>
      'Student welfare and housing directorate';

  @override
  String get accommodationSupportExtension => 'Ext. #41';

  @override
  String get accommodationSupportCall => 'Call the directorate';

  @override
  String get accommodationNoticeTerms => 'Terms accepted. Booking is open.';

  @override
  String get accommodationNoticeHeld =>
      'Bed held. Pay before the deadline to confirm it.';

  @override
  String get accommodationNoticeCancelled =>
      'Booking cancelled and the bed released.';

  @override
  String get accommodationNoticeAccepted =>
      'Offer accepted. An invoice has been raised.';

  @override
  String get accommodationNoticeDeclined =>
      'Offer declined. You have left the waitlist.';

  @override
  String get accommodationNoticeSwapDone => 'Beds swapped.';

  @override
  String get accommodationNoticeSwapDeclined => 'Swap declined.';

  @override
  String get accommodationNoticeSwapSent => 'Swap proposal sent.';

  @override
  String get housingTaskBarTitle => 'Housing Directorate';

  @override
  String get housingTaskBarSubtitle => 'Staff · Accommodation';

  @override
  String get housingBreadcrumbRoot => 'Housing';

  @override
  String get housingSave => 'Save changes';

  @override
  String get housingNone => 'None';

  @override
  String get housingConfirmKeep => 'Keep as it is';

  @override
  String get housingDaysSuffix => 'days';

  @override
  String get housingPercentSign => '%';

  @override
  String housingHours(Object count) {
    return '$count hours';
  }

  @override
  String housingDays(Object count) {
    return '$count days';
  }

  @override
  String housingBeds(Object count) {
    return '$count beds';
  }

  @override
  String housingPercent(Object percent) {
    return '$percent%';
  }

  @override
  String get housingFilterAll => 'All';

  @override
  String get housingStateHeld => 'Held';

  @override
  String get housingStateOffered => 'Offered';

  @override
  String get housingStateConfirmed => 'Confirmed';

  @override
  String get housingStateCheckedIn => 'Checked in';

  @override
  String get housingStateCancelled => 'Cancelled';

  @override
  String get housingMethodStudent => 'Booked by student';

  @override
  String get housingMethodByHand => 'By hand';

  @override
  String get housingMethodSpreadsheet => 'Spreadsheet';

  @override
  String get housingMethodAutomatic => 'Automatic';

  @override
  String get housingMethodDraw => 'Draw';

  @override
  String get housingMethodKeepMyRoom => 'Keep my room';

  @override
  String get housingGenderFemale => 'Female hostel';

  @override
  String get housingGenderMale => 'Male hostel';

  @override
  String get housingGenderMixed => 'Mixed hostel';

  @override
  String get housingBedFree => 'Free';

  @override
  String get housingBedHeld => 'Held';

  @override
  String get housingBedTaken => 'Taken';

  @override
  String get housingBedBlocked => 'Not bookable';

  @override
  String housingBedSemantics(Object number, Object state) {
    return 'Bed $number, $state';
  }

  @override
  String housingBedSemanticsOccupied(
    Object number,
    Object occupant,
    Object state,
  ) {
    return 'Bed $number, $state, $occupant';
  }

  @override
  String get housingRoomOpen => 'Open';

  @override
  String get housingRoomMaintenance => 'Maintenance';

  @override
  String get housingRoomClosed => 'Closed';

  @override
  String get housingBookingFirstCome => 'First come';

  @override
  String get housingBookingDraw => 'Draw';

  @override
  String get housingBookingPriority => 'Priority';

  @override
  String get housingOpeningScheduled => 'Scheduled';

  @override
  String get housingOpeningOpen => 'Open';

  @override
  String get housingOpeningClosed => 'Closed';

  @override
  String get housingIssueBedUnknown => 'No such bed in the hostel inventory.';

  @override
  String get housingIssueMatricUnknown => 'No student has this matric number.';

  @override
  String get housingIssueBedTaken => 'This bed is already allocated.';

  @override
  String get housingIssueDuplicate =>
      'This student appears on more than one row.';

  @override
  String get housingIssueGender =>
      'The hostel is not open to this student\'s gender.';

  @override
  String get housingNoticeOfferMade => 'Offer made';

  @override
  String get housingNoticeDeadlineNear => 'Deadline near';

  @override
  String get housingNoticeBedReleased => 'Bed released';

  @override
  String get housingNoticeWelcome => 'Welcome';

  @override
  String get housingSkipBanned => 'Banned from housing';

  @override
  String get housingSkipUnpaid => 'Unpaid fees';

  @override
  String get housingSkipRoomClosed => 'Room is closed';

  @override
  String get housingDrawBallot => 'Ballot';

  @override
  String get housingDrawPriority => 'Priority';

  @override
  String get housingNoticeCancelled =>
      'Allocation cancelled and the bed freed.';

  @override
  String get housingNoticeRoomSaved => 'Room settings saved.';

  @override
  String get housingNoticeRoomsAdded => 'Rooms added to the block.';

  @override
  String get housingNoticePublished => 'New agreement version published.';

  @override
  String get housingNoticeWordingSaved => 'Notice wording saved.';

  @override
  String get housingNoticeCategorySaved => 'Category added.';

  @override
  String get housingNoticeCategoryRemoved => 'Category removed.';

  @override
  String get housingNoticeBanAdded => 'Student banned from booking.';

  @override
  String get housingNoticeBanLifted => 'Ban lifted.';

  @override
  String get housingNoticeRefundSaved => 'Refund rules saved.';

  @override
  String get housingNoticePriceSaved => 'Price saved.';

  @override
  String get housingNoticeOpeningSaved => 'Booking method saved.';

  @override
  String get housingNoticeDrawRun => 'Draw complete.';

  @override
  String get housingNoticeAutoRun => 'Automatic allocation complete.';

  @override
  String get housingNoticeKeepSent => 'Keep-my-room offers sent.';

  @override
  String get housingNoticeUploadDone => 'Spreadsheet applied as one batch.';

  @override
  String get housingToolsTitle => 'Tools';

  @override
  String get housingQueueTitle => 'Allocations';

  @override
  String get housingQueueSubtitle =>
      'Every bed given out, by state, and the tools to give out more.';

  @override
  String get housingQueueSummaryTitle => 'Today';

  @override
  String get housingMetricAllocations => 'Allocations';

  @override
  String get housingMetricFreeBeds => 'Free beds';

  @override
  String get housingMetricWaitlist => 'Waitlist';

  @override
  String get housingMetricBeds => 'Beds';

  @override
  String get housingMetricTaken => 'Taken';

  @override
  String get housingMetricFree => 'Free';

  @override
  String get housingMetricApplicants => 'Applicants';

  @override
  String get housingMetricEligible => 'Eligible residents';

  @override
  String get housingQueueEmptyTitle => 'No allocations here';

  @override
  String get housingQueueEmptyBody =>
      'Nothing matches this filter. Pick another state, or give out beds with one of the tools.';

  @override
  String get housingToolHostelsTitle => 'Hostels and rooms';

  @override
  String get housingToolHostelsBody =>
      'Beds block by block, room settings and occupants.';

  @override
  String get housingToolOpeningsTitle => 'Openings and prices';

  @override
  String get housingToolOpeningsBody =>
      'When each term books, how, and what a bed costs.';

  @override
  String get housingToolUploadTitle => 'Allocate from a spreadsheet';

  @override
  String get housingToolUploadBody =>
      'Upload a sheet of students and beds as one batch.';

  @override
  String get housingToolAllocateTitle => 'Allocate by hand';

  @override
  String get housingToolAllocateBody => 'Give one student one bed.';

  @override
  String get housingToolAutoTitle => 'Automatic allocation';

  @override
  String housingToolAutoBody(Object count) {
    return 'Place the $count students on the waitlist.';
  }

  @override
  String get housingToolDrawTitle => 'The draw';

  @override
  String housingToolDrawBody(Object count) {
    return 'Pick winners for $count applicants.';
  }

  @override
  String get housingToolKeepTitle => 'Keep my room';

  @override
  String housingToolKeepBody(Object count) {
    return 'Offer $count residents their own beds back.';
  }

  @override
  String get housingToolAgreementTitle => 'Accommodation agreement';

  @override
  String get housingToolAgreementBody =>
      'Publish a new version students must accept.';

  @override
  String get housingToolNoticesTitle => 'Housing notices';

  @override
  String get housingToolNoticesBody => 'Reword the messages students receive.';

  @override
  String get housingToolCategoriesTitle => 'Housing categories';

  @override
  String get housingToolCategoriesBody =>
      'Who counts for more in a priority draw.';

  @override
  String get housingToolBansTitle => 'Housing bans';

  @override
  String housingToolBansBody(Object count) {
    return '$count students barred from booking.';
  }

  @override
  String get housingToolRefundsTitle => 'Cancellation refunds';

  @override
  String housingToolRefundsBody(Object percent) {
    return 'Students get $percent% back when they cancel in time.';
  }

  @override
  String get housingDetailTitle => 'Allocation';

  @override
  String get housingDetailSubtitle =>
      'The student, the bed, the fee and how it was made.';

  @override
  String get housingDetailMissingTitle => 'Allocation not found';

  @override
  String get housingDetailMissingBody =>
      'It may have been removed. Go back to the queue and pick another.';

  @override
  String get housingDetailProgramme => 'Programme';

  @override
  String get housingDetailBedTitle => 'Bed';

  @override
  String get housingDetailHostel => 'Hostel';

  @override
  String get housingDetailRoom => 'Room';

  @override
  String get housingDetailRoomType => 'Room type';

  @override
  String get housingDetailTerm => 'Term';

  @override
  String get housingDetailRecordTitle => 'Record';

  @override
  String get housingDetailFee => 'Fee';

  @override
  String get housingDetailInvoice => 'Invoice';

  @override
  String get housingDetailMethod => 'Made by';

  @override
  String get housingDetailCreated => 'Created';

  @override
  String get housingCancelAction => 'Cancel this allocation';

  @override
  String get housingCancelTitle => 'Cancel this allocation?';

  @override
  String housingCancelBody(Object name) {
    return '$name loses the bed and it becomes free for the next student. Any fee paid goes to their wallet.';
  }

  @override
  String get housingCancelConfirm => 'Cancel allocation';

  @override
  String get housingHostelsSubtitle =>
      'Every hostel, with how many beds are free.';

  @override
  String get housingHostelsEmptyTitle => 'No hostels yet';

  @override
  String get housingHostelsEmptyBody =>
      'Hostels appear here once they are added to the inventory.';

  @override
  String housingHostelSummary(
    Object blocks,
    Object free,
    Object rooms,
    Object total,
  ) {
    return '$blocks blocks · $rooms rooms · $free of $total beds free';
  }

  @override
  String get housingHostelTitle => 'Hostel';

  @override
  String get housingHostelSubtitle =>
      'Beds block by block. Tap a room to change its settings.';

  @override
  String get housingHostelMissingTitle => 'Hostel not found';

  @override
  String get housingHostelMissingBody =>
      'It may have been removed. Go back to the list and pick another.';

  @override
  String get housingOccupantsTitle => 'Occupants';

  @override
  String housingOccupantsEntry(Object count) {
    return '$count students living here.';
  }

  @override
  String get housingOccupantsSubtitle => 'Who holds a bed in this hostel.';

  @override
  String housingOccupantsCount(Object count) {
    return '$count occupants';
  }

  @override
  String get housingOccupantsEmptyTitle => 'Nobody lives here yet';

  @override
  String housingOccupantsEmptyBody(Object hostel) {
    return '$hostel has no occupants. They appear once a bed is held or confirmed.';
  }

  @override
  String housingOccupantBed(Object bed, Object room) {
    return '$room · Bed $bed';
  }

  @override
  String get housingBlockAddRooms => 'Add rooms';

  @override
  String get housingBlockEmptyTitle => 'No rooms in this block';

  @override
  String get housingBlockEmptyBody =>
      'Add a run of rooms to start giving out beds here.';

  @override
  String housingRoomHeading(Object number, Object type) {
    return 'Room $number · $type';
  }

  @override
  String get housingRoomTitle => 'Room settings';

  @override
  String get housingRoomSubtitle =>
      'Whether the room can be booked, and what type it is.';

  @override
  String get housingRoomMissingTitle => 'Room not found';

  @override
  String get housingRoomMissingBody =>
      'It may have been removed. Go back to the hostel and pick another.';

  @override
  String get housingRoomFloor => 'Floor';

  @override
  String get housingRoomStatusTitle => 'Booking status';

  @override
  String get housingRoomStatusBody =>
      'A room under maintenance or closed shows no free beds to students.';

  @override
  String get housingRoomTypeTitle => 'Room type';

  @override
  String get housingRoomTypeNote =>
      'The type decides the price a student is invoiced.';

  @override
  String get housingBlockTitle => 'Add rooms to a block';

  @override
  String get housingBlockSubtitle => 'Create a run of rooms in one go.';

  @override
  String housingBlockCurrent(Object count, Object hostel) {
    return '$hostel · $count rooms now';
  }

  @override
  String get housingBlockFrom => 'First room number';

  @override
  String get housingBlockTo => 'Last room number';

  @override
  String get housingBlockRangeError =>
      'Enter two numbers, the second not smaller than the first.';

  @override
  String get housingBlockBeds => 'Beds per room';

  @override
  String housingBlockPreview(Object beds, Object rooms) {
    return 'This adds $rooms rooms and $beds beds. Room numbers already in the block are skipped.';
  }

  @override
  String get housingBlockAdd => 'Add rooms';

  @override
  String get housingOpeningsSubtitle =>
      'When each term books, how beds are given out, and what they cost.';

  @override
  String get housingTabOpenings => 'Openings';

  @override
  String get housingTabPrices => 'Prices';

  @override
  String get housingTabRefunds => 'Refunds';

  @override
  String get housingOpeningsEmptyTitle => 'No openings scheduled';

  @override
  String get housingOpeningsEmptyBody =>
      'Schedule a term\'s booking window before students can book.';

  @override
  String housingOpeningWindow(Object closes, Object opens) {
    return 'Booking from $opens to $closes';
  }

  @override
  String get housingOpeningMethod => 'How beds are given out';

  @override
  String get housingOpeningHold => 'Hold time for payment';

  @override
  String get housingOpeningGrace => 'Grace after the deadline';

  @override
  String get housingOpeningQuota => 'Free scholarship beds';

  @override
  String get housingOpeningClosedDays => 'Closed days';

  @override
  String get housingPricesTitle => 'Bed price by room type';

  @override
  String get housingPricesBody =>
      'Per term, in naira. A change applies to beds booked from now on.';

  @override
  String get housingPriceInvalid => 'Enter an amount such as 75,000.00.';

  @override
  String get housingRefundsTitle => 'Cancellation refunds';

  @override
  String get housingRefundsIntro =>
      'What share of a paid fee goes back to the wallet when a student cancels early enough.';

  @override
  String get housingRefundsSubtitle =>
      'Set the refund share and test it on a sample cancellation.';

  @override
  String get housingRefundShare => 'Refund share';

  @override
  String get housingRefundWindow => 'Cancel at least this long before check-in';

  @override
  String get housingRefundsOpen => 'Open the refund simulator';

  @override
  String get housingSimulateTitle => 'Simulate a cancellation';

  @override
  String get housingSimulateBody =>
      'See what one cancellation would hand back under the rules above.';

  @override
  String get housingSimulatePaid => 'Fee paid';

  @override
  String get housingSimulateDays => 'Days before check-in';

  @override
  String get housingSimulateRun => 'Simulate';

  @override
  String get housingSimulateRefund => 'Refunded to wallet';

  @override
  String get housingSimulateCharge => 'Cancellation charge';

  @override
  String housingSimulateWithin(Object days) {
    return 'This is at least $days days before check-in, so the refund share applies.';
  }

  @override
  String housingSimulateOutside(Object days) {
    return 'This is less than $days days before check-in, so nothing is refunded.';
  }

  @override
  String get housingUploadSubtitle =>
      'Give out many beds at once from a spreadsheet.';

  @override
  String get housingUploadFormTitle => 'Choose a spreadsheet';

  @override
  String get housingUploadFormBody =>
      'The whole sheet is applied together, or not at all. Any row problem leaves everything untouched.';

  @override
  String get housingUploadColumns => 'Columns';

  @override
  String get housingUploadColumnList =>
      'matric_number, hostel, block, room, bed';

  @override
  String get housingUploadSampleValid => 'Use a correct sample sheet';

  @override
  String get housingUploadSampleHeader => 'Use a sheet with a missing column';

  @override
  String get housingUploadSampleRows => 'Use a sheet with row problems';

  @override
  String get housingUploadAnother => 'Try another file';

  @override
  String housingUploadHeaderTitle(Object file) {
    return '$file cannot be read';
  }

  @override
  String housingUploadHeaderBody(Object column) {
    return 'The sheet has no \"$column\" column. Add it to the first row and upload again.';
  }

  @override
  String housingUploadRowsTitle(Object issues, Object rows) {
    return '$issues of $rows rows have problems';
  }

  @override
  String get housingUploadRowsBody =>
      'Nothing was applied. Fix these rows in the sheet and upload it again.';

  @override
  String housingUploadRow(Object row) {
    return 'Row $row';
  }

  @override
  String get housingUploadSuccessTitle => 'Batch applied';

  @override
  String housingUploadSuccessBody(Object rows) {
    return 'All $rows rows were applied. Each student has been told.';
  }

  @override
  String get housingUploadBatch => 'Batch';

  @override
  String get housingUploadFile => 'File';

  @override
  String get housingAllocateSubtitle =>
      'Give one student one bed. They are told straight away.';

  @override
  String get housingAllocateStudent => 'Student';

  @override
  String get housingAllocateMatric => 'Matric number';

  @override
  String get housingAllocateBed => 'Bed';

  @override
  String get housingAllocateHostel => 'Hostel';

  @override
  String get housingAllocateRoom => 'Room';

  @override
  String housingAllocateRoomChoice(Object block, Object number) {
    return '$block · $number';
  }

  @override
  String get housingAllocateBedNumber => 'Bed number';

  @override
  String get housingAllocateSubmit => 'Allocate bed';

  @override
  String get housingAllocateDoneTitle => 'Bed allocated';

  @override
  String housingAllocateDoneBody(Object bed, Object name) {
    return '$name now holds $bed.';
  }

  @override
  String get housingAllocateUnknown => 'No student has this matric number.';

  @override
  String housingAllocateTaken(Object name) {
    return 'That bed is no longer free, so $name was not allocated.';
  }

  @override
  String housingAllocateBanned(Object name) {
    return '$name is barred from housing and cannot be allocated a bed.';
  }

  @override
  String get housingAutoSubtitle => 'Place the waitlist into the free beds.';

  @override
  String get housingAutoTitle => 'Automatic allocation';

  @override
  String get housingAutoBody =>
      'Students on the waitlist are placed in order of when they joined, into beds that match their hostel\'s gender and level.';

  @override
  String get housingAutoRules =>
      'Banned students are skipped. Anyone left over stays on the waitlist.';

  @override
  String get housingAutoRun => 'Run allocation';

  @override
  String get housingAutoConfirmTitle => 'Run automatic allocation?';

  @override
  String housingAutoConfirmBody(Object free, Object waitlist) {
    return 'This places up to $waitlist students into $free free beds. Each student is told.';
  }

  @override
  String get housingAutoResultTitle => 'Result';

  @override
  String get housingAutoPlaced => 'Placed';

  @override
  String get housingAutoUnplaced => 'Still waiting';

  @override
  String get housingAutoLeft => 'Beds left';

  @override
  String get housingDrawSubtitle =>
      'Pick who gets a bed when there are more applicants than beds.';

  @override
  String get housingDrawTitle => 'The draw';

  @override
  String get housingDrawBody =>
      'A ballot picks at random. A priority draw weighs each applicant by their housing category.';

  @override
  String get housingDrawBallotNote => 'Every applicant has the same chance.';

  @override
  String get housingDrawPriorityNote =>
      'Applicants in heavier categories are drawn first. Set the weights under housing categories.';

  @override
  String get housingDrawSeats => 'Beds to give out';

  @override
  String get housingDrawRun => 'Run the draw';

  @override
  String get housingDrawConfirmTitle => 'Run the draw?';

  @override
  String housingDrawConfirmBody(Object applicants, Object seats) {
    return 'This gives out $seats beds among $applicants applicants. It cannot be run again for the same applicants.';
  }

  @override
  String get housingDrawResultTitle => 'Draw result';

  @override
  String get housingDrawReference => 'Draw';

  @override
  String get housingDrawMethodLabel => 'Method';

  @override
  String get housingDrawWinners => 'Winners';

  @override
  String housingDrawWinnersValue(Object applicants, Object winners) {
    return '$winners of $applicants';
  }

  @override
  String get housingDrawWaitlisted => 'Moved to the waitlist';

  @override
  String get housingKeepSubtitle =>
      'Offer last term\'s residents the beds they already have.';

  @override
  String get housingKeepTitle => 'Keep my room';

  @override
  String get housingKeepBody =>
      'Residents who qualify get their own bed offered back for a window, before booking opens to everyone else.';

  @override
  String get housingKeepWindow => 'Offer lasts';

  @override
  String get housingKeepNote =>
      'Each resident is sent an offer. They answer once; an unanswered offer releases the bed.';

  @override
  String get housingKeepSend => 'Send offers';

  @override
  String get housingKeepConfirmTitle => 'Send keep-my-room offers?';

  @override
  String housingKeepConfirmBody(Object count, Object days) {
    return '$count residents will be offered their beds for $days days.';
  }

  @override
  String get housingKeepResultTitle => 'Offers sent';

  @override
  String housingKeepResultBody(Object days, Object offered) {
    return '$offered residents were offered their beds for $days days.';
  }

  @override
  String housingKeepSkippedTitle(Object count) {
    return '$count residents were skipped';
  }

  @override
  String get housingAgreementSubtitle =>
      'Publish a new version of the accommodation terms.';

  @override
  String get housingAgreementCurrent => 'Version in force';

  @override
  String housingAgreementPublished(Object date, Object version) {
    return 'Version $version, published $date.';
  }

  @override
  String housingAgreementPublishTitle(Object version) {
    return 'Publish version $version';
  }

  @override
  String get housingAgreementPublishBody =>
      'Say in a few sentences what changed.';

  @override
  String get housingAgreementSummary => 'What changed';

  @override
  String get housingAgreementWarning =>
      'Every student has to accept the new version before they can book a bed again.';

  @override
  String get housingAgreementPublish => 'Publish version';

  @override
  String housingAgreementConfirmTitle(Object version) {
    return 'Publish version $version?';
  }

  @override
  String get housingAgreementConfirmBody =>
      'It replaces the version in force straight away. Students accept it the next time they book.';

  @override
  String get housingAgreementHistory => 'Earlier versions';

  @override
  String get housingAgreementLive => 'In force';

  @override
  String get housingNoticesSubtitle =>
      'Reword the messages students receive about their beds.';

  @override
  String get housingNoticeWording => 'Wording';

  @override
  String get housingCategoriesSubtitle =>
      'The weight of each category when a draw is by priority.';

  @override
  String get housingCategoriesEmptyTitle => 'No categories';

  @override
  String get housingCategoriesEmptyBody =>
      'Add a category to give some students priority in a draw.';

  @override
  String housingCategoryLine(Object count, Object weight) {
    return 'Weight $weight · $count students';
  }

  @override
  String get housingCategoryRemove => 'Remove category';

  @override
  String housingCategoryRemoveTitle(Object name) {
    return 'Remove $name?';
  }

  @override
  String get housingCategoryRemoveBody =>
      'Students in it lose the priority it gave them in the next draw.';

  @override
  String get housingCategoryAddTitle => 'Add a category';

  @override
  String get housingCategoryName => 'Category name';

  @override
  String get housingCategoryWeight => 'Weight';

  @override
  String get housingCategoryAdd => 'Add category';

  @override
  String get housingBansSubtitle => 'Students barred from booking a bed.';

  @override
  String get housingBansEmptyTitle => 'Nobody is banned';

  @override
  String get housingBansEmptyBody =>
      'Bar a student here and they cannot book, be offered or be allocated a bed.';

  @override
  String housingBanSince(Object date, Object matric) {
    return '$matric · since $date';
  }

  @override
  String get housingBanLift => 'Lift ban';

  @override
  String housingBanLiftTitle(Object name) {
    return 'Lift the ban on $name?';
  }

  @override
  String get housingBanLiftBody => 'They can book beds again from now on.';

  @override
  String get housingBanAddTitle => 'Ban a student';

  @override
  String get housingBanAddBody =>
      'The student cannot book, be offered or be allocated a bed until you lift the ban.';

  @override
  String get housingBanReason => 'Reason';

  @override
  String get housingBanRejected =>
      'No student with that matric number, or they are already banned.';

  @override
  String get housingBanAdd => 'Ban student';

  @override
  String get accommodationPreviewAction => 'Preview states';

  @override
  String get accommodationPreviewTitle => 'Student accommodation states';

  @override
  String get accommodationPreviewSubtitle =>
      'Debug only. Loads a fixture ledger so you can walk every student screen. Use the History tab for past beds; Terms and Rooms open from the matching states.';

  @override
  String get accommodationPreviewHeldAndOffer => 'Held bed + waitlist offer';

  @override
  String get accommodationPreviewHeldAndOfferHint =>
      'Term 1 held with a swap proposal; switch to Term 2 for the offer.';

  @override
  String get accommodationPreviewNotScheduled => 'Not scheduled';

  @override
  String get accommodationPreviewNotScheduledHint =>
      'Booking has not been published for either term.';

  @override
  String get accommodationPreviewNeedsTerms => 'Terms to accept';

  @override
  String get accommodationPreviewNeedsTermsHint =>
      'Opens the agreement gate, then booking.';

  @override
  String get accommodationPreviewRoomList => 'Room list';

  @override
  String get accommodationPreviewRoomListHint =>
      'Booking open — choose a room.';

  @override
  String get accommodationPreviewConfirmed => 'Confirmed bed';

  @override
  String get accommodationPreviewConfirmedHint =>
      'Paid and confirmed, not yet checked in.';

  @override
  String get accommodationPreviewFreeBed => 'Free / scholarship bed';

  @override
  String get accommodationPreviewFreeBedHint => 'Confirmed with no fee due.';

  @override
  String get accommodationPreviewCheckedIn => 'Checked in';

  @override
  String get accommodationPreviewCheckedInHint =>
      'Official resident with slip and hall details.';

  @override
  String get accommodationPreviewSessionHeld => 'Session booking (held)';

  @override
  String get accommodationPreviewSessionHeldHint =>
      'One fee covers both terms of the session.';

  @override
  String get accommodationPreviewNoHistory => 'History empty';

  @override
  String get accommodationPreviewNoHistoryHint =>
      'Opens History with no past beds.';
}

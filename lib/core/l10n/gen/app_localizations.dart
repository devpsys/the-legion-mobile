import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// Application name shown in the task switcher and browser tab.
  ///
  /// In en, this message translates to:
  /// **'The Legion'**
  String get appTitle;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get commonDismiss;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get commonLoading;

  /// No description provided for @commonComingSoon.
  ///
  /// In en, this message translates to:
  /// **'This service goes live with the next release.'**
  String get commonComingSoon;

  /// No description provided for @commonGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get commonGreetingMorning;

  /// No description provided for @commonGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get commonGreetingAfternoon;

  /// No description provided for @commonGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get commonGreetingEvening;

  /// No description provided for @errorsNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check your network and try again.'**
  String get errorsNetwork;

  /// No description provided for @errorsServer.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on our side. Please try again.'**
  String get errorsServer;

  /// No description provided for @errorsUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'You are not authorized to continue.'**
  String get errorsUnauthorized;

  /// No description provided for @errorsCache.
  ///
  /// In en, this message translates to:
  /// **'Local data could not be read or written.'**
  String get errorsCache;

  /// No description provided for @errorsUnexpected.
  ///
  /// In en, this message translates to:
  /// **'Something unexpected happened. Please try again.'**
  String get errorsUnexpected;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get validationRequired;

  /// No description provided for @validationInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get validationInvalidEmail;

  /// No description provided for @validationPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters.'**
  String get validationPasswordTooShort;

  /// No description provided for @validationPasswordNeedsLettersAndNumbers.
  ///
  /// In en, this message translates to:
  /// **'Use both letters and numbers in your password.'**
  String get validationPasswordNeedsLettersAndNumbers;

  /// No description provided for @validationPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'The passwords do not match.'**
  String get validationPasswordMismatch;

  /// No description provided for @validationInvalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number.'**
  String get validationInvalidPhone;

  /// No description provided for @validationEmailAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'An account already exists for this email address. Sign in instead.'**
  String get validationEmailAlreadyRegistered;

  /// No description provided for @validationInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get validationInvalidCredentials;

  /// No description provided for @validationInvalidRequest.
  ///
  /// In en, this message translates to:
  /// **'The submitted data is invalid.'**
  String get validationInvalidRequest;

  /// No description provided for @sessionRestoring.
  ///
  /// In en, this message translates to:
  /// **'Restoring your session'**
  String get sessionRestoring;

  /// No description provided for @loginSsoBadge.
  ///
  /// In en, this message translates to:
  /// **'SSO'**
  String get loginSsoBadge;

  /// No description provided for @loginHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The Legion University — one sign-in for admissions, students, staff and administration.'**
  String get loginHeaderSubtitle;

  /// No description provided for @loginCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginCardTitle;

  /// No description provided for @loginCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use your institutional email and password.'**
  String get loginCardSubtitle;

  /// No description provided for @loginEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Institutional email'**
  String get loginEmailLabel;

  /// No description provided for @loginEmailHint.
  ///
  /// In en, this message translates to:
  /// **'you@legion.edu.ng'**
  String get loginEmailHint;

  /// No description provided for @loginEmailHelper.
  ///
  /// In en, this message translates to:
  /// **'Use your @legion.edu.ng address or applicant email.'**
  String get loginEmailHelper;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter institutional password'**
  String get loginPasswordHint;

  /// No description provided for @loginShowPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get loginShowPassword;

  /// No description provided for @loginHidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get loginHidePassword;

  /// No description provided for @loginRememberMe.
  ///
  /// In en, this message translates to:
  /// **'Keep me signed in'**
  String get loginRememberMe;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get loginForgotPassword;

  /// No description provided for @loginSubmit.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginSubmit;

  /// No description provided for @loginSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Signing in'**
  String get loginSubmitting;

  /// No description provided for @loginOrDivider.
  ///
  /// In en, this message translates to:
  /// **'or institutional access'**
  String get loginOrDivider;

  /// No description provided for @loginActionCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an applicant account'**
  String get loginActionCreateAccount;

  /// No description provided for @loginActionVerifyLetter.
  ///
  /// In en, this message translates to:
  /// **'Verify an admission letter'**
  String get loginActionVerifyLetter;

  /// No description provided for @loginAuditTitle.
  ///
  /// In en, this message translates to:
  /// **'Statutory Audit Protocol'**
  String get loginAuditTitle;

  /// No description provided for @loginAuditBody.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized access attempts to academic records or financial portfolios are monitored and reported under statutory federal frameworks.'**
  String get loginAuditBody;

  /// No description provided for @loginCopyright.
  ///
  /// In en, this message translates to:
  /// **'Secure Institutional Verification © The Legion University'**
  String get loginCopyright;

  /// No description provided for @createAccountBackTooltip.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get createAccountBackTooltip;

  /// No description provided for @createAccountBrandCaption.
  ///
  /// In en, this message translates to:
  /// **'The Legion University Admissions'**
  String get createAccountBrandCaption;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create an applicant account'**
  String get createAccountTitle;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Apply for admission, claim your JAMB result and track your offer. Students and staff get their accounts from the university.'**
  String get createAccountSubtitle;

  /// No description provided for @fieldRequiredMarker.
  ///
  /// In en, this message translates to:
  /// **'*'**
  String get fieldRequiredMarker;

  /// No description provided for @createAccountOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'{label} (optional)'**
  String createAccountOptionalLabel(Object label);

  /// No description provided for @createAccountFirstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get createAccountFirstName;

  /// No description provided for @createAccountFirstNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Oluwaseun'**
  String get createAccountFirstNameHint;

  /// No description provided for @createAccountSurname.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get createAccountSurname;

  /// No description provided for @createAccountSurnameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Adeyemi'**
  String get createAccountSurnameHint;

  /// No description provided for @createAccountOtherNames.
  ///
  /// In en, this message translates to:
  /// **'Other names'**
  String get createAccountOtherNames;

  /// No description provided for @createAccountOtherNamesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Michael'**
  String get createAccountOtherNamesHint;

  /// No description provided for @createAccountEmail.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get createAccountEmail;

  /// No description provided for @createAccountEmailHint.
  ///
  /// In en, this message translates to:
  /// **'candidate@example.com'**
  String get createAccountEmailHint;

  /// No description provided for @createAccountEmailHelper.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send a link to confirm it.'**
  String get createAccountEmailHelper;

  /// No description provided for @createAccountPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get createAccountPhone;

  /// No description provided for @createAccountPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'+234 803 123 4567'**
  String get createAccountPhoneHint;

  /// No description provided for @createAccountPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get createAccountPassword;

  /// No description provided for @createAccountPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get createAccountPasswordHint;

  /// No description provided for @createAccountPasswordHelper.
  ///
  /// In en, this message translates to:
  /// **'8 or more characters, with letters and numbers.'**
  String get createAccountPasswordHelper;

  /// No description provided for @createAccountConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get createAccountConfirmPassword;

  /// No description provided for @createAccountConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Repeat password'**
  String get createAccountConfirmPasswordHint;

  /// No description provided for @createAccountSubmit.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccountSubmit;

  /// No description provided for @createAccountSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Creating account'**
  String get createAccountSubmitting;

  /// No description provided for @createAccountHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get createAccountHaveAccount;

  /// No description provided for @createAccountSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get createAccountSignIn;

  /// No description provided for @rateLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'Too many sign-in attempts'**
  String get rateLimitTitle;

  /// No description provided for @rateLimitRetryIn.
  ///
  /// In en, this message translates to:
  /// **'Try again in'**
  String get rateLimitRetryIn;

  /// No description provided for @rateLimitTag.
  ///
  /// In en, this message translates to:
  /// **'Security alert'**
  String get rateLimitTag;

  /// No description provided for @rateLimitFieldLocked.
  ///
  /// In en, this message translates to:
  /// **'Field locked'**
  String get rateLimitFieldLocked;

  /// No description provided for @rateLimitRetryAction.
  ///
  /// In en, this message translates to:
  /// **'Try again in'**
  String get rateLimitRetryAction;

  /// No description provided for @rateLimitRetryActionReady.
  ///
  /// In en, this message translates to:
  /// **'Try sign in again'**
  String get rateLimitRetryActionReady;

  /// No description provided for @rateLimitLockoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Institutional lockout'**
  String get rateLimitLockoutTitle;

  /// No description provided for @rateLimitLockoutCode.
  ///
  /// In en, this message translates to:
  /// **'SEC-403'**
  String get rateLimitLockoutCode;

  /// No description provided for @rateLimitLockoutBody.
  ///
  /// In en, this message translates to:
  /// **'Your account is temporarily locked after repeated failed sign-ins. Wait for the countdown or contact the registry to have it restored.'**
  String get rateLimitLockoutBody;

  /// No description provided for @rateLimitAdminRoute.
  ///
  /// In en, this message translates to:
  /// **'Direct administrative route'**
  String get rateLimitAdminRoute;

  /// No description provided for @rateLimitRegistryEmail.
  ///
  /// In en, this message translates to:
  /// **'registry@legion.edu.ng'**
  String get rateLimitRegistryEmail;

  /// No description provided for @rateLimitRegistryPhone.
  ///
  /// In en, this message translates to:
  /// **'+234 1 234 5678'**
  String get rateLimitRegistryPhone;

  /// No description provided for @rateLimitStatutoryRef.
  ///
  /// In en, this message translates to:
  /// **'Statutory Regulation Ref: NG-EDU-VER-2024'**
  String get rateLimitStatutoryRef;

  /// No description provided for @recoveryPortalTitle.
  ///
  /// In en, this message translates to:
  /// **'Legion Sovereign Portal'**
  String get recoveryPortalTitle;

  /// No description provided for @recoverySovereignId.
  ///
  /// In en, this message translates to:
  /// **'Legion Sovereign ID'**
  String get recoverySovereignId;

  /// No description provided for @recoverySecurityLevel.
  ///
  /// In en, this message translates to:
  /// **'SEC-L4'**
  String get recoverySecurityLevel;

  /// No description provided for @recoveryStepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String recoveryStepOf(Object current, Object total);

  /// No description provided for @recoveryRegistryAuthority.
  ///
  /// In en, this message translates to:
  /// **'Legion Registry Authority'**
  String get recoveryRegistryAuthority;

  /// No description provided for @recoveryRegistryMonogram.
  ///
  /// In en, this message translates to:
  /// **'LR'**
  String get recoveryRegistryMonogram;

  /// No description provided for @recoveryAccessDirectorate.
  ///
  /// In en, this message translates to:
  /// **'Identity & Access Directorate'**
  String get recoveryAccessDirectorate;

  /// No description provided for @recoveryVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get recoveryVerified;

  /// No description provided for @recoveryRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get recoveryRequestTitle;

  /// No description provided for @recoveryRequestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your registered institutional email or candidate registration number to initiate identity verification.'**
  String get recoveryRequestSubtitle;

  /// No description provided for @recoveryIdentifierLabel.
  ///
  /// In en, this message translates to:
  /// **'Institutional email or ID'**
  String get recoveryIdentifierLabel;

  /// No description provided for @recoveryIdentifierHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. amaka.bello@legion.edu.ng or 23/CSC/0412'**
  String get recoveryIdentifierHint;

  /// No description provided for @recoveryIdentifierHelper.
  ///
  /// In en, this message translates to:
  /// **'For applicants, use the email registered on your application.'**
  String get recoveryIdentifierHelper;

  /// No description provided for @recoverySecurityProtocol.
  ///
  /// In en, this message translates to:
  /// **'Institutional Security Protocol'**
  String get recoverySecurityProtocol;

  /// No description provided for @recoverySecurityProtocolBody.
  ///
  /// In en, this message translates to:
  /// **'A 6-digit one-time verification code will be dispatched to your recovery phone number and official inbox.'**
  String get recoverySecurityProtocolBody;

  /// No description provided for @recoverySendCode.
  ///
  /// In en, this message translates to:
  /// **'Send recovery code'**
  String get recoverySendCode;

  /// No description provided for @recoveryRememberedPassword.
  ///
  /// In en, this message translates to:
  /// **'Remembered your password? Sign in'**
  String get recoveryRememberedPassword;

  /// No description provided for @recoveryVerifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your identity'**
  String get recoveryVerifyTitle;

  /// No description provided for @recoveryVerifySent.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit security code to'**
  String get recoveryVerifySent;

  /// No description provided for @recoveryVerifyAndSms.
  ///
  /// In en, this message translates to:
  /// **'and SMS to'**
  String get recoveryVerifyAndSms;

  /// No description provided for @recoveryCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Cryptographic authentication token'**
  String get recoveryCodeLabel;

  /// No description provided for @recoveryExpiresIn.
  ///
  /// In en, this message translates to:
  /// **'Code expires in'**
  String get recoveryExpiresIn;

  /// No description provided for @recoveryVerifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify code'**
  String get recoveryVerifyCode;

  /// No description provided for @recoveryCodeInvalid.
  ///
  /// In en, this message translates to:
  /// **'That code is not correct. {remaining} attempts remaining before your recovery is locked for 15 minutes.'**
  String recoveryCodeInvalid(Object remaining);

  /// No description provided for @recoveryCodeInvalidTitle.
  ///
  /// In en, this message translates to:
  /// **'Incorrect code'**
  String get recoveryCodeInvalidTitle;

  /// No description provided for @recoveryCodeLockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Recovery temporarily locked'**
  String get recoveryCodeLockedTitle;

  /// No description provided for @recoveryCodeLockedBody.
  ///
  /// In en, this message translates to:
  /// **'Too many incorrect codes. Recovery unlocks in {remaining}.'**
  String recoveryCodeLockedBody(Object remaining);

  /// No description provided for @recoveryAttemptsTitle.
  ///
  /// In en, this message translates to:
  /// **'Protect your account'**
  String get recoveryAttemptsTitle;

  /// No description provided for @recoveryAttemptsBody.
  ///
  /// In en, this message translates to:
  /// **'For your protection, {attempts} incorrect verification attempts will temporarily lock your credentials for {minutes} minutes.'**
  String recoveryAttemptsBody(Object attempts, Object minutes);

  /// No description provided for @recoveryStage.
  ///
  /// In en, this message translates to:
  /// **'Authentication Stage {stage}'**
  String recoveryStage(Object stage);

  /// No description provided for @recoveryNoCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get recoveryNoCode;

  /// No description provided for @recoveryResendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get recoveryResendCode;

  /// No description provided for @recoveryResendIn.
  ///
  /// In en, this message translates to:
  /// **'(available in'**
  String get recoveryResendIn;

  /// No description provided for @recoveryDifferentMethod.
  ///
  /// In en, this message translates to:
  /// **'Try a different recovery method'**
  String get recoveryDifferentMethod;

  /// No description provided for @recoveryCancelAndReturn.
  ///
  /// In en, this message translates to:
  /// **'Cancel and return to sign in'**
  String get recoveryCancelAndReturn;

  /// No description provided for @recoveryResetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get recoveryResetPasswordTitle;

  /// No description provided for @recoveryNewPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a new password that satisfies the institutional policy below.'**
  String get recoveryNewPasswordSubtitle;

  /// No description provided for @recoveryNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get recoveryNewPasswordLabel;

  /// No description provided for @recoveryNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get recoveryNewPasswordHint;

  /// No description provided for @recoveryConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get recoveryConfirmPassword;

  /// No description provided for @recoveryConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Repeat new password'**
  String get recoveryConfirmPasswordHint;

  /// No description provided for @recoveryPolicyRequirement.
  ///
  /// In en, this message translates to:
  /// **'Institutional Policy Requirement'**
  String get recoveryPolicyRequirement;

  /// No description provided for @recoveryPolicyCompliant.
  ///
  /// In en, this message translates to:
  /// **'Policy Compliant'**
  String get recoveryPolicyCompliant;

  /// No description provided for @recoveryStrengthCompliant.
  ///
  /// In en, this message translates to:
  /// **'Policy Compliant'**
  String get recoveryStrengthCompliant;

  /// No description provided for @recoveryStrengthProgress.
  ///
  /// In en, this message translates to:
  /// **'Policy {met} of {total}'**
  String recoveryStrengthProgress(Object met, Object total);

  /// No description provided for @recoveryRequirementLength.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get recoveryRequirementLength;

  /// No description provided for @recoveryRequirementUppercase.
  ///
  /// In en, this message translates to:
  /// **'Contains at least one uppercase letter'**
  String get recoveryRequirementUppercase;

  /// No description provided for @recoveryRequirementNumber.
  ///
  /// In en, this message translates to:
  /// **'Contains at least one number'**
  String get recoveryRequirementNumber;

  /// No description provided for @recoveryRequirementSpecial.
  ///
  /// In en, this message translates to:
  /// **'Contains at least one special character (!@#\$%^&*)'**
  String get recoveryRequirementSpecial;

  /// No description provided for @recoveryPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'The passwords do not match.'**
  String get recoveryPasswordMismatch;

  /// No description provided for @recoveryPasswordPolicyError.
  ///
  /// In en, this message translates to:
  /// **'Choose a password that satisfies every institutional requirement.'**
  String get recoveryPasswordPolicyError;

  /// No description provided for @recoveryTerminateSessions.
  ///
  /// In en, this message translates to:
  /// **'Sign out of all other active browser sessions and devices'**
  String get recoveryTerminateSessions;

  /// No description provided for @recoveryUpdatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get recoveryUpdatePassword;

  /// No description provided for @recoveryImmediateEffect.
  ///
  /// In en, this message translates to:
  /// **'Your new password will take effect immediately across all university portals, including Course Registration and Bursary.'**
  String get recoveryImmediateEffect;

  /// No description provided for @recoverySuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get recoverySuccessTitle;

  /// No description provided for @recoverySuccessBody.
  ///
  /// In en, this message translates to:
  /// **'Your institutional security credentials have been updated{revocation}.'**
  String recoverySuccessBody(Object revocation);

  /// No description provided for @recoveryAuditSummary.
  ///
  /// In en, this message translates to:
  /// **'Official Audit Summary'**
  String get recoveryAuditSummary;

  /// No description provided for @recoveryStatusCommitted.
  ///
  /// In en, this message translates to:
  /// **'STATUS: COMMITTED'**
  String get recoveryStatusCommitted;

  /// No description provided for @recoveryAuditAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get recoveryAuditAccount;

  /// No description provided for @recoveryAuditEmail.
  ///
  /// In en, this message translates to:
  /// **'Primary Email'**
  String get recoveryAuditEmail;

  /// No description provided for @recoveryAuditTimestamp.
  ///
  /// In en, this message translates to:
  /// **'Timestamp'**
  String get recoveryAuditTimestamp;

  /// No description provided for @recoveryAuditHash.
  ///
  /// In en, this message translates to:
  /// **'Security Audit Hash'**
  String get recoveryAuditHash;

  /// No description provided for @recoveryAuditSessions.
  ///
  /// In en, this message translates to:
  /// **'Active Sessions'**
  String get recoveryAuditSessions;

  /// No description provided for @recoverySessionsRevoked.
  ///
  /// In en, this message translates to:
  /// **'Revoked on all other devices (1 device authorized)'**
  String get recoverySessionsRevoked;

  /// No description provided for @recoverySessionsKept.
  ///
  /// In en, this message translates to:
  /// **'Other sessions remain active (1 device authorized)'**
  String get recoverySessionsKept;

  /// No description provided for @recoveryAdvisoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Institutional Advisory Notice'**
  String get recoveryAdvisoryTitle;

  /// No description provided for @recoveryAdvisoryBody.
  ///
  /// In en, this message translates to:
  /// **'A cryptographic notification has been logged to your university inbox. If you did not authorize this change, freeze your account immediately via the Emergency Registry Hotline ({hotline}).'**
  String recoveryAdvisoryBody(Object hotline);

  /// No description provided for @recoverySignInWithNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Sign in with new password'**
  String get recoverySignInWithNewPassword;

  /// No description provided for @recoveryAuditGuidelines.
  ///
  /// In en, this message translates to:
  /// **'View security audit guidelines'**
  String get recoveryAuditGuidelines;

  /// No description provided for @navOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get navOverview;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Hub'**
  String get homeTitle;

  /// No description provided for @homeHubTitle.
  ///
  /// In en, this message translates to:
  /// **'The Legion Hub'**
  String get homeHubTitle;

  /// No description provided for @homeMenuTooltip.
  ///
  /// In en, this message translates to:
  /// **'Open navigation menu'**
  String get homeMenuTooltip;

  /// No description provided for @homeNotificationsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get homeNotificationsTooltip;

  /// No description provided for @homeCurrentTerm.
  ///
  /// In en, this message translates to:
  /// **'Current Term'**
  String get homeCurrentTerm;

  /// No description provided for @homeDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'days left'**
  String get homeDaysLeft;

  /// No description provided for @homeTermInProgress.
  ///
  /// In en, this message translates to:
  /// **'Term in progress'**
  String get homeTermInProgress;

  /// No description provided for @homeTermEndsOn.
  ///
  /// In en, this message translates to:
  /// **'Ends {date}'**
  String homeTermEndsOn(Object date);

  /// No description provided for @homeDoThisNext.
  ///
  /// In en, this message translates to:
  /// **'Do this next'**
  String get homeDoThisNext;

  /// No description provided for @homeSequentialFlow.
  ///
  /// In en, this message translates to:
  /// **'Sequential priority flow'**
  String get homeSequentialFlow;

  /// No description provided for @homeStepActionable.
  ///
  /// In en, this message translates to:
  /// **'Actionable'**
  String get homeStepActionable;

  /// No description provided for @homeStepBlocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get homeStepBlocked;

  /// No description provided for @homeStepWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get homeStepWaiting;

  /// No description provided for @homeStepDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get homeStepDone;

  /// No description provided for @homeDueOn.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String homeDueOn(Object date);

  /// No description provided for @homeEverythingElse.
  ///
  /// In en, this message translates to:
  /// **'Everything else'**
  String get homeEverythingElse;

  /// No description provided for @homeModuleCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Module} other{{count} Modules}}'**
  String homeModuleCount(num count);

  /// No description provided for @homeModuleRows.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 module} other{{count} modules}}'**
  String homeModuleRows(num count);

  /// No description provided for @homeAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get homeAnnouncements;

  /// No description provided for @homeSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get homeSeeAll;

  /// No description provided for @homeReadMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get homeReadMore;

  /// No description provided for @homeCategoryUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get homeCategoryUrgent;

  /// No description provided for @homeCategoryNotice.
  ///
  /// In en, this message translates to:
  /// **'Notice'**
  String get homeCategoryNotice;

  /// No description provided for @homeCategoryInformation.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get homeCategoryInformation;

  /// No description provided for @homeAccountServices.
  ///
  /// In en, this message translates to:
  /// **'Account & Services'**
  String get homeAccountServices;

  /// No description provided for @homeQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get homeQuickActions;

  /// No description provided for @homeSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get homeSignOut;

  /// No description provided for @homeSignOutBody.
  ///
  /// In en, this message translates to:
  /// **'You will need your institutional matriculation email and portal password to sign back in.'**
  String get homeSignOutBody;

  /// No description provided for @homeDiagnosticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Build diagnostics'**
  String get homeDiagnosticsTitle;

  /// No description provided for @homeEnvironmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get homeEnvironmentLabel;

  /// No description provided for @homeApiBaseUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'API base URL'**
  String get homeApiBaseUrlLabel;

  /// No description provided for @homeNetworkLoggingLabel.
  ///
  /// In en, this message translates to:
  /// **'Network logging'**
  String get homeNetworkLoggingLabel;

  /// No description provided for @homeViewportLabel.
  ///
  /// In en, this message translates to:
  /// **'Viewport'**
  String get homeViewportLabel;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileSignedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as'**
  String get profileSignedInAs;

  /// No description provided for @profileMemberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since'**
  String get profileMemberSince;

  /// No description provided for @profileSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get profileSignOut;

  /// No description provided for @profileNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Profile details are unavailable.'**
  String get profileNotAvailable;

  /// No description provided for @routeNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get routeNotFoundTitle;

  /// No description provided for @routeNotFoundBody.
  ///
  /// In en, this message translates to:
  /// **'The page you requested does not exist or has moved.'**
  String get routeNotFoundBody;

  /// No description provided for @routeErrorBackHome.
  ///
  /// In en, this message translates to:
  /// **'Back to overview'**
  String get routeErrorBackHome;

  /// No description provided for @admissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Admissions'**
  String get admissionsTitle;

  /// No description provided for @admissionsApplicantLabel.
  ///
  /// In en, this message translates to:
  /// **'Applicant'**
  String get admissionsApplicantLabel;

  /// No description provided for @admissionsGreeting.
  ///
  /// In en, this message translates to:
  /// **'{greeting}, {name}'**
  String admissionsGreeting(Object greeting, Object name);

  /// No description provided for @admissionsConfirmEmailBody.
  ///
  /// In en, this message translates to:
  /// **'Confirm your email address ({email}) to submit applications and claim a JAMB result.'**
  String admissionsConfirmEmailBody(Object email);

  /// No description provided for @admissionsConfirmEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Confirmation link sent. Check your inbox.'**
  String get admissionsConfirmEmailSent;

  /// No description provided for @admissionsResendLink.
  ///
  /// In en, this message translates to:
  /// **'Resend link'**
  String get admissionsResendLink;

  /// No description provided for @admissionsResendingLink.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get admissionsResendingLink;

  /// No description provided for @admissionsYourApplications.
  ///
  /// In en, this message translates to:
  /// **'Your applications'**
  String get admissionsYourApplications;

  /// No description provided for @admissionsApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get admissionsApply;

  /// No description provided for @admissionsNoApplicationsTitle.
  ///
  /// In en, this message translates to:
  /// **'No applications yet'**
  String get admissionsNoApplicationsTitle;

  /// No description provided for @admissionsNoApplicationsBody.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 admission cycle is open. Browse programmes to apply.} other{{count} admission cycles are open. Browse programmes to apply.}}'**
  String admissionsNoApplicationsBody(num count);

  /// No description provided for @admissionsBrowseProgrammes.
  ///
  /// In en, this message translates to:
  /// **'Browse programmes'**
  String get admissionsBrowseProgrammes;

  /// No description provided for @admissionsApplicationsTitle.
  ///
  /// In en, this message translates to:
  /// **'My applications'**
  String get admissionsApplicationsTitle;

  /// No description provided for @admissionsNewApplication.
  ///
  /// In en, this message translates to:
  /// **'New application'**
  String get admissionsNewApplication;

  /// No description provided for @admissionsSecondChoice.
  ///
  /// In en, this message translates to:
  /// **'Second choice: {programme}'**
  String admissionsSecondChoice(Object programme);

  /// No description provided for @admissionsRespondBy.
  ///
  /// In en, this message translates to:
  /// **'Respond by {date}'**
  String admissionsRespondBy(Object date);

  /// No description provided for @admissionsUpdatedOn.
  ///
  /// In en, this message translates to:
  /// **'Updated {date}'**
  String admissionsUpdatedOn(Object date);

  /// No description provided for @admissionsMatriculation.
  ///
  /// In en, this message translates to:
  /// **'Matriculation'**
  String get admissionsMatriculation;

  /// No description provided for @admissionsOpenStudentPortal.
  ///
  /// In en, this message translates to:
  /// **'Open the student portal'**
  String get admissionsOpenStudentPortal;

  /// No description provided for @admissionsCycleClosedNote.
  ///
  /// In en, this message translates to:
  /// **'Admissions for this cycle closed on {date}.'**
  String admissionsCycleClosedNote(Object date);

  /// No description provided for @admissionsAgeJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get admissionsAgeJustNow;

  /// No description provided for @admissionsAgeMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute ago} other{{count} minutes ago}}'**
  String admissionsAgeMinutes(num count);

  /// No description provided for @admissionsAgeHours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour ago} other{{count} hours ago}}'**
  String admissionsAgeHours(num count);

  /// No description provided for @admissionsJambTag.
  ///
  /// In en, this message translates to:
  /// **'JAMB CAPS Import'**
  String get admissionsJambTag;

  /// No description provided for @admissionsJambTitle.
  ///
  /// In en, this message translates to:
  /// **'You chose us in JAMB'**
  String get admissionsJambTitle;

  /// No description provided for @admissionsJambBody.
  ///
  /// In en, this message translates to:
  /// **'Your result is waiting. Claim it to add it to your records and start an application.'**
  String get admissionsJambBody;

  /// No description provided for @admissionsClaimResult.
  ///
  /// In en, this message translates to:
  /// **'Claim your result'**
  String get admissionsClaimResult;

  /// No description provided for @admissionsAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get admissionsAnnouncements;

  /// No description provided for @admissionsSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get admissionsSeeAll;

  /// No description provided for @admissionsReadMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get admissionsReadMore;

  /// No description provided for @admissionsStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get admissionsStatusDraft;

  /// No description provided for @admissionsStatusSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get admissionsStatusSubmitted;

  /// No description provided for @admissionsStatusUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Under review'**
  String get admissionsStatusUnderReview;

  /// No description provided for @admissionsStatusOffered.
  ///
  /// In en, this message translates to:
  /// **'Admission offered'**
  String get admissionsStatusOffered;

  /// No description provided for @admissionsStatusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Offer accepted'**
  String get admissionsStatusAccepted;

  /// No description provided for @admissionsStatusDeclined.
  ///
  /// In en, this message translates to:
  /// **'Offer declined'**
  String get admissionsStatusDeclined;

  /// No description provided for @admissionsStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get admissionsStatusRejected;

  /// No description provided for @admissionsStatusWithdrawn.
  ///
  /// In en, this message translates to:
  /// **'Withdrawn'**
  String get admissionsStatusWithdrawn;

  /// No description provided for @admissionsStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Offer expired'**
  String get admissionsStatusExpired;

  /// No description provided for @admissionsStatusMatriculated.
  ///
  /// In en, this message translates to:
  /// **'Matriculated'**
  String get admissionsStatusMatriculated;

  /// No description provided for @admissionsTabOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get admissionsTabOverview;

  /// No description provided for @admissionsTabProgrammes.
  ///
  /// In en, this message translates to:
  /// **'Programmes'**
  String get admissionsTabProgrammes;

  /// No description provided for @admissionsTabApplications.
  ///
  /// In en, this message translates to:
  /// **'Applications'**
  String get admissionsTabApplications;

  /// No description provided for @admissionsTabJamb.
  ///
  /// In en, this message translates to:
  /// **'JAMB'**
  String get admissionsTabJamb;

  /// No description provided for @homeUnreadCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 unread} other{{count} unread}}'**
  String homeUnreadCount(num count);

  /// No description provided for @homeNoNotifications.
  ///
  /// In en, this message translates to:
  /// **'You are all caught up.'**
  String get homeNoNotifications;

  /// No description provided for @homeBackAgainToExit.
  ///
  /// In en, this message translates to:
  /// **'Press back again to exit'**
  String get homeBackAgainToExit;

  /// No description provided for @admissionsBackTooltip.
  ///
  /// In en, this message translates to:
  /// **'Back to the hub'**
  String get admissionsBackTooltip;

  /// No description provided for @admissionsProgrammesTitle.
  ///
  /// In en, this message translates to:
  /// **'Programmes'**
  String get admissionsProgrammesTitle;

  /// No description provided for @admissionsProgrammesAvailable.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 available} other{{count} available}}'**
  String admissionsProgrammesAvailable(num count);

  /// No description provided for @admissionsProgrammesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore degree programmes and check your eligibility before applying.'**
  String get admissionsProgrammesSubtitle;

  /// No description provided for @admissionsProgrammesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search programmes, faculties or course codes…'**
  String get admissionsProgrammesSearchHint;

  /// No description provided for @admissionsProgrammesNoResults.
  ///
  /// In en, this message translates to:
  /// **'No programme matches “{query}”. Try a course code, a faculty, or clear the search.'**
  String admissionsProgrammesNoResults(Object query);

  /// No description provided for @admissionsProgrammesNoResultsFaculty.
  ///
  /// In en, this message translates to:
  /// **'There is no programme in {faculty} in this cycle.'**
  String admissionsProgrammesNoResultsFaculty(Object faculty);

  /// No description provided for @admissionsProgrammesNoResultsAll.
  ///
  /// In en, this message translates to:
  /// **'There is no programme in this cycle.'**
  String get admissionsProgrammesNoResultsAll;

  /// No description provided for @admissionsProgrammesSwitchCycle.
  ///
  /// In en, this message translates to:
  /// **'Switch cycle'**
  String get admissionsProgrammesSwitchCycle;

  /// No description provided for @admissionsProgrammesCyclePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Admissions cycles'**
  String get admissionsProgrammesCyclePickerTitle;

  /// No description provided for @admissionsProgrammesCyclePickerBody.
  ///
  /// In en, this message translates to:
  /// **'Choose the cycle you want to see deadlines and fees for.'**
  String get admissionsProgrammesCyclePickerBody;

  /// No description provided for @admissionsProgrammesCycleCloses.
  ///
  /// In en, this message translates to:
  /// **'Closes {date}'**
  String admissionsProgrammesCycleCloses(Object date);

  /// No description provided for @admissionsProgrammesCycleClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed {date}'**
  String admissionsProgrammesCycleClosed(Object date);

  /// No description provided for @admissionsProgrammeFormFee.
  ///
  /// In en, this message translates to:
  /// **'Form fee'**
  String get admissionsProgrammeFormFee;

  /// No description provided for @admissionsProgrammeDuration.
  ///
  /// In en, this message translates to:
  /// **'{years, plural, =1{1 year} other{{years} years}}'**
  String admissionsProgrammeDuration(num years);

  /// No description provided for @admissionsProgrammeClosedOn.
  ///
  /// In en, this message translates to:
  /// **'Closed on {date}'**
  String admissionsProgrammeClosedOn(Object date);

  /// No description provided for @admissionsProgrammeDeadlineAhead.
  ///
  /// In en, this message translates to:
  /// **'Applications close {date}, ahead of the cycle'**
  String admissionsProgrammeDeadlineAhead(Object date);

  /// No description provided for @admissionsProgrammeAdmissionsActive.
  ///
  /// In en, this message translates to:
  /// **'Admissions active'**
  String get admissionsProgrammeAdmissionsActive;

  /// No description provided for @admissionsProgrammeClosesIn.
  ///
  /// In en, this message translates to:
  /// **'Closes in {count, plural, =1{1 day} other{{count} days}}'**
  String admissionsProgrammeClosesIn(num count);

  /// No description provided for @admissionsProgrammeArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived session'**
  String get admissionsProgrammeArchived;

  /// No description provided for @admissionsProgrammeApply.
  ///
  /// In en, this message translates to:
  /// **'View programme & apply'**
  String get admissionsProgrammeApply;

  /// No description provided for @admissionsProgrammeViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get admissionsProgrammeViewDetails;

  /// No description provided for @admissionsVerdictEligible.
  ///
  /// In en, this message translates to:
  /// **'You meet the requirements'**
  String get admissionsVerdictEligible;

  /// No description provided for @admissionsVerdictNeedsChecking.
  ///
  /// In en, this message translates to:
  /// **'Some requirements need checking'**
  String get admissionsVerdictNeedsChecking;

  /// No description provided for @admissionsVerdictNotEligible.
  ///
  /// In en, this message translates to:
  /// **'You don’t yet meet the requirements'**
  String get admissionsVerdictNotEligible;

  /// No description provided for @admissionsVerdictClosed.
  ///
  /// In en, this message translates to:
  /// **'Applications have closed'**
  String get admissionsVerdictClosed;

  /// No description provided for @admissionsVerdictClosedSummary.
  ///
  /// In en, this message translates to:
  /// **'Applications closed for the current session. The quota is full.'**
  String get admissionsVerdictClosedSummary;

  /// No description provided for @admissionsFacultyScience.
  ///
  /// In en, this message translates to:
  /// **'Science'**
  String get admissionsFacultyScience;

  /// No description provided for @admissionsFacultyArts.
  ///
  /// In en, this message translates to:
  /// **'Arts'**
  String get admissionsFacultyArts;

  /// No description provided for @admissionsFacultyLaw.
  ///
  /// In en, this message translates to:
  /// **'Law'**
  String get admissionsFacultyLaw;

  /// No description provided for @admissionsFacultyEngineering.
  ///
  /// In en, this message translates to:
  /// **'Engineering'**
  String get admissionsFacultyEngineering;

  /// No description provided for @admissionsFacultyFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All faculties ({count})'**
  String admissionsFacultyFilterAll(Object count);

  /// No description provided for @admissionsStudyModeUndergraduate.
  ///
  /// In en, this message translates to:
  /// **'Full-time undergraduate'**
  String get admissionsStudyModeUndergraduate;

  /// No description provided for @admissionsStudyModeDirectEntry.
  ///
  /// In en, this message translates to:
  /// **'Direct Entry / Full-time'**
  String get admissionsStudyModeDirectEntry;

  /// No description provided for @admissionsFacultyFilterNamed.
  ///
  /// In en, this message translates to:
  /// **'{faculty} ({count})'**
  String admissionsFacultyFilterNamed(Object count, Object faculty);

  /// No description provided for @admissionsDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get admissionsDetailTitle;

  /// No description provided for @admissionsDetailCaption.
  ///
  /// In en, this message translates to:
  /// **'Application detail'**
  String get admissionsDetailCaption;

  /// No description provided for @admissionsDetailBackTooltip.
  ///
  /// In en, this message translates to:
  /// **'Back to my applications'**
  String get admissionsDetailBackTooltip;

  /// No description provided for @admissionsDetailSubmitBy.
  ///
  /// In en, this message translates to:
  /// **'Submit by {date}, {time}'**
  String admissionsDetailSubmitBy(Object date, Object time);

  /// No description provided for @admissionsDetailNotFound.
  ///
  /// In en, this message translates to:
  /// **'This application is no longer on your record.'**
  String get admissionsDetailNotFound;

  /// No description provided for @admissionsChecklistTitle.
  ///
  /// In en, this message translates to:
  /// **'Before you submit'**
  String get admissionsChecklistTitle;

  /// No description provided for @admissionsChecklistSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete each item, then come back to submit.'**
  String get admissionsChecklistSubtitle;

  /// No description provided for @admissionsChecklistProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get admissionsChecklistProgress;

  /// No description provided for @admissionsChecklistProgressValue.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} complete'**
  String admissionsChecklistProgressValue(Object done, Object total);

  /// No description provided for @admissionsChecklistEmailDetail.
  ///
  /// In en, this message translates to:
  /// **'Open the confirmation link we emailed to {email}.'**
  String admissionsChecklistEmailDetail(Object email);

  /// No description provided for @admissionsNotTracked.
  ///
  /// In en, this message translates to:
  /// **'Not tracked'**
  String get admissionsNotTracked;

  /// No description provided for @admissionsChecklistResendEmail.
  ///
  /// In en, this message translates to:
  /// **'Resend confirmation email'**
  String get admissionsChecklistResendEmail;

  /// No description provided for @admissionsChecklistResendNote.
  ///
  /// In en, this message translates to:
  /// **'We send one every time you ask. Check your spam folder.'**
  String get admissionsChecklistResendNote;

  /// No description provided for @admissionsChecklistActionResend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get admissionsChecklistActionResend;

  /// No description provided for @admissionsChecklistActionComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get admissionsChecklistActionComplete;

  /// No description provided for @admissionsChecklistActionClaim.
  ///
  /// In en, this message translates to:
  /// **'Claim'**
  String get admissionsChecklistActionClaim;

  /// No description provided for @admissionsChecklistActionUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get admissionsChecklistActionUpload;

  /// No description provided for @admissionsChecklistActionInvite.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get admissionsChecklistActionInvite;

  /// No description provided for @admissionsChecklistActionCheck.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get admissionsChecklistActionCheck;

  /// No description provided for @admissionsChoicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Programme choices'**
  String get admissionsChoicesTitle;

  /// No description provided for @admissionsChoicesFirstLabel.
  ///
  /// In en, this message translates to:
  /// **'First choice *'**
  String get admissionsChoicesFirstLabel;

  /// No description provided for @admissionsChoicesSecondLabel.
  ///
  /// In en, this message translates to:
  /// **'Second choice'**
  String get admissionsChoicesSecondLabel;

  /// No description provided for @admissionsChoicesOptional.
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get admissionsChoicesOptional;

  /// No description provided for @admissionsChoicesNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get admissionsChoicesNone;

  /// No description provided for @admissionsChoicesFee.
  ///
  /// In en, this message translates to:
  /// **'Form fee for your first choice:'**
  String get admissionsChoicesFee;

  /// No description provided for @admissionsChoicesSave.
  ///
  /// In en, this message translates to:
  /// **'Save choices'**
  String get admissionsChoicesSave;

  /// No description provided for @admissionsRefereesTitle.
  ///
  /// In en, this message translates to:
  /// **'Referees'**
  String get admissionsRefereesTitle;

  /// No description provided for @admissionsRefereesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'At least 2 required. Each receives an emailed link to a short confidential form.'**
  String get admissionsRefereesSubtitle;

  /// No description provided for @admissionsRefereeAwaiting.
  ///
  /// In en, this message translates to:
  /// **'Awaiting'**
  String get admissionsRefereeAwaiting;

  /// No description provided for @admissionsRefereeResend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get admissionsRefereeResend;

  /// No description provided for @admissionsRefereeRemoveTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove referee'**
  String get admissionsRefereeRemoveTooltip;

  /// No description provided for @admissionsRefereeInviteTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite a referee'**
  String get admissionsRefereeInviteTitle;

  /// No description provided for @admissionsRefereeInviteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'They get a link by email. They never see your application.'**
  String get admissionsRefereeInviteSubtitle;

  /// No description provided for @admissionsRefereeNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name *'**
  String get admissionsRefereeNameLabel;

  /// No description provided for @admissionsRefereeEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email *'**
  String get admissionsRefereeEmailLabel;

  /// No description provided for @admissionsRefereePhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone (optional)'**
  String get admissionsRefereePhoneLabel;

  /// No description provided for @admissionsRefereeOccupationLabel.
  ///
  /// In en, this message translates to:
  /// **'Occupation (optional)'**
  String get admissionsRefereeOccupationLabel;

  /// No description provided for @admissionsRefereeNameHint.
  ///
  /// In en, this message translates to:
  /// **'Dr/Prof Full Name'**
  String get admissionsRefereeNameHint;

  /// No description provided for @admissionsRefereeEmailHint.
  ///
  /// In en, this message translates to:
  /// **'official.email@institution.edu.ng'**
  String get admissionsRefereeEmailHint;

  /// No description provided for @admissionsRefereePhoneHint.
  ///
  /// In en, this message translates to:
  /// **'+234...'**
  String get admissionsRefereePhoneHint;

  /// No description provided for @admissionsRefereeOccupationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Senior Lecturer, ABU Zaria'**
  String get admissionsRefereeOccupationHint;

  /// No description provided for @admissionsRefereeSend.
  ///
  /// In en, this message translates to:
  /// **'Send invitation'**
  String get admissionsRefereeSend;

  /// No description provided for @admissionsSubmitTitle.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get admissionsSubmitTitle;

  /// No description provided for @admissionsSubmitDeclaration.
  ///
  /// In en, this message translates to:
  /// **'I confirm that the information in my application and records is true and complete. I understand that false information will lead to my admission being withdrawn.'**
  String get admissionsSubmitDeclaration;

  /// No description provided for @admissionsSubmitAction.
  ///
  /// In en, this message translates to:
  /// **'Submit application'**
  String get admissionsSubmitAction;

  /// No description provided for @admissionsSubmitBlocked.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Complete the checklist first. 1 item is outstanding} other{Complete the checklist first. {count} items are outstanding}}'**
  String admissionsSubmitBlocked(num count);

  /// No description provided for @admissionsSubmitNeedsDeclaration.
  ///
  /// In en, this message translates to:
  /// **'Tick the confirmation above to submit.'**
  String get admissionsSubmitNeedsDeclaration;

  /// No description provided for @admissionsHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get admissionsHistoryTitle;

  /// No description provided for @admissionsHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Append-only record'**
  String get admissionsHistorySubtitle;

  /// No description provided for @admissionsWithdrawAction.
  ///
  /// In en, this message translates to:
  /// **'Withdraw application'**
  String get admissionsWithdrawAction;

  /// No description provided for @admissionsWithdrawTitle.
  ///
  /// In en, this message translates to:
  /// **'Withdraw this application?'**
  String get admissionsWithdrawTitle;

  /// No description provided for @admissionsWithdrawBody.
  ///
  /// In en, this message translates to:
  /// **'The application is closed for good and cannot be reopened. You can start another while the cycle is still open.'**
  String get admissionsWithdrawBody;

  /// No description provided for @admissionsDepartmentInFaculty.
  ///
  /// In en, this message translates to:
  /// **'{department}, Faculty of {faculty}'**
  String admissionsDepartmentInFaculty(Object department, Object faculty);

  /// No description provided for @admissionsFacultyAndMode.
  ///
  /// In en, this message translates to:
  /// **'Faculty of {faculty} • {mode}'**
  String admissionsFacultyAndMode(Object faculty, Object mode);

  /// No description provided for @admissionsOfferLetter.
  ///
  /// In en, this message translates to:
  /// **'Admission letter'**
  String get admissionsOfferLetter;

  /// No description provided for @admissionsOfferEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Admission offered'**
  String get admissionsOfferEyebrow;

  /// No description provided for @admissionsOfferLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get admissionsOfferLevel;

  /// No description provided for @admissionsOfferLevelValue.
  ///
  /// In en, this message translates to:
  /// **'{level} Level'**
  String admissionsOfferLevelValue(Object level);

  /// No description provided for @admissionsOfferSession.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get admissionsOfferSession;

  /// No description provided for @admissionsOfferFormFee.
  ///
  /// In en, this message translates to:
  /// **'Form fee'**
  String get admissionsOfferFormFee;

  /// No description provided for @admissionsOfferFormFeePaid.
  ///
  /// In en, this message translates to:
  /// **'(paid {date})'**
  String admissionsOfferFormFeePaid(Object date);

  /// No description provided for @admissionsOfferAcceptanceFee.
  ///
  /// In en, this message translates to:
  /// **'Acceptance fee'**
  String get admissionsOfferAcceptanceFee;

  /// No description provided for @admissionsOfferAcceptanceFeeDue.
  ///
  /// In en, this message translates to:
  /// **'(due after you accept)'**
  String get admissionsOfferAcceptanceFeeDue;

  /// No description provided for @admissionsOfferAcceptBy.
  ///
  /// In en, this message translates to:
  /// **'Accept by {date}'**
  String admissionsOfferAcceptBy(Object date);

  /// No description provided for @admissionsOfferAcceptByNote.
  ///
  /// In en, this message translates to:
  /// **'After that date the offer lapses and the place is offered to somebody else.'**
  String get admissionsOfferAcceptByNote;

  /// No description provided for @admissionsOfferCondition.
  ///
  /// In en, this message translates to:
  /// **'You accept on this page. You then pay the acceptance fee of {fee} under Payments. The registry then issues your matric number.'**
  String admissionsOfferCondition(Object fee);

  /// No description provided for @admissionsOfferAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept offer'**
  String get admissionsOfferAccept;

  /// No description provided for @admissionsOfferReadLetter.
  ///
  /// In en, this message translates to:
  /// **'Read the admission letter first'**
  String get admissionsOfferReadLetter;

  /// No description provided for @admissionsOfferDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline offer'**
  String get admissionsOfferDecline;

  /// No description provided for @admissionsDecisionContext.
  ///
  /// In en, this message translates to:
  /// **'Candidate portal • Final decision'**
  String get admissionsDecisionContext;

  /// No description provided for @admissionsDecisionCycleChip.
  ///
  /// In en, this message translates to:
  /// **'Cycle {session}'**
  String admissionsDecisionCycleChip(Object session);

  /// No description provided for @admissionsDecisionUnsuccessful.
  ///
  /// In en, this message translates to:
  /// **'Admission unsuccessful'**
  String get admissionsDecisionUnsuccessful;

  /// No description provided for @admissionsDecisionProgrammeApplied.
  ///
  /// In en, this message translates to:
  /// **'Programme applied'**
  String get admissionsDecisionProgrammeApplied;

  /// No description provided for @admissionsDecisionReference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get admissionsDecisionReference;

  /// No description provided for @admissionsDecisionSubmittedOn.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get admissionsDecisionSubmittedOn;

  /// No description provided for @admissionsDecisionDecidedOn.
  ///
  /// In en, this message translates to:
  /// **'Decision date'**
  String get admissionsDecisionDecidedOn;

  /// No description provided for @admissionsDecisionDateTime.
  ///
  /// In en, this message translates to:
  /// **'{date} • {time}'**
  String admissionsDecisionDateTime(Object date, Object time);

  /// No description provided for @admissionsDecisionFindingTitle.
  ///
  /// In en, this message translates to:
  /// **'Official admissions committee finding'**
  String get admissionsDecisionFindingTitle;

  /// No description provided for @admissionsDecisionFindingBody.
  ///
  /// In en, this message translates to:
  /// **'The Central Admissions Committee of The Legion, having evaluated all verified credentials for the {cycle} exercise, regrets to communicate that your application has not been recommended for matriculation.'**
  String admissionsDecisionFindingBody(Object cycle);

  /// No description provided for @admissionsDecisionDeterminationLabel.
  ///
  /// In en, this message translates to:
  /// **'Primary determination'**
  String get admissionsDecisionDeterminationLabel;

  /// No description provided for @admissionsAuditTitle.
  ///
  /// In en, this message translates to:
  /// **'Departmental metric audit'**
  String get admissionsAuditTitle;

  /// No description provided for @admissionsAuditCaption.
  ///
  /// In en, this message translates to:
  /// **'Statutory minimums'**
  String get admissionsAuditCaption;

  /// No description provided for @admissionsAuditSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get admissionsAuditSubmitted;

  /// No description provided for @admissionsAuditRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get admissionsAuditRequired;

  /// No description provided for @admissionsCriterionUtme.
  ///
  /// In en, this message translates to:
  /// **'UTME composite score'**
  String get admissionsCriterionUtme;

  /// No description provided for @admissionsCriterionOlevelEnglish.
  ///
  /// In en, this message translates to:
  /// **'O\'level English literature'**
  String get admissionsCriterionOlevelEnglish;

  /// No description provided for @admissionsCriterionDirectEntry.
  ///
  /// In en, this message translates to:
  /// **'Direct entry accreditation'**
  String get admissionsCriterionDirectEntry;

  /// No description provided for @admissionsOutcomeMet.
  ///
  /// In en, this message translates to:
  /// **'Met'**
  String get admissionsOutcomeMet;

  /// No description provided for @admissionsOutcomeBelowCutoff.
  ///
  /// In en, this message translates to:
  /// **'Below cutoff'**
  String get admissionsOutcomeBelowCutoff;

  /// No description provided for @admissionsOutcomeDeficit.
  ///
  /// In en, this message translates to:
  /// **'Deficit'**
  String get admissionsOutcomeDeficit;

  /// No description provided for @admissionsOutcomeIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Incomplete'**
  String get admissionsOutcomeIncomplete;

  /// No description provided for @admissionsAttestationEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Attestation and record'**
  String get admissionsAttestationEyebrow;

  /// No description provided for @admissionsAttestationOffice.
  ///
  /// In en, this message translates to:
  /// **'Office of the Registrar'**
  String get admissionsAttestationOffice;

  /// No description provided for @admissionsAttestationDirectorate.
  ///
  /// In en, this message translates to:
  /// **'Admissions Directorate • The Legion'**
  String get admissionsAttestationDirectorate;

  /// No description provided for @admissionsAttestationHash.
  ///
  /// In en, this message translates to:
  /// **'Verification hash'**
  String get admissionsAttestationHash;

  /// No description provided for @admissionsAttestationImmutable.
  ///
  /// In en, this message translates to:
  /// **'Immutable'**
  String get admissionsAttestationImmutable;

  /// No description provided for @admissionsAttestationConclusive.
  ///
  /// In en, this message translates to:
  /// **'Decisions pronounced by the Central Admissions Board are conclusive for the specified academic year. Re-evaluation within the {cycle} exercise is closed.'**
  String admissionsAttestationConclusive(Object cycle);

  /// No description provided for @admissionsNextCycleHeadline.
  ///
  /// In en, this message translates to:
  /// **'Applications are open'**
  String get admissionsNextCycleHeadline;

  /// No description provided for @admissionsNextCycleBody.
  ///
  /// In en, this message translates to:
  /// **'You may submit a fresh profile for the forthcoming academic session, explore alternative departments, or address credential requirements.'**
  String get admissionsNextCycleBody;

  /// No description provided for @admissionsStartNewApplication.
  ///
  /// In en, this message translates to:
  /// **'Start a new application'**
  String get admissionsStartNewApplication;

  /// No description provided for @admissionsDownloadDecisionNotice.
  ///
  /// In en, this message translates to:
  /// **'Download the decision notice (PDF)'**
  String get admissionsDownloadDecisionNotice;

  /// No description provided for @admissionsInquiriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Administrative inquiries'**
  String get admissionsInquiriesTitle;

  /// No description provided for @admissionsReturnToApplications.
  ///
  /// In en, this message translates to:
  /// **'Return to my applications'**
  String get admissionsReturnToApplications;

  /// No description provided for @admissionsHelpDesk.
  ///
  /// In en, this message translates to:
  /// **'Admissions help desk'**
  String get admissionsHelpDesk;

  /// No description provided for @admissionsMatriculatedTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re matriculated'**
  String get admissionsMatriculatedTitle;

  /// No description provided for @admissionsMatriculatedUse.
  ///
  /// In en, this message translates to:
  /// **'Use it in all correspondence with the university.'**
  String get admissionsMatriculatedUse;

  /// No description provided for @admissionsMatriculatedComplete.
  ///
  /// In en, this message translates to:
  /// **'Your admission is complete. Your student portal is open.'**
  String get admissionsMatriculatedComplete;

  /// No description provided for @admissionsMatriculatedDownloadLetter.
  ///
  /// In en, this message translates to:
  /// **'Download your admission letter'**
  String get admissionsMatriculatedDownloadLetter;

  /// No description provided for @admissionsExpiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Offer expired'**
  String get admissionsExpiredTitle;

  /// No description provided for @admissionsExpiredBody.
  ///
  /// In en, this message translates to:
  /// **'The offer of {programme} expired on {date}.'**
  String admissionsExpiredBody(Object date, Object programme);

  /// No description provided for @admissionsExpiredNote.
  ///
  /// In en, this message translates to:
  /// **'The place has been offered to somebody else. Your application and records stay on your account, and you can apply again in the next cycle.'**
  String get admissionsExpiredNote;

  /// No description provided for @admissionsWithdrawnTitle.
  ///
  /// In en, this message translates to:
  /// **'Application withdrawn'**
  String get admissionsWithdrawnTitle;

  /// No description provided for @admissionsWithdrawnBody.
  ///
  /// In en, this message translates to:
  /// **'You withdrew this application on {date}.'**
  String admissionsWithdrawnBody(Object date);

  /// No description provided for @admissionsWithdrawnReason.
  ///
  /// In en, this message translates to:
  /// **'“Reason: {reason}”'**
  String admissionsWithdrawnReason(Object reason);

  /// No description provided for @admissionsWithdrawnNote.
  ///
  /// In en, this message translates to:
  /// **'You can start a new application in any open cycle.'**
  String get admissionsWithdrawnNote;

  /// No description provided for @admissionsClosedRejectedTitle.
  ///
  /// In en, this message translates to:
  /// **'Application not successful'**
  String get admissionsClosedRejectedTitle;

  /// No description provided for @admissionsClosedRejectedBody.
  ///
  /// In en, this message translates to:
  /// **'Your application to {programme} was not successful in this round.'**
  String admissionsClosedRejectedBody(Object programme);

  /// No description provided for @admissionsClosedRejectedNote.
  ///
  /// In en, this message translates to:
  /// **'You are welcome to apply again in the next cycle, and your records and documents stay on your account.'**
  String get admissionsClosedRejectedNote;

  /// No description provided for @admissionsLetterCaption.
  ///
  /// In en, this message translates to:
  /// **'Admission letter'**
  String get admissionsLetterCaption;

  /// No description provided for @admissionsLetterBackTooltip.
  ///
  /// In en, this message translates to:
  /// **'Back to the application'**
  String get admissionsLetterBackTooltip;

  /// No description provided for @admissionsLetterSavePdf.
  ///
  /// In en, this message translates to:
  /// **'Save PDF'**
  String get admissionsLetterSavePdf;

  /// No description provided for @admissionsLetterShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get admissionsLetterShare;

  /// No description provided for @admissionsLetterCopyCode.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get admissionsLetterCopyCode;

  /// No description provided for @admissionsLetterCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Verification code copied'**
  String get admissionsLetterCodeCopied;

  /// No description provided for @admissionsLetterKeepNote.
  ///
  /// In en, this message translates to:
  /// **'Keep this letter. It is the document a landlord or employer will ask to see.'**
  String get admissionsLetterKeepNote;

  /// No description provided for @admissionsLetterNotIssued.
  ///
  /// In en, this message translates to:
  /// **'No letter has been issued for this application.'**
  String get admissionsLetterNotIssued;

  /// No description provided for @admissionsLetterUniversity.
  ///
  /// In en, this message translates to:
  /// **'The Legion University'**
  String get admissionsLetterUniversity;

  /// No description provided for @admissionsLetterOffice.
  ///
  /// In en, this message translates to:
  /// **'Office of the Registrar | Admissions'**
  String get admissionsLetterOffice;

  /// No description provided for @admissionsLetterRef.
  ///
  /// In en, this message translates to:
  /// **'Ref:'**
  String get admissionsLetterRef;

  /// No description provided for @admissionsLetterDate.
  ///
  /// In en, this message translates to:
  /// **'Date:'**
  String get admissionsLetterDate;

  /// No description provided for @admissionsLetterScanToVerify.
  ///
  /// In en, this message translates to:
  /// **'Scan to verify'**
  String get admissionsLetterScanToVerify;

  /// No description provided for @admissionsLetterHeadline.
  ///
  /// In en, this message translates to:
  /// **'Offer of provisional admission: {session} session'**
  String admissionsLetterHeadline(Object session);

  /// No description provided for @admissionsLetterBody.
  ///
  /// In en, this message translates to:
  /// **'I am pleased to inform you that you have been offered provisional admission to study for the award of {programme} in the {department}, Faculty of {faculty}, entering at {level} Level, for the {session} academic session.'**
  String admissionsLetterBody(
    Object department,
    Object faculty,
    Object level,
    Object programme,
    Object session,
  );

  /// No description provided for @admissionsLetterBodyNoFaculty.
  ///
  /// In en, this message translates to:
  /// **'I am pleased to inform you that you have been offered provisional admission to study for the award of {programme} in the {department}, entering at {level} Level, for the {session} academic session.'**
  String admissionsLetterBodyNoFaculty(
    Object department,
    Object level,
    Object programme,
    Object session,
  );

  /// No description provided for @admissionsLetterConditionsIntro.
  ///
  /// In en, this message translates to:
  /// **'This offer is subject to the following conditions:'**
  String get admissionsLetterConditionsIntro;

  /// No description provided for @admissionsLetterConditionNumber.
  ///
  /// In en, this message translates to:
  /// **'{index}.'**
  String admissionsLetterConditionNumber(Object index);

  /// No description provided for @admissionsLetterConditionAccept.
  ///
  /// In en, this message translates to:
  /// **'You accept the offer on the admissions portal by {date}.'**
  String admissionsLetterConditionAccept(Object date);

  /// No description provided for @admissionsLetterConditionFee.
  ///
  /// In en, this message translates to:
  /// **'You pay the acceptance fee of {fee}.'**
  String admissionsLetterConditionFee(Object fee);

  /// No description provided for @admissionsLetterConditionCredentials.
  ///
  /// In en, this message translates to:
  /// **'The originals of your credentials are verified at registration. The offer will be withdrawn if any information you supplied proves false.'**
  String get admissionsLetterConditionCredentials;

  /// No description provided for @admissionsLetterConditionRules.
  ///
  /// In en, this message translates to:
  /// **'You meet the requirements for {programme} and abide by the rules and regulations of the university.'**
  String admissionsLetterConditionRules(Object programme);

  /// No description provided for @admissionsLetterClosing.
  ///
  /// In en, this message translates to:
  /// **'Please accept my congratulations.'**
  String get admissionsLetterClosing;

  /// No description provided for @admissionsLetterVerifyPrefix.
  ///
  /// In en, this message translates to:
  /// **'Verify this letter at'**
  String get admissionsLetterVerifyPrefix;

  /// No description provided for @admissionsLetterVerifyWithCode.
  ///
  /// In en, this message translates to:
  /// **'with code'**
  String get admissionsLetterVerifyWithCode;

  /// No description provided for @admissionsLetterVerifySuffix.
  ///
  /// In en, this message translates to:
  /// **', or scan the QR code.'**
  String get admissionsLetterVerifySuffix;

  /// No description provided for @admissionsVerifyBrandCaption.
  ///
  /// In en, this message translates to:
  /// **'Admissions verification'**
  String get admissionsVerifyBrandCaption;

  /// No description provided for @admissionsVerifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify an admission'**
  String get admissionsVerifyTitle;

  /// No description provided for @admissionsVerifySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code printed at the foot of the admission letter.'**
  String get admissionsVerifySubtitle;

  /// No description provided for @admissionsVerifyCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get admissionsVerifyCodeLabel;

  /// No description provided for @admissionsVerifyCodeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 7KQ2M9XW4HPA'**
  String get admissionsVerifyCodeHint;

  /// No description provided for @admissionsVerifyAction.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get admissionsVerifyAction;

  /// No description provided for @admissionsVerifyGenuine.
  ///
  /// In en, this message translates to:
  /// **'Genuine admission'**
  String get admissionsVerifyGenuine;

  /// No description provided for @admissionsVerifyName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get admissionsVerifyName;

  /// No description provided for @admissionsVerifyProgramme.
  ///
  /// In en, this message translates to:
  /// **'Programme'**
  String get admissionsVerifyProgramme;

  /// No description provided for @admissionsVerifyLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get admissionsVerifyLevel;

  /// No description provided for @admissionsVerifySession.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get admissionsVerifySession;

  /// No description provided for @admissionsVerifyStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get admissionsVerifyStatus;

  /// No description provided for @admissionsVerifyMatricNumber.
  ///
  /// In en, this message translates to:
  /// **'Matric number'**
  String get admissionsVerifyMatricNumber;

  /// No description provided for @admissionsVerifyIssuedOn.
  ///
  /// In en, this message translates to:
  /// **'Offered on'**
  String get admissionsVerifyIssuedOn;

  /// No description provided for @admissionsVerifyNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'No admission matches this code'**
  String get admissionsVerifyNotFoundTitle;

  /// No description provided for @admissionsVerifyNotFoundBody.
  ///
  /// In en, this message translates to:
  /// **'Check the code at the foot of the letter and try again. If it still does not match, the letter was not issued by the university.'**
  String get admissionsVerifyNotFoundBody;

  /// No description provided for @admissionsVerifyPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'This page shows only what is printed on the letter.'**
  String get admissionsVerifyPrivacyNote;

  /// No description provided for @admissionsVerifySignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in to the portal'**
  String get admissionsVerifySignIn;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

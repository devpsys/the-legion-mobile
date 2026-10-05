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

  /// No description provided for @navFees.
  ///
  /// In en, this message translates to:
  /// **'Fees'**
  String get navFees;

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

  /// No description provided for @admissionsProgrammeAlreadyApplied.
  ///
  /// In en, this message translates to:
  /// **'Already applied this cycle'**
  String get admissionsProgrammeAlreadyApplied;

  /// No description provided for @admissionsProgrammeApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
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

  /// No description provided for @admissionsStudyModeDiploma.
  ///
  /// In en, this message translates to:
  /// **'Full-time diploma'**
  String get admissionsStudyModeDiploma;

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

  /// No description provided for @admissionsJambEyebrow.
  ///
  /// In en, this message translates to:
  /// **'CAPS result import'**
  String get admissionsJambEyebrow;

  /// No description provided for @admissionsJambHeading.
  ///
  /// In en, this message translates to:
  /// **'Claim your JAMB result'**
  String get admissionsJambHeading;

  /// No description provided for @admissionsJambIntro.
  ///
  /// In en, this message translates to:
  /// **'The Legion University receives official examination results directly from the Joint Admissions and Matriculation Board (JAMB) Central Admissions Processing System (CAPS). Match your record to link your score to your application.'**
  String get admissionsJambIntro;

  /// No description provided for @admissionsJambRegistrationLabel.
  ///
  /// In en, this message translates to:
  /// **'JAMB registration number'**
  String get admissionsJambRegistrationLabel;

  /// No description provided for @admissionsJambRegistrationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 202630112233AB'**
  String get admissionsJambRegistrationHint;

  /// No description provided for @admissionsJambRegistrationHelper.
  ///
  /// In en, this message translates to:
  /// **'12-digit number followed by 2 letters, as printed on your JAMB slip.'**
  String get admissionsJambRegistrationHelper;

  /// No description provided for @admissionsJambSurnameLabel.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get admissionsJambSurnameLabel;

  /// No description provided for @admissionsJambSurnameHint.
  ///
  /// In en, this message translates to:
  /// **'As on your JAMB slip'**
  String get admissionsJambSurnameHint;

  /// No description provided for @admissionsJambSurnameHelper.
  ///
  /// In en, this message translates to:
  /// **'Must match exactly as registered with JAMB.'**
  String get admissionsJambSurnameHelper;

  /// No description provided for @admissionsJambDateOfBirthLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get admissionsJambDateOfBirthLabel;

  /// No description provided for @admissionsJambDateOfBirthHint.
  ///
  /// In en, this message translates to:
  /// **'DD / MM / YYYY'**
  String get admissionsJambDateOfBirthHint;

  /// No description provided for @admissionsJambDateOfBirthHelper.
  ///
  /// In en, this message translates to:
  /// **'Used to verify you are the legitimate candidate.'**
  String get admissionsJambDateOfBirthHelper;

  /// No description provided for @admissionsJambDateOfBirthPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Your date of birth'**
  String get admissionsJambDateOfBirthPickerTitle;

  /// No description provided for @admissionsJambPermanentWarning.
  ///
  /// In en, this message translates to:
  /// **'Check your registration number carefully. Linking a JAMB result is permanent and cannot be undone from the portal.'**
  String get admissionsJambPermanentWarning;

  /// No description provided for @admissionsJambFindAction.
  ///
  /// In en, this message translates to:
  /// **'Find my result'**
  String get admissionsJambFindAction;

  /// No description provided for @admissionsJambMatching.
  ///
  /// In en, this message translates to:
  /// **'Checking CAPS'**
  String get admissionsJambMatching;

  /// No description provided for @admissionsJambConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Confirm and link result'**
  String get admissionsJambConfirmAction;

  /// No description provided for @admissionsJambHelpLink.
  ///
  /// In en, this message translates to:
  /// **'Need help claiming? Contact admissions registry'**
  String get admissionsJambHelpLink;

  /// No description provided for @admissionsJambRecordEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Verification status'**
  String get admissionsJambRecordEyebrow;

  /// No description provided for @admissionsJambRecordTitle.
  ///
  /// In en, this message translates to:
  /// **'Official CAPS record'**
  String get admissionsJambRecordTitle;

  /// No description provided for @admissionsJambRecordFound.
  ///
  /// In en, this message translates to:
  /// **'Record found'**
  String get admissionsJambRecordFound;

  /// No description provided for @admissionsJambRecordLinked.
  ///
  /// In en, this message translates to:
  /// **'Linked'**
  String get admissionsJambRecordLinked;

  /// No description provided for @admissionsJambCandidate.
  ///
  /// In en, this message translates to:
  /// **'Candidate'**
  String get admissionsJambCandidate;

  /// No description provided for @admissionsJambExaminationYear.
  ///
  /// In en, this message translates to:
  /// **'Examination year'**
  String get admissionsJambExaminationYear;

  /// No description provided for @admissionsJambExaminationValue.
  ///
  /// In en, this message translates to:
  /// **'{year} UTME'**
  String admissionsJambExaminationValue(Object year);

  /// No description provided for @admissionsJambAggregate.
  ///
  /// In en, this message translates to:
  /// **'Aggregate score'**
  String get admissionsJambAggregate;

  /// No description provided for @admissionsJambSubjects.
  ///
  /// In en, this message translates to:
  /// **'Subject breakdown'**
  String get admissionsJambSubjects;

  /// No description provided for @admissionsJambBindingNotice.
  ///
  /// In en, this message translates to:
  /// **'This record will be permanently linked to {reference}.'**
  String admissionsJambBindingNotice(Object reference);

  /// No description provided for @admissionsJambLinkedNotice.
  ///
  /// In en, this message translates to:
  /// **'This record is permanently linked to {reference}.'**
  String admissionsJambLinkedNotice(Object reference);

  /// No description provided for @admissionsJambLinkedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your JAMB result is now on your record.'**
  String get admissionsJambLinkedMessage;

  /// No description provided for @admissionsJambNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'No record matches these details'**
  String get admissionsJambNotFoundTitle;

  /// No description provided for @admissionsJambNotFoundBody.
  ///
  /// In en, this message translates to:
  /// **'Check the registration number, surname and date of birth against your JAMB slip and try again. If they are right and it still does not match, CAPS has not sent us your result yet.'**
  String get admissionsJambNotFoundBody;

  /// No description provided for @feesInstitution.
  ///
  /// In en, this message translates to:
  /// **'The Legion University'**
  String get feesInstitution;

  /// No description provided for @feesBackTooltip.
  ///
  /// In en, this message translates to:
  /// **'Back to the hub'**
  String get feesBackTooltip;

  /// No description provided for @feesEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Bursary & Financial Services'**
  String get feesEyebrow;

  /// No description provided for @feesTitle.
  ///
  /// In en, this message translates to:
  /// **'Student fees'**
  String get feesTitle;

  /// No description provided for @feesStudentLine.
  ///
  /// In en, this message translates to:
  /// **'{name} · {matricNumber} · {level}'**
  String feesStudentLine(Object level, Object matricNumber, Object name);

  /// No description provided for @feesLevel.
  ///
  /// In en, this message translates to:
  /// **'{level} Level'**
  String feesLevel(Object level);

  /// No description provided for @feesOutstandingLabel.
  ///
  /// In en, this message translates to:
  /// **'Total outstanding balance'**
  String get feesOutstandingLabel;

  /// No description provided for @feesDueOn.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String feesDueOn(Object date);

  /// No description provided for @feesNothingOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Nothing is owed on your account.'**
  String get feesNothingOutstanding;

  /// No description provided for @feesPayOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Pay outstanding ({amount})'**
  String feesPayOutstanding(Object amount);

  /// No description provided for @feesPaymentChannelsNote.
  ///
  /// In en, this message translates to:
  /// **'Bank transfer, card and Remita RRR are supported, with instant bursary clearance.'**
  String get feesPaymentChannelsNote;

  /// No description provided for @feesInvoicesHeading.
  ///
  /// In en, this message translates to:
  /// **'{session} invoices'**
  String feesInvoicesHeading(Object session);

  /// No description provided for @feesPendingCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{All settled} =1{1 pending} other{{count} pending}}'**
  String feesPendingCount(num count);

  /// No description provided for @feesNoInvoices.
  ///
  /// In en, this message translates to:
  /// **'No invoices have been raised for this session.'**
  String get feesNoInvoices;

  /// No description provided for @feesStatusUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get feesStatusUnpaid;

  /// No description provided for @feesStatusPartPaid.
  ///
  /// In en, this message translates to:
  /// **'Part paid'**
  String get feesStatusPartPaid;

  /// No description provided for @feesStatusSettled.
  ///
  /// In en, this message translates to:
  /// **'Settled'**
  String get feesStatusSettled;

  /// No description provided for @feesStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get feesStatusCancelled;

  /// No description provided for @feesTotalBilled.
  ///
  /// In en, this message translates to:
  /// **'Total billed'**
  String get feesTotalBilled;

  /// No description provided for @feesAmountCleared.
  ///
  /// In en, this message translates to:
  /// **'Amount cleared'**
  String get feesAmountCleared;

  /// No description provided for @feesRemainingBalance.
  ///
  /// In en, this message translates to:
  /// **'Remaining balance'**
  String get feesRemainingBalance;

  /// No description provided for @feesPaymentProgress.
  ///
  /// In en, this message translates to:
  /// **'Payment progress'**
  String get feesPaymentProgress;

  /// No description provided for @feesPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String feesPercent(Object percent);

  /// No description provided for @feesPayBalance.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount}'**
  String feesPayBalance(Object amount);

  /// No description provided for @feesPayAmount.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount}'**
  String feesPayAmount(Object amount);

  /// No description provided for @feesBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Breakdown'**
  String get feesBreakdown;

  /// No description provided for @feesAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get feesAmount;

  /// No description provided for @feesHistoryHeading.
  ///
  /// In en, this message translates to:
  /// **'Payment history & receipts'**
  String get feesHistoryHeading;

  /// No description provided for @feesViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get feesViewAll;

  /// No description provided for @feesNoPayments.
  ///
  /// In en, this message translates to:
  /// **'No payments have been recorded yet.'**
  String get feesNoPayments;

  /// No description provided for @feesPaymentSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Successful'**
  String get feesPaymentSuccessful;

  /// No description provided for @feesPaymentPending.
  ///
  /// In en, this message translates to:
  /// **'Awaiting confirmation'**
  String get feesPaymentPending;

  /// No description provided for @feesPaymentLine.
  ///
  /// In en, this message translates to:
  /// **'{date} · {channel}'**
  String feesPaymentLine(Object channel, Object date);

  /// No description provided for @feesChannelCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get feesChannelCard;

  /// No description provided for @feesChannelRemitaRrr.
  ///
  /// In en, this message translates to:
  /// **'Remita RRR'**
  String get feesChannelRemitaRrr;

  /// No description provided for @feesChannelWithReference.
  ///
  /// In en, this message translates to:
  /// **'{channel} {reference}'**
  String feesChannelWithReference(Object channel, Object reference);

  /// No description provided for @feesReceiptPdf.
  ///
  /// In en, this message translates to:
  /// **'Receipt PDF'**
  String get feesReceiptPdf;

  /// No description provided for @feesBursaryNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Institutional bursary notice:'**
  String get feesBursaryNoticeTitle;

  /// No description provided for @feesBursaryNoticeBody.
  ///
  /// In en, this message translates to:
  /// **'All official payments must be validated with an official university bursary receipt bearing a cryptographic QR code. Cash payments to staff are strictly prohibited.'**
  String get feesBursaryNoticeBody;

  /// No description provided for @feesCheckoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Make payment'**
  String get feesCheckoutTitle;

  /// No description provided for @feesCheckoutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Official bursary payment gateway · The Legion University'**
  String get feesCheckoutSubtitle;

  /// No description provided for @feesCheckoutBackTooltip.
  ///
  /// In en, this message translates to:
  /// **'Back to your fees'**
  String get feesCheckoutBackTooltip;

  /// No description provided for @feesSecure.
  ///
  /// In en, this message translates to:
  /// **'Secure'**
  String get feesSecure;

  /// No description provided for @feesPaymentDetails.
  ///
  /// In en, this message translates to:
  /// **'Payment details'**
  String get feesPaymentDetails;

  /// No description provided for @feesTerm.
  ///
  /// In en, this message translates to:
  /// **'Term: {session}'**
  String feesTerm(Object session);

  /// No description provided for @feesInvoiceReference.
  ///
  /// In en, this message translates to:
  /// **'Invoice reference'**
  String get feesInvoiceReference;

  /// No description provided for @feesDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get feesDescription;

  /// No description provided for @feesGatewayCharge.
  ///
  /// In en, this message translates to:
  /// **'Gateway processing charge (statutory)'**
  String get feesGatewayCharge;

  /// No description provided for @feesGatewayChargeInfo.
  ///
  /// In en, this message translates to:
  /// **'A statutory charge collected by the payment gateway, not by the university.'**
  String get feesGatewayChargeInfo;

  /// No description provided for @feesTotalPayable.
  ///
  /// In en, this message translates to:
  /// **'Total amount payable'**
  String get feesTotalPayable;

  /// No description provided for @feesTotalPayableNote.
  ///
  /// In en, this message translates to:
  /// **'Includes statutory automated clearing fees'**
  String get feesTotalPayableNote;

  /// No description provided for @feesSelectAmount.
  ///
  /// In en, this message translates to:
  /// **'Select payment amount'**
  String get feesSelectAmount;

  /// No description provided for @feesPayFull.
  ///
  /// In en, this message translates to:
  /// **'Pay full balance'**
  String get feesPayFull;

  /// No description provided for @feesPayFullDetail.
  ///
  /// In en, this message translates to:
  /// **'Clears your course enrolment hold immediately'**
  String get feesPayFullDetail;

  /// No description provided for @feesPayInstalment.
  ///
  /// In en, this message translates to:
  /// **'Pay a custom instalment'**
  String get feesPayInstalment;

  /// No description provided for @feesMinimumInstalment.
  ///
  /// In en, this message translates to:
  /// **'Minimum permitted instalment: {amount}'**
  String feesMinimumInstalment(Object amount);

  /// No description provided for @feesSpecifiedAmount.
  ///
  /// In en, this message translates to:
  /// **'Specified payment amount'**
  String get feesSpecifiedAmount;

  /// No description provided for @feesInstalmentMissing.
  ///
  /// In en, this message translates to:
  /// **'Enter the amount you want to pay.'**
  String get feesInstalmentMissing;

  /// No description provided for @feesInstalmentBelowMinimum.
  ///
  /// In en, this message translates to:
  /// **'Enter at least {amount}.'**
  String feesInstalmentBelowMinimum(Object amount);

  /// No description provided for @feesInstalmentAboveBalance.
  ///
  /// In en, this message translates to:
  /// **'Enter no more than {amount}, the balance owed.'**
  String feesInstalmentAboveBalance(Object amount);

  /// No description provided for @feesPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get feesPaymentMethod;

  /// No description provided for @feesVerifiedIntegrations.
  ///
  /// In en, this message translates to:
  /// **'Verified integrations'**
  String get feesVerifiedIntegrations;

  /// No description provided for @feesMethodGateway.
  ///
  /// In en, this message translates to:
  /// **'Card & instant bank transfer'**
  String get feesMethodGateway;

  /// No description provided for @feesMethodGatewayDetail.
  ///
  /// In en, this message translates to:
  /// **'Remita & Interswitch secure gateway. Automated clearance within 60 seconds.'**
  String get feesMethodGatewayDetail;

  /// No description provided for @feesMethodInstant.
  ///
  /// In en, this message translates to:
  /// **'Instant'**
  String get feesMethodInstant;

  /// No description provided for @feesMethodBankBranch.
  ///
  /// In en, this message translates to:
  /// **'Bank branch via RRR invoice'**
  String get feesMethodBankBranch;

  /// No description provided for @feesMethodBankBranchClearing.
  ///
  /// In en, this message translates to:
  /// **'1–24h clearing'**
  String get feesMethodBankBranchClearing;

  /// No description provided for @feesMethodBankBranchDetail.
  ///
  /// In en, this message translates to:
  /// **'Pay at any commercial bank branch across Nigeria using your active reference.'**
  String get feesMethodBankBranchDetail;

  /// No description provided for @feesRrrLabel.
  ///
  /// In en, this message translates to:
  /// **'RRR: {reference}'**
  String feesRrrLabel(Object reference);

  /// No description provided for @feesCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get feesCopy;

  /// No description provided for @feesReferenceCopied.
  ///
  /// In en, this message translates to:
  /// **'Reference copied.'**
  String get feesReferenceCopied;

  /// No description provided for @feesMethodVirtualAccount.
  ///
  /// In en, this message translates to:
  /// **'NIP dedicated student virtual account'**
  String get feesMethodVirtualAccount;

  /// No description provided for @feesMethodVirtualAccountDetail.
  ///
  /// In en, this message translates to:
  /// **'Single-use account generated specifically for matric {matricNumber}.'**
  String feesMethodVirtualAccountDetail(Object matricNumber);

  /// No description provided for @feesChipDebitCard.
  ///
  /// In en, this message translates to:
  /// **'Debit card'**
  String get feesChipDebitCard;

  /// No description provided for @feesChipUssd.
  ///
  /// In en, this message translates to:
  /// **'USSD'**
  String get feesChipUssd;

  /// No description provided for @feesChipDirectDebit.
  ///
  /// In en, this message translates to:
  /// **'Direct debit'**
  String get feesChipDirectDebit;

  /// No description provided for @feesPayerVerification.
  ///
  /// In en, this message translates to:
  /// **'Payer verification'**
  String get feesPayerVerification;

  /// No description provided for @feesVerifiedRecord.
  ///
  /// In en, this message translates to:
  /// **'Verified record'**
  String get feesVerifiedRecord;

  /// No description provided for @feesStudentName.
  ///
  /// In en, this message translates to:
  /// **'Student name'**
  String get feesStudentName;

  /// No description provided for @feesMatricNumber.
  ///
  /// In en, this message translates to:
  /// **'Matriculation number'**
  String get feesMatricNumber;

  /// No description provided for @feesDepartment.
  ///
  /// In en, this message translates to:
  /// **'Academic department'**
  String get feesDepartment;

  /// No description provided for @feesDepartmentValue.
  ///
  /// In en, this message translates to:
  /// **'{department} ({level})'**
  String feesDepartmentValue(Object department, Object level);

  /// No description provided for @feesEmail.
  ///
  /// In en, this message translates to:
  /// **'Institutional email'**
  String get feesEmail;

  /// No description provided for @feesProceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed to pay'**
  String get feesProceed;

  /// No description provided for @feesProceedToPay.
  ///
  /// In en, this message translates to:
  /// **'Proceed to pay {amount}'**
  String feesProceedToPay(Object amount);

  /// No description provided for @feesProceedNote.
  ///
  /// In en, this message translates to:
  /// **'Encrypted 256-bit TLS connection. Your payment updates your student portal and unlocks course registration immediately.'**
  String get feesProceedNote;

  /// No description provided for @feesCheckoutNothingToPay.
  ///
  /// In en, this message translates to:
  /// **'There is nothing to pay on these invoices.'**
  String get feesCheckoutNothingToPay;

  /// No description provided for @feesCardCheckoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Card checkout'**
  String get feesCardCheckoutTitle;

  /// No description provided for @feesCardCheckoutEyebrow.
  ///
  /// In en, this message translates to:
  /// **'The Legion · Bursary gateway'**
  String get feesCardCheckoutEyebrow;

  /// No description provided for @feesCardCheckoutBackTooltip.
  ///
  /// In en, this message translates to:
  /// **'Back to payment details'**
  String get feesCardCheckoutBackTooltip;

  /// No description provided for @feesPciCompliant.
  ///
  /// In en, this message translates to:
  /// **'PCI-DSS compliant'**
  String get feesPciCompliant;

  /// No description provided for @feesFeeBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Fee breakdown'**
  String get feesFeeBreakdown;

  /// No description provided for @feesItemisedSchedule.
  ///
  /// In en, this message translates to:
  /// **'Itemised schedule'**
  String get feesItemisedSchedule;

  /// No description provided for @feesSecurePayment.
  ///
  /// In en, this message translates to:
  /// **'Secure payment'**
  String get feesSecurePayment;

  /// No description provided for @feesTlsActive.
  ///
  /// In en, this message translates to:
  /// **'TLS 1.3 active'**
  String get feesTlsActive;

  /// No description provided for @feesSecurePaymentNote.
  ///
  /// In en, this message translates to:
  /// **'256-bit TLS encrypted sovereign bursary settlement.'**
  String get feesSecurePaymentNote;

  /// No description provided for @feesSupportedNetworks.
  ///
  /// In en, this message translates to:
  /// **'Supported networks'**
  String get feesSupportedNetworks;

  /// No description provided for @feesNetworkMastercard.
  ///
  /// In en, this message translates to:
  /// **'Mastercard'**
  String get feesNetworkMastercard;

  /// No description provided for @feesNetworkVerve.
  ///
  /// In en, this message translates to:
  /// **'Verve'**
  String get feesNetworkVerve;

  /// No description provided for @feesNetworkVisa.
  ///
  /// In en, this message translates to:
  /// **'Visa'**
  String get feesNetworkVisa;

  /// No description provided for @feesCardInformation.
  ///
  /// In en, this message translates to:
  /// **'Card information'**
  String get feesCardInformation;

  /// No description provided for @feesCardInformationDetail.
  ///
  /// In en, this message translates to:
  /// **'Enter your debit or credit card details below to complete your academic fee settlement.'**
  String get feesCardInformationDetail;

  /// No description provided for @feesCardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card number'**
  String get feesCardNumber;

  /// No description provided for @feesCardNumberHint.
  ///
  /// In en, this message translates to:
  /// **'ACCT-000003'**
  String get feesCardNumberHint;

  /// No description provided for @feesCardExpiry.
  ///
  /// In en, this message translates to:
  /// **'Expiry date'**
  String get feesCardExpiry;

  /// No description provided for @feesCardExpiryHint.
  ///
  /// In en, this message translates to:
  /// **'MM/YY'**
  String get feesCardExpiryHint;

  /// No description provided for @feesCardCvv.
  ///
  /// In en, this message translates to:
  /// **'CVV / Security code'**
  String get feesCardCvv;

  /// No description provided for @feesCardCvvHint.
  ///
  /// In en, this message translates to:
  /// **'123'**
  String get feesCardCvvHint;

  /// No description provided for @feesCardCvvHelp.
  ///
  /// In en, this message translates to:
  /// **'3 digits'**
  String get feesCardCvvHelp;

  /// No description provided for @feesCardPin.
  ///
  /// In en, this message translates to:
  /// **'Card PIN'**
  String get feesCardPin;

  /// No description provided for @feesCardPinHint.
  ///
  /// In en, this message translates to:
  /// **'••••'**
  String get feesCardPinHint;

  /// No description provided for @feesCardPinNote.
  ///
  /// In en, this message translates to:
  /// **'Required to authorise domestic debit cards via Interswitch / NIBSS before 3D-Secure verification.'**
  String get feesCardPinNote;

  /// No description provided for @feesSaveCard.
  ///
  /// In en, this message translates to:
  /// **'Save card for future session payments'**
  String get feesSaveCard;

  /// No description provided for @feesCardTokenNote.
  ///
  /// In en, this message translates to:
  /// **'Card details are encrypted and tokenised according to CBN regulatory standards.'**
  String get feesCardTokenNote;

  /// No description provided for @feesPayAmountAction.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount}'**
  String feesPayAmountAction(Object amount);

  /// No description provided for @feesPayRedirectNote.
  ///
  /// In en, this message translates to:
  /// **'You will be redirected to your bank\'s 3D-Secure authentication screen.'**
  String get feesPayRedirectNote;

  /// No description provided for @feesCancelToFees.
  ///
  /// In en, this message translates to:
  /// **'Cancel and return to fees'**
  String get feesCancelToFees;

  /// No description provided for @feesCbnLicensed.
  ///
  /// In en, this message translates to:
  /// **'Central Bank of Nigeria licensed PSP'**
  String get feesCbnLicensed;

  /// No description provided for @feesEndToEndEncryption.
  ///
  /// In en, this message translates to:
  /// **'End-to-end encryption'**
  String get feesEndToEndEncryption;

  /// No description provided for @feesTransactionReference.
  ///
  /// In en, this message translates to:
  /// **'Transaction reference: {reference}'**
  String feesTransactionReference(Object reference);

  /// No description provided for @feesGatewayReturnBackTooltip.
  ///
  /// In en, this message translates to:
  /// **'Back to fees'**
  String get feesGatewayReturnBackTooltip;

  /// No description provided for @feesGatewayReturnShareTooltip.
  ///
  /// In en, this message translates to:
  /// **'Share receipt'**
  String get feesGatewayReturnShareTooltip;

  /// No description provided for @feesGatewayStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Awaiting confirmation'**
  String get feesGatewayStatusPending;

  /// No description provided for @feesGatewayStatusSucceeded.
  ///
  /// In en, this message translates to:
  /// **'Payment successful'**
  String get feesGatewayStatusSucceeded;

  /// No description provided for @feesGatewayStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment failed'**
  String get feesGatewayStatusFailed;

  /// No description provided for @feesGatewayStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Payment expired'**
  String get feesGatewayStatusExpired;

  /// No description provided for @feesGatewayPendingDetail.
  ///
  /// In en, this message translates to:
  /// **'The gateway has not confirmed this payment yet. You can close this page. Your reference is kept below.'**
  String get feesGatewayPendingDetail;

  /// No description provided for @feesGatewaySucceededDetail.
  ///
  /// In en, this message translates to:
  /// **'Remita settlement confirmed · {date}'**
  String feesGatewaySucceededDetail(Object date);

  /// No description provided for @feesGatewayFailedDetail.
  ///
  /// In en, this message translates to:
  /// **'The gateway declined this attempt. No money was taken. Try again from your fees.'**
  String get feesGatewayFailedDetail;

  /// No description provided for @feesGatewayExpiredDetail.
  ///
  /// In en, this message translates to:
  /// **'This payment window closed before the gateway answered. No money was taken.'**
  String get feesGatewayExpiredDetail;

  /// No description provided for @feesGatewayYouCanClose.
  ///
  /// In en, this message translates to:
  /// **'You can close this page.'**
  String get feesGatewayYouCanClose;

  /// No description provided for @feesCoursePortalUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Course portal unlocked'**
  String get feesCoursePortalUnlocked;

  /// No description provided for @feesCoursePortalActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get feesCoursePortalActive;

  /// No description provided for @feesCoursePortalDetail.
  ///
  /// In en, this message translates to:
  /// **'Harmattan semester registration clearance is now linked to your academic dossier.'**
  String get feesCoursePortalDetail;

  /// No description provided for @feesRemitaRrr.
  ///
  /// In en, this message translates to:
  /// **'Remita RRR'**
  String get feesRemitaRrr;

  /// No description provided for @feesGatewayReference.
  ///
  /// In en, this message translates to:
  /// **'Gateway reference'**
  String get feesGatewayReference;

  /// No description provided for @feesPaymentChannel.
  ///
  /// In en, this message translates to:
  /// **'Payment channel'**
  String get feesPaymentChannel;

  /// No description provided for @feesPaidFor.
  ///
  /// In en, this message translates to:
  /// **'Paid for'**
  String get feesPaidFor;

  /// No description provided for @feesViewOfficialReceipt.
  ///
  /// In en, this message translates to:
  /// **'View official receipt'**
  String get feesViewOfficialReceipt;

  /// No description provided for @feesProceedToRegistration.
  ///
  /// In en, this message translates to:
  /// **'Proceed to course registration'**
  String get feesProceedToRegistration;

  /// No description provided for @feesGatewayVerifiedStamp.
  ///
  /// In en, this message translates to:
  /// **'Cryptographically verified by The Legion Treasury'**
  String get feesGatewayVerifiedStamp;

  /// No description provided for @feesGatewaySupport.
  ///
  /// In en, this message translates to:
  /// **'Support inquiries: bursary@thelegion.edu.ng'**
  String get feesGatewaySupport;

  /// No description provided for @feesGatewayReturnNotFound.
  ///
  /// In en, this message translates to:
  /// **'No payment matches this reference.'**
  String get feesGatewayReturnNotFound;

  /// No description provided for @feesReceiptBackTooltip.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get feesReceiptBackTooltip;

  /// No description provided for @feesReceiptTitle.
  ///
  /// In en, this message translates to:
  /// **'Clearance receipt {number}'**
  String feesReceiptTitle(Object number);

  /// No description provided for @feesReceiptVerifiedCleared.
  ///
  /// In en, this message translates to:
  /// **'Verified & cleared'**
  String get feesReceiptVerifiedCleared;

  /// No description provided for @feesReceiptKeepNote.
  ///
  /// In en, this message translates to:
  /// **'Keep this receipt for your exam docket, hostel clearance and any bursary enquiry.'**
  String get feesReceiptKeepNote;

  /// No description provided for @feesReceiptSavePdf.
  ///
  /// In en, this message translates to:
  /// **'Print or save as PDF'**
  String get feesReceiptSavePdf;

  /// No description provided for @feesReceiptShare.
  ///
  /// In en, this message translates to:
  /// **'Share receipt'**
  String get feesReceiptShare;

  /// No description provided for @feesReceiptCopyCode.
  ///
  /// In en, this message translates to:
  /// **'Copy verification code'**
  String get feesReceiptCopyCode;

  /// No description provided for @feesReceiptCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Verification code copied.'**
  String get feesReceiptCodeCopied;

  /// No description provided for @feesReceiptOffice.
  ///
  /// In en, this message translates to:
  /// **'Office of the Bursar'**
  String get feesReceiptOffice;

  /// No description provided for @feesReceiptUnit.
  ///
  /// In en, this message translates to:
  /// **'FIS & Treasury verification unit'**
  String get feesReceiptUnit;

  /// No description provided for @feesReceiptBadge.
  ///
  /// In en, this message translates to:
  /// **'Official e-receipt'**
  String get feesReceiptBadge;

  /// No description provided for @feesReceiptNumber.
  ///
  /// In en, this message translates to:
  /// **'Receipt number'**
  String get feesReceiptNumber;

  /// No description provided for @feesReceiptDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get feesReceiptDate;

  /// No description provided for @feesReceiptSession.
  ///
  /// In en, this message translates to:
  /// **'Academic session'**
  String get feesReceiptSession;

  /// No description provided for @feesReceiptCentralRrr.
  ///
  /// In en, this message translates to:
  /// **'Central RRR'**
  String get feesReceiptCentralRrr;

  /// No description provided for @feesReceiptStudentHeading.
  ///
  /// In en, this message translates to:
  /// **'Student & payer'**
  String get feesReceiptStudentHeading;

  /// No description provided for @feesReceiptFacultyProgram.
  ///
  /// In en, this message translates to:
  /// **'{faculty} · {department}'**
  String feesReceiptFacultyProgram(Object department, Object faculty);

  /// No description provided for @feesReceiptItem.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get feesReceiptItem;

  /// No description provided for @feesReceiptFee.
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get feesReceiptFee;

  /// No description provided for @feesReceiptLineStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get feesReceiptLineStatus;

  /// No description provided for @feesReceiptLinePaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get feesReceiptLinePaid;

  /// No description provided for @feesReceiptTotalCleared.
  ///
  /// In en, this message translates to:
  /// **'Total paid & cleared'**
  String get feesReceiptTotalCleared;

  /// No description provided for @feesReceiptSettled.
  ///
  /// In en, this message translates to:
  /// **'Settled'**
  String get feesReceiptSettled;

  /// No description provided for @feesReceiptToWallet.
  ///
  /// In en, this message translates to:
  /// **'To wallet'**
  String get feesReceiptToWallet;

  /// No description provided for @feesReceiptChannel.
  ///
  /// In en, this message translates to:
  /// **'Settlement channel'**
  String get feesReceiptChannel;

  /// No description provided for @feesReceiptAuthCode.
  ///
  /// In en, this message translates to:
  /// **'Authorisation code'**
  String get feesReceiptAuthCode;

  /// No description provided for @feesReceiptClearingRef.
  ///
  /// In en, this message translates to:
  /// **'Clearing reference'**
  String get feesReceiptClearingRef;

  /// No description provided for @feesReceiptStamp.
  ///
  /// In en, this message translates to:
  /// **'Electronically cleared & audited'**
  String get feesReceiptStamp;

  /// No description provided for @feesReceiptSignatory.
  ///
  /// In en, this message translates to:
  /// **'Alhaji Bello Danbatta'**
  String get feesReceiptSignatory;

  /// No description provided for @feesReceiptSignatoryTitle.
  ///
  /// In en, this message translates to:
  /// **'University Bursar & CFO'**
  String get feesReceiptSignatoryTitle;

  /// No description provided for @feesReceiptVerifyUrl.
  ///
  /// In en, this message translates to:
  /// **'Verify at thelegion.edu.ng/verify/receipt'**
  String get feesReceiptVerifyUrl;

  /// No description provided for @feesReceiptScanToVerify.
  ///
  /// In en, this message translates to:
  /// **'Scan to verify payment'**
  String get feesReceiptScanToVerify;

  /// No description provided for @feesReceiptNotFound.
  ///
  /// In en, this message translates to:
  /// **'No receipt matches this reference.'**
  String get feesReceiptNotFound;

  /// No description provided for @feesVerifyBrandCaption.
  ///
  /// In en, this message translates to:
  /// **'Bursary receipt verification'**
  String get feesVerifyBrandCaption;

  /// No description provided for @feesVerifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify a receipt'**
  String get feesVerifyTitle;

  /// No description provided for @feesVerifySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code printed at the foot of the official bursary receipt.'**
  String get feesVerifySubtitle;

  /// No description provided for @feesVerifyOffice.
  ///
  /// In en, this message translates to:
  /// **'Office of the Registrar · Directorate of Bursary Services'**
  String get feesVerifyOffice;

  /// No description provided for @feesVerifyCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Receipt reference key'**
  String get feesVerifyCodeLabel;

  /// No description provided for @feesVerifyCodeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 9K8L-4M2P-TX77'**
  String get feesVerifyCodeHint;

  /// No description provided for @feesVerifyAction.
  ///
  /// In en, this message translates to:
  /// **'Verify receipt'**
  String get feesVerifyAction;

  /// No description provided for @feesVerifyGenuine.
  ///
  /// In en, this message translates to:
  /// **'Genuine bursary receipt'**
  String get feesVerifyGenuine;

  /// No description provided for @feesVerifyReceiptNumber.
  ///
  /// In en, this message translates to:
  /// **'Receipt number'**
  String get feesVerifyReceiptNumber;

  /// No description provided for @feesVerifyAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount paid'**
  String get feesVerifyAmount;

  /// No description provided for @feesVerifyPaidBy.
  ///
  /// In en, this message translates to:
  /// **'Paid by'**
  String get feesVerifyPaidBy;

  /// No description provided for @feesVerifyPaidFor.
  ///
  /// In en, this message translates to:
  /// **'For'**
  String get feesVerifyPaidFor;

  /// No description provided for @feesVerifyPaidOn.
  ///
  /// In en, this message translates to:
  /// **'Payment date'**
  String get feesVerifyPaidOn;

  /// No description provided for @feesVerifyNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'No receipt matches this code'**
  String get feesVerifyNotFoundTitle;

  /// No description provided for @feesVerifyNotFoundBody.
  ///
  /// In en, this message translates to:
  /// **'Check the code at the foot of the receipt and try again. If it still does not match, the receipt was not issued by the university.'**
  String get feesVerifyNotFoundBody;

  /// No description provided for @feesVerifyPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy & redaction'**
  String get feesVerifyPrivacyTitle;

  /// No description provided for @feesVerifyPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'This page shows only what is confirmed on the official bursary ledger: receipt number, amount, payer name, purpose and date. It does not show email, phone, address, matric number, bank account or gateway references.'**
  String get feesVerifyPrivacyBody;

  /// No description provided for @feesVerifySignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in to the student portal'**
  String get feesVerifySignIn;

  /// No description provided for @navRegistration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get navRegistration;

  /// No description provided for @navStudyPlan.
  ///
  /// In en, this message translates to:
  /// **'Study plan'**
  String get navStudyPlan;

  /// No description provided for @navCourseForm.
  ///
  /// In en, this message translates to:
  /// **'Form'**
  String get navCourseForm;

  /// No description provided for @registrationBackTooltip.
  ///
  /// In en, this message translates to:
  /// **'Back to the hub'**
  String get registrationBackTooltip;

  /// No description provided for @registrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Course registration'**
  String get registrationTitle;

  /// No description provided for @registrationBreadcrumbStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get registrationBreadcrumbStudent;

  /// No description provided for @registrationSessionLine.
  ///
  /// In en, this message translates to:
  /// **'{session} · {term}'**
  String registrationSessionLine(Object session, Object term);

  /// No description provided for @registrationSessionHeadline.
  ///
  /// In en, this message translates to:
  /// **'{session} session · {term}'**
  String registrationSessionHeadline(Object session, Object term);

  /// No description provided for @registrationStudentProgramme.
  ///
  /// In en, this message translates to:
  /// **'{programme} · {faculty}'**
  String registrationStudentProgramme(Object faculty, Object programme);

  /// No description provided for @registrationMatricLevel.
  ///
  /// In en, this message translates to:
  /// **'{matricNumber} · {level}'**
  String registrationMatricLevel(Object level, Object matricNumber);

  /// No description provided for @registrationMatricLevelSuffix.
  ///
  /// In en, this message translates to:
  /// **'· {matricNumber} · {level}'**
  String registrationMatricLevelSuffix(Object level, Object matricNumber);

  /// No description provided for @registrationLevel.
  ///
  /// In en, this message translates to:
  /// **'{level} Level'**
  String registrationLevel(Object level);

  /// No description provided for @registrationUnitsRegisteredLabel.
  ///
  /// In en, this message translates to:
  /// **'Units registered'**
  String get registrationUnitsRegisteredLabel;

  /// No description provided for @registrationCountingUnitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Counting units: {units}'**
  String registrationCountingUnitsTitle(Object units);

  /// No description provided for @registrationCountingUnitsBody.
  ///
  /// In en, this message translates to:
  /// **'You are at your minimum of {minimum} exactly. Dropping any course leaves you below minimum.'**
  String registrationCountingUnitsBody(Object minimum);

  /// No description provided for @registrationCatalogueTitleSection.
  ///
  /// In en, this message translates to:
  /// **'{title} · Section {section}'**
  String registrationCatalogueTitleSection(Object section, Object title);

  /// No description provided for @registrationNoLecturesLab.
  ///
  /// In en, this message translates to:
  /// **'No lectures or lab sessions scheduled'**
  String get registrationNoLecturesLab;

  /// No description provided for @registrationMeetingCourseVenue.
  ///
  /// In en, this message translates to:
  /// **'{code} · {venue}'**
  String registrationMeetingCourseVenue(Object code, Object venue);

  /// No description provided for @registrationMeetingTime.
  ///
  /// In en, this message translates to:
  /// **'{start} - {end}'**
  String registrationMeetingTime(Object end, Object start);

  /// No description provided for @registrationWindowOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get registrationWindowOpen;

  /// No description provided for @registrationWindowOpenForYou.
  ///
  /// In en, this message translates to:
  /// **'Open for you'**
  String get registrationWindowOpenForYou;

  /// No description provided for @registrationWindowAddDropOnly.
  ///
  /// In en, this message translates to:
  /// **'Add/drop only'**
  String get registrationWindowAddDropOnly;

  /// No description provided for @registrationWindowUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Opens soon'**
  String get registrationWindowUpcoming;

  /// No description provided for @registrationWindowClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get registrationWindowClosed;

  /// No description provided for @registrationUnitsLabel.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get registrationUnitsLabel;

  /// No description provided for @registrationUnitsValue.
  ///
  /// In en, this message translates to:
  /// **'{registered} / {maximum}'**
  String registrationUnitsValue(Object maximum, Object registered);

  /// No description provided for @registrationUnitsHint.
  ///
  /// In en, this message translates to:
  /// **'Min {minimum} · Limit per plan'**
  String registrationUnitsHint(Object minimum);

  /// No description provided for @registrationApprovalLabel.
  ///
  /// In en, this message translates to:
  /// **'Approval'**
  String get registrationApprovalLabel;

  /// No description provided for @registrationApprovalHint.
  ///
  /// In en, this message translates to:
  /// **'Adviser review'**
  String get registrationApprovalHint;

  /// No description provided for @registrationFormShortLabel.
  ///
  /// In en, this message translates to:
  /// **'Form'**
  String get registrationFormShortLabel;

  /// No description provided for @registrationFormPendingSubmit.
  ///
  /// In en, this message translates to:
  /// **'Pending submit'**
  String get registrationFormPendingSubmit;

  /// No description provided for @registrationPendingLabel.
  ///
  /// In en, this message translates to:
  /// **'Awaiting approval'**
  String get registrationPendingLabel;

  /// No description provided for @registrationPendingHint.
  ///
  /// In en, this message translates to:
  /// **'Level adviser queue'**
  String get registrationPendingHint;

  /// No description provided for @registrationPendingCoursesValue.
  ///
  /// In en, this message translates to:
  /// **'{count}'**
  String registrationPendingCoursesValue(Object count);

  /// No description provided for @registrationPendingCoursesHint.
  ///
  /// In en, this message translates to:
  /// **'courses'**
  String get registrationPendingCoursesHint;

  /// No description provided for @registrationFormLabel.
  ///
  /// In en, this message translates to:
  /// **'Course form'**
  String get registrationFormLabel;

  /// No description provided for @registrationFormNotSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Not submitted'**
  String get registrationFormNotSubmitted;

  /// No description provided for @registrationFormDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get registrationFormDraft;

  /// No description provided for @registrationFormSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get registrationFormSubmitted;

  /// No description provided for @registrationFormHint.
  ///
  /// In en, this message translates to:
  /// **'Submit when complete'**
  String get registrationFormHint;

  /// No description provided for @registrationTabSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected & Timetable'**
  String get registrationTabSelected;

  /// No description provided for @registrationTabCatalogue.
  ///
  /// In en, this message translates to:
  /// **'Catalogue & Add'**
  String get registrationTabCatalogue;

  /// No description provided for @registrationLedgerCourseTitle.
  ///
  /// In en, this message translates to:
  /// **'Course / Title'**
  String get registrationLedgerCourseTitle;

  /// No description provided for @registrationLedgerUnits.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get registrationLedgerUnits;

  /// No description provided for @registrationLedgerAction.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get registrationLedgerAction;

  /// No description provided for @registrationActionBlocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get registrationActionBlocked;

  /// No description provided for @registrationActionArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get registrationActionArchived;

  /// No description provided for @registrationActionNone.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get registrationActionNone;

  /// No description provided for @registrationMatricBulletLevel.
  ///
  /// In en, this message translates to:
  /// **'{matricNumber} • {level}'**
  String registrationMatricBulletLevel(String matricNumber, String level);

  /// No description provided for @registrationUnitsDegreePlan.
  ///
  /// In en, this message translates to:
  /// **'Min {minimum} · Degree plan'**
  String registrationUnitsDegreePlan(int minimum);

  /// No description provided for @registrationDeckTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration Deck'**
  String get registrationDeckTitle;

  /// No description provided for @registrationUnitsCap.
  ///
  /// In en, this message translates to:
  /// **'/ {maximum} units'**
  String registrationUnitsCap(Object maximum);

  /// No description provided for @registrationCoursesTotal.
  ///
  /// In en, this message translates to:
  /// **'{count} total'**
  String registrationCoursesTotal(Object count);

  /// No description provided for @registrationStandardLoad.
  ///
  /// In en, this message translates to:
  /// **'Standard load: {minimum}-{maximum}'**
  String registrationStandardLoad(Object maximum, Object minimum);

  /// No description provided for @registrationLectureLabSchedule.
  ///
  /// In en, this message translates to:
  /// **'Lecture & Lab Timetable'**
  String get registrationLectureLabSchedule;

  /// No description provided for @registrationWeekdaySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get registrationWeekdaySat;

  /// No description provided for @registrationWeekdaySaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get registrationWeekdaySaturday;

  /// No description provided for @registrationEventCountShort.
  ///
  /// In en, this message translates to:
  /// **'{count} ev'**
  String registrationEventCountShort(Object count);

  /// No description provided for @registrationEventsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 event} other{{count} events}}'**
  String registrationEventsCount(int count);

  /// No description provided for @registrationFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get registrationFree;

  /// No description provided for @registrationActiveDay.
  ///
  /// In en, this message translates to:
  /// **'Active day'**
  String get registrationActiveDay;

  /// No description provided for @registrationCatalogueSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by course code, title, or department'**
  String get registrationCatalogueSearchHint;

  /// No description provided for @registrationCatalogueDepartmental.
  ///
  /// In en, this message translates to:
  /// **'Departmental Catalog'**
  String get registrationCatalogueDepartmental;

  /// No description provided for @registrationNeedsPrerequisite.
  ///
  /// In en, this message translates to:
  /// **'Needs {code}.'**
  String registrationNeedsPrerequisite(String code);

  /// No description provided for @registrationNotOpenDetail.
  ///
  /// In en, this message translates to:
  /// **'No lecturer assigned · {units} units'**
  String registrationNotOpenDetail(int units);

  /// No description provided for @registrationCatalogueFullDetail.
  ///
  /// In en, this message translates to:
  /// **'{title} · {units} units'**
  String registrationCatalogueFullDetail(String title, int units);

  /// No description provided for @registrationGateNotTracked.
  ///
  /// In en, this message translates to:
  /// **'Not tracked'**
  String get registrationGateNotTracked;

  /// No description provided for @registrationYourCourses.
  ///
  /// In en, this message translates to:
  /// **'Your courses ({count})'**
  String registrationYourCourses(Object count);

  /// No description provided for @registrationYourCoursesTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Courses'**
  String get registrationYourCoursesTitle;

  /// No description provided for @registrationUnitsRegistered.
  ///
  /// In en, this message translates to:
  /// **'{units} units registered'**
  String registrationUnitsRegistered(Object units);

  /// No description provided for @registrationMinUnitsNote.
  ///
  /// In en, this message translates to:
  /// **'Your degree plan asks for at least {minimum} units this term.'**
  String registrationMinUnitsNote(Object minimum);

  /// No description provided for @registrationYourWeek.
  ///
  /// In en, this message translates to:
  /// **'Your Week'**
  String get registrationYourWeek;

  /// No description provided for @registrationLectureSchedule.
  ///
  /// In en, this message translates to:
  /// **'Lecture schedule'**
  String get registrationLectureSchedule;

  /// No description provided for @registrationNoLectures.
  ///
  /// In en, this message translates to:
  /// **'No lectures scheduled'**
  String get registrationNoLectures;

  /// No description provided for @registrationWeekdayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get registrationWeekdayMon;

  /// No description provided for @registrationWeekdayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get registrationWeekdayTue;

  /// No description provided for @registrationWeekdayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get registrationWeekdayWed;

  /// No description provided for @registrationWeekdayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get registrationWeekdayThu;

  /// No description provided for @registrationWeekdayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get registrationWeekdayFri;

  /// No description provided for @registrationAddCourses.
  ///
  /// In en, this message translates to:
  /// **'Add Courses'**
  String get registrationAddCourses;

  /// No description provided for @registrationSubmittedForms.
  ///
  /// In en, this message translates to:
  /// **'Submitted forms'**
  String get registrationSubmittedForms;

  /// No description provided for @registrationNoForms.
  ///
  /// In en, this message translates to:
  /// **'No course form has been submitted for this window yet.'**
  String get registrationNoForms;

  /// No description provided for @registrationHelpLine.
  ///
  /// In en, this message translates to:
  /// **'Registration closed? Ask for late registration or add/drop from Requests.'**
  String get registrationHelpLine;

  /// No description provided for @registrationDeclaration.
  ///
  /// In en, this message translates to:
  /// **'I confirm these courses conform to my degree structure and satisfy prerequisite conditions. Once submitted, changes require formal adviser clearance.'**
  String get registrationDeclaration;

  /// No description provided for @registrationSubmitForm.
  ///
  /// In en, this message translates to:
  /// **'Submit course form'**
  String get registrationSubmitForm;

  /// No description provided for @registrationSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get registrationSaveChanges;

  /// No description provided for @registrationDrop.
  ///
  /// In en, this message translates to:
  /// **'Drop'**
  String get registrationDrop;

  /// No description provided for @registrationAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get registrationAdd;

  /// No description provided for @registrationAddAnyway.
  ///
  /// In en, this message translates to:
  /// **'Add anyway'**
  String get registrationAddAnyway;

  /// No description provided for @registrationRequestWaiver.
  ///
  /// In en, this message translates to:
  /// **'Request it'**
  String get registrationRequestWaiver;

  /// No description provided for @registrationCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get registrationCancel;

  /// No description provided for @registrationKeepIt.
  ///
  /// In en, this message translates to:
  /// **'Keep it'**
  String get registrationKeepIt;

  /// No description provided for @registrationDropAnyway.
  ///
  /// In en, this message translates to:
  /// **'Drop anyway'**
  String get registrationDropAnyway;

  /// No description provided for @registrationStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get registrationStatusApproved;

  /// No description provided for @registrationStatusAwaiting.
  ///
  /// In en, this message translates to:
  /// **'Awaiting approval'**
  String get registrationStatusAwaiting;

  /// No description provided for @registrationStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get registrationStatusRejected;

  /// No description provided for @registrationStatusDropped.
  ///
  /// In en, this message translates to:
  /// **'Dropped'**
  String get registrationStatusDropped;

  /// No description provided for @registrationStatusClashAccepted.
  ///
  /// In en, this message translates to:
  /// **'Clash accepted'**
  String get registrationStatusClashAccepted;

  /// No description provided for @registrationCatalogueFull.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get registrationCatalogueFull;

  /// No description provided for @registrationCatalogueNotOpen.
  ///
  /// In en, this message translates to:
  /// **'Not open yet'**
  String get registrationCatalogueNotOpen;

  /// No description provided for @registrationCatalogueOutsidePlan.
  ///
  /// In en, this message translates to:
  /// **'Outside your degree plan'**
  String get registrationCatalogueOutsidePlan;

  /// No description provided for @registrationCatalogueClash.
  ///
  /// In en, this message translates to:
  /// **'Timetable clash'**
  String get registrationCatalogueClash;

  /// No description provided for @registrationClashSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Timetable clash'**
  String get registrationClashSheetTitle;

  /// No description provided for @registrationClashSheetBody.
  ///
  /// In en, this message translates to:
  /// **'{detail} You can still add it if your adviser accepts the clash.'**
  String registrationClashSheetBody(Object detail);

  /// No description provided for @registrationDropSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Drop {code}?'**
  String registrationDropSheetTitle(Object code);

  /// No description provided for @registrationDropSheetBody.
  ///
  /// In en, this message translates to:
  /// **'Dropping this course leaves you on {units} units, below the {minimum}-unit minimum for this term.'**
  String registrationDropSheetBody(Object minimum, Object units);

  /// No description provided for @registrationSectionUnits.
  ///
  /// In en, this message translates to:
  /// **'{units} units · Section {section}'**
  String registrationSectionUnits(Object section, Object units);

  /// No description provided for @registrationCourseUnits.
  ///
  /// In en, this message translates to:
  /// **'{units} units'**
  String registrationCourseUnits(Object units);

  /// No description provided for @registrationViewForm.
  ///
  /// In en, this message translates to:
  /// **'View form {version}'**
  String registrationViewForm(Object version);

  /// No description provided for @studyPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Study plan'**
  String get studyPlanTitle;

  /// No description provided for @studyPlanUndergraduate.
  ///
  /// In en, this message translates to:
  /// **'Undergraduate degree'**
  String get studyPlanUndergraduate;

  /// No description provided for @studyPlanActiveStatus.
  ///
  /// In en, this message translates to:
  /// **'Active status'**
  String get studyPlanActiveStatus;

  /// No description provided for @studyPlanUnitsPassed.
  ///
  /// In en, this message translates to:
  /// **'Units passed'**
  String get studyPlanUnitsPassed;

  /// No description provided for @studyPlanUnitsPlanned.
  ///
  /// In en, this message translates to:
  /// **'Units planned'**
  String get studyPlanUnitsPlanned;

  /// No description provided for @studyPlanAwardUnits.
  ///
  /// In en, this message translates to:
  /// **'Awarded on'**
  String get studyPlanAwardUnits;

  /// No description provided for @studyPlanStillToPass.
  ///
  /// In en, this message translates to:
  /// **'Still to pass'**
  String get studyPlanStillToPass;

  /// No description provided for @studyPlanStillToPassValue.
  ///
  /// In en, this message translates to:
  /// **'{count} courses'**
  String studyPlanStillToPassValue(Object count);

  /// No description provided for @studyPlanWorthKnowing.
  ///
  /// In en, this message translates to:
  /// **'Worth knowing now'**
  String get studyPlanWorthKnowing;

  /// No description provided for @studyPlanAdviserSaid.
  ///
  /// In en, this message translates to:
  /// **'What your adviser said'**
  String get studyPlanAdviserSaid;

  /// No description provided for @studyPlanAdviserByline.
  ///
  /// In en, this message translates to:
  /// **'{name} · {date}'**
  String studyPlanAdviserByline(Object date, Object name);

  /// No description provided for @studyPlanTermByTerm.
  ///
  /// In en, this message translates to:
  /// **'Your plan, term by term'**
  String get studyPlanTermByTerm;

  /// No description provided for @studyPlanDegreeAsks.
  ///
  /// In en, this message translates to:
  /// **'What your degree asks of you'**
  String get studyPlanDegreeAsks;

  /// No description provided for @studyPlanACourse.
  ///
  /// In en, this message translates to:
  /// **'Plan a course'**
  String get studyPlanACourse;

  /// No description provided for @studyPlanAddToPlan.
  ///
  /// In en, this message translates to:
  /// **'Add to plan'**
  String get studyPlanAddToPlan;

  /// No description provided for @studyPlanHowThisWorks.
  ///
  /// In en, this message translates to:
  /// **'How this works'**
  String get studyPlanHowThisWorks;

  /// No description provided for @studyPlanHowThisWorksBody.
  ///
  /// In en, this message translates to:
  /// **'A study plan is your intent across terms. It is not a registration. Your adviser can leave a note here; only Course registration submits a form to the registry.'**
  String get studyPlanHowThisWorksBody;

  /// No description provided for @studyPlanComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Planning a course into a future term goes live with the next release.'**
  String get studyPlanComingSoon;

  /// No description provided for @courseFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Course form {version}'**
  String courseFormTitle(Object version);

  /// No description provided for @courseFormSavePdf.
  ///
  /// In en, this message translates to:
  /// **'Save PDF'**
  String get courseFormSavePdf;

  /// No description provided for @courseFormOffice.
  ///
  /// In en, this message translates to:
  /// **'Office of the Registrar · Academic Affairs'**
  String get courseFormOffice;

  /// No description provided for @courseFormHeading.
  ///
  /// In en, this message translates to:
  /// **'Course registration form'**
  String get courseFormHeading;

  /// No description provided for @courseFormOfficialBadge.
  ///
  /// In en, this message translates to:
  /// **'Official endorsed record'**
  String get courseFormOfficialBadge;

  /// No description provided for @courseFormStudentHeading.
  ///
  /// In en, this message translates to:
  /// **'Student identification'**
  String get courseFormStudentHeading;

  /// No description provided for @courseFormFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get courseFormFullName;

  /// No description provided for @courseFormMatric.
  ///
  /// In en, this message translates to:
  /// **'Matriculation number'**
  String get courseFormMatric;

  /// No description provided for @courseFormLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get courseFormLevel;

  /// No description provided for @courseFormProgramme.
  ///
  /// In en, this message translates to:
  /// **'Programme of study'**
  String get courseFormProgramme;

  /// No description provided for @courseFormFacultyDept.
  ///
  /// In en, this message translates to:
  /// **'Faculty & department'**
  String get courseFormFacultyDept;

  /// No description provided for @courseFormFacultyDeptValue.
  ///
  /// In en, this message translates to:
  /// **'{faculty} · {department}'**
  String courseFormFacultyDeptValue(Object department, Object faculty);

  /// No description provided for @courseFormSubmissionLog.
  ///
  /// In en, this message translates to:
  /// **'Submission log'**
  String get courseFormSubmissionLog;

  /// No description provided for @courseFormRegisteredCourses.
  ///
  /// In en, this message translates to:
  /// **'Registered courses'**
  String get courseFormRegisteredCourses;

  /// No description provided for @courseFormTotalUnits.
  ///
  /// In en, this message translates to:
  /// **'Total units'**
  String get courseFormTotalUnits;

  /// No description provided for @courseFormDeclarationHeading.
  ///
  /// In en, this message translates to:
  /// **'Student declaration'**
  String get courseFormDeclarationHeading;

  /// No description provided for @courseFormDeclarationBody.
  ///
  /// In en, this message translates to:
  /// **'I confirm that the courses listed are those I intend to take this term and that the particulars above are correct.'**
  String get courseFormDeclarationBody;

  /// No description provided for @courseFormAuthDigital.
  ///
  /// In en, this message translates to:
  /// **'Digital acceptance · Validated'**
  String get courseFormAuthDigital;

  /// No description provided for @courseFormSignatures.
  ///
  /// In en, this message translates to:
  /// **'Required physical signatures & endorsements'**
  String get courseFormSignatures;

  /// No description provided for @courseFormVerifyFooter.
  ///
  /// In en, this message translates to:
  /// **'Verify authenticity with the document id below.'**
  String get courseFormVerifyFooter;

  /// No description provided for @courseFormEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No course form yet'**
  String get courseFormEmptyTitle;

  /// No description provided for @courseFormEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Submit your course form from the Registration tab once your courses and the declaration are ready.'**
  String get courseFormEmptyBody;

  /// No description provided for @registrationCountingUnits.
  ///
  /// In en, this message translates to:
  /// **'Counting units: {units}. You are at your minimum of {minimum} exactly. Dropping any course leaves you below minimum.'**
  String registrationCountingUnits(Object minimum, Object units);

  /// No description provided for @registrationYourWeekTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Week'**
  String get registrationYourWeekTitle;

  /// No description provided for @registrationAddCoursesTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Courses'**
  String get registrationAddCoursesTitle;

  /// No description provided for @registrationAddDropBanner.
  ///
  /// In en, this message translates to:
  /// **'Students already registered for this semester can add or drop courses in this window.'**
  String get registrationAddDropBanner;

  /// No description provided for @registrationEmptyCoursesTitle.
  ///
  /// In en, this message translates to:
  /// **'No courses yet'**
  String get registrationEmptyCoursesTitle;

  /// No description provided for @registrationEmptyCoursesBody.
  ///
  /// In en, this message translates to:
  /// **'Add the courses for this semester from the catalogue below.'**
  String get registrationEmptyCoursesBody;

  /// No description provided for @registrationCatalogueTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Courses'**
  String get registrationCatalogueTitle;

  /// No description provided for @registrationCatalogueSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Departmental Catalog'**
  String get registrationCatalogueSubtitle;

  /// No description provided for @registrationMissingPrerequisite.
  ///
  /// In en, this message translates to:
  /// **'Missing a prerequisite'**
  String get registrationMissingPrerequisite;

  /// No description provided for @registrationWeekdayMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get registrationWeekdayMonday;

  /// No description provided for @registrationWeekdayTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get registrationWeekdayTuesday;

  /// No description provided for @registrationWeekdayWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get registrationWeekdayWednesday;

  /// No description provided for @registrationWeekdayThursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get registrationWeekdayThursday;

  /// No description provided for @registrationWeekdayFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get registrationWeekdayFriday;

  /// No description provided for @registrationMeetingLine.
  ///
  /// In en, this message translates to:
  /// **'{start} – {end} · {venue}'**
  String registrationMeetingLine(Object end, Object start, Object venue);

  /// No description provided for @registrationFormSubmittedHint.
  ///
  /// In en, this message translates to:
  /// **'On record with the registry'**
  String get registrationFormSubmittedHint;

  /// No description provided for @courseFormVersionLine.
  ///
  /// In en, this message translates to:
  /// **'{version} · {submittedOn}'**
  String courseFormVersionLine(Object submittedOn, Object version);

  /// No description provided for @courseFormSessionLine.
  ///
  /// In en, this message translates to:
  /// **'Course registration form · {session}, {term}'**
  String courseFormSessionLine(Object session, Object term);

  /// No description provided for @courseFormStudentSignature.
  ///
  /// In en, this message translates to:
  /// **'Student signature'**
  String get courseFormStudentSignature;

  /// No description provided for @courseFormAdviserSignature.
  ///
  /// In en, this message translates to:
  /// **'Level adviser'**
  String get courseFormAdviserSignature;

  /// No description provided for @courseFormHodSignature.
  ///
  /// In en, this message translates to:
  /// **'Head of department'**
  String get courseFormHodSignature;

  /// No description provided for @courseFormSignatureDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get courseFormSignatureDate;

  /// No description provided for @courseFormSignaturePrintNote.
  ///
  /// In en, this message translates to:
  /// **'Signature lines are for the printed copy.'**
  String get courseFormSignaturePrintNote;

  /// No description provided for @courseFormDocId.
  ///
  /// In en, this message translates to:
  /// **'DOC ID: {id}'**
  String courseFormDocId(Object id);

  /// No description provided for @courseFormFormId.
  ///
  /// In en, this message translates to:
  /// **'FORM ID: {id}'**
  String courseFormFormId(Object id);

  /// No description provided for @courseFormSealed.
  ///
  /// In en, this message translates to:
  /// **'Sealed & issued'**
  String get courseFormSealed;

  /// No description provided for @courseFormUnitsColumn.
  ///
  /// In en, this message translates to:
  /// **'Units / status'**
  String get courseFormUnitsColumn;

  /// No description provided for @studyPlanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What is left of your degree, and when you mean to take it.'**
  String get studyPlanSubtitle;

  /// No description provided for @studyPlanTermUnits.
  ///
  /// In en, this message translates to:
  /// **'{planned} of {maximum} units'**
  String studyPlanTermUnits(Object maximum, Object planned);

  /// No description provided for @studyPlanHowThisWorksTitle.
  ///
  /// In en, this message translates to:
  /// **'How this works'**
  String get studyPlanHowThisWorksTitle;
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

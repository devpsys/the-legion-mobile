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

  /// No description provided for @navRequests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get navRequests;

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
  /// **'{level} • {matricNumber}'**
  String registrationMatricBulletLevel(String level, String matricNumber);

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
  /// **'Active Status'**
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

  /// No description provided for @studyPlanUnitsEarnedHint.
  ///
  /// In en, this message translates to:
  /// **'earned'**
  String get studyPlanUnitsEarnedHint;

  /// No description provided for @studyPlanUnitsCurrentTermHint.
  ///
  /// In en, this message translates to:
  /// **'current term'**
  String get studyPlanUnitsCurrentTermHint;

  /// No description provided for @studyPlanUnitsHint.
  ///
  /// In en, this message translates to:
  /// **'units'**
  String get studyPlanUnitsHint;

  /// No description provided for @studyPlanCoursesHint.
  ///
  /// In en, this message translates to:
  /// **'courses'**
  String get studyPlanCoursesHint;

  /// No description provided for @studyPlanAwardCaption.
  ///
  /// In en, this message translates to:
  /// **'Degree plan requirement: {units} units'**
  String studyPlanAwardCaption(int units);

  /// No description provided for @studyPlanStillToPassCaption.
  ///
  /// In en, this message translates to:
  /// **'Across remaining levels: {count} courses'**
  String studyPlanStillToPassCaption(int count);

  /// No description provided for @studyPlanProgrammeConclusion.
  ///
  /// In en, this message translates to:
  /// **'Programme conclusion:'**
  String get studyPlanProgrammeConclusion;

  /// No description provided for @studyPlanMatricLevelShort.
  ///
  /// In en, this message translates to:
  /// **'{matricNumber} · {level}L'**
  String studyPlanMatricLevelShort(String matricNumber, int level);

  /// No description provided for @studyPlanWorthKnowing.
  ///
  /// In en, this message translates to:
  /// **'Worth knowing now'**
  String get studyPlanWorthKnowing;

  /// No description provided for @studyPlanAdvisoriesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Advisories'**
  String studyPlanAdvisoriesCount(int count);

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

  /// No description provided for @studyPlanTermsListed.
  ///
  /// In en, this message translates to:
  /// **'{count} Terms Listed'**
  String studyPlanTermsListed(int count);

  /// No description provided for @studyPlanNowBadge.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get studyPlanNowBadge;

  /// No description provided for @studyPlanLedgerCourse.
  ///
  /// In en, this message translates to:
  /// **'Course'**
  String get studyPlanLedgerCourse;

  /// No description provided for @studyPlanLedgerTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get studyPlanLedgerTitle;

  /// No description provided for @studyPlanLedgerUnits.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get studyPlanLedgerUnits;

  /// No description provided for @studyPlanDegreeAsks.
  ///
  /// In en, this message translates to:
  /// **'What your degree asks of you'**
  String get studyPlanDegreeAsks;

  /// No description provided for @studyPlanDegreeAsksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Audit breakdown across all four academic levels.'**
  String get studyPlanDegreeAsksSubtitle;

  /// No description provided for @studyPlanPassed.
  ///
  /// In en, this message translates to:
  /// **'Passed'**
  String get studyPlanPassed;

  /// No description provided for @studyPlanCurrentLevel.
  ///
  /// In en, this message translates to:
  /// **'Current Level'**
  String get studyPlanCurrentLevel;

  /// No description provided for @studyPlanTakingNow.
  ///
  /// In en, this message translates to:
  /// **'Taking now'**
  String get studyPlanTakingNow;

  /// No description provided for @studyPlanStillToTake.
  ///
  /// In en, this message translates to:
  /// **'Still to take'**
  String get studyPlanStillToTake;

  /// No description provided for @studyPlanACourse.
  ///
  /// In en, this message translates to:
  /// **'Plan a course'**
  String get studyPlanACourse;

  /// No description provided for @studyPlanACourseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select an unallocated course and assign it to a future session.'**
  String get studyPlanACourseSubtitle;

  /// No description provided for @studyPlanCourseLabel.
  ///
  /// In en, this message translates to:
  /// **'Course'**
  String get studyPlanCourseLabel;

  /// No description provided for @studyPlanTargetTermLabel.
  ///
  /// In en, this message translates to:
  /// **'Target term'**
  String get studyPlanTargetTermLabel;

  /// No description provided for @studyPlanSelectCourse.
  ///
  /// In en, this message translates to:
  /// **'Select an outstanding course'**
  String get studyPlanSelectCourse;

  /// No description provided for @studyPlanSelectTerm.
  ///
  /// In en, this message translates to:
  /// **'Select academic term'**
  String get studyPlanSelectTerm;

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
  /// **'Nothing on this page records what you have done. What is left is read from your degree plan and your results each time you open it, so clearing a carry-over changes it without you touching anything. What you store is only when you mean to take what remains.'**
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

  /// No description provided for @courseFormShortTitle.
  ///
  /// In en, this message translates to:
  /// **'Course Form'**
  String get courseFormShortTitle;

  /// No description provided for @courseFormSavePdf.
  ///
  /// In en, this message translates to:
  /// **'Save PDF'**
  String get courseFormSavePdf;

  /// No description provided for @courseFormShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get courseFormShare;

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
  /// **'{department}, {faculty}'**
  String courseFormFacultyDeptValue(Object department, Object faculty);

  /// No description provided for @courseFormSubmissionLog.
  ///
  /// In en, this message translates to:
  /// **'Submission log'**
  String get courseFormSubmissionLog;

  /// No description provided for @courseFormSubmissionLogLine.
  ///
  /// In en, this message translates to:
  /// **'Submission Log: {version} · {submittedOn} WAT'**
  String courseFormSubmissionLogLine(Object submittedOn, Object version);

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

  /// No description provided for @courseFormTotalRegisteredUnits.
  ///
  /// In en, this message translates to:
  /// **'Total Registered Units'**
  String get courseFormTotalRegisteredUnits;

  /// No description provided for @courseFormUnitsAbbrev.
  ///
  /// In en, this message translates to:
  /// **'UNITS'**
  String get courseFormUnitsAbbrev;

  /// No description provided for @courseFormSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Section {section}'**
  String courseFormSectionLabel(Object section);

  /// No description provided for @courseFormUnitsStatus.
  ///
  /// In en, this message translates to:
  /// **'{units} units · {status}'**
  String courseFormUnitsStatus(Object status, Object units);

  /// No description provided for @courseFormDeclarationHeading.
  ///
  /// In en, this message translates to:
  /// **'Student declaration'**
  String get courseFormDeclarationHeading;

  /// No description provided for @courseFormDeclarationBody.
  ///
  /// In en, this message translates to:
  /// **'“I confirm these are the courses I will take this semester and that I have read the registration rules.”'**
  String get courseFormDeclarationBody;

  /// No description provided for @courseFormAuthDigital.
  ///
  /// In en, this message translates to:
  /// **'Auth: Digital Acceptance'**
  String get courseFormAuthDigital;

  /// No description provided for @courseFormStatusValidated.
  ///
  /// In en, this message translates to:
  /// **'Status: Validated'**
  String get courseFormStatusValidated;

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

  /// No description provided for @courseFormVerifyAuthenticity.
  ///
  /// In en, this message translates to:
  /// **'Verify authenticity'**
  String get courseFormVerifyAuthenticity;

  /// No description provided for @courseFormRegistrarArchive.
  ///
  /// In en, this message translates to:
  /// **'Registrar secure archive'**
  String get courseFormRegistrarArchive;

  /// No description provided for @courseFormAcademicReg.
  ///
  /// In en, this message translates to:
  /// **'Academic Reg.'**
  String get courseFormAcademicReg;

  /// No description provided for @courseFormPresentHint.
  ///
  /// In en, this message translates to:
  /// **'Present this stamped copy to the departmental officer if requested.'**
  String get courseFormPresentHint;

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

  /// No description provided for @registrationAddToCalendar.
  ///
  /// In en, this message translates to:
  /// **'Add to calendar'**
  String get registrationAddToCalendar;

  /// No description provided for @registrationCalendarShared.
  ///
  /// In en, this message translates to:
  /// **'Week schedule ready to add to your calendar.'**
  String get registrationCalendarShared;

  /// No description provided for @registrationCalendarShareFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not share the week schedule.'**
  String get registrationCalendarShareFailed;

  /// No description provided for @registrationCalendarEmpty.
  ///
  /// In en, this message translates to:
  /// **'There are no lectures this week to add.'**
  String get registrationCalendarEmpty;

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
  /// **'Student Signature:'**
  String get courseFormStudentSignature;

  /// No description provided for @courseFormAdviserSignature.
  ///
  /// In en, this message translates to:
  /// **'Level Adviser:'**
  String get courseFormAdviserSignature;

  /// No description provided for @courseFormHodSignature.
  ///
  /// In en, this message translates to:
  /// **'Head of Department:'**
  String get courseFormHodSignature;

  /// No description provided for @courseFormSignatureDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get courseFormSignatureDate;

  /// No description provided for @courseFormSignatureDateBlank.
  ///
  /// In en, this message translates to:
  /// **'Date: ________________'**
  String get courseFormSignatureDateBlank;

  /// No description provided for @courseFormSignaturePrintNote.
  ///
  /// In en, this message translates to:
  /// **'* Signature lines are for the printed copy.'**
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
  /// **'Units / Status'**
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

  /// No description provided for @requestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requestsTitle;

  /// No description provided for @requestsBreadcrumb.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requestsBreadcrumb;

  /// No description provided for @requestsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask for an exception to the registration rules or a change of programme.'**
  String get requestsSubtitle;

  /// No description provided for @requestsExistingTitle.
  ///
  /// In en, this message translates to:
  /// **'Existing requests'**
  String get requestsExistingTitle;

  /// No description provided for @requestsExistingCount.
  ///
  /// In en, this message translates to:
  /// **'{count} recorded'**
  String requestsExistingCount(int count);

  /// No description provided for @requestsSubmittedTitle.
  ///
  /// In en, this message translates to:
  /// **'Submitted requests ({count})'**
  String requestsSubmittedTitle(int count);

  /// No description provided for @requestsSessionLabel.
  ///
  /// In en, this message translates to:
  /// **'Academic session {session}'**
  String requestsSessionLabel(String session);

  /// No description provided for @requestsFiledOn.
  ///
  /// In en, this message translates to:
  /// **'filed {date}'**
  String requestsFiledOn(String date);

  /// No description provided for @requestsWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw this request'**
  String get requestsWithdraw;

  /// No description provided for @requestsWithdrawTitle.
  ///
  /// In en, this message translates to:
  /// **'Withdraw this request?'**
  String get requestsWithdrawTitle;

  /// No description provided for @requestsWithdrawBody.
  ///
  /// In en, this message translates to:
  /// **'The registry will stop reviewing “{title}”. You can file again later if you still need the exception.'**
  String requestsWithdrawBody(String title);

  /// No description provided for @requestsWithdrawConfirm.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get requestsWithdrawConfirm;

  /// No description provided for @requestsDecisionNote.
  ///
  /// In en, this message translates to:
  /// **'Decision note: {note}'**
  String requestsDecisionNote(String note);

  /// No description provided for @requestsStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get requestsStatusPending;

  /// No description provided for @requestsStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get requestsStatusRejected;

  /// No description provided for @requestsStatusWithdrawn.
  ///
  /// In en, this message translates to:
  /// **'Withdrawn'**
  String get requestsStatusWithdrawn;

  /// No description provided for @requestsNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New request'**
  String get requestsNewTitle;

  /// No description provided for @requestsNewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Submit a formal petition for departmental review.'**
  String get requestsNewSubtitle;

  /// No description provided for @requestsWhatDoYouNeed.
  ///
  /// In en, this message translates to:
  /// **'What do you need?'**
  String get requestsWhatDoYouNeed;

  /// No description provided for @requestsCourseLabel.
  ///
  /// In en, this message translates to:
  /// **'Course'**
  String get requestsCourseLabel;

  /// No description provided for @requestsPrerequisiteLabel.
  ///
  /// In en, this message translates to:
  /// **'Prerequisite to waive'**
  String get requestsPrerequisiteLabel;

  /// No description provided for @requestsReasonsLabel.
  ///
  /// In en, this message translates to:
  /// **'Your reasons'**
  String get requestsReasonsLabel;

  /// No description provided for @requestsReasonsHint.
  ///
  /// In en, this message translates to:
  /// **'Explain your circumstances. Attach supporting documents under My account → Documents.'**
  String get requestsReasonsHint;

  /// No description provided for @requestsWaiveNote.
  ///
  /// In en, this message translates to:
  /// **'Waiving a prerequisite does not change your result. It only lets you register for the course now.'**
  String get requestsWaiveNote;

  /// No description provided for @requestsSend.
  ///
  /// In en, this message translates to:
  /// **'Send request'**
  String get requestsSend;

  /// No description provided for @requestsSent.
  ///
  /// In en, this message translates to:
  /// **'Your request was sent for review.'**
  String get requestsSent;

  /// No description provided for @requestsAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About requests'**
  String get requestsAboutTitle;

  /// No description provided for @requestsAboutBody.
  ///
  /// In en, this message translates to:
  /// **'An approval moves a rule in the academic record system. It is read automatically when you register or when grades are computed.'**
  String get requestsAboutBody;

  /// No description provided for @requestsTypeLateRegistration.
  ///
  /// In en, this message translates to:
  /// **'Late registration'**
  String get requestsTypeLateRegistration;

  /// No description provided for @requestsTypeAddDropAfterDeadline.
  ///
  /// In en, this message translates to:
  /// **'Add or drop courses after the deadline'**
  String get requestsTypeAddDropAfterDeadline;

  /// No description provided for @requestsTypeOverload.
  ///
  /// In en, this message translates to:
  /// **'Register more units than allowed'**
  String get requestsTypeOverload;

  /// No description provided for @requestsTypeUnderload.
  ///
  /// In en, this message translates to:
  /// **'Register fewer units than the minimum'**
  String get requestsTypeUnderload;

  /// No description provided for @requestsTypeWaivePrerequisite.
  ///
  /// In en, this message translates to:
  /// **'Waive a prerequisite'**
  String get requestsTypeWaivePrerequisite;

  /// No description provided for @requestsTypeChangeOfProgramme.
  ///
  /// In en, this message translates to:
  /// **'Change of programme'**
  String get requestsTypeChangeOfProgramme;

  /// No description provided for @requestsTypeHintLateRegistration.
  ///
  /// In en, this message translates to:
  /// **'Lets the student register after the ordinary window has closed.'**
  String get requestsTypeHintLateRegistration;

  /// No description provided for @requestsTypeHintAddDropAfterDeadline.
  ///
  /// In en, this message translates to:
  /// **'Lets the student change courses after add/drop has closed.'**
  String get requestsTypeHintAddDropAfterDeadline;

  /// No description provided for @requestsTypeHintOverload.
  ///
  /// In en, this message translates to:
  /// **'Lets the student register above the unit ceiling for their level.'**
  String get requestsTypeHintOverload;

  /// No description provided for @requestsTypeHintUnderload.
  ///
  /// In en, this message translates to:
  /// **'Lets the student register below the unit minimum for their level.'**
  String get requestsTypeHintUnderload;

  /// No description provided for @requestsTypeHintWaivePrerequisite.
  ///
  /// In en, this message translates to:
  /// **'Lets the student register for the course without the prerequisite.'**
  String get requestsTypeHintWaivePrerequisite;

  /// No description provided for @requestsTypeHintChangeOfProgramme.
  ///
  /// In en, this message translates to:
  /// **'Asks the faculty to move the student onto a different programme.'**
  String get requestsTypeHintChangeOfProgramme;

  /// No description provided for @requestsIdCardEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Student ID card'**
  String get requestsIdCardEntryTitle;

  /// No description provided for @requestsIdCardEntryBody.
  ///
  /// In en, this message translates to:
  /// **'Request a first card or a replacement, track printing, and collect from the registry.'**
  String get requestsIdCardEntryBody;

  /// No description provided for @requestsIdCardEntryAction.
  ///
  /// In en, this message translates to:
  /// **'Open ID card'**
  String get requestsIdCardEntryAction;

  /// No description provided for @requestsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No requests yet'**
  String get requestsEmptyTitle;

  /// No description provided for @requestsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'File a petition below when you need an exception to the registration rules.'**
  String get requestsEmptyBody;

  /// No description provided for @requestsReasonsRequired.
  ///
  /// In en, this message translates to:
  /// **'Add your reasons before sending.'**
  String get requestsReasonsRequired;

  /// No description provided for @idCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Student ID card'**
  String get idCardTitle;

  /// No description provided for @idCardBreadcrumb.
  ///
  /// In en, this message translates to:
  /// **'ID card'**
  String get idCardBreadcrumb;

  /// No description provided for @idCardActiveCredential.
  ///
  /// In en, this message translates to:
  /// **'Active credential'**
  String get idCardActiveCredential;

  /// No description provided for @idCardRequestFormSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Procure an updated physical student identity card.'**
  String get idCardRequestFormSubtitle;

  /// No description provided for @idCardFirstIssueFormSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Submit a request to have your first card printed.'**
  String get idCardFirstIssueFormSubtitle;

  /// No description provided for @idCardProgrammeLevel.
  ///
  /// In en, this message translates to:
  /// **'{programme} ({level})'**
  String idCardProgrammeLevel(String programme, String level);

  /// No description provided for @idCardStatusNone.
  ///
  /// In en, this message translates to:
  /// **'No active card'**
  String get idCardStatusNone;

  /// No description provided for @idCardStatusRequested.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get idCardStatusRequested;

  /// No description provided for @idCardStatusReadyForCollection.
  ///
  /// In en, this message translates to:
  /// **'Ready for collection'**
  String get idCardStatusReadyForCollection;

  /// No description provided for @idCardStatusCollected.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get idCardStatusCollected;

  /// No description provided for @idCardStatusReplaced.
  ///
  /// In en, this message translates to:
  /// **'Replaced'**
  String get idCardStatusReplaced;

  /// No description provided for @idCardNoActiveBody.
  ///
  /// In en, this message translates to:
  /// **'You do not currently hold an active student ID card. Submit a request below to have your first card printed.'**
  String get idCardNoActiveBody;

  /// No description provided for @idCardPreviousLostBody.
  ///
  /// In en, this message translates to:
  /// **'Your previous card {serial} was reported lost or stolen. Request a replacement card below.'**
  String idCardPreviousLostBody(String serial);

  /// No description provided for @idCardRequestedBody.
  ///
  /// In en, this message translates to:
  /// **'Requested {date} ({reason}). We\'ll notify you when it\'s printed.'**
  String idCardRequestedBody(String date, String reason);

  /// No description provided for @idCardReadyBody.
  ///
  /// In en, this message translates to:
  /// **'Your card is printed. Collect it from the registry with another form of identification.'**
  String get idCardReadyBody;

  /// No description provided for @idCardFeeUnpaidBody.
  ///
  /// In en, this message translates to:
  /// **'Replacement fee: {amount}. Pay it under Payments; the card is printed once it\'s paid.'**
  String idCardFeeUnpaidBody(String amount);

  /// No description provided for @idCardFeePaid.
  ///
  /// In en, this message translates to:
  /// **'Replacement fee paid.'**
  String get idCardFeePaid;

  /// No description provided for @idCardFeeFree.
  ///
  /// In en, this message translates to:
  /// **'Your first card is free.'**
  String get idCardFeeFree;

  /// No description provided for @idCardCollectBy.
  ///
  /// In en, this message translates to:
  /// **'Collect it by {date}.'**
  String idCardCollectBy(String date);

  /// No description provided for @idCardVerificationPending.
  ///
  /// In en, this message translates to:
  /// **'Your verification code is issued when the card is printed.'**
  String get idCardVerificationPending;

  /// No description provided for @idCardCancelRequest.
  ///
  /// In en, this message translates to:
  /// **'Cancel request'**
  String get idCardCancelRequest;

  /// No description provided for @idCardCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this ID card request?'**
  String get idCardCancelTitle;

  /// No description provided for @idCardCancelBody.
  ///
  /// In en, this message translates to:
  /// **'The registry will stop printing {serial}. You can request a card again later.'**
  String idCardCancelBody(String serial);

  /// No description provided for @idCardCancelConfirm.
  ///
  /// In en, this message translates to:
  /// **'Cancel request'**
  String get idCardCancelConfirm;

  /// No description provided for @idCardRequestReplacement.
  ///
  /// In en, this message translates to:
  /// **'Request a replacement'**
  String get idCardRequestReplacement;

  /// No description provided for @idCardRequestYourCard.
  ///
  /// In en, this message translates to:
  /// **'Request your card'**
  String get idCardRequestYourCard;

  /// No description provided for @idCardPhotoHint.
  ///
  /// In en, this message translates to:
  /// **'Your card carries your passport photo. Upload a profile photo before requesting a replacement card.'**
  String get idCardPhotoHint;

  /// No description provided for @idCardPhotoUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload a profile photo'**
  String get idCardPhotoUpload;

  /// No description provided for @idCardReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get idCardReasonLabel;

  /// No description provided for @idCardReasonFirstCard.
  ///
  /// In en, this message translates to:
  /// **'First card'**
  String get idCardReasonFirstCard;

  /// No description provided for @idCardReasonLostOrStolen.
  ///
  /// In en, this message translates to:
  /// **'Lost or stolen'**
  String get idCardReasonLostOrStolen;

  /// No description provided for @idCardReasonDamaged.
  ///
  /// In en, this message translates to:
  /// **'Damaged'**
  String get idCardReasonDamaged;

  /// No description provided for @idCardReasonNameOrProgramme.
  ///
  /// In en, this message translates to:
  /// **'Name or programme update'**
  String get idCardReasonNameOrProgramme;

  /// No description provided for @idCardReplacementFeeLine.
  ///
  /// In en, this message translates to:
  /// **'A replacement costs {amount}.'**
  String idCardReplacementFeeLine(String amount);

  /// No description provided for @idCardFreeBadge.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get idCardFreeBadge;

  /// No description provided for @idCardRequestCard.
  ///
  /// In en, this message translates to:
  /// **'Request card'**
  String get idCardRequestCard;

  /// No description provided for @idCardRequestLockedActive.
  ///
  /// In en, this message translates to:
  /// **'Clear or cancel the pending request to submit anew.'**
  String get idCardRequestLockedActive;

  /// No description provided for @idCardRequestLockedPhoto.
  ///
  /// In en, this message translates to:
  /// **'Action locked until profile photo is approved'**
  String get idCardRequestLockedPhoto;

  /// No description provided for @idCardRequestLockedReason.
  ///
  /// In en, this message translates to:
  /// **'Choose a reason before requesting a card.'**
  String get idCardRequestLockedReason;

  /// No description provided for @idCardRequestedSnack.
  ///
  /// In en, this message translates to:
  /// **'Your ID card request was sent.'**
  String get idCardRequestedSnack;

  /// No description provided for @idCardHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Card history'**
  String get idCardHistoryTitle;

  /// No description provided for @idCardHistoryCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 records} =1{1 record} other{{count} records}}'**
  String idCardHistoryCount(int count);

  /// No description provided for @idCardHistoryEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No cards yet'**
  String get idCardHistoryEmptyTitle;

  /// No description provided for @idCardHistoryEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Your first card is free.'**
  String get idCardHistoryEmptyBody;

  /// No description provided for @idCardHistoryLine.
  ///
  /// In en, this message translates to:
  /// **'{reason} · requested {requested} · expires {expires}'**
  String idCardHistoryLine(String reason, String requested, String expires);

  /// No description provided for @idCardHistoryLineExpired.
  ///
  /// In en, this message translates to:
  /// **'{reason} · requested {requested} · expired {expires}'**
  String idCardHistoryLineExpired(
    String reason,
    String requested,
    String expires,
  );

  /// No description provided for @idCardHistoryFirstCard.
  ///
  /// In en, this message translates to:
  /// **'First card · requested {requested} · expires {expires}'**
  String idCardHistoryFirstCard(String requested, String expires);

  /// No description provided for @idCardAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About ID cards'**
  String get idCardAboutTitle;

  /// No description provided for @idCardAboutBody.
  ///
  /// In en, this message translates to:
  /// **'Your first card is free. Carry it on campus and to examinations. Printing a new card cancels the old one, so report a lost card straight away.'**
  String get idCardAboutBody;

  /// No description provided for @disciplineTitle.
  ///
  /// In en, this message translates to:
  /// **'Disciplinary matters'**
  String get disciplineTitle;

  /// No description provided for @disciplineBreadcrumb.
  ///
  /// In en, this message translates to:
  /// **'Disciplinary matters'**
  String get disciplineBreadcrumb;

  /// No description provided for @disciplineBreadcrumbRecord.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get disciplineBreadcrumbRecord;

  /// No description provided for @disciplineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Cases involving you, their outcome, and any sanctions.'**
  String get disciplineSubtitle;

  /// No description provided for @disciplineEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Disciplinary matters'**
  String get disciplineEntryTitle;

  /// No description provided for @disciplineEntryBody.
  ///
  /// In en, this message translates to:
  /// **'Cases involving you, their outcome, and any sanctions on your record.'**
  String get disciplineEntryBody;

  /// No description provided for @disciplineEntryAction.
  ///
  /// In en, this message translates to:
  /// **'Open discipline'**
  String get disciplineEntryAction;

  /// No description provided for @disciplineCasesTitle.
  ///
  /// In en, this message translates to:
  /// **'Cases'**
  String get disciplineCasesTitle;

  /// No description provided for @disciplineCasesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 recorded} =1{1 recorded} other{{count} recorded}}'**
  String disciplineCasesCount(int count);

  /// No description provided for @disciplineCasesSortedNewest.
  ///
  /// In en, this message translates to:
  /// **'Sorted by newest'**
  String get disciplineCasesSortedNewest;

  /// No description provided for @disciplineSanctionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sanctions'**
  String get disciplineSanctionsTitle;

  /// No description provided for @disciplineSanctionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 recorded} =1{1 recorded} other{{count} recorded}}'**
  String disciplineSanctionsCount(int count);

  /// No description provided for @disciplineSanctionsActiveCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 active} =1{1 active} other{{count} active}}'**
  String disciplineSanctionsActiveCount(int count);

  /// No description provided for @disciplineEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No disciplinary cases'**
  String get disciplineEmptyTitle;

  /// No description provided for @disciplineEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'You have a clean record.'**
  String get disciplineEmptyBody;

  /// No description provided for @disciplineAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About disciplinary records'**
  String get disciplineAboutTitle;

  /// No description provided for @disciplineAboutBody.
  ///
  /// In en, this message translates to:
  /// **'Cases and sanctions recorded under University Disciplinary Statutes remain part of your academic dossier. Active sanctions are enforced across portal functions.'**
  String get disciplineAboutBody;

  /// No description provided for @disciplineStandingActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get disciplineStandingActive;

  /// No description provided for @disciplineStandingSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get disciplineStandingSuspended;

  /// No description provided for @disciplineStandingExpelled.
  ///
  /// In en, this message translates to:
  /// **'Expelled'**
  String get disciplineStandingExpelled;

  /// No description provided for @disciplineSuspendedBanner.
  ///
  /// In en, this message translates to:
  /// **'Your student status is Suspended, so you cannot register, request an ID card or file a request. Contact the registry.'**
  String get disciplineSuspendedBanner;

  /// No description provided for @disciplineCaseStatusUnderInvestigation.
  ///
  /// In en, this message translates to:
  /// **'Under investigation'**
  String get disciplineCaseStatusUnderInvestigation;

  /// No description provided for @disciplineCaseStatusHearingScheduled.
  ///
  /// In en, this message translates to:
  /// **'Hearing scheduled'**
  String get disciplineCaseStatusHearingScheduled;

  /// No description provided for @disciplineCaseStatusDecided.
  ///
  /// In en, this message translates to:
  /// **'Decided'**
  String get disciplineCaseStatusDecided;

  /// No description provided for @disciplineCaseStatusUnderAppeal.
  ///
  /// In en, this message translates to:
  /// **'Under appeal'**
  String get disciplineCaseStatusUnderAppeal;

  /// No description provided for @disciplineSeverityMinor.
  ///
  /// In en, this message translates to:
  /// **'Minor'**
  String get disciplineSeverityMinor;

  /// No description provided for @disciplineSeverityMajor.
  ///
  /// In en, this message translates to:
  /// **'Major'**
  String get disciplineSeverityMajor;

  /// No description provided for @disciplineCategoryExamination.
  ///
  /// In en, this message translates to:
  /// **'Examination misconduct'**
  String get disciplineCategoryExamination;

  /// No description provided for @disciplineCategoryHarassment.
  ///
  /// In en, this message translates to:
  /// **'Harassment'**
  String get disciplineCategoryHarassment;

  /// No description provided for @disciplineFindingLiable.
  ///
  /// In en, this message translates to:
  /// **'Found liable'**
  String get disciplineFindingLiable;

  /// No description provided for @disciplineFindingNotLiable.
  ///
  /// In en, this message translates to:
  /// **'Not liable'**
  String get disciplineFindingNotLiable;

  /// No description provided for @disciplineSanctionWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get disciplineSanctionWarning;

  /// No description provided for @disciplineSanctionProbation.
  ///
  /// In en, this message translates to:
  /// **'Probation'**
  String get disciplineSanctionProbation;

  /// No description provided for @disciplineSanctionSuspension.
  ///
  /// In en, this message translates to:
  /// **'Suspension'**
  String get disciplineSanctionSuspension;

  /// No description provided for @disciplineSanctionExpulsion.
  ///
  /// In en, this message translates to:
  /// **'Expulsion'**
  String get disciplineSanctionExpulsion;

  /// No description provided for @disciplineSanctionActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get disciplineSanctionActive;

  /// No description provided for @disciplineSanctionServed.
  ///
  /// In en, this message translates to:
  /// **'Served'**
  String get disciplineSanctionServed;

  /// No description provided for @disciplineSanctionLifted.
  ///
  /// In en, this message translates to:
  /// **'Lifted'**
  String get disciplineSanctionLifted;

  /// No description provided for @disciplineEvidenceDocument.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get disciplineEvidenceDocument;

  /// No description provided for @disciplineEvidenceStatement.
  ///
  /// In en, this message translates to:
  /// **'Written statement'**
  String get disciplineEvidenceStatement;

  /// No description provided for @disciplineOpenedOn.
  ///
  /// In en, this message translates to:
  /// **'opened {date}'**
  String disciplineOpenedOn(String date);

  /// No description provided for @disciplineCaseMeta.
  ///
  /// In en, this message translates to:
  /// **'{severity} · {category} · {opened}'**
  String disciplineCaseMeta(String severity, String category, String opened);

  /// No description provided for @disciplineCaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Case {reference}'**
  String disciplineCaseTitle(String reference);

  /// No description provided for @disciplineDecidedOn.
  ///
  /// In en, this message translates to:
  /// **'decided {date}'**
  String disciplineDecidedOn(String date);

  /// No description provided for @disciplineHearingScheduledTitle.
  ///
  /// In en, this message translates to:
  /// **'Hearing scheduled'**
  String get disciplineHearingScheduledTitle;

  /// No description provided for @disciplineHearingHeldTitle.
  ///
  /// In en, this message translates to:
  /// **'Hearing held'**
  String get disciplineHearingHeldTitle;

  /// No description provided for @disciplineHearingSessionMandatory.
  ///
  /// In en, this message translates to:
  /// **'Session mandatory'**
  String get disciplineHearingSessionMandatory;

  /// No description provided for @disciplineHearingAtVenue.
  ///
  /// In en, this message translates to:
  /// **'at {venue}'**
  String disciplineHearingAtVenue(String venue);

  /// No description provided for @disciplineAllegationTitle.
  ///
  /// In en, this message translates to:
  /// **'The allegation'**
  String get disciplineAllegationTitle;

  /// No description provided for @disciplineAllegationCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get disciplineAllegationCategory;

  /// No description provided for @disciplineAllegationIncident.
  ///
  /// In en, this message translates to:
  /// **'Incident'**
  String get disciplineAllegationIncident;

  /// No description provided for @disciplineAllegationReportedBy.
  ///
  /// In en, this message translates to:
  /// **'Reported by'**
  String get disciplineAllegationReportedBy;

  /// No description provided for @disciplineIncidentLine.
  ///
  /// In en, this message translates to:
  /// **'{date} · {venue}, during {session}'**
  String disciplineIncidentLine(String date, String venue, String session);

  /// No description provided for @disciplineReportedLine.
  ///
  /// In en, this message translates to:
  /// **'{reporter}, on {date}'**
  String disciplineReportedLine(String reporter, String date);

  /// No description provided for @disciplineEvidenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Evidence on file'**
  String get disciplineEvidenceTitle;

  /// No description provided for @disciplineEvidenceCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 items} =1{1 item} other{{count} items}}'**
  String disciplineEvidenceCount(int count);

  /// No description provided for @disciplineEvidenceInspectHint.
  ///
  /// In en, this message translates to:
  /// **'You may inspect the evidence at the disciplinary office before the hearing.'**
  String get disciplineEvidenceInspectHint;

  /// No description provided for @disciplineAppealTitle.
  ///
  /// In en, this message translates to:
  /// **'Appeal this decision'**
  String get disciplineAppealTitle;

  /// No description provided for @disciplineAppealUntil.
  ///
  /// In en, this message translates to:
  /// **'You can appeal until {date}.'**
  String disciplineAppealUntil(String date);

  /// No description provided for @disciplineAppealWindowDays.
  ///
  /// In en, this message translates to:
  /// **'14 days from the decision.'**
  String get disciplineAppealWindowDays;

  /// No description provided for @disciplineAppealGroundsLabel.
  ///
  /// In en, this message translates to:
  /// **'Grounds of appeal'**
  String get disciplineAppealGroundsLabel;

  /// No description provided for @disciplineAppealGroundsHint.
  ///
  /// In en, this message translates to:
  /// **'Explain why the decision or sanction is wrong, including any new evidence.'**
  String get disciplineAppealGroundsHint;

  /// No description provided for @disciplineAppealGroundsRequired.
  ///
  /// In en, this message translates to:
  /// **'Set out your grounds of appeal in at least {min} characters.'**
  String disciplineAppealGroundsRequired(int min);

  /// No description provided for @disciplineAppealGroundsCounter.
  ///
  /// In en, this message translates to:
  /// **'{count}/{min}'**
  String disciplineAppealGroundsCounter(int count, int min);

  /// No description provided for @disciplineAppealLodge.
  ///
  /// In en, this message translates to:
  /// **'Lodge appeal'**
  String get disciplineAppealLodge;

  /// No description provided for @disciplineAppealOnceNote.
  ///
  /// In en, this message translates to:
  /// **'You can only appeal once. Once lodged, an appeal cannot be edited or withdrawn.'**
  String get disciplineAppealOnceNote;

  /// No description provided for @disciplineAppealClosedTitle.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get disciplineAppealClosedTitle;

  /// No description provided for @disciplineAppealClosedBody.
  ///
  /// In en, this message translates to:
  /// **'The appeal period ended on {date}.'**
  String disciplineAppealClosedBody(String date);

  /// No description provided for @disciplineAppealClosedDetail.
  ///
  /// In en, this message translates to:
  /// **'The decision was made on {date}. The appeal period is fourteen days from the decision.'**
  String disciplineAppealClosedDetail(String date);

  /// No description provided for @disciplineAppealWrittenStill.
  ///
  /// In en, this message translates to:
  /// **'A written appeal may still be delivered to the disciplinary office.'**
  String get disciplineAppealWrittenStill;

  /// No description provided for @disciplineAppealLiableOnly.
  ///
  /// In en, this message translates to:
  /// **'Only a decision finding you liable can be appealed.'**
  String get disciplineAppealLiableOnly;

  /// No description provided for @disciplineAppealLodgedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your appeal'**
  String get disciplineAppealLodgedTitle;

  /// No description provided for @disciplineAppealLodgedOn.
  ///
  /// In en, this message translates to:
  /// **'Lodged {date}'**
  String disciplineAppealLodgedOn(String date);

  /// No description provided for @disciplineAppealAwaiting.
  ///
  /// In en, this message translates to:
  /// **'Awaiting decision'**
  String get disciplineAppealAwaiting;

  /// No description provided for @disciplineAppealFiledBanner.
  ///
  /// In en, this message translates to:
  /// **'Appeal filed · Awaiting Disciplinary Appeals Committee review'**
  String get disciplineAppealFiledBanner;

  /// No description provided for @disciplineAppealAbeyanceNote.
  ///
  /// In en, this message translates to:
  /// **'Sanctions held in abeyance pending appeal outcome under Statute 14(b). Academic participation remains fully active.'**
  String get disciplineAppealAbeyanceNote;

  /// No description provided for @disciplineAppealReviewNote.
  ///
  /// In en, this message translates to:
  /// **'The appeal committee will review it. You will be notified of the outcome.'**
  String get disciplineAppealReviewNote;

  /// No description provided for @disciplineAppealConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Lodge this appeal?'**
  String get disciplineAppealConfirmTitle;

  /// No description provided for @disciplineAppealConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'You can only appeal once. Once submitted, your grounds cannot be edited or withdrawn.'**
  String get disciplineAppealConfirmBody;

  /// No description provided for @disciplineAppealConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Lodge appeal'**
  String get disciplineAppealConfirmAction;

  /// No description provided for @disciplineAppealLodgedSnack.
  ///
  /// In en, this message translates to:
  /// **'Your appeal was lodged.'**
  String get disciplineAppealLodgedSnack;

  /// No description provided for @disciplineDecisionFinalized.
  ///
  /// In en, this message translates to:
  /// **'Decision finalized'**
  String get disciplineDecisionFinalized;

  /// No description provided for @disciplineDecisionFinalizedBody.
  ///
  /// In en, this message translates to:
  /// **'Appeal window closed on {date}. Sanction in effect under Statute 14.'**
  String disciplineDecisionFinalizedBody(String date);

  /// No description provided for @disciplineCaseNotFound.
  ///
  /// In en, this message translates to:
  /// **'This case is not on your record.'**
  String get disciplineCaseNotFound;

  /// No description provided for @disciplineSanctionCaseRef.
  ///
  /// In en, this message translates to:
  /// **'{reference}'**
  String disciplineSanctionCaseRef(String reference);

  /// No description provided for @requestsStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get requestsStatusApproved;

  /// No description provided for @staffApprovalsTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Approvals'**
  String get staffApprovalsTaskTitle;

  /// No description provided for @staffApprovalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration approvals'**
  String get staffApprovalsTitle;

  /// No description provided for @staffApprovalsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Submitted course forms for this semester from the students you advise or oversee.'**
  String get staffApprovalsSubtitle;

  /// No description provided for @staffApprovalsBreadcrumb.
  ///
  /// In en, this message translates to:
  /// **'Course registrations'**
  String get staffApprovalsBreadcrumb;

  /// No description provided for @staffApprovalsBreadcrumbRoot.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staffApprovalsBreadcrumbRoot;

  /// No description provided for @staffApprovalsFilterAwaiting.
  ///
  /// In en, this message translates to:
  /// **'Awaiting approval'**
  String get staffApprovalsFilterAwaiting;

  /// No description provided for @staffApprovalsFilterApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get staffApprovalsFilterApproved;

  /// No description provided for @staffApprovalsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All submissions'**
  String get staffApprovalsFilterAll;

  /// No description provided for @staffApprovalsQueueTitle.
  ///
  /// In en, this message translates to:
  /// **'Action queue'**
  String get staffApprovalsQueueTitle;

  /// No description provided for @staffApprovalsQueueProcessed.
  ///
  /// In en, this message translates to:
  /// **'Processed'**
  String get staffApprovalsQueueProcessed;

  /// No description provided for @staffApprovalsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing waiting'**
  String get staffApprovalsEmptyTitle;

  /// No description provided for @staffApprovalsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'There are no course forms in this filter right now.'**
  String get staffApprovalsEmptyBody;

  /// No description provided for @staffApprovalsFlagAtMinimum.
  ///
  /// In en, this message translates to:
  /// **'At minimum'**
  String get staffApprovalsFlagAtMinimum;

  /// No description provided for @staffApprovalsFlagClash.
  ///
  /// In en, this message translates to:
  /// **'Clash acknowledged'**
  String get staffApprovalsFlagClash;

  /// No description provided for @staffApprovalsReviewForm.
  ///
  /// In en, this message translates to:
  /// **'Review form'**
  String get staffApprovalsReviewForm;

  /// No description provided for @staffApprovalsViewForm.
  ///
  /// In en, this message translates to:
  /// **'View form'**
  String get staffApprovalsViewForm;

  /// No description provided for @staffApprovalsStudyPlan.
  ///
  /// In en, this message translates to:
  /// **'Study plan'**
  String get staffApprovalsStudyPlan;

  /// No description provided for @staffApprovalsAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About approvals'**
  String get staffApprovalsAboutTitle;

  /// No description provided for @staffApprovalsAboutBody.
  ///
  /// In en, this message translates to:
  /// **'Approve or reject pending courses on each student\'s form. Rejected lines need a reason the student will see.'**
  String get staffApprovalsAboutBody;

  /// No description provided for @staffApprovalsRequestsEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Student requests'**
  String get staffApprovalsRequestsEntryTitle;

  /// No description provided for @staffApprovalsRequestsEntryBody.
  ///
  /// In en, this message translates to:
  /// **'Decide overload, waiver, late add/drop, and programme-change petitions.'**
  String get staffApprovalsRequestsEntryBody;

  /// No description provided for @staffApprovalsDecisionTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Course form'**
  String get staffApprovalsDecisionTaskTitle;

  /// No description provided for @staffApprovalsDecisionTitle.
  ///
  /// In en, this message translates to:
  /// **'Course form review'**
  String get staffApprovalsDecisionTitle;

  /// No description provided for @staffApprovalsDirectTitle.
  ///
  /// In en, this message translates to:
  /// **'Department registers courses directly'**
  String get staffApprovalsDirectTitle;

  /// No description provided for @staffApprovalsDirectBody.
  ///
  /// In en, this message translates to:
  /// **'This programme does not use the approval queue. Courses are already on the record.'**
  String get staffApprovalsDirectBody;

  /// No description provided for @staffApprovalsAtMinimumTitle.
  ///
  /// In en, this message translates to:
  /// **'At the unit minimum'**
  String get staffApprovalsAtMinimumTitle;

  /// No description provided for @staffApprovalsCoursesTitle.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get staffApprovalsCoursesTitle;

  /// No description provided for @staffApprovalsSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all pending'**
  String get staffApprovalsSelectAll;

  /// No description provided for @staffApprovalsApproveSelected.
  ///
  /// In en, this message translates to:
  /// **'Approve selected'**
  String get staffApprovalsApproveSelected;

  /// No description provided for @staffApprovalsRejectSelected.
  ///
  /// In en, this message translates to:
  /// **'Reject selected'**
  String get staffApprovalsRejectSelected;

  /// No description provided for @staffApprovalsSelectFirst.
  ///
  /// In en, this message translates to:
  /// **'Select at least one pending course.'**
  String get staffApprovalsSelectFirst;

  /// No description provided for @staffApprovalsRejectCoursesTitle.
  ///
  /// In en, this message translates to:
  /// **'Reject selected courses?'**
  String get staffApprovalsRejectCoursesTitle;

  /// No description provided for @staffApprovalsRejectCoursesConfirm.
  ///
  /// In en, this message translates to:
  /// **'Reject courses'**
  String get staffApprovalsRejectCoursesConfirm;

  /// No description provided for @staffApprovalsRejectReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Note to the student'**
  String get staffApprovalsRejectReasonLabel;

  /// No description provided for @staffApprovalsRejectReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Required. The student sees this word for word.'**
  String get staffApprovalsRejectReasonHint;

  /// No description provided for @staffApprovalsRejectRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Reject this request?'**
  String get staffApprovalsRejectRequestTitle;

  /// No description provided for @staffApprovalsRejectRequestConfirm.
  ///
  /// In en, this message translates to:
  /// **'Reject request'**
  String get staffApprovalsRejectRequestConfirm;

  /// No description provided for @staffApprovalsReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Add a note for the student before rejecting.'**
  String get staffApprovalsReasonRequired;

  /// No description provided for @staffApprovalsRequestsTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Student requests'**
  String get staffApprovalsRequestsTaskTitle;

  /// No description provided for @staffApprovalsRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Student requests'**
  String get staffApprovalsRequestsTitle;

  /// No description provided for @staffApprovalsRequestsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Approving a request applies it straight away: see what each type does before deciding.'**
  String get staffApprovalsRequestsSubtitle;

  /// No description provided for @staffApprovalsRequestsBreadcrumb.
  ///
  /// In en, this message translates to:
  /// **'Student requests'**
  String get staffApprovalsRequestsBreadcrumb;

  /// No description provided for @staffApprovalsRequestsListTitle.
  ///
  /// In en, this message translates to:
  /// **'Pending and decided'**
  String get staffApprovalsRequestsListTitle;

  /// No description provided for @staffApprovalsRequestsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No requests here'**
  String get staffApprovalsRequestsEmptyTitle;

  /// No description provided for @staffApprovalsRequestsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches this filter.'**
  String get staffApprovalsRequestsEmptyBody;

  /// No description provided for @staffApprovalsRequestFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All statuses'**
  String get staffApprovalsRequestFilterAll;

  /// No description provided for @staffApprovalsRequestFilterPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get staffApprovalsRequestFilterPending;

  /// No description provided for @staffApprovalsRequestFilterDecided.
  ///
  /// In en, this message translates to:
  /// **'Decided'**
  String get staffApprovalsRequestFilterDecided;

  /// No description provided for @staffApprovalsStudentNote.
  ///
  /// In en, this message translates to:
  /// **'Student\'s reasons'**
  String get staffApprovalsStudentNote;

  /// No description provided for @staffApprovalsRequestReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Note to the student (needed to reject)'**
  String get staffApprovalsRequestReasonLabel;

  /// No description provided for @staffApprovalsRequestReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Required when rejecting.'**
  String get staffApprovalsRequestReasonHint;

  /// No description provided for @staffApprovalsRequestApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get staffApprovalsRequestApprove;

  /// No description provided for @staffApprovalsRequestReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get staffApprovalsRequestReject;

  /// No description provided for @staffApprovalsAdvisingTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Study plan'**
  String get staffApprovalsAdvisingTaskTitle;

  /// No description provided for @staffApprovalsAdvisingTitle.
  ///
  /// In en, this message translates to:
  /// **'Study plan advising'**
  String get staffApprovalsAdvisingTitle;

  /// No description provided for @staffApprovalsAdvisingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Their intent, not a registration. Advise against unit limits and prerequisites.'**
  String get staffApprovalsAdvisingSubtitle;

  /// No description provided for @staffApprovalsAdvisingProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get staffApprovalsAdvisingProgressTitle;

  /// No description provided for @staffApprovalsAdvisingWarningsTitle.
  ///
  /// In en, this message translates to:
  /// **'What the plan would run into'**
  String get staffApprovalsAdvisingWarningsTitle;

  /// No description provided for @staffApprovalsAdvisingTermsTitle.
  ///
  /// In en, this message translates to:
  /// **'What they mean to take'**
  String get staffApprovalsAdvisingTermsTitle;

  /// No description provided for @staffApprovalsAdviceLabel.
  ///
  /// In en, this message translates to:
  /// **'Your advice'**
  String get staffApprovalsAdviceLabel;

  /// No description provided for @staffApprovalsAdviceHint.
  ///
  /// In en, this message translates to:
  /// **'Notes the student and future advisers can read.'**
  String get staffApprovalsAdviceHint;

  /// No description provided for @staffApprovalsAdviceSave.
  ///
  /// In en, this message translates to:
  /// **'Save advice'**
  String get staffApprovalsAdviceSave;

  /// No description provided for @staffApprovalsAdviceSaved.
  ///
  /// In en, this message translates to:
  /// **'Advice saved.'**
  String get staffApprovalsAdviceSaved;

  /// No description provided for @staffApprovalsAdviceRequired.
  ///
  /// In en, this message translates to:
  /// **'Write advice before saving.'**
  String get staffApprovalsAdviceRequired;

  /// No description provided for @staffRegistryBreadcrumbRoot.
  ///
  /// In en, this message translates to:
  /// **'Registry'**
  String get staffRegistryBreadcrumbRoot;

  /// No description provided for @staffRegistryStudentsBreadcrumb.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get staffRegistryStudentsBreadcrumb;

  /// No description provided for @staffRegistryStudentsTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get staffRegistryStudentsTaskTitle;

  /// No description provided for @staffRegistryStudentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get staffRegistryStudentsTitle;

  /// No description provided for @staffRegistryStudentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Matriculated students and their current academic standing across faculties.'**
  String get staffRegistryStudentsSubtitle;

  /// No description provided for @staffRegistryStudentsListTitle.
  ///
  /// In en, this message translates to:
  /// **'Directory'**
  String get staffRegistryStudentsListTitle;

  /// No description provided for @staffRegistryStudentsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No students match'**
  String get staffRegistryStudentsEmptyTitle;

  /// No description provided for @staffRegistryStudentsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Clear the search or filters and try again.'**
  String get staffRegistryStudentsEmptyBody;

  /// No description provided for @staffRegistryIdCardsEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'ID cards'**
  String get staffRegistryIdCardsEntryTitle;

  /// No description provided for @staffRegistryStatMatriculated.
  ///
  /// In en, this message translates to:
  /// **'Matriculated'**
  String get staffRegistryStatMatriculated;

  /// No description provided for @staffRegistryStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get staffRegistryStatusActive;

  /// No description provided for @staffRegistryStatusSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get staffRegistryStatusSuspended;

  /// No description provided for @staffRegistryStatusWithdrawn.
  ///
  /// In en, this message translates to:
  /// **'Withdrawn'**
  String get staffRegistryStatusWithdrawn;

  /// No description provided for @staffRegistryStatusExpelled.
  ///
  /// In en, this message translates to:
  /// **'Expelled'**
  String get staffRegistryStatusExpelled;

  /// No description provided for @staffRegistryStatusGraduated.
  ///
  /// In en, this message translates to:
  /// **'Graduated'**
  String get staffRegistryStatusGraduated;

  /// No description provided for @staffRegistryFilterAll.
  ///
  /// In en, this message translates to:
  /// **'Any status'**
  String get staffRegistryFilterAll;

  /// No description provided for @staffRegistrySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search name, matric, email, or programme'**
  String get staffRegistrySearchHint;

  /// No description provided for @staffRegistrySearchClear.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get staffRegistrySearchClear;

  /// No description provided for @staffRegistryPromoteAction.
  ///
  /// In en, this message translates to:
  /// **'Batch promote'**
  String get staffRegistryPromoteAction;

  /// No description provided for @staffRegistryPromoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Move the selected students to this level?'**
  String get staffRegistryPromoteTitle;

  /// No description provided for @staffRegistryPromoteLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'New level'**
  String get staffRegistryPromoteLevelLabel;

  /// No description provided for @staffRegistryRecordTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Student record'**
  String get staffRegistryRecordTaskTitle;

  /// No description provided for @staffRegistryRecordTitle.
  ///
  /// In en, this message translates to:
  /// **'Student record'**
  String get staffRegistryRecordTitle;

  /// No description provided for @staffRegistryRecordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Statutory record and registration history.'**
  String get staffRegistryRecordSubtitle;

  /// No description provided for @staffRegistryRecordDetails.
  ///
  /// In en, this message translates to:
  /// **'Statutory record'**
  String get staffRegistryRecordDetails;

  /// No description provided for @staffRegistryNoDegreePlanTitle.
  ///
  /// In en, this message translates to:
  /// **'No degree plan linked'**
  String get staffRegistryNoDegreePlanTitle;

  /// No description provided for @staffRegistryNoDegreePlanBody.
  ///
  /// In en, this message translates to:
  /// **'Link a curriculum before advising or registering this student.'**
  String get staffRegistryNoDegreePlanBody;

  /// No description provided for @staffRegistryFeeOwingTitle.
  ///
  /// In en, this message translates to:
  /// **'Replacement fee unpaid'**
  String get staffRegistryFeeOwingTitle;

  /// No description provided for @staffRegistryFeeOwingBody.
  ///
  /// In en, this message translates to:
  /// **'The student\'s ID card replacement cannot be printed until the fee is paid.'**
  String get staffRegistryFeeOwingBody;

  /// No description provided for @staffRegistryOpenStudyPlan.
  ///
  /// In en, this message translates to:
  /// **'Open study plan'**
  String get staffRegistryOpenStudyPlan;

  /// No description provided for @staffRegistryTermsTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration history'**
  String get staffRegistryTermsTitle;

  /// No description provided for @staffRegistryTermsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No registrations yet'**
  String get staffRegistryTermsEmptyTitle;

  /// No description provided for @staffRegistryTermsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Course registrations will appear here once started.'**
  String get staffRegistryTermsEmptyBody;

  /// No description provided for @staffRegistryTermConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get staffRegistryTermConfirmed;

  /// No description provided for @staffRegistryTermNotConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Provisional'**
  String get staffRegistryTermNotConfirmed;

  /// No description provided for @staffRegistryFieldEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get staffRegistryFieldEmail;

  /// No description provided for @staffRegistryFieldDepartment.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get staffRegistryFieldDepartment;

  /// No description provided for @staffRegistryFieldDegreePlan.
  ///
  /// In en, this message translates to:
  /// **'Degree plan'**
  String get staffRegistryFieldDegreePlan;

  /// No description provided for @staffRegistryFieldDegreePlanNone.
  ///
  /// In en, this message translates to:
  /// **'None linked'**
  String get staffRegistryFieldDegreePlanNone;

  /// No description provided for @staffRegistryFieldEntry.
  ///
  /// In en, this message translates to:
  /// **'Entry'**
  String get staffRegistryFieldEntry;

  /// No description provided for @staffRegistryFieldJamb.
  ///
  /// In en, this message translates to:
  /// **'JAMB number'**
  String get staffRegistryFieldJamb;

  /// No description provided for @staffRegistryFieldMatriculated.
  ///
  /// In en, this message translates to:
  /// **'Matriculated'**
  String get staffRegistryFieldMatriculated;

  /// No description provided for @staffRegistryFieldPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get staffRegistryFieldPhoto;

  /// No description provided for @staffRegistryPhotoVerified.
  ///
  /// In en, this message translates to:
  /// **'Photo verified'**
  String get staffRegistryPhotoVerified;

  /// No description provided for @staffRegistryPhotoMissing.
  ///
  /// In en, this message translates to:
  /// **'No photo on file'**
  String get staffRegistryPhotoMissing;

  /// No description provided for @staffRegistryIdCardsBreadcrumb.
  ///
  /// In en, this message translates to:
  /// **'ID cards'**
  String get staffRegistryIdCardsBreadcrumb;

  /// No description provided for @staffRegistryIdCardsTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'ID cards'**
  String get staffRegistryIdCardsTaskTitle;

  /// No description provided for @staffRegistryIdCardsTitle.
  ///
  /// In en, this message translates to:
  /// **'ID cards'**
  String get staffRegistryIdCardsTitle;

  /// No description provided for @staffRegistryIdCardsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Print requested cards, then hand them over when students collect.'**
  String get staffRegistryIdCardsSubtitle;

  /// No description provided for @staffRegistryIdCardsListTitle.
  ///
  /// In en, this message translates to:
  /// **'Production queue'**
  String get staffRegistryIdCardsListTitle;

  /// No description provided for @staffRegistryIdCardsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No cards here'**
  String get staffRegistryIdCardsEmptyTitle;

  /// No description provided for @staffRegistryIdCardsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Nothing in this tab right now.'**
  String get staffRegistryIdCardsEmptyBody;

  /// No description provided for @staffRegistryIdCardsAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About ID card production'**
  String get staffRegistryIdCardsAboutTitle;

  /// No description provided for @staffRegistryIdCardsAboutBody.
  ///
  /// In en, this message translates to:
  /// **'A replacement cannot be marked printed while unpaid. Expiry and verification codes are issued only when you mark printed.'**
  String get staffRegistryIdCardsAboutBody;

  /// No description provided for @staffRegistryFeeNotRequired.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get staffRegistryFeeNotRequired;

  /// No description provided for @staffRegistryFeeUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get staffRegistryFeeUnpaid;

  /// No description provided for @staffRegistryFeePaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get staffRegistryFeePaid;

  /// No description provided for @staffRegistryBlockedUnpaid.
  ///
  /// In en, this message translates to:
  /// **'The replacement fee isn\'t paid, so this card cannot be printed.'**
  String get staffRegistryBlockedUnpaid;

  /// No description provided for @staffRegistryBlockedNoPhoto.
  ///
  /// In en, this message translates to:
  /// **'No photo on file, so this card cannot be printed.'**
  String get staffRegistryBlockedNoPhoto;

  /// No description provided for @staffRegistryMarkPrinted.
  ///
  /// In en, this message translates to:
  /// **'Mark printed'**
  String get staffRegistryMarkPrinted;

  /// No description provided for @staffRegistryMarkCollected.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get staffRegistryMarkCollected;

  /// No description provided for @staffRegistryPreview.
  ///
  /// In en, this message translates to:
  /// **'View card'**
  String get staffRegistryPreview;

  /// No description provided for @staffRegistryCancelCard.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get staffRegistryCancelCard;

  /// No description provided for @staffRegistryMarkPrintedBlocked.
  ///
  /// In en, this message translates to:
  /// **'Action locked until the fee is paid and a photo is on file.'**
  String get staffRegistryMarkPrintedBlocked;

  /// No description provided for @staffRegistryCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this card request?'**
  String get staffRegistryCancelTitle;

  /// No description provided for @staffRegistryCancelConfirm.
  ///
  /// In en, this message translates to:
  /// **'Cancel request'**
  String get staffRegistryCancelConfirm;

  /// No description provided for @staffRegistryCancelReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get staffRegistryCancelReasonLabel;

  /// No description provided for @staffRegistryCancelReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Required. Kept on the card history.'**
  String get staffRegistryCancelReasonHint;

  /// No description provided for @staffRegistryCancelReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Add a reason before cancelling.'**
  String get staffRegistryCancelReasonRequired;

  /// No description provided for @staffRegistryPreviewTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Print preview'**
  String get staffRegistryPreviewTaskTitle;

  /// No description provided for @staffRegistryPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Card preview'**
  String get staffRegistryPreviewTitle;

  /// No description provided for @staffRegistryPreviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Preview. Mark the card printed to issue its expiry date and verification QR code.'**
  String get staffRegistryPreviewSubtitle;

  /// No description provided for @staffRegistryPreviewCardCaption.
  ///
  /// In en, this message translates to:
  /// **'Student identity card'**
  String get staffRegistryPreviewCardCaption;

  /// No description provided for @staffRegistryPreviewNoExpiry.
  ///
  /// In en, this message translates to:
  /// **'Expires —'**
  String get staffRegistryPreviewNoExpiry;

  /// No description provided for @staffRegistryPreviewStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get staffRegistryPreviewStatus;

  /// No description provided for @staffRegistryPreviewCode.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get staffRegistryPreviewCode;

  /// No description provided for @staffRegistryPreviewNoPhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'No photo on file'**
  String get staffRegistryPreviewNoPhotoTitle;

  /// No description provided for @staffRegistryPreviewBlocked.
  ///
  /// In en, this message translates to:
  /// **'This card cannot be marked printed yet.'**
  String get staffRegistryPreviewBlocked;

  /// No description provided for @staffRegistryPreviewVerify.
  ///
  /// In en, this message translates to:
  /// **'Public verification uses the code issued after Mark printed.'**
  String get staffRegistryPreviewVerify;

  /// No description provided for @verifyIdCardBrandCaption.
  ///
  /// In en, this message translates to:
  /// **'The Legion University'**
  String get verifyIdCardBrandCaption;

  /// No description provided for @verifyIdCardOffice.
  ///
  /// In en, this message translates to:
  /// **'Student Registry'**
  String get verifyIdCardOffice;

  /// No description provided for @verifyIdCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Student ID card check'**
  String get verifyIdCardTitle;

  /// No description provided for @verifyIdCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The result of scanning the QR code on a student ID card.'**
  String get verifyIdCardSubtitle;

  /// No description provided for @verifyIdCardCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get verifyIdCardCodeLabel;

  /// No description provided for @verifyIdCardCodeHint.
  ///
  /// In en, this message translates to:
  /// **'16-character code from the card'**
  String get verifyIdCardCodeHint;

  /// No description provided for @verifyIdCardAction.
  ///
  /// In en, this message translates to:
  /// **'Check card'**
  String get verifyIdCardAction;

  /// No description provided for @verifyIdCardSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in to the portal'**
  String get verifyIdCardSignIn;

  /// No description provided for @verifyIdCardValidTitle.
  ///
  /// In en, this message translates to:
  /// **'Valid card'**
  String get verifyIdCardValidTitle;

  /// No description provided for @verifyIdCardInvalidTitle.
  ///
  /// In en, this message translates to:
  /// **'This card is not valid'**
  String get verifyIdCardInvalidTitle;

  /// No description provided for @verifyIdCardInvalidBody.
  ///
  /// In en, this message translates to:
  /// **'The code matches a card that is no longer valid for the holder.'**
  String get verifyIdCardInvalidBody;

  /// No description provided for @verifyIdCardNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'No card matches this code'**
  String get verifyIdCardNotFoundTitle;

  /// No description provided for @verifyIdCardNotFoundBody.
  ///
  /// In en, this message translates to:
  /// **'Check the code on the card and try again.'**
  String get verifyIdCardNotFoundBody;

  /// No description provided for @verifyIdCardFieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get verifyIdCardFieldName;

  /// No description provided for @verifyIdCardFieldMatric.
  ///
  /// In en, this message translates to:
  /// **'Matric number'**
  String get verifyIdCardFieldMatric;

  /// No description provided for @verifyIdCardFieldProgramme.
  ///
  /// In en, this message translates to:
  /// **'Programme'**
  String get verifyIdCardFieldProgramme;

  /// No description provided for @verifyIdCardFieldSerial.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get verifyIdCardFieldSerial;

  /// No description provided for @verifyIdCardFieldExpires.
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get verifyIdCardFieldExpires;

  /// No description provided for @verifyIdCardPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get verifyIdCardPrivacyTitle;

  /// No description provided for @verifyIdCardPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'This page shows only name, matric number, programme, card number and expiry. It does not show a photograph, email, phone, level, department, case, sanction or fee.'**
  String get verifyIdCardPrivacyBody;

  /// No description provided for @staffApprovalsSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'{count} forms waiting'**
  String staffApprovalsSummaryTitle(int count);

  /// No description provided for @staffApprovalsSummaryBody.
  ///
  /// In en, this message translates to:
  /// **'{count} courses awaiting approval.'**
  String staffApprovalsSummaryBody(int count);

  /// No description provided for @staffApprovalsQueueCount.
  ///
  /// In en, this message translates to:
  /// **'{count} students'**
  String staffApprovalsQueueCount(int count);

  /// No description provided for @staffApprovalsQueuePending.
  ///
  /// In en, this message translates to:
  /// **'{count} courses'**
  String staffApprovalsQueuePending(int count);

  /// No description provided for @staffApprovalsQueueMeta.
  ///
  /// In en, this message translates to:
  /// **'{matricNumber} · {programmeCode} · {level}'**
  String staffApprovalsQueueMeta(
    String matricNumber,
    String programmeCode,
    String level,
  );

  /// No description provided for @staffApprovalsDecisionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{session}'**
  String staffApprovalsDecisionSubtitle(String session);

  /// No description provided for @staffApprovalsAtMinimumBody.
  ///
  /// In en, this message translates to:
  /// **'This student is at the minimum of {minimum} units. Rejecting courses may leave them under the floor.'**
  String staffApprovalsAtMinimumBody(int minimum);

  /// No description provided for @staffApprovalsCoursesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} courses'**
  String staffApprovalsCoursesCount(int count);

  /// No description provided for @staffApprovalsCourseMeta.
  ///
  /// In en, this message translates to:
  /// **'Section {section} · {units} units'**
  String staffApprovalsCourseMeta(String section, int units);

  /// No description provided for @staffApprovalsDecidedBy.
  ///
  /// In en, this message translates to:
  /// **'{name}, {date}'**
  String staffApprovalsDecidedBy(String name, String date);

  /// No description provided for @staffApprovalsSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String staffApprovalsSelectedCount(int count);

  /// No description provided for @staffApprovalsApprovedMessage.
  ///
  /// In en, this message translates to:
  /// **'{count} courses approved.'**
  String staffApprovalsApprovedMessage(int count);

  /// No description provided for @staffApprovalsRejectedMessage.
  ///
  /// In en, this message translates to:
  /// **'{count} courses rejected.'**
  String staffApprovalsRejectedMessage(int count);

  /// No description provided for @staffApprovalsRejectCoursesBody.
  ///
  /// In en, this message translates to:
  /// **'Reject {count} courses for {name}? The student will see your note.'**
  String staffApprovalsRejectCoursesBody(int count, String name);

  /// No description provided for @staffApprovalsRejectRequestBody.
  ///
  /// In en, this message translates to:
  /// **'Reject the request from {name}? The student will see your note.'**
  String staffApprovalsRejectRequestBody(String name);

  /// No description provided for @staffApprovalsRequestsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} requests'**
  String staffApprovalsRequestsCount(int count);

  /// No description provided for @staffApprovalsRequestApprovedMessage.
  ///
  /// In en, this message translates to:
  /// **'Approved for {name}.'**
  String staffApprovalsRequestApprovedMessage(String name);

  /// No description provided for @staffApprovalsRequestRejectedMessage.
  ///
  /// In en, this message translates to:
  /// **'Rejected for {name}.'**
  String staffApprovalsRequestRejectedMessage(String name);

  /// No description provided for @staffApprovalsAdvisingProgressValue.
  ///
  /// In en, this message translates to:
  /// **'{passed} of {threshold} units toward the award'**
  String staffApprovalsAdvisingProgressValue(int passed, int threshold);

  /// No description provided for @staffApprovalsAdvisingPlanned.
  ///
  /// In en, this message translates to:
  /// **'{planned} units planned · {remaining} courses still to pass'**
  String staffApprovalsAdvisingPlanned(int planned, int remaining);

  /// No description provided for @staffApprovalsAdvisingWarningsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} warnings'**
  String staffApprovalsAdvisingWarningsCount(int count);

  /// No description provided for @staffApprovalsAdvisingTermsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} terms'**
  String staffApprovalsAdvisingTermsCount(int count);

  /// No description provided for @staffApprovalsAdvisingTermUnits.
  ///
  /// In en, this message translates to:
  /// **'{planned} of {maximum}'**
  String staffApprovalsAdvisingTermUnits(int planned, int maximum);

  /// No description provided for @staffApprovalsAdvisingOverCeiling.
  ///
  /// In en, this message translates to:
  /// **'Over the unit ceiling of {maximum}. Something must move.'**
  String staffApprovalsAdvisingOverCeiling(int maximum);

  /// No description provided for @staffRegistryIdCardsEntryBody.
  ///
  /// In en, this message translates to:
  /// **'{count} cards in production.'**
  String staffRegistryIdCardsEntryBody(int count);

  /// No description provided for @staffRegistrySelectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String staffRegistrySelectedCount(int count);

  /// No description provided for @staffRegistryStudentsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} students'**
  String staffRegistryStudentsCount(int count);

  /// No description provided for @staffRegistryStudentMeta.
  ///
  /// In en, this message translates to:
  /// **'{matricNumber} · {programmeCode} · {detail}'**
  String staffRegistryStudentMeta(
    String matricNumber,
    String programmeCode,
    String detail,
  );

  /// No description provided for @staffRegistryPromoteBody.
  ///
  /// In en, this message translates to:
  /// **'Move {count} students to a new level?'**
  String staffRegistryPromoteBody(int count);

  /// No description provided for @staffRegistryPromoteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Promote to {level} Level'**
  String staffRegistryPromoteConfirm(int level);

  /// No description provided for @staffRegistryPromotedMessage.
  ///
  /// In en, this message translates to:
  /// **'Moved {count} students to {level} Level.'**
  String staffRegistryPromotedMessage(int count, int level);

  /// No description provided for @staffRegistryTermsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} terms'**
  String staffRegistryTermsCount(int count);

  /// No description provided for @staffRegistryTermMeta.
  ///
  /// In en, this message translates to:
  /// **'{level} · {units} units'**
  String staffRegistryTermMeta(String level, int units);

  /// No description provided for @staffRegistryCourseLine.
  ///
  /// In en, this message translates to:
  /// **'{code} Section {section} · {units} units'**
  String staffRegistryCourseLine(String code, String section, int units);

  /// No description provided for @staffRegistryIdCardsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} cards'**
  String staffRegistryIdCardsCount(int count);

  /// No description provided for @staffRegistryTabRequested.
  ///
  /// In en, this message translates to:
  /// **'Requested ({count})'**
  String staffRegistryTabRequested(int count);

  /// No description provided for @staffRegistryTabReadyForCollection.
  ///
  /// In en, this message translates to:
  /// **'Ready for collection ({count})'**
  String staffRegistryTabReadyForCollection(int count);

  /// No description provided for @staffRegistryTabCollected.
  ///
  /// In en, this message translates to:
  /// **'Collected ({count})'**
  String staffRegistryTabCollected(int count);

  /// No description provided for @staffRegistryRequestedOn.
  ///
  /// In en, this message translates to:
  /// **'Requested {date}'**
  String staffRegistryRequestedOn(String date);

  /// No description provided for @staffRegistryPrintedOn.
  ///
  /// In en, this message translates to:
  /// **'Printed {date}'**
  String staffRegistryPrintedOn(String date);

  /// No description provided for @staffRegistryPrintedMessage.
  ///
  /// In en, this message translates to:
  /// **'{serial} marked ready for collection.'**
  String staffRegistryPrintedMessage(String serial);

  /// No description provided for @staffRegistryCollectedMessage.
  ///
  /// In en, this message translates to:
  /// **'{serial} marked collected.'**
  String staffRegistryCollectedMessage(String serial);

  /// No description provided for @staffRegistryCancelBody.
  ///
  /// In en, this message translates to:
  /// **'Cancel the request for {serial}?'**
  String staffRegistryCancelBody(String serial);

  /// No description provided for @staffRegistryCancelledMessage.
  ///
  /// In en, this message translates to:
  /// **'Cancelled {serial}.'**
  String staffRegistryCancelledMessage(String serial);

  /// No description provided for @staffRegistryPreviewExpires.
  ///
  /// In en, this message translates to:
  /// **'Expires {date}'**
  String staffRegistryPreviewExpires(String date);

  /// No description provided for @navAccommodation.
  ///
  /// In en, this message translates to:
  /// **'Accommodation'**
  String get navAccommodation;

  /// No description provided for @navAccommodationHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navAccommodationHistory;

  /// No description provided for @accommodationBackTooltip.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get accommodationBackTooltip;

  /// No description provided for @accommodationTitle.
  ///
  /// In en, this message translates to:
  /// **'Accommodation'**
  String get accommodationTitle;

  /// No description provided for @accommodationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hostel accommodation for {term}.'**
  String accommodationSubtitle(Object term);

  /// No description provided for @accommodationBreadcrumbStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get accommodationBreadcrumbStudent;

  /// No description provided for @accommodationMatricLevel.
  ///
  /// In en, this message translates to:
  /// **'{matricNumber} · {level} Level'**
  String accommodationMatricLevel(Object level, Object matricNumber);

  /// No description provided for @accommodationBookFor.
  ///
  /// In en, this message translates to:
  /// **'Book for'**
  String get accommodationBookFor;

  /// No description provided for @accommodationEverythingBelow.
  ///
  /// In en, this message translates to:
  /// **'Everything below is for {term}.'**
  String accommodationEverythingBelow(Object term);

  /// No description provided for @accommodationRoomBed.
  ///
  /// In en, this message translates to:
  /// **'Room {room} · Bed {bed}'**
  String accommodationRoomBed(Object bed, Object room);

  /// No description provided for @accommodationBedFull.
  ///
  /// In en, this message translates to:
  /// **'{hostelBlock} · Room {room} · Bed {bed}'**
  String accommodationBedFull(Object bed, Object hostelBlock, Object room);

  /// No description provided for @accommodationRoomOnly.
  ///
  /// In en, this message translates to:
  /// **'{hostelBlock} · Room {room}'**
  String accommodationRoomOnly(Object hostelBlock, Object room);

  /// No description provided for @accommodationBlockRoom.
  ///
  /// In en, this message translates to:
  /// **'{block} · Room {room}'**
  String accommodationBlockRoom(Object block, Object room);

  /// No description provided for @accommodationRoomLine.
  ///
  /// In en, this message translates to:
  /// **'{hostelBlock} · Room {room}'**
  String accommodationRoomLine(Object hostelBlock, Object room);

  /// No description provided for @accommodationDuration.
  ///
  /// In en, this message translates to:
  /// **'{hours} hours and {minutes} minutes'**
  String accommodationDuration(Object hours, Object minutes);

  /// No description provided for @accommodationStatusNotScheduled.
  ///
  /// In en, this message translates to:
  /// **'Not scheduled'**
  String get accommodationStatusNotScheduled;

  /// No description provided for @accommodationStatusNeedsTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms to accept'**
  String get accommodationStatusNeedsTerms;

  /// No description provided for @accommodationStatusBookingOpen.
  ///
  /// In en, this message translates to:
  /// **'Booking open'**
  String get accommodationStatusBookingOpen;

  /// No description provided for @accommodationStatusHeld.
  ///
  /// In en, this message translates to:
  /// **'Reserved, awaiting payment'**
  String get accommodationStatusHeld;

  /// No description provided for @accommodationStatusOffered.
  ///
  /// In en, this message translates to:
  /// **'Offered, awaiting the student'**
  String get accommodationStatusOffered;

  /// No description provided for @accommodationStatusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get accommodationStatusConfirmed;

  /// No description provided for @accommodationStatusCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Checked in'**
  String get accommodationStatusCheckedIn;

  /// No description provided for @accommodationNotScheduledTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking for {term} hasn\'t been scheduled.'**
  String accommodationNotScheduledTitle(Object term);

  /// No description provided for @accommodationNotScheduledBody.
  ///
  /// In en, this message translates to:
  /// **'It is normally published in September. Check back, or ask the housing office.'**
  String get accommodationNotScheduledBody;

  /// No description provided for @accommodationCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'{term} housing calendar'**
  String accommodationCalendarTitle(Object term);

  /// No description provided for @accommodationCalendarBody.
  ///
  /// In en, this message translates to:
  /// **'Booking hasn\'t opened, so these rooms cannot be booked yet.'**
  String get accommodationCalendarBody;

  /// No description provided for @accommodationNeedsTermsTitle.
  ///
  /// In en, this message translates to:
  /// **'Accept the accommodation terms'**
  String get accommodationNeedsTermsTitle;

  /// No description provided for @accommodationNeedsTermsBody.
  ///
  /// In en, this message translates to:
  /// **'Booking for {term} opens once you accept version {version} of the accommodation terms.'**
  String accommodationNeedsTermsBody(Object term, Object version);

  /// No description provided for @accommodationNeedsTermsAction.
  ///
  /// In en, this message translates to:
  /// **'Read and accept the terms'**
  String get accommodationNeedsTermsAction;

  /// No description provided for @accommodationRoomsTitle.
  ///
  /// In en, this message translates to:
  /// **'Rooms you can book'**
  String get accommodationRoomsTitle;

  /// No description provided for @accommodationRoomsVisible.
  ///
  /// In en, this message translates to:
  /// **'{count} rooms visible'**
  String accommodationRoomsVisible(Object count);

  /// No description provided for @accommodationRoomsIntro.
  ///
  /// In en, this message translates to:
  /// **'Beds are held for you until the fee is paid. You get the first free bed in the room.'**
  String get accommodationRoomsIntro;

  /// No description provided for @accommodationRoomsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search hostel, block or room'**
  String get accommodationRoomsSearchHint;

  /// No description provided for @accommodationRoomsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No rooms to show'**
  String get accommodationRoomsEmptyTitle;

  /// No description provided for @accommodationRoomsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'No room matches, or every room is full. Check back, or ask the housing office about the waitlist.'**
  String get accommodationRoomsEmptyBody;

  /// No description provided for @accommodationRoomsFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Hostels are filtered for you'**
  String get accommodationRoomsFilterTitle;

  /// No description provided for @accommodationRoomsFilterBody.
  ///
  /// In en, this message translates to:
  /// **'Hostels that are not open to your gender, programme or level are left out automatically.'**
  String get accommodationRoomsFilterBody;

  /// No description provided for @accommodationRoomsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get accommodationRoomsPageTitle;

  /// No description provided for @accommodationRoomsClosedTitle.
  ///
  /// In en, this message translates to:
  /// **'Rooms are not open for booking'**
  String get accommodationRoomsClosedTitle;

  /// No description provided for @accommodationRoomsClosedBody.
  ///
  /// In en, this message translates to:
  /// **'{term} is not open for booking, so there are no rooms to choose from.'**
  String accommodationRoomsClosedBody(Object term);

  /// No description provided for @accommodationRoomsBackToHub.
  ///
  /// In en, this message translates to:
  /// **'Back to accommodation'**
  String get accommodationRoomsBackToHub;

  /// No description provided for @accommodationFreeBeds.
  ///
  /// In en, this message translates to:
  /// **'{count} free'**
  String accommodationFreeBeds(Object count);

  /// No description provided for @accommodationOfBeds.
  ///
  /// In en, this message translates to:
  /// **'of {total} beds'**
  String accommodationOfBeds(Object total);

  /// No description provided for @accommodationPerTerm.
  ///
  /// In en, this message translates to:
  /// **'/ term'**
  String get accommodationPerTerm;

  /// No description provided for @accommodationSingleSlotNote.
  ///
  /// In en, this message translates to:
  /// **'Single remaining slot. Roommate pairing is unavailable.'**
  String get accommodationSingleSlotNote;

  /// No description provided for @accommodationBookRoom.
  ///
  /// In en, this message translates to:
  /// **'Book room'**
  String get accommodationBookRoom;

  /// No description provided for @accommodationRoomOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get accommodationRoomOpen;

  /// No description provided for @accommodationRoomSingleSlot.
  ///
  /// In en, this message translates to:
  /// **'Last bed'**
  String get accommodationRoomSingleSlot;

  /// No description provided for @accommodationRoomUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get accommodationRoomUnavailable;

  /// No description provided for @accommodationRoomMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get accommodationRoomMaintenance;

  /// No description provided for @accommodationHoldTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm room hold'**
  String get accommodationHoldTitle;

  /// No description provided for @accommodationHoldSession.
  ///
  /// In en, this message translates to:
  /// **'Term'**
  String get accommodationHoldSession;

  /// No description provided for @accommodationHoldFee.
  ///
  /// In en, this message translates to:
  /// **'Bed fee'**
  String get accommodationHoldFee;

  /// No description provided for @accommodationHoldExpiry.
  ///
  /// In en, this message translates to:
  /// **'Hold expires'**
  String get accommodationHoldExpiry;

  /// No description provided for @accommodationHoldMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes after issue'**
  String accommodationHoldMinutes(Object minutes);

  /// No description provided for @accommodationHoldBody.
  ///
  /// In en, this message translates to:
  /// **'Continuing raises an invoice in your payments ledger straight away. The bed stays held for you while payment is confirmed.'**
  String get accommodationHoldBody;

  /// No description provided for @accommodationHoldConfirm.
  ///
  /// In en, this message translates to:
  /// **'Raise invoice and hold bed'**
  String get accommodationHoldConfirm;

  /// No description provided for @accommodationHoldCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel selection'**
  String get accommodationHoldCancel;

  /// No description provided for @accommodationPortalLock.
  ///
  /// In en, this message translates to:
  /// **'Portal lock'**
  String get accommodationPortalLock;

  /// No description provided for @accommodationLeftToPay.
  ///
  /// In en, this message translates to:
  /// **'{duration} left to pay'**
  String accommodationLeftToPay(Object duration);

  /// No description provided for @accommodationLeftToAnswer.
  ///
  /// In en, this message translates to:
  /// **'{duration} left to answer'**
  String accommodationLeftToAnswer(Object duration);

  /// No description provided for @accommodationLockLapses.
  ///
  /// In en, this message translates to:
  /// **'The hold lapses automatically at the deadline.'**
  String get accommodationLockLapses;

  /// No description provided for @accommodationTotalFee.
  ///
  /// In en, this message translates to:
  /// **'Total allocation fee'**
  String get accommodationTotalFee;

  /// No description provided for @accommodationSessionFee.
  ///
  /// In en, this message translates to:
  /// **'Total session fee'**
  String get accommodationSessionFee;

  /// No description provided for @accommodationPayBy.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount} by {date}.'**
  String accommodationPayBy(Object amount, Object date);

  /// No description provided for @accommodationGraceTitle.
  ///
  /// In en, this message translates to:
  /// **'Grace period clause'**
  String get accommodationGraceTitle;

  /// No description provided for @accommodationGraceBody.
  ///
  /// In en, this message translates to:
  /// **'If it is late, the bed is still kept until {date} and then released. A fee paid during that grace still confirms the bed.'**
  String accommodationGraceBody(Object date);

  /// No description provided for @accommodationInvoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice {reference}'**
  String accommodationInvoice(Object reference);

  /// No description provided for @accommodationOpenPayments.
  ///
  /// In en, this message translates to:
  /// **'Open in Payments'**
  String get accommodationOpenPayments;

  /// No description provided for @accommodationPay.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount}'**
  String accommodationPay(Object amount);

  /// No description provided for @accommodationCancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel booking'**
  String get accommodationCancelBooking;

  /// No description provided for @accommodationCancelWalletNote.
  ///
  /// In en, this message translates to:
  /// **'If you cancel, anything you have paid goes to your wallet — it is not refunded to your card.'**
  String get accommodationCancelWalletNote;

  /// No description provided for @accommodationCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this booking?'**
  String get accommodationCancelTitle;

  /// No description provided for @accommodationCancelBody.
  ///
  /// In en, this message translates to:
  /// **'Cancelling releases {bed} straight away and it goes to the next student. Anything you have paid goes to your wallet.'**
  String accommodationCancelBody(Object bed);

  /// No description provided for @accommodationCancelConfirm.
  ///
  /// In en, this message translates to:
  /// **'Cancel booking'**
  String get accommodationCancelConfirm;

  /// No description provided for @accommodationCancelKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep my allocation'**
  String get accommodationCancelKeep;

  /// No description provided for @accommodationCancelConfirmedTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this booking and release the bed?'**
  String get accommodationCancelConfirmedTitle;

  /// No description provided for @accommodationCancelFreeBody.
  ///
  /// In en, this message translates to:
  /// **'There is no fee to refund. You lose the bed and it goes to the next student.'**
  String get accommodationCancelFreeBody;

  /// No description provided for @accommodationCancelPaidBody.
  ///
  /// In en, this message translates to:
  /// **'You lose the bed and it goes to the next student. What you paid goes to your wallet, less any cancellation charge.'**
  String get accommodationCancelPaidBody;

  /// No description provided for @accommodationCancelForfeit.
  ///
  /// In en, this message translates to:
  /// **'Confirm forfeiture'**
  String get accommodationCancelForfeit;

  /// No description provided for @accommodationCancelKeepBed.
  ///
  /// In en, this message translates to:
  /// **'Keep bed'**
  String get accommodationCancelKeepBed;

  /// No description provided for @accommodationSessionCoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Session booking'**
  String get accommodationSessionCoverTitle;

  /// No description provided for @accommodationSessionCoverBody.
  ///
  /// In en, this message translates to:
  /// **'One booking covers {first} and {second}: the same bed throughout, invoiced once.'**
  String accommodationSessionCoverBody(Object first, Object second);

  /// No description provided for @accommodationWaitlistOffer.
  ///
  /// In en, this message translates to:
  /// **'Waitlist allocation'**
  String get accommodationWaitlistOffer;

  /// No description provided for @accommodationOfferReference.
  ///
  /// In en, this message translates to:
  /// **'Offer #{reference}'**
  String accommodationOfferReference(Object reference);

  /// No description provided for @accommodationAnswerOnce.
  ///
  /// In en, this message translates to:
  /// **'You can only answer this once. If you do nothing, it is offered to the next student.'**
  String get accommodationAnswerOnce;

  /// No description provided for @accommodationOfferBody.
  ///
  /// In en, this message translates to:
  /// **'This bed is offered to you from the waitlist. It is not yours, and nothing is charged, until you accept. Answer by {date} or it goes to the next student.'**
  String accommodationOfferBody(Object date);

  /// No description provided for @accommodationOtherTermUnaffected.
  ///
  /// In en, this message translates to:
  /// **'Your bed in {term} is not affected by this.'**
  String accommodationOtherTermUnaffected(Object term);

  /// No description provided for @accommodationAcceptRaises.
  ///
  /// In en, this message translates to:
  /// **'Accepting raises an invoice of {amount}.'**
  String accommodationAcceptRaises(Object amount);

  /// No description provided for @accommodationAcceptBed.
  ///
  /// In en, this message translates to:
  /// **'Accept the bed'**
  String get accommodationAcceptBed;

  /// No description provided for @accommodationDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get accommodationDecline;

  /// No description provided for @accommodationDeclineTitle.
  ///
  /// In en, this message translates to:
  /// **'Decline this bed?'**
  String get accommodationDeclineTitle;

  /// No description provided for @accommodationDeclineBody.
  ///
  /// In en, this message translates to:
  /// **'You leave the waitlist and it goes to the next student. This cannot be reversed.'**
  String get accommodationDeclineBody;

  /// No description provided for @accommodationDeclineConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm decline'**
  String get accommodationDeclineConfirm;

  /// No description provided for @accommodationDeclineKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep my offer'**
  String get accommodationDeclineKeep;

  /// No description provided for @accommodationOtherOffersTitle.
  ///
  /// In en, this message translates to:
  /// **'How other offers work'**
  String get accommodationOtherOffersTitle;

  /// No description provided for @accommodationOtherOffersRoommate.
  ///
  /// In en, this message translates to:
  /// **'Roommate named you: a bed reserved by an approved room buddy. You must confirm, or it is released.'**
  String get accommodationOtherOffersRoommate;

  /// No description provided for @accommodationOtherOffersRetain.
  ///
  /// In en, this message translates to:
  /// **'Keeping your bed from last term: a priority booking window before booking opens to everybody, or it is released.'**
  String get accommodationOtherOffersRetain;

  /// No description provided for @accommodationScholarshipQuota.
  ///
  /// In en, this message translates to:
  /// **'Scholarship quota'**
  String get accommodationScholarshipQuota;

  /// No description provided for @accommodationYoursFor.
  ///
  /// In en, this message translates to:
  /// **'{bed} is yours for {term}.'**
  String accommodationYoursFor(Object bed, Object term);

  /// No description provided for @accommodationSlipCode.
  ///
  /// In en, this message translates to:
  /// **'Slip code'**
  String get accommodationSlipCode;

  /// No description provided for @accommodationSlipCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy slip code'**
  String get accommodationSlipCopy;

  /// No description provided for @accommodationSlipCopied.
  ///
  /// In en, this message translates to:
  /// **'Slip code copied.'**
  String get accommodationSlipCopied;

  /// No description provided for @accommodationSlipHint.
  ///
  /// In en, this message translates to:
  /// **'Bring your slip and your ID card to the hall office when you check in.'**
  String get accommodationSlipHint;

  /// No description provided for @accommodationSlipDownload.
  ///
  /// In en, this message translates to:
  /// **'Allocation slip'**
  String get accommodationSlipDownload;

  /// No description provided for @accommodationSlipDownloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download allocation slip (PDF)'**
  String get accommodationSlipDownloadPdf;

  /// No description provided for @accommodationPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get accommodationPrice;

  /// No description provided for @accommodationPriceFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get accommodationPriceFree;

  /// No description provided for @accommodationFreeNote.
  ///
  /// In en, this message translates to:
  /// **'A scholarship exemption applies. No fee is due.'**
  String get accommodationFreeNote;

  /// No description provided for @accommodationOfficialResident.
  ///
  /// In en, this message translates to:
  /// **'Official resident'**
  String get accommodationOfficialResident;

  /// No description provided for @accommodationResidentDesignated.
  ///
  /// In en, this message translates to:
  /// **'Your official designated room is {bed}.'**
  String accommodationResidentDesignated(Object bed);

  /// No description provided for @accommodationCheckedInLine.
  ///
  /// In en, this message translates to:
  /// **'Checked in {date}. Your official designated room is {bed}.'**
  String accommodationCheckedInLine(Object bed, Object date);

  /// No description provided for @accommodationClearanceHint.
  ///
  /// In en, this message translates to:
  /// **'Present this slip code or your student ID card at the porter lodge or the gate when asked.'**
  String get accommodationClearanceHint;

  /// No description provided for @accommodationResidenceRecord.
  ///
  /// In en, this message translates to:
  /// **'Residence record'**
  String get accommodationResidenceRecord;

  /// No description provided for @accommodationCheckInDate.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get accommodationCheckInDate;

  /// No description provided for @accommodationTenancyTerm.
  ///
  /// In en, this message translates to:
  /// **'Tenancy term'**
  String get accommodationTenancyTerm;

  /// No description provided for @accommodationValidUntil.
  ///
  /// In en, this message translates to:
  /// **'Valid until {date}'**
  String accommodationValidUntil(Object date);

  /// No description provided for @accommodationKeyTag.
  ///
  /// In en, this message translates to:
  /// **'Key tag'**
  String get accommodationKeyTag;

  /// No description provided for @accommodationLocker.
  ///
  /// In en, this message translates to:
  /// **'Locker'**
  String get accommodationLocker;

  /// No description provided for @accommodationPorterTitle.
  ///
  /// In en, this message translates to:
  /// **'{hostel} porter lodge'**
  String accommodationPorterTitle(Object hostel);

  /// No description provided for @accommodationPorterDetail.
  ///
  /// In en, this message translates to:
  /// **'Campus ext. #41'**
  String get accommodationPorterDetail;

  /// No description provided for @accommodationPorterBody.
  ///
  /// In en, this message translates to:
  /// **'For maintenance requests, plumbing checks or a replacement key, tell the porter on duty or call the extension.'**
  String get accommodationPorterBody;

  /// No description provided for @accommodationNextTitle.
  ///
  /// In en, this message translates to:
  /// **'What happens next'**
  String get accommodationNextTitle;

  /// No description provided for @accommodationNextStage.
  ///
  /// In en, this message translates to:
  /// **'Stage {stage} of {total}'**
  String accommodationNextStage(Object stage, Object total);

  /// No description provided for @accommodationStepBooked.
  ///
  /// In en, this message translates to:
  /// **'Booked'**
  String get accommodationStepBooked;

  /// No description provided for @accommodationStepBookedBody.
  ///
  /// In en, this message translates to:
  /// **'The bed is reserved for you in the hostel inventory.'**
  String get accommodationStepBookedBody;

  /// No description provided for @accommodationStepPay.
  ///
  /// In en, this message translates to:
  /// **'Pay the fee'**
  String get accommodationStepPay;

  /// No description provided for @accommodationStepPaid.
  ///
  /// In en, this message translates to:
  /// **'Fee paid'**
  String get accommodationStepPaid;

  /// No description provided for @accommodationStepCleared.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get accommodationStepCleared;

  /// No description provided for @accommodationStepBy.
  ///
  /// In en, this message translates to:
  /// **'By {date}'**
  String accommodationStepBy(Object date);

  /// No description provided for @accommodationStepFrom.
  ///
  /// In en, this message translates to:
  /// **'From {date}'**
  String accommodationStepFrom(Object date);

  /// No description provided for @accommodationStepPayBody.
  ///
  /// In en, this message translates to:
  /// **'Paying the fee confirms your bed and issues your allocation slip.'**
  String get accommodationStepPayBody;

  /// No description provided for @accommodationStepClearedBody.
  ///
  /// In en, this message translates to:
  /// **'Cleared straight away by your scholarship exemption.'**
  String get accommodationStepClearedBody;

  /// No description provided for @accommodationStepCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Check in at the hall office'**
  String get accommodationStepCheckIn;

  /// No description provided for @accommodationStepCheckInBody.
  ///
  /// In en, this message translates to:
  /// **'Collect your key from the hall warden with your slip and ID card.'**
  String get accommodationStepCheckInBody;

  /// No description provided for @accommodationSwapIncoming.
  ///
  /// In en, this message translates to:
  /// **'Incoming proposal'**
  String get accommodationSwapIncoming;

  /// No description provided for @accommodationSwapExpires.
  ///
  /// In en, this message translates to:
  /// **'Exp: {date}'**
  String accommodationSwapExpires(Object date);

  /// No description provided for @accommodationSwapBody.
  ///
  /// In en, this message translates to:
  /// **'The student in {bed} has asked to swap beds with you. Swap beds? Any difference in price is invoiced or credited to your wallet.'**
  String accommodationSwapBody(Object bed);

  /// No description provided for @accommodationSwapAccept.
  ///
  /// In en, this message translates to:
  /// **'Swap'**
  String get accommodationSwapAccept;

  /// No description provided for @accommodationSwapDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get accommodationSwapDecline;

  /// No description provided for @accommodationSwapTitle.
  ///
  /// In en, this message translates to:
  /// **'Swap beds with another student'**
  String get accommodationSwapTitle;

  /// No description provided for @accommodationSwapIntro.
  ///
  /// In en, this message translates to:
  /// **'Enter the matric number of the student you want to swap with. Both of you must hold a reserved or confirmed bed in the same term.'**
  String get accommodationSwapIntro;

  /// No description provided for @accommodationSwapMatricLabel.
  ///
  /// In en, this message translates to:
  /// **'Their matric number'**
  String get accommodationSwapMatricLabel;

  /// No description provided for @accommodationSwapMatricHint.
  ///
  /// In en, this message translates to:
  /// **'25/CSC/0202'**
  String get accommodationSwapMatricHint;

  /// No description provided for @accommodationSwapVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get accommodationSwapVerify;

  /// No description provided for @accommodationSwapNotFound.
  ///
  /// In en, this message translates to:
  /// **'No student with a bed this term has that matric number.'**
  String get accommodationSwapNotFound;

  /// No description provided for @accommodationSwapFound.
  ///
  /// In en, this message translates to:
  /// **'Found student: {name}'**
  String accommodationSwapFound(Object name);

  /// No description provided for @accommodationSwapPropose.
  ///
  /// In en, this message translates to:
  /// **'Propose swap'**
  String get accommodationSwapPropose;

  /// No description provided for @accommodationTermsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Accommodation terms'**
  String get accommodationTermsPageTitle;

  /// No description provided for @accommodationTermsGovernance.
  ///
  /// In en, this message translates to:
  /// **'Residential code and tenancy'**
  String get accommodationTermsGovernance;

  /// No description provided for @accommodationTermsHeadline.
  ///
  /// In en, this message translates to:
  /// **'Accommodation terms'**
  String get accommodationTermsHeadline;

  /// No description provided for @accommodationTermsGate.
  ///
  /// In en, this message translates to:
  /// **'You must accept these terms before you can book a room.'**
  String get accommodationTermsGate;

  /// No description provided for @accommodationTermsTitle.
  ///
  /// In en, this message translates to:
  /// **'The agreement'**
  String get accommodationTermsTitle;

  /// No description provided for @accommodationTermsVersion.
  ///
  /// In en, this message translates to:
  /// **'v{version}'**
  String accommodationTermsVersion(Object version);

  /// No description provided for @accommodationTermsIntro.
  ///
  /// In en, this message translates to:
  /// **'Version {version}. Accept them to book a room for {term}.'**
  String accommodationTermsIntro(Object term, Object version);

  /// No description provided for @accommodationTermsCheckbox.
  ///
  /// In en, this message translates to:
  /// **'I have read and accept the accommodation terms.'**
  String get accommodationTermsCheckbox;

  /// No description provided for @accommodationTermsTickError.
  ///
  /// In en, this message translates to:
  /// **'Tick the box to accept the accommodation terms.'**
  String get accommodationTermsTickError;

  /// No description provided for @accommodationTermsAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept terms'**
  String get accommodationTermsAccept;

  /// No description provided for @accommodationTermsAccepted.
  ///
  /// In en, this message translates to:
  /// **'You have accepted version {version} of the accommodation terms.'**
  String accommodationTermsAccepted(Object version);

  /// No description provided for @accommodationTermsRecordNote.
  ///
  /// In en, this message translates to:
  /// **'Accepting records this version and the date against your account.'**
  String get accommodationTermsRecordNote;

  /// No description provided for @accommodationTermsSeal.
  ///
  /// In en, this message translates to:
  /// **'Deanery of Student Affairs · {reference}'**
  String accommodationTermsSeal(Object reference);

  /// No description provided for @accommodationClauseLoadBearing.
  ///
  /// In en, this message translates to:
  /// **'If the fee is late, the bed is released.'**
  String get accommodationClauseLoadBearing;

  /// No description provided for @accommodationHistoryLinkTitle.
  ///
  /// In en, this message translates to:
  /// **'Accommodation history'**
  String get accommodationHistoryLinkTitle;

  /// No description provided for @accommodationHistoryLinkBody.
  ///
  /// In en, this message translates to:
  /// **'Rooms and beds you held in earlier terms.'**
  String get accommodationHistoryLinkBody;

  /// No description provided for @accommodationHistoryNoCurrent.
  ///
  /// In en, this message translates to:
  /// **'No current allocation'**
  String get accommodationHistoryNoCurrent;

  /// No description provided for @accommodationHistoryNoBed.
  ///
  /// In en, this message translates to:
  /// **'No bed allocated for {term}'**
  String accommodationHistoryNoBed(Object term);

  /// No description provided for @accommodationHistoryNoBedBody.
  ///
  /// In en, this message translates to:
  /// **'The allocation window may be closed, or you have not applied for a bed. When a waitlist offer or a booking window opens, it will appear here.'**
  String get accommodationHistoryNoBedBody;

  /// No description provided for @accommodationHistoryCurrentBody.
  ///
  /// In en, this message translates to:
  /// **'This is your bed for the selected term.'**
  String get accommodationHistoryCurrentBody;

  /// No description provided for @accommodationHistoryOpenings.
  ///
  /// In en, this message translates to:
  /// **'View housing openings and notices'**
  String get accommodationHistoryOpenings;

  /// No description provided for @accommodationHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Accommodation history'**
  String get accommodationHistoryTitle;

  /// No description provided for @accommodationHistoryCount.
  ///
  /// In en, this message translates to:
  /// **'{count} records'**
  String accommodationHistoryCount(Object count);

  /// No description provided for @accommodationHistoryIntro.
  ///
  /// In en, this message translates to:
  /// **'Rooms and beds you held in earlier terms. Use this record for clearance or proof of earlier residence.'**
  String get accommodationHistoryIntro;

  /// No description provided for @accommodationHistoryBed.
  ///
  /// In en, this message translates to:
  /// **'{hostelBlock} / Room {room} · Bed {bed}'**
  String accommodationHistoryBed(Object bed, Object hostelBlock, Object room);

  /// No description provided for @accommodationHistorySession.
  ///
  /// In en, this message translates to:
  /// **'Session {label}'**
  String accommodationHistorySession(Object label);

  /// No description provided for @accommodationHistoryCheckedOut.
  ///
  /// In en, this message translates to:
  /// **'Checked out'**
  String get accommodationHistoryCheckedOut;

  /// No description provided for @accommodationHistoryCancelledCharge.
  ///
  /// In en, this message translates to:
  /// **'Cancelled with a charge'**
  String get accommodationHistoryCancelledCharge;

  /// No description provided for @accommodationHistoryCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get accommodationHistoryCancelled;

  /// No description provided for @accommodationHistoryExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get accommodationHistoryExpired;

  /// No description provided for @accommodationHistoryEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No previous accommodation'**
  String get accommodationHistoryEmptyTitle;

  /// No description provided for @accommodationHistoryEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'You have not held a bed in a hostel before.'**
  String get accommodationHistoryEmptyBody;

  /// No description provided for @accommodationHistoryExport.
  ///
  /// In en, this message translates to:
  /// **'Export accommodation history'**
  String get accommodationHistoryExport;

  /// No description provided for @accommodationHistoryDisplaying.
  ///
  /// In en, this message translates to:
  /// **'Showing all {count} past records.'**
  String accommodationHistoryDisplaying(Object count);

  /// No description provided for @accommodationSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Student welfare and housing directorate'**
  String get accommodationSupportTitle;

  /// No description provided for @accommodationSupportExtension.
  ///
  /// In en, this message translates to:
  /// **'Ext. #41'**
  String get accommodationSupportExtension;

  /// No description provided for @accommodationSupportCall.
  ///
  /// In en, this message translates to:
  /// **'Call the directorate'**
  String get accommodationSupportCall;

  /// No description provided for @accommodationNoticeTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms accepted. Booking is open.'**
  String get accommodationNoticeTerms;

  /// No description provided for @accommodationNoticeHeld.
  ///
  /// In en, this message translates to:
  /// **'Bed held. Pay before the deadline to confirm it.'**
  String get accommodationNoticeHeld;

  /// No description provided for @accommodationNoticeCancelled.
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled and the bed released.'**
  String get accommodationNoticeCancelled;

  /// No description provided for @accommodationNoticeAccepted.
  ///
  /// In en, this message translates to:
  /// **'Offer accepted. An invoice has been raised.'**
  String get accommodationNoticeAccepted;

  /// No description provided for @accommodationNoticeDeclined.
  ///
  /// In en, this message translates to:
  /// **'Offer declined. You have left the waitlist.'**
  String get accommodationNoticeDeclined;

  /// No description provided for @accommodationNoticeSwapDone.
  ///
  /// In en, this message translates to:
  /// **'Beds swapped.'**
  String get accommodationNoticeSwapDone;

  /// No description provided for @accommodationNoticeSwapDeclined.
  ///
  /// In en, this message translates to:
  /// **'Swap declined.'**
  String get accommodationNoticeSwapDeclined;

  /// No description provided for @accommodationNoticeSwapSent.
  ///
  /// In en, this message translates to:
  /// **'Swap proposal sent.'**
  String get accommodationNoticeSwapSent;

  /// No description provided for @housingTaskBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Housing Directorate'**
  String get housingTaskBarTitle;

  /// No description provided for @housingTaskBarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Staff · Accommodation'**
  String get housingTaskBarSubtitle;

  /// No description provided for @housingBreadcrumbRoot.
  ///
  /// In en, this message translates to:
  /// **'Housing'**
  String get housingBreadcrumbRoot;

  /// No description provided for @housingSave.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get housingSave;

  /// No description provided for @housingNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get housingNone;

  /// No description provided for @housingConfirmKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep as it is'**
  String get housingConfirmKeep;

  /// No description provided for @housingDaysSuffix.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get housingDaysSuffix;

  /// No description provided for @housingPercentSign.
  ///
  /// In en, this message translates to:
  /// **'%'**
  String get housingPercentSign;

  /// No description provided for @housingHours.
  ///
  /// In en, this message translates to:
  /// **'{count} hours'**
  String housingHours(Object count);

  /// No description provided for @housingDays.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String housingDays(Object count);

  /// No description provided for @housingBeds.
  ///
  /// In en, this message translates to:
  /// **'{count} beds'**
  String housingBeds(Object count);

  /// No description provided for @housingPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String housingPercent(Object percent);

  /// No description provided for @housingFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get housingFilterAll;

  /// No description provided for @housingStateHeld.
  ///
  /// In en, this message translates to:
  /// **'Held'**
  String get housingStateHeld;

  /// No description provided for @housingStateOffered.
  ///
  /// In en, this message translates to:
  /// **'Offered'**
  String get housingStateOffered;

  /// No description provided for @housingStateConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get housingStateConfirmed;

  /// No description provided for @housingStateCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Checked in'**
  String get housingStateCheckedIn;

  /// No description provided for @housingStateCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get housingStateCancelled;

  /// No description provided for @housingMethodStudent.
  ///
  /// In en, this message translates to:
  /// **'Booked by student'**
  String get housingMethodStudent;

  /// No description provided for @housingMethodByHand.
  ///
  /// In en, this message translates to:
  /// **'By hand'**
  String get housingMethodByHand;

  /// No description provided for @housingMethodSpreadsheet.
  ///
  /// In en, this message translates to:
  /// **'Spreadsheet'**
  String get housingMethodSpreadsheet;

  /// No description provided for @housingMethodAutomatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get housingMethodAutomatic;

  /// No description provided for @housingMethodDraw.
  ///
  /// In en, this message translates to:
  /// **'Draw'**
  String get housingMethodDraw;

  /// No description provided for @housingMethodKeepMyRoom.
  ///
  /// In en, this message translates to:
  /// **'Keep my room'**
  String get housingMethodKeepMyRoom;

  /// No description provided for @housingGenderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female hostel'**
  String get housingGenderFemale;

  /// No description provided for @housingGenderMale.
  ///
  /// In en, this message translates to:
  /// **'Male hostel'**
  String get housingGenderMale;

  /// No description provided for @housingGenderMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed hostel'**
  String get housingGenderMixed;

  /// No description provided for @housingBedFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get housingBedFree;

  /// No description provided for @housingBedHeld.
  ///
  /// In en, this message translates to:
  /// **'Held'**
  String get housingBedHeld;

  /// No description provided for @housingBedTaken.
  ///
  /// In en, this message translates to:
  /// **'Taken'**
  String get housingBedTaken;

  /// No description provided for @housingBedBlocked.
  ///
  /// In en, this message translates to:
  /// **'Not bookable'**
  String get housingBedBlocked;

  /// No description provided for @housingBedSemantics.
  ///
  /// In en, this message translates to:
  /// **'Bed {number}, {state}'**
  String housingBedSemantics(Object number, Object state);

  /// No description provided for @housingBedSemanticsOccupied.
  ///
  /// In en, this message translates to:
  /// **'Bed {number}, {state}, {occupant}'**
  String housingBedSemanticsOccupied(
    Object number,
    Object occupant,
    Object state,
  );

  /// No description provided for @housingRoomOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get housingRoomOpen;

  /// No description provided for @housingRoomMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get housingRoomMaintenance;

  /// No description provided for @housingRoomClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get housingRoomClosed;

  /// No description provided for @housingBookingFirstCome.
  ///
  /// In en, this message translates to:
  /// **'First come'**
  String get housingBookingFirstCome;

  /// No description provided for @housingBookingDraw.
  ///
  /// In en, this message translates to:
  /// **'Draw'**
  String get housingBookingDraw;

  /// No description provided for @housingBookingPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get housingBookingPriority;

  /// No description provided for @housingOpeningScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get housingOpeningScheduled;

  /// No description provided for @housingOpeningOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get housingOpeningOpen;

  /// No description provided for @housingOpeningClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get housingOpeningClosed;

  /// No description provided for @housingIssueBedUnknown.
  ///
  /// In en, this message translates to:
  /// **'No such bed in the hostel inventory.'**
  String get housingIssueBedUnknown;

  /// No description provided for @housingIssueMatricUnknown.
  ///
  /// In en, this message translates to:
  /// **'No student has this matric number.'**
  String get housingIssueMatricUnknown;

  /// No description provided for @housingIssueBedTaken.
  ///
  /// In en, this message translates to:
  /// **'This bed is already allocated.'**
  String get housingIssueBedTaken;

  /// No description provided for @housingIssueDuplicate.
  ///
  /// In en, this message translates to:
  /// **'This student appears on more than one row.'**
  String get housingIssueDuplicate;

  /// No description provided for @housingIssueGender.
  ///
  /// In en, this message translates to:
  /// **'The hostel is not open to this student\'s gender.'**
  String get housingIssueGender;

  /// No description provided for @housingNoticeOfferMade.
  ///
  /// In en, this message translates to:
  /// **'Offer made'**
  String get housingNoticeOfferMade;

  /// No description provided for @housingNoticeDeadlineNear.
  ///
  /// In en, this message translates to:
  /// **'Deadline near'**
  String get housingNoticeDeadlineNear;

  /// No description provided for @housingNoticeBedReleased.
  ///
  /// In en, this message translates to:
  /// **'Bed released'**
  String get housingNoticeBedReleased;

  /// No description provided for @housingNoticeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get housingNoticeWelcome;

  /// No description provided for @housingSkipBanned.
  ///
  /// In en, this message translates to:
  /// **'Banned from housing'**
  String get housingSkipBanned;

  /// No description provided for @housingSkipUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid fees'**
  String get housingSkipUnpaid;

  /// No description provided for @housingSkipRoomClosed.
  ///
  /// In en, this message translates to:
  /// **'Room is closed'**
  String get housingSkipRoomClosed;

  /// No description provided for @housingDrawBallot.
  ///
  /// In en, this message translates to:
  /// **'Ballot'**
  String get housingDrawBallot;

  /// No description provided for @housingDrawPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get housingDrawPriority;

  /// No description provided for @housingNoticeCancelled.
  ///
  /// In en, this message translates to:
  /// **'Allocation cancelled and the bed freed.'**
  String get housingNoticeCancelled;

  /// No description provided for @housingNoticeRoomSaved.
  ///
  /// In en, this message translates to:
  /// **'Room settings saved.'**
  String get housingNoticeRoomSaved;

  /// No description provided for @housingNoticeRoomsAdded.
  ///
  /// In en, this message translates to:
  /// **'Rooms added to the block.'**
  String get housingNoticeRoomsAdded;

  /// No description provided for @housingNoticePublished.
  ///
  /// In en, this message translates to:
  /// **'New agreement version published.'**
  String get housingNoticePublished;

  /// No description provided for @housingNoticeWordingSaved.
  ///
  /// In en, this message translates to:
  /// **'Notice wording saved.'**
  String get housingNoticeWordingSaved;

  /// No description provided for @housingNoticeCategorySaved.
  ///
  /// In en, this message translates to:
  /// **'Category added.'**
  String get housingNoticeCategorySaved;

  /// No description provided for @housingNoticeCategoryRemoved.
  ///
  /// In en, this message translates to:
  /// **'Category removed.'**
  String get housingNoticeCategoryRemoved;

  /// No description provided for @housingNoticeBanAdded.
  ///
  /// In en, this message translates to:
  /// **'Student banned from booking.'**
  String get housingNoticeBanAdded;

  /// No description provided for @housingNoticeBanLifted.
  ///
  /// In en, this message translates to:
  /// **'Ban lifted.'**
  String get housingNoticeBanLifted;

  /// No description provided for @housingNoticeRefundSaved.
  ///
  /// In en, this message translates to:
  /// **'Refund rules saved.'**
  String get housingNoticeRefundSaved;

  /// No description provided for @housingNoticePriceSaved.
  ///
  /// In en, this message translates to:
  /// **'Price saved.'**
  String get housingNoticePriceSaved;

  /// No description provided for @housingNoticeOpeningSaved.
  ///
  /// In en, this message translates to:
  /// **'Booking method saved.'**
  String get housingNoticeOpeningSaved;

  /// No description provided for @housingNoticeDrawRun.
  ///
  /// In en, this message translates to:
  /// **'Draw complete.'**
  String get housingNoticeDrawRun;

  /// No description provided for @housingNoticeAutoRun.
  ///
  /// In en, this message translates to:
  /// **'Automatic allocation complete.'**
  String get housingNoticeAutoRun;

  /// No description provided for @housingNoticeKeepSent.
  ///
  /// In en, this message translates to:
  /// **'Keep-my-room offers sent.'**
  String get housingNoticeKeepSent;

  /// No description provided for @housingNoticeUploadDone.
  ///
  /// In en, this message translates to:
  /// **'Spreadsheet applied as one batch.'**
  String get housingNoticeUploadDone;

  /// No description provided for @housingToolsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get housingToolsTitle;

  /// No description provided for @housingQueueTitle.
  ///
  /// In en, this message translates to:
  /// **'Allocations'**
  String get housingQueueTitle;

  /// No description provided for @housingQueueSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Every bed given out, by state, and the tools to give out more.'**
  String get housingQueueSubtitle;

  /// No description provided for @housingQueueSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get housingQueueSummaryTitle;

  /// No description provided for @housingMetricAllocations.
  ///
  /// In en, this message translates to:
  /// **'Allocations'**
  String get housingMetricAllocations;

  /// No description provided for @housingMetricFreeBeds.
  ///
  /// In en, this message translates to:
  /// **'Free beds'**
  String get housingMetricFreeBeds;

  /// No description provided for @housingMetricWaitlist.
  ///
  /// In en, this message translates to:
  /// **'Waitlist'**
  String get housingMetricWaitlist;

  /// No description provided for @housingMetricBeds.
  ///
  /// In en, this message translates to:
  /// **'Beds'**
  String get housingMetricBeds;

  /// No description provided for @housingMetricTaken.
  ///
  /// In en, this message translates to:
  /// **'Taken'**
  String get housingMetricTaken;

  /// No description provided for @housingMetricFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get housingMetricFree;

  /// No description provided for @housingMetricApplicants.
  ///
  /// In en, this message translates to:
  /// **'Applicants'**
  String get housingMetricApplicants;

  /// No description provided for @housingMetricEligible.
  ///
  /// In en, this message translates to:
  /// **'Eligible residents'**
  String get housingMetricEligible;

  /// No description provided for @housingQueueEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No allocations here'**
  String get housingQueueEmptyTitle;

  /// No description provided for @housingQueueEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches this filter. Pick another state, or give out beds with one of the tools.'**
  String get housingQueueEmptyBody;

  /// No description provided for @housingToolHostelsTitle.
  ///
  /// In en, this message translates to:
  /// **'Hostels and rooms'**
  String get housingToolHostelsTitle;

  /// No description provided for @housingToolHostelsBody.
  ///
  /// In en, this message translates to:
  /// **'Beds block by block, room settings and occupants.'**
  String get housingToolHostelsBody;

  /// No description provided for @housingToolOpeningsTitle.
  ///
  /// In en, this message translates to:
  /// **'Openings and prices'**
  String get housingToolOpeningsTitle;

  /// No description provided for @housingToolOpeningsBody.
  ///
  /// In en, this message translates to:
  /// **'When each term books, how, and what a bed costs.'**
  String get housingToolOpeningsBody;

  /// No description provided for @housingToolUploadTitle.
  ///
  /// In en, this message translates to:
  /// **'Allocate from a spreadsheet'**
  String get housingToolUploadTitle;

  /// No description provided for @housingToolUploadBody.
  ///
  /// In en, this message translates to:
  /// **'Upload a sheet of students and beds as one batch.'**
  String get housingToolUploadBody;

  /// No description provided for @housingToolAllocateTitle.
  ///
  /// In en, this message translates to:
  /// **'Allocate by hand'**
  String get housingToolAllocateTitle;

  /// No description provided for @housingToolAllocateBody.
  ///
  /// In en, this message translates to:
  /// **'Give one student one bed.'**
  String get housingToolAllocateBody;

  /// No description provided for @housingToolAutoTitle.
  ///
  /// In en, this message translates to:
  /// **'Automatic allocation'**
  String get housingToolAutoTitle;

  /// No description provided for @housingToolAutoBody.
  ///
  /// In en, this message translates to:
  /// **'Place the {count} students on the waitlist.'**
  String housingToolAutoBody(Object count);

  /// No description provided for @housingToolDrawTitle.
  ///
  /// In en, this message translates to:
  /// **'The draw'**
  String get housingToolDrawTitle;

  /// No description provided for @housingToolDrawBody.
  ///
  /// In en, this message translates to:
  /// **'Pick winners for {count} applicants.'**
  String housingToolDrawBody(Object count);

  /// No description provided for @housingToolKeepTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep my room'**
  String get housingToolKeepTitle;

  /// No description provided for @housingToolKeepBody.
  ///
  /// In en, this message translates to:
  /// **'Offer {count} residents their own beds back.'**
  String housingToolKeepBody(Object count);

  /// No description provided for @housingToolAgreementTitle.
  ///
  /// In en, this message translates to:
  /// **'Accommodation agreement'**
  String get housingToolAgreementTitle;

  /// No description provided for @housingToolAgreementBody.
  ///
  /// In en, this message translates to:
  /// **'Publish a new version students must accept.'**
  String get housingToolAgreementBody;

  /// No description provided for @housingToolNoticesTitle.
  ///
  /// In en, this message translates to:
  /// **'Housing notices'**
  String get housingToolNoticesTitle;

  /// No description provided for @housingToolNoticesBody.
  ///
  /// In en, this message translates to:
  /// **'Reword the messages students receive.'**
  String get housingToolNoticesBody;

  /// No description provided for @housingToolCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Housing categories'**
  String get housingToolCategoriesTitle;

  /// No description provided for @housingToolCategoriesBody.
  ///
  /// In en, this message translates to:
  /// **'Who counts for more in a priority draw.'**
  String get housingToolCategoriesBody;

  /// No description provided for @housingToolBansTitle.
  ///
  /// In en, this message translates to:
  /// **'Housing bans'**
  String get housingToolBansTitle;

  /// No description provided for @housingToolBansBody.
  ///
  /// In en, this message translates to:
  /// **'{count} students barred from booking.'**
  String housingToolBansBody(Object count);

  /// No description provided for @housingToolRefundsTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancellation refunds'**
  String get housingToolRefundsTitle;

  /// No description provided for @housingToolRefundsBody.
  ///
  /// In en, this message translates to:
  /// **'Students get {percent}% back when they cancel in time.'**
  String housingToolRefundsBody(Object percent);

  /// No description provided for @housingDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Allocation'**
  String get housingDetailTitle;

  /// No description provided for @housingDetailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The student, the bed, the fee and how it was made.'**
  String get housingDetailSubtitle;

  /// No description provided for @housingDetailMissingTitle.
  ///
  /// In en, this message translates to:
  /// **'Allocation not found'**
  String get housingDetailMissingTitle;

  /// No description provided for @housingDetailMissingBody.
  ///
  /// In en, this message translates to:
  /// **'It may have been removed. Go back to the queue and pick another.'**
  String get housingDetailMissingBody;

  /// No description provided for @housingDetailProgramme.
  ///
  /// In en, this message translates to:
  /// **'Programme'**
  String get housingDetailProgramme;

  /// No description provided for @housingDetailBedTitle.
  ///
  /// In en, this message translates to:
  /// **'Bed'**
  String get housingDetailBedTitle;

  /// No description provided for @housingDetailHostel.
  ///
  /// In en, this message translates to:
  /// **'Hostel'**
  String get housingDetailHostel;

  /// No description provided for @housingDetailRoom.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get housingDetailRoom;

  /// No description provided for @housingDetailRoomType.
  ///
  /// In en, this message translates to:
  /// **'Room type'**
  String get housingDetailRoomType;

  /// No description provided for @housingDetailTerm.
  ///
  /// In en, this message translates to:
  /// **'Term'**
  String get housingDetailTerm;

  /// No description provided for @housingDetailRecordTitle.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get housingDetailRecordTitle;

  /// No description provided for @housingDetailFee.
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get housingDetailFee;

  /// No description provided for @housingDetailInvoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get housingDetailInvoice;

  /// No description provided for @housingDetailMethod.
  ///
  /// In en, this message translates to:
  /// **'Made by'**
  String get housingDetailMethod;

  /// No description provided for @housingDetailCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get housingDetailCreated;

  /// No description provided for @housingCancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel this allocation'**
  String get housingCancelAction;

  /// No description provided for @housingCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this allocation?'**
  String get housingCancelTitle;

  /// No description provided for @housingCancelBody.
  ///
  /// In en, this message translates to:
  /// **'{name} loses the bed and it becomes free for the next student. Any fee paid goes to their wallet.'**
  String housingCancelBody(Object name);

  /// No description provided for @housingCancelConfirm.
  ///
  /// In en, this message translates to:
  /// **'Cancel allocation'**
  String get housingCancelConfirm;

  /// No description provided for @housingHostelsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Every hostel, with how many beds are free.'**
  String get housingHostelsSubtitle;

  /// No description provided for @housingHostelsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No hostels yet'**
  String get housingHostelsEmptyTitle;

  /// No description provided for @housingHostelsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Hostels appear here once they are added to the inventory.'**
  String get housingHostelsEmptyBody;

  /// No description provided for @housingHostelSummary.
  ///
  /// In en, this message translates to:
  /// **'{blocks} blocks · {rooms} rooms · {free} of {total} beds free'**
  String housingHostelSummary(
    Object blocks,
    Object free,
    Object rooms,
    Object total,
  );

  /// No description provided for @housingHostelTitle.
  ///
  /// In en, this message translates to:
  /// **'Hostel'**
  String get housingHostelTitle;

  /// No description provided for @housingHostelSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Beds block by block. Tap a room to change its settings.'**
  String get housingHostelSubtitle;

  /// No description provided for @housingHostelMissingTitle.
  ///
  /// In en, this message translates to:
  /// **'Hostel not found'**
  String get housingHostelMissingTitle;

  /// No description provided for @housingHostelMissingBody.
  ///
  /// In en, this message translates to:
  /// **'It may have been removed. Go back to the list and pick another.'**
  String get housingHostelMissingBody;

  /// No description provided for @housingOccupantsTitle.
  ///
  /// In en, this message translates to:
  /// **'Occupants'**
  String get housingOccupantsTitle;

  /// No description provided for @housingOccupantsEntry.
  ///
  /// In en, this message translates to:
  /// **'{count} students living here.'**
  String housingOccupantsEntry(Object count);

  /// No description provided for @housingOccupantsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Who holds a bed in this hostel.'**
  String get housingOccupantsSubtitle;

  /// No description provided for @housingOccupantsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} occupants'**
  String housingOccupantsCount(Object count);

  /// No description provided for @housingOccupantsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nobody lives here yet'**
  String get housingOccupantsEmptyTitle;

  /// No description provided for @housingOccupantsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'{hostel} has no occupants. They appear once a bed is held or confirmed.'**
  String housingOccupantsEmptyBody(Object hostel);

  /// No description provided for @housingOccupantBed.
  ///
  /// In en, this message translates to:
  /// **'{room} · Bed {bed}'**
  String housingOccupantBed(Object bed, Object room);

  /// No description provided for @housingBlockAddRooms.
  ///
  /// In en, this message translates to:
  /// **'Add rooms'**
  String get housingBlockAddRooms;

  /// No description provided for @housingBlockEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No rooms in this block'**
  String get housingBlockEmptyTitle;

  /// No description provided for @housingBlockEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add a run of rooms to start giving out beds here.'**
  String get housingBlockEmptyBody;

  /// No description provided for @housingRoomHeading.
  ///
  /// In en, this message translates to:
  /// **'Room {number} · {type}'**
  String housingRoomHeading(Object number, Object type);

  /// No description provided for @housingRoomTitle.
  ///
  /// In en, this message translates to:
  /// **'Room settings'**
  String get housingRoomTitle;

  /// No description provided for @housingRoomSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Whether the room can be booked, and what type it is.'**
  String get housingRoomSubtitle;

  /// No description provided for @housingRoomMissingTitle.
  ///
  /// In en, this message translates to:
  /// **'Room not found'**
  String get housingRoomMissingTitle;

  /// No description provided for @housingRoomMissingBody.
  ///
  /// In en, this message translates to:
  /// **'It may have been removed. Go back to the hostel and pick another.'**
  String get housingRoomMissingBody;

  /// No description provided for @housingRoomFloor.
  ///
  /// In en, this message translates to:
  /// **'Floor'**
  String get housingRoomFloor;

  /// No description provided for @housingRoomStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking status'**
  String get housingRoomStatusTitle;

  /// No description provided for @housingRoomStatusBody.
  ///
  /// In en, this message translates to:
  /// **'A room under maintenance or closed shows no free beds to students.'**
  String get housingRoomStatusBody;

  /// No description provided for @housingRoomTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Room type'**
  String get housingRoomTypeTitle;

  /// No description provided for @housingRoomTypeNote.
  ///
  /// In en, this message translates to:
  /// **'The type decides the price a student is invoiced.'**
  String get housingRoomTypeNote;

  /// No description provided for @housingBlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Add rooms to a block'**
  String get housingBlockTitle;

  /// No description provided for @housingBlockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a run of rooms in one go.'**
  String get housingBlockSubtitle;

  /// No description provided for @housingBlockCurrent.
  ///
  /// In en, this message translates to:
  /// **'{hostel} · {count} rooms now'**
  String housingBlockCurrent(Object count, Object hostel);

  /// No description provided for @housingBlockFrom.
  ///
  /// In en, this message translates to:
  /// **'First room number'**
  String get housingBlockFrom;

  /// No description provided for @housingBlockTo.
  ///
  /// In en, this message translates to:
  /// **'Last room number'**
  String get housingBlockTo;

  /// No description provided for @housingBlockRangeError.
  ///
  /// In en, this message translates to:
  /// **'Enter two numbers, the second not smaller than the first.'**
  String get housingBlockRangeError;

  /// No description provided for @housingBlockBeds.
  ///
  /// In en, this message translates to:
  /// **'Beds per room'**
  String get housingBlockBeds;

  /// No description provided for @housingBlockPreview.
  ///
  /// In en, this message translates to:
  /// **'This adds {rooms} rooms and {beds} beds. Room numbers already in the block are skipped.'**
  String housingBlockPreview(Object beds, Object rooms);

  /// No description provided for @housingBlockAdd.
  ///
  /// In en, this message translates to:
  /// **'Add rooms'**
  String get housingBlockAdd;

  /// No description provided for @housingOpeningsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When each term books, how beds are given out, and what they cost.'**
  String get housingOpeningsSubtitle;

  /// No description provided for @housingTabOpenings.
  ///
  /// In en, this message translates to:
  /// **'Openings'**
  String get housingTabOpenings;

  /// No description provided for @housingTabPrices.
  ///
  /// In en, this message translates to:
  /// **'Prices'**
  String get housingTabPrices;

  /// No description provided for @housingTabRefunds.
  ///
  /// In en, this message translates to:
  /// **'Refunds'**
  String get housingTabRefunds;

  /// No description provided for @housingOpeningsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No openings scheduled'**
  String get housingOpeningsEmptyTitle;

  /// No description provided for @housingOpeningsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Schedule a term\'s booking window before students can book.'**
  String get housingOpeningsEmptyBody;

  /// No description provided for @housingOpeningWindow.
  ///
  /// In en, this message translates to:
  /// **'Booking from {opens} to {closes}'**
  String housingOpeningWindow(Object closes, Object opens);

  /// No description provided for @housingOpeningMethod.
  ///
  /// In en, this message translates to:
  /// **'How beds are given out'**
  String get housingOpeningMethod;

  /// No description provided for @housingOpeningHold.
  ///
  /// In en, this message translates to:
  /// **'Hold time for payment'**
  String get housingOpeningHold;

  /// No description provided for @housingOpeningGrace.
  ///
  /// In en, this message translates to:
  /// **'Grace after the deadline'**
  String get housingOpeningGrace;

  /// No description provided for @housingOpeningQuota.
  ///
  /// In en, this message translates to:
  /// **'Free scholarship beds'**
  String get housingOpeningQuota;

  /// No description provided for @housingOpeningClosedDays.
  ///
  /// In en, this message translates to:
  /// **'Closed days'**
  String get housingOpeningClosedDays;

  /// No description provided for @housingPricesTitle.
  ///
  /// In en, this message translates to:
  /// **'Bed price by room type'**
  String get housingPricesTitle;

  /// No description provided for @housingPricesBody.
  ///
  /// In en, this message translates to:
  /// **'Per term, in naira. A change applies to beds booked from now on.'**
  String get housingPricesBody;

  /// No description provided for @housingPriceInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount such as 75,000.00.'**
  String get housingPriceInvalid;

  /// No description provided for @housingRefundsTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancellation refunds'**
  String get housingRefundsTitle;

  /// No description provided for @housingRefundsIntro.
  ///
  /// In en, this message translates to:
  /// **'What share of a paid fee goes back to the wallet when a student cancels early enough.'**
  String get housingRefundsIntro;

  /// No description provided for @housingRefundsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set the refund share and test it on a sample cancellation.'**
  String get housingRefundsSubtitle;

  /// No description provided for @housingRefundShare.
  ///
  /// In en, this message translates to:
  /// **'Refund share'**
  String get housingRefundShare;

  /// No description provided for @housingRefundWindow.
  ///
  /// In en, this message translates to:
  /// **'Cancel at least this long before check-in'**
  String get housingRefundWindow;

  /// No description provided for @housingRefundsOpen.
  ///
  /// In en, this message translates to:
  /// **'Open the refund simulator'**
  String get housingRefundsOpen;

  /// No description provided for @housingSimulateTitle.
  ///
  /// In en, this message translates to:
  /// **'Simulate a cancellation'**
  String get housingSimulateTitle;

  /// No description provided for @housingSimulateBody.
  ///
  /// In en, this message translates to:
  /// **'See what one cancellation would hand back under the rules above.'**
  String get housingSimulateBody;

  /// No description provided for @housingSimulatePaid.
  ///
  /// In en, this message translates to:
  /// **'Fee paid'**
  String get housingSimulatePaid;

  /// No description provided for @housingSimulateDays.
  ///
  /// In en, this message translates to:
  /// **'Days before check-in'**
  String get housingSimulateDays;

  /// No description provided for @housingSimulateRun.
  ///
  /// In en, this message translates to:
  /// **'Simulate'**
  String get housingSimulateRun;

  /// No description provided for @housingSimulateRefund.
  ///
  /// In en, this message translates to:
  /// **'Refunded to wallet'**
  String get housingSimulateRefund;

  /// No description provided for @housingSimulateCharge.
  ///
  /// In en, this message translates to:
  /// **'Cancellation charge'**
  String get housingSimulateCharge;

  /// No description provided for @housingSimulateWithin.
  ///
  /// In en, this message translates to:
  /// **'This is at least {days} days before check-in, so the refund share applies.'**
  String housingSimulateWithin(Object days);

  /// No description provided for @housingSimulateOutside.
  ///
  /// In en, this message translates to:
  /// **'This is less than {days} days before check-in, so nothing is refunded.'**
  String housingSimulateOutside(Object days);

  /// No description provided for @housingUploadSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Give out many beds at once from a spreadsheet.'**
  String get housingUploadSubtitle;

  /// No description provided for @housingUploadFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a spreadsheet'**
  String get housingUploadFormTitle;

  /// No description provided for @housingUploadFormBody.
  ///
  /// In en, this message translates to:
  /// **'The whole sheet is applied together, or not at all. Any row problem leaves everything untouched.'**
  String get housingUploadFormBody;

  /// No description provided for @housingUploadColumns.
  ///
  /// In en, this message translates to:
  /// **'Columns'**
  String get housingUploadColumns;

  /// No description provided for @housingUploadColumnList.
  ///
  /// In en, this message translates to:
  /// **'matric_number, hostel, block, room, bed'**
  String get housingUploadColumnList;

  /// No description provided for @housingUploadSampleValid.
  ///
  /// In en, this message translates to:
  /// **'Use a correct sample sheet'**
  String get housingUploadSampleValid;

  /// No description provided for @housingUploadSampleHeader.
  ///
  /// In en, this message translates to:
  /// **'Use a sheet with a missing column'**
  String get housingUploadSampleHeader;

  /// No description provided for @housingUploadSampleRows.
  ///
  /// In en, this message translates to:
  /// **'Use a sheet with row problems'**
  String get housingUploadSampleRows;

  /// No description provided for @housingUploadAnother.
  ///
  /// In en, this message translates to:
  /// **'Try another file'**
  String get housingUploadAnother;

  /// No description provided for @housingUploadHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'{file} cannot be read'**
  String housingUploadHeaderTitle(Object file);

  /// No description provided for @housingUploadHeaderBody.
  ///
  /// In en, this message translates to:
  /// **'The sheet has no \"{column}\" column. Add it to the first row and upload again.'**
  String housingUploadHeaderBody(Object column);

  /// No description provided for @housingUploadRowsTitle.
  ///
  /// In en, this message translates to:
  /// **'{issues} of {rows} rows have problems'**
  String housingUploadRowsTitle(Object issues, Object rows);

  /// No description provided for @housingUploadRowsBody.
  ///
  /// In en, this message translates to:
  /// **'Nothing was applied. Fix these rows in the sheet and upload it again.'**
  String get housingUploadRowsBody;

  /// No description provided for @housingUploadRow.
  ///
  /// In en, this message translates to:
  /// **'Row {row}'**
  String housingUploadRow(Object row);

  /// No description provided for @housingUploadSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Batch applied'**
  String get housingUploadSuccessTitle;

  /// No description provided for @housingUploadSuccessBody.
  ///
  /// In en, this message translates to:
  /// **'All {rows} rows were applied. Each student has been told.'**
  String housingUploadSuccessBody(Object rows);

  /// No description provided for @housingUploadBatch.
  ///
  /// In en, this message translates to:
  /// **'Batch'**
  String get housingUploadBatch;

  /// No description provided for @housingUploadFile.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get housingUploadFile;

  /// No description provided for @housingAllocateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Give one student one bed. They are told straight away.'**
  String get housingAllocateSubtitle;

  /// No description provided for @housingAllocateStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get housingAllocateStudent;

  /// No description provided for @housingAllocateMatric.
  ///
  /// In en, this message translates to:
  /// **'Matric number'**
  String get housingAllocateMatric;

  /// No description provided for @housingAllocateBed.
  ///
  /// In en, this message translates to:
  /// **'Bed'**
  String get housingAllocateBed;

  /// No description provided for @housingAllocateHostel.
  ///
  /// In en, this message translates to:
  /// **'Hostel'**
  String get housingAllocateHostel;

  /// No description provided for @housingAllocateRoom.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get housingAllocateRoom;

  /// No description provided for @housingAllocateRoomChoice.
  ///
  /// In en, this message translates to:
  /// **'{block} · {number}'**
  String housingAllocateRoomChoice(Object block, Object number);

  /// No description provided for @housingAllocateBedNumber.
  ///
  /// In en, this message translates to:
  /// **'Bed number'**
  String get housingAllocateBedNumber;

  /// No description provided for @housingAllocateSubmit.
  ///
  /// In en, this message translates to:
  /// **'Allocate bed'**
  String get housingAllocateSubmit;

  /// No description provided for @housingAllocateDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Bed allocated'**
  String get housingAllocateDoneTitle;

  /// No description provided for @housingAllocateDoneBody.
  ///
  /// In en, this message translates to:
  /// **'{name} now holds {bed}.'**
  String housingAllocateDoneBody(Object bed, Object name);

  /// No description provided for @housingAllocateUnknown.
  ///
  /// In en, this message translates to:
  /// **'No student has this matric number.'**
  String get housingAllocateUnknown;

  /// No description provided for @housingAllocateTaken.
  ///
  /// In en, this message translates to:
  /// **'That bed is no longer free, so {name} was not allocated.'**
  String housingAllocateTaken(Object name);

  /// No description provided for @housingAllocateBanned.
  ///
  /// In en, this message translates to:
  /// **'{name} is barred from housing and cannot be allocated a bed.'**
  String housingAllocateBanned(Object name);

  /// No description provided for @housingAutoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Place the waitlist into the free beds.'**
  String get housingAutoSubtitle;

  /// No description provided for @housingAutoTitle.
  ///
  /// In en, this message translates to:
  /// **'Automatic allocation'**
  String get housingAutoTitle;

  /// No description provided for @housingAutoBody.
  ///
  /// In en, this message translates to:
  /// **'Students on the waitlist are placed in order of when they joined, into beds that match their hostel\'s gender and level.'**
  String get housingAutoBody;

  /// No description provided for @housingAutoRules.
  ///
  /// In en, this message translates to:
  /// **'Banned students are skipped. Anyone left over stays on the waitlist.'**
  String get housingAutoRules;

  /// No description provided for @housingAutoRun.
  ///
  /// In en, this message translates to:
  /// **'Run allocation'**
  String get housingAutoRun;

  /// No description provided for @housingAutoConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Run automatic allocation?'**
  String get housingAutoConfirmTitle;

  /// No description provided for @housingAutoConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This places up to {waitlist} students into {free} free beds. Each student is told.'**
  String housingAutoConfirmBody(Object free, Object waitlist);

  /// No description provided for @housingAutoResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get housingAutoResultTitle;

  /// No description provided for @housingAutoPlaced.
  ///
  /// In en, this message translates to:
  /// **'Placed'**
  String get housingAutoPlaced;

  /// No description provided for @housingAutoUnplaced.
  ///
  /// In en, this message translates to:
  /// **'Still waiting'**
  String get housingAutoUnplaced;

  /// No description provided for @housingAutoLeft.
  ///
  /// In en, this message translates to:
  /// **'Beds left'**
  String get housingAutoLeft;

  /// No description provided for @housingDrawSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick who gets a bed when there are more applicants than beds.'**
  String get housingDrawSubtitle;

  /// No description provided for @housingDrawTitle.
  ///
  /// In en, this message translates to:
  /// **'The draw'**
  String get housingDrawTitle;

  /// No description provided for @housingDrawBody.
  ///
  /// In en, this message translates to:
  /// **'A ballot picks at random. A priority draw weighs each applicant by their housing category.'**
  String get housingDrawBody;

  /// No description provided for @housingDrawBallotNote.
  ///
  /// In en, this message translates to:
  /// **'Every applicant has the same chance.'**
  String get housingDrawBallotNote;

  /// No description provided for @housingDrawPriorityNote.
  ///
  /// In en, this message translates to:
  /// **'Applicants in heavier categories are drawn first. Set the weights under housing categories.'**
  String get housingDrawPriorityNote;

  /// No description provided for @housingDrawSeats.
  ///
  /// In en, this message translates to:
  /// **'Beds to give out'**
  String get housingDrawSeats;

  /// No description provided for @housingDrawRun.
  ///
  /// In en, this message translates to:
  /// **'Run the draw'**
  String get housingDrawRun;

  /// No description provided for @housingDrawConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Run the draw?'**
  String get housingDrawConfirmTitle;

  /// No description provided for @housingDrawConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This gives out {seats} beds among {applicants} applicants. It cannot be run again for the same applicants.'**
  String housingDrawConfirmBody(Object applicants, Object seats);

  /// No description provided for @housingDrawResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Draw result'**
  String get housingDrawResultTitle;

  /// No description provided for @housingDrawReference.
  ///
  /// In en, this message translates to:
  /// **'Draw'**
  String get housingDrawReference;

  /// No description provided for @housingDrawMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get housingDrawMethodLabel;

  /// No description provided for @housingDrawWinners.
  ///
  /// In en, this message translates to:
  /// **'Winners'**
  String get housingDrawWinners;

  /// No description provided for @housingDrawWinnersValue.
  ///
  /// In en, this message translates to:
  /// **'{winners} of {applicants}'**
  String housingDrawWinnersValue(Object applicants, Object winners);

  /// No description provided for @housingDrawWaitlisted.
  ///
  /// In en, this message translates to:
  /// **'Moved to the waitlist'**
  String get housingDrawWaitlisted;

  /// No description provided for @housingKeepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Offer last term\'s residents the beds they already have.'**
  String get housingKeepSubtitle;

  /// No description provided for @housingKeepTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep my room'**
  String get housingKeepTitle;

  /// No description provided for @housingKeepBody.
  ///
  /// In en, this message translates to:
  /// **'Residents who qualify get their own bed offered back for a window, before booking opens to everyone else.'**
  String get housingKeepBody;

  /// No description provided for @housingKeepWindow.
  ///
  /// In en, this message translates to:
  /// **'Offer lasts'**
  String get housingKeepWindow;

  /// No description provided for @housingKeepNote.
  ///
  /// In en, this message translates to:
  /// **'Each resident is sent an offer. They answer once; an unanswered offer releases the bed.'**
  String get housingKeepNote;

  /// No description provided for @housingKeepSend.
  ///
  /// In en, this message translates to:
  /// **'Send offers'**
  String get housingKeepSend;

  /// No description provided for @housingKeepConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Send keep-my-room offers?'**
  String get housingKeepConfirmTitle;

  /// No description provided for @housingKeepConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'{count} residents will be offered their beds for {days} days.'**
  String housingKeepConfirmBody(Object count, Object days);

  /// No description provided for @housingKeepResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Offers sent'**
  String get housingKeepResultTitle;

  /// No description provided for @housingKeepResultBody.
  ///
  /// In en, this message translates to:
  /// **'{offered} residents were offered their beds for {days} days.'**
  String housingKeepResultBody(Object days, Object offered);

  /// No description provided for @housingKeepSkippedTitle.
  ///
  /// In en, this message translates to:
  /// **'{count} residents were skipped'**
  String housingKeepSkippedTitle(Object count);

  /// No description provided for @housingAgreementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Publish a new version of the accommodation terms.'**
  String get housingAgreementSubtitle;

  /// No description provided for @housingAgreementCurrent.
  ///
  /// In en, this message translates to:
  /// **'Version in force'**
  String get housingAgreementCurrent;

  /// No description provided for @housingAgreementPublished.
  ///
  /// In en, this message translates to:
  /// **'Version {version}, published {date}.'**
  String housingAgreementPublished(Object date, Object version);

  /// No description provided for @housingAgreementPublishTitle.
  ///
  /// In en, this message translates to:
  /// **'Publish version {version}'**
  String housingAgreementPublishTitle(Object version);

  /// No description provided for @housingAgreementPublishBody.
  ///
  /// In en, this message translates to:
  /// **'Say in a few sentences what changed.'**
  String get housingAgreementPublishBody;

  /// No description provided for @housingAgreementSummary.
  ///
  /// In en, this message translates to:
  /// **'What changed'**
  String get housingAgreementSummary;

  /// No description provided for @housingAgreementWarning.
  ///
  /// In en, this message translates to:
  /// **'Every student has to accept the new version before they can book a bed again.'**
  String get housingAgreementWarning;

  /// No description provided for @housingAgreementPublish.
  ///
  /// In en, this message translates to:
  /// **'Publish version'**
  String get housingAgreementPublish;

  /// No description provided for @housingAgreementConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Publish version {version}?'**
  String housingAgreementConfirmTitle(Object version);

  /// No description provided for @housingAgreementConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'It replaces the version in force straight away. Students accept it the next time they book.'**
  String get housingAgreementConfirmBody;

  /// No description provided for @housingAgreementHistory.
  ///
  /// In en, this message translates to:
  /// **'Earlier versions'**
  String get housingAgreementHistory;

  /// No description provided for @housingAgreementLive.
  ///
  /// In en, this message translates to:
  /// **'In force'**
  String get housingAgreementLive;

  /// No description provided for @housingNoticesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reword the messages students receive about their beds.'**
  String get housingNoticesSubtitle;

  /// No description provided for @housingNoticeWording.
  ///
  /// In en, this message translates to:
  /// **'Wording'**
  String get housingNoticeWording;

  /// No description provided for @housingCategoriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The weight of each category when a draw is by priority.'**
  String get housingCategoriesSubtitle;

  /// No description provided for @housingCategoriesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No categories'**
  String get housingCategoriesEmptyTitle;

  /// No description provided for @housingCategoriesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add a category to give some students priority in a draw.'**
  String get housingCategoriesEmptyBody;

  /// No description provided for @housingCategoryLine.
  ///
  /// In en, this message translates to:
  /// **'Weight {weight} · {count} students'**
  String housingCategoryLine(Object count, Object weight);

  /// No description provided for @housingCategoryRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove category'**
  String get housingCategoryRemove;

  /// No description provided for @housingCategoryRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String housingCategoryRemoveTitle(Object name);

  /// No description provided for @housingCategoryRemoveBody.
  ///
  /// In en, this message translates to:
  /// **'Students in it lose the priority it gave them in the next draw.'**
  String get housingCategoryRemoveBody;

  /// No description provided for @housingCategoryAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a category'**
  String get housingCategoryAddTitle;

  /// No description provided for @housingCategoryName.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get housingCategoryName;

  /// No description provided for @housingCategoryWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get housingCategoryWeight;

  /// No description provided for @housingCategoryAdd.
  ///
  /// In en, this message translates to:
  /// **'Add category'**
  String get housingCategoryAdd;

  /// No description provided for @housingBansSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Students barred from booking a bed.'**
  String get housingBansSubtitle;

  /// No description provided for @housingBansEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nobody is banned'**
  String get housingBansEmptyTitle;

  /// No description provided for @housingBansEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Bar a student here and they cannot book, be offered or be allocated a bed.'**
  String get housingBansEmptyBody;

  /// No description provided for @housingBanSince.
  ///
  /// In en, this message translates to:
  /// **'{matric} · since {date}'**
  String housingBanSince(Object date, Object matric);

  /// No description provided for @housingBanLift.
  ///
  /// In en, this message translates to:
  /// **'Lift ban'**
  String get housingBanLift;

  /// No description provided for @housingBanLiftTitle.
  ///
  /// In en, this message translates to:
  /// **'Lift the ban on {name}?'**
  String housingBanLiftTitle(Object name);

  /// No description provided for @housingBanLiftBody.
  ///
  /// In en, this message translates to:
  /// **'They can book beds again from now on.'**
  String get housingBanLiftBody;

  /// No description provided for @housingBanAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Ban a student'**
  String get housingBanAddTitle;

  /// No description provided for @housingBanAddBody.
  ///
  /// In en, this message translates to:
  /// **'The student cannot book, be offered or be allocated a bed until you lift the ban.'**
  String get housingBanAddBody;

  /// No description provided for @housingBanReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get housingBanReason;

  /// No description provided for @housingBanRejected.
  ///
  /// In en, this message translates to:
  /// **'No student with that matric number, or they are already banned.'**
  String get housingBanRejected;

  /// No description provided for @housingBanAdd.
  ///
  /// In en, this message translates to:
  /// **'Ban student'**
  String get housingBanAdd;

  /// No description provided for @accommodationPreviewAction.
  ///
  /// In en, this message translates to:
  /// **'Preview states'**
  String get accommodationPreviewAction;

  /// No description provided for @accommodationPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Student accommodation states'**
  String get accommodationPreviewTitle;

  /// No description provided for @accommodationPreviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Debug only. Loads a fixture ledger so you can walk every student screen. Use the History tab for past beds; Terms and Rooms open from the matching states.'**
  String get accommodationPreviewSubtitle;

  /// No description provided for @accommodationPreviewHeldAndOffer.
  ///
  /// In en, this message translates to:
  /// **'Held bed + waitlist offer'**
  String get accommodationPreviewHeldAndOffer;

  /// No description provided for @accommodationPreviewHeldAndOfferHint.
  ///
  /// In en, this message translates to:
  /// **'Term 1 held with a swap proposal; switch to Term 2 for the offer.'**
  String get accommodationPreviewHeldAndOfferHint;

  /// No description provided for @accommodationPreviewNotScheduled.
  ///
  /// In en, this message translates to:
  /// **'Not scheduled'**
  String get accommodationPreviewNotScheduled;

  /// No description provided for @accommodationPreviewNotScheduledHint.
  ///
  /// In en, this message translates to:
  /// **'Booking has not been published for either term.'**
  String get accommodationPreviewNotScheduledHint;

  /// No description provided for @accommodationPreviewNeedsTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms to accept'**
  String get accommodationPreviewNeedsTerms;

  /// No description provided for @accommodationPreviewNeedsTermsHint.
  ///
  /// In en, this message translates to:
  /// **'Opens the agreement gate, then booking.'**
  String get accommodationPreviewNeedsTermsHint;

  /// No description provided for @accommodationPreviewRoomList.
  ///
  /// In en, this message translates to:
  /// **'Room list'**
  String get accommodationPreviewRoomList;

  /// No description provided for @accommodationPreviewRoomListHint.
  ///
  /// In en, this message translates to:
  /// **'Booking open — choose a room.'**
  String get accommodationPreviewRoomListHint;

  /// No description provided for @accommodationPreviewConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed bed'**
  String get accommodationPreviewConfirmed;

  /// No description provided for @accommodationPreviewConfirmedHint.
  ///
  /// In en, this message translates to:
  /// **'Paid and confirmed, not yet checked in.'**
  String get accommodationPreviewConfirmedHint;

  /// No description provided for @accommodationPreviewFreeBed.
  ///
  /// In en, this message translates to:
  /// **'Free / scholarship bed'**
  String get accommodationPreviewFreeBed;

  /// No description provided for @accommodationPreviewFreeBedHint.
  ///
  /// In en, this message translates to:
  /// **'Confirmed with no fee due.'**
  String get accommodationPreviewFreeBedHint;

  /// No description provided for @accommodationPreviewCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Checked in'**
  String get accommodationPreviewCheckedIn;

  /// No description provided for @accommodationPreviewCheckedInHint.
  ///
  /// In en, this message translates to:
  /// **'Official resident with slip and hall details.'**
  String get accommodationPreviewCheckedInHint;

  /// No description provided for @accommodationPreviewSessionHeld.
  ///
  /// In en, this message translates to:
  /// **'Session booking (held)'**
  String get accommodationPreviewSessionHeld;

  /// No description provided for @accommodationPreviewSessionHeldHint.
  ///
  /// In en, this message translates to:
  /// **'One fee covers both terms of the session.'**
  String get accommodationPreviewSessionHeldHint;

  /// No description provided for @accommodationPreviewNoHistory.
  ///
  /// In en, this message translates to:
  /// **'History empty'**
  String get accommodationPreviewNoHistory;

  /// No description provided for @accommodationPreviewNoHistoryHint.
  ///
  /// In en, this message translates to:
  /// **'Opens History with no past beds.'**
  String get accommodationPreviewNoHistoryHint;

  /// No description provided for @examCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Examination card'**
  String get examCardTitle;

  /// No description provided for @examCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show this at the hall door. It lists every paper you sit and where you sit it.'**
  String get examCardSubtitle;

  /// No description provided for @examCardStatusNotIssued.
  ///
  /// In en, this message translates to:
  /// **'Not issued'**
  String get examCardStatusNotIssued;

  /// No description provided for @examCardStatusIssued.
  ///
  /// In en, this message translates to:
  /// **'Issued'**
  String get examCardStatusIssued;

  /// No description provided for @examCardStatusRevoked.
  ///
  /// In en, this message translates to:
  /// **'Revoked'**
  String get examCardStatusRevoked;

  /// No description provided for @examCardGateOf.
  ///
  /// In en, this message translates to:
  /// **'Gate {current} of {count}'**
  String examCardGateOf(int current, int count);

  /// No description provided for @examCardNotIssuedTitle.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have a card yet'**
  String get examCardNotIssuedTitle;

  /// No description provided for @examCardNotIssuedBody.
  ///
  /// In en, this message translates to:
  /// **'Statutory examination clearance requires unhindered satisfaction of all five institutional prerequisites.'**
  String get examCardNotIssuedBody;

  /// No description provided for @examCardBlockingTitle.
  ///
  /// In en, this message translates to:
  /// **'Blocking issue'**
  String get examCardBlockingTitle;

  /// No description provided for @examCardGateMark.
  ///
  /// In en, this message translates to:
  /// **'Gate {position} • {title}'**
  String examCardGateMark(int position, String title);

  /// No description provided for @examCardIdentityLine.
  ///
  /// In en, this message translates to:
  /// **'{programme} • {department}'**
  String examCardIdentityLine(String programme, String department);

  /// No description provided for @examCardLevel.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String examCardLevel(int level);

  /// No description provided for @examCardFeesBlocking.
  ///
  /// In en, this message translates to:
  /// **'Pay at least {amount} of this term\'s fees before your examination card can be issued.'**
  String examCardFeesBlocking(Object amount);

  /// No description provided for @examCardPayUnder.
  ///
  /// In en, this message translates to:
  /// **'Pay under Fees.'**
  String get examCardPayUnder;

  /// No description provided for @examCardMinimumToPay.
  ///
  /// In en, this message translates to:
  /// **'Minimum statutory threshold'**
  String get examCardMinimumToPay;

  /// No description provided for @examCardOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Outstanding total'**
  String get examCardOutstanding;

  /// No description provided for @examCardPayAction.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount}'**
  String examCardPayAction(Object amount);

  /// No description provided for @examGatesTitle.
  ///
  /// In en, this message translates to:
  /// **'All clearance gates'**
  String get examGatesTitle;

  /// No description provided for @examGatesBody.
  ///
  /// In en, this message translates to:
  /// **'Complete review of verification requirements for this assessment cycle.'**
  String get examGatesBody;

  /// No description provided for @examCardAuditLedger.
  ///
  /// In en, this message translates to:
  /// **'Audit ledger'**
  String get examCardAuditLedger;

  /// No description provided for @examCardPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Institutional policy note'**
  String get examCardPolicyTitle;

  /// No description provided for @examCardPolicyBody.
  ///
  /// In en, this message translates to:
  /// **'In accordance with Senate regulations, physical printouts of examination admission passes are strictly barred from issuance until financial reconciliations are cleared through the bursary ledger. Invigilators will invalidate unverified entry credentials at examination centre entry points.'**
  String get examCardPolicyBody;

  /// No description provided for @examGatePosition.
  ///
  /// In en, this message translates to:
  /// **'{position}.'**
  String examGatePosition(Object position);

  /// No description provided for @examGateFees.
  ///
  /// In en, this message translates to:
  /// **'Bursary fee obligations'**
  String get examGateFees;

  /// No description provided for @examGateFeesDetail.
  ///
  /// In en, this message translates to:
  /// **'Financial clearance threshold'**
  String get examGateFeesDetail;

  /// No description provided for @examGateStanding.
  ///
  /// In en, this message translates to:
  /// **'Student matriculation status'**
  String get examGateStanding;

  /// No description provided for @examGateStandingDetail.
  ///
  /// In en, this message translates to:
  /// **'Registrar administrative standing'**
  String get examGateStandingDetail;

  /// No description provided for @examGatePapers.
  ///
  /// In en, this message translates to:
  /// **'Examination paper registration'**
  String get examGatePapers;

  /// No description provided for @examGatePapersDetail.
  ///
  /// In en, this message translates to:
  /// **'Senate approved paper roster'**
  String get examGatePapersDetail;

  /// No description provided for @examGateSchedule.
  ///
  /// In en, this message translates to:
  /// **'Card issuance schedule'**
  String get examGateSchedule;

  /// No description provided for @examGateScheduleDetail.
  ///
  /// In en, this message translates to:
  /// **'Central examinations time window'**
  String get examGateScheduleDetail;

  /// No description provided for @examGateSeats.
  ///
  /// In en, this message translates to:
  /// **'Final seat allotment and pass'**
  String get examGateSeats;

  /// No description provided for @examGateSeatsDetail.
  ///
  /// In en, this message translates to:
  /// **'Physical desk allocation'**
  String get examGateSeatsDetail;

  /// No description provided for @examGatePassed.
  ///
  /// In en, this message translates to:
  /// **'Passed'**
  String get examGatePassed;

  /// No description provided for @examGateBlocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get examGateBlocked;

  /// No description provided for @examGateWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get examGateWaiting;

  /// No description provided for @examGateFeesHint.
  ///
  /// In en, this message translates to:
  /// **'Pay the minimum of this term\'s fees under Fees.'**
  String get examGateFeesHint;

  /// No description provided for @examGateStandingHint.
  ///
  /// In en, this message translates to:
  /// **'Cards are only issued to active students. Speak to your level adviser.'**
  String get examGateStandingHint;

  /// No description provided for @examGatePapersHint.
  ///
  /// In en, this message translates to:
  /// **'You have no approved courses with papers in this session. Check your registered courses.'**
  String get examGatePapersHint;

  /// No description provided for @examGateScheduleHint.
  ///
  /// In en, this message translates to:
  /// **'Cards are not open yet. Check back nearer the examinations.'**
  String get examGateScheduleHint;

  /// No description provided for @examGateSeatsHint.
  ///
  /// In en, this message translates to:
  /// **'Your seat is allotted once the first four checks pass.'**
  String get examGateSeatsHint;

  /// No description provided for @examCardInstitution.
  ///
  /// In en, this message translates to:
  /// **'The Legion University'**
  String get examCardInstitution;

  /// No description provided for @examCardOfficial.
  ///
  /// In en, this message translates to:
  /// **'Official'**
  String get examCardOfficial;

  /// No description provided for @examCardSession.
  ///
  /// In en, this message translates to:
  /// **'Session {session}'**
  String examCardSession(Object session);

  /// No description provided for @examCardCandidate.
  ///
  /// In en, this message translates to:
  /// **'Candidate'**
  String get examCardCandidate;

  /// No description provided for @examCardMatric.
  ///
  /// In en, this message translates to:
  /// **'Matric number'**
  String get examCardMatric;

  /// No description provided for @examCardProgramme.
  ///
  /// In en, this message translates to:
  /// **'Programme'**
  String get examCardProgramme;

  /// No description provided for @examCardNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Card number'**
  String get examCardNumberLabel;

  /// No description provided for @examCardCheckCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Check code'**
  String get examCardCheckCodeLabel;

  /// No description provided for @examCardIssuedOn.
  ///
  /// In en, this message translates to:
  /// **'Issued on {date}.'**
  String examCardIssuedOn(Object date);

  /// No description provided for @examCardPapersTitle.
  ///
  /// In en, this message translates to:
  /// **'Timetabled papers'**
  String get examCardPapersTitle;

  /// No description provided for @examCardPapersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sittings'**
  String examCardPapersCount(Object count);

  /// No description provided for @examCardPaperWhen.
  ///
  /// In en, this message translates to:
  /// **'{date}, {time}'**
  String examCardPaperWhen(Object date, Object time);

  /// No description provided for @examCardSeat.
  ///
  /// In en, this message translates to:
  /// **'Seat {seat}'**
  String examCardSeat(Object seat);

  /// No description provided for @examCardVenueToBeAnnounced.
  ///
  /// In en, this message translates to:
  /// **'To be announced'**
  String get examCardVenueToBeAnnounced;

  /// No description provided for @examCardPersonalNote.
  ///
  /// In en, this message translates to:
  /// **'This card is personal and cannot be transferred. Bring it and your student ID card to every paper. An invigilator may check the card number against the examinations office record.'**
  String get examCardPersonalNote;

  /// No description provided for @examCardPrint.
  ///
  /// In en, this message translates to:
  /// **'Print card'**
  String get examCardPrint;

  /// No description provided for @examRevokedTitle.
  ///
  /// In en, this message translates to:
  /// **'This card was withdrawn'**
  String get examRevokedTitle;

  /// No description provided for @examRevokedBody.
  ///
  /// In en, this message translates to:
  /// **'A withdrawn card cannot be reprinted. If this is wrong, the examinations office can issue a new one.'**
  String get examRevokedBody;

  /// No description provided for @examRevokedReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Withdrawn reason'**
  String get examRevokedReasonLabel;

  /// No description provided for @examRevokedSpeakOffice.
  ///
  /// In en, this message translates to:
  /// **'Speak to the examinations office.'**
  String get examRevokedSpeakOffice;

  /// No description provided for @examRevokedCredentialId.
  ///
  /// In en, this message translates to:
  /// **'Credential ID'**
  String get examRevokedCredentialId;

  /// No description provided for @examRevokedExaminations.
  ///
  /// In en, this message translates to:
  /// **'Examinations'**
  String get examRevokedExaminations;

  /// No description provided for @examRevokedFeeReversed.
  ///
  /// In en, this message translates to:
  /// **'Fee reversed'**
  String get examRevokedFeeReversed;

  /// No description provided for @examRevokedSessionLabel.
  ///
  /// In en, this message translates to:
  /// **'Term'**
  String get examRevokedSessionLabel;

  /// No description provided for @examRevokedStudentLabel.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get examRevokedStudentLabel;

  /// No description provided for @examRevokedStudent.
  ///
  /// In en, this message translates to:
  /// **'{name} ({matric})'**
  String examRevokedStudent(Object matric, Object name);

  /// No description provided for @examRevokedHallNote.
  ///
  /// In en, this message translates to:
  /// **'Withdrawn cards are logged at all entrance scanners. Presenting this card at a hall doorway will flag an invalid credential.'**
  String get examRevokedHallNote;

  /// No description provided for @examRevokedViewFees.
  ///
  /// In en, this message translates to:
  /// **'View fees ledger'**
  String get examRevokedViewFees;

  /// No description provided for @examRevokedContact.
  ///
  /// In en, this message translates to:
  /// **'Contact examinations office'**
  String get examRevokedContact;

  /// No description provided for @navExamResults.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get navExamResults;

  /// No description provided for @navExamResits.
  ///
  /// In en, this message translates to:
  /// **'Resits'**
  String get navExamResits;

  /// No description provided for @navExamCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get navExamCard;

  /// No description provided for @examTitle.
  ///
  /// In en, this message translates to:
  /// **'Examinations and results'**
  String get examTitle;

  /// No description provided for @examNoticeResitRegistered.
  ///
  /// In en, this message translates to:
  /// **'You are registered for the resit. The fee is invoiced now.'**
  String get examNoticeResitRegistered;

  /// No description provided for @examNoticeResitClosed.
  ///
  /// In en, this message translates to:
  /// **'The resit window is closed, so you can\'t register.'**
  String get examNoticeResitClosed;

  /// No description provided for @examNoticeResitOverBudget.
  ///
  /// In en, this message translates to:
  /// **'That resit would take you over your unit allowance for the semester.'**
  String get examNoticeResitOverBudget;

  /// No description provided for @examPreviewAction.
  ///
  /// In en, this message translates to:
  /// **'Preview states'**
  String get examPreviewAction;

  /// No description provided for @examPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Preview examinations states'**
  String get examPreviewTitle;

  /// No description provided for @examPreviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Debug builds only. Loads a fixture ledger and opens the tab that shows it.'**
  String get examPreviewSubtitle;

  /// No description provided for @examPreviewPublishedGood.
  ///
  /// In en, this message translates to:
  /// **'Results published, good standing'**
  String get examPreviewPublishedGood;

  /// No description provided for @examPreviewPublishedGoodHint.
  ///
  /// In en, this message translates to:
  /// **'CGPA 3.62, one term, a resit and a held-back mark.'**
  String get examPreviewPublishedGoodHint;

  /// No description provided for @examPreviewUnpublished.
  ///
  /// In en, this message translates to:
  /// **'No results published'**
  String get examPreviewUnpublished;

  /// No description provided for @examPreviewUnpublishedHint.
  ///
  /// In en, this message translates to:
  /// **'The empty results hub.'**
  String get examPreviewUnpublishedHint;

  /// No description provided for @examPreviewProbation.
  ///
  /// In en, this message translates to:
  /// **'Probation'**
  String get examPreviewProbation;

  /// No description provided for @examPreviewProbationHint.
  ///
  /// In en, this message translates to:
  /// **'CGPA 1.84 with the adviser and the warning.'**
  String get examPreviewProbationHint;

  /// No description provided for @examPreviewCardNotIssued.
  ///
  /// In en, this message translates to:
  /// **'Card not issued'**
  String get examPreviewCardNotIssued;

  /// No description provided for @examPreviewCardNotIssuedHint.
  ///
  /// In en, this message translates to:
  /// **'Fees owing block the card; five clearances.'**
  String get examPreviewCardNotIssuedHint;

  /// No description provided for @examPreviewCardIssued.
  ///
  /// In en, this message translates to:
  /// **'Card issued'**
  String get examPreviewCardIssued;

  /// No description provided for @examPreviewCardIssuedHint.
  ///
  /// In en, this message translates to:
  /// **'The card with its timetable of papers.'**
  String get examPreviewCardIssuedHint;

  /// No description provided for @examPreviewCardRevoked.
  ///
  /// In en, this message translates to:
  /// **'Card revoked'**
  String get examPreviewCardRevoked;

  /// No description provided for @examPreviewCardRevokedHint.
  ///
  /// In en, this message translates to:
  /// **'Withdrawn because the fee was reversed.'**
  String get examPreviewCardRevokedHint;

  /// No description provided for @examPreviewResitsOpen.
  ///
  /// In en, this message translates to:
  /// **'Resits open'**
  String get examPreviewResitsOpen;

  /// No description provided for @examPreviewResitsOpenHint.
  ///
  /// In en, this message translates to:
  /// **'Unit allowance, failed courses and the confirm sheet.'**
  String get examPreviewResitsOpenHint;

  /// No description provided for @examPreviewResitsClosed.
  ///
  /// In en, this message translates to:
  /// **'Resits closed'**
  String get examPreviewResitsClosed;

  /// No description provided for @examPreviewResitsClosedHint.
  ///
  /// In en, this message translates to:
  /// **'Failures listed as not open.'**
  String get examPreviewResitsClosedHint;

  /// No description provided for @examOfficeBroadsheetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Broadsheets'**
  String get examOfficeBroadsheetsTitle;

  /// No description provided for @examOfficeBroadsheetsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Published scores by course, and each student\'s semester.'**
  String get examOfficeBroadsheetsSubtitle;

  /// No description provided for @examOfficeBroadsheetEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No published results'**
  String get examOfficeBroadsheetEmptyTitle;

  /// No description provided for @examOfficeBroadsheetEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'A course appears here once its results are published.'**
  String get examOfficeBroadsheetEmptyBody;

  /// No description provided for @examOfficeBroadsheetEnrolled.
  ///
  /// In en, this message translates to:
  /// **'Enrolled'**
  String get examOfficeBroadsheetEnrolled;

  /// No description provided for @examOfficeBroadsheetMean.
  ///
  /// In en, this message translates to:
  /// **'Mean'**
  String get examOfficeBroadsheetMean;

  /// No description provided for @examOfficeBroadsheetPassRate.
  ///
  /// In en, this message translates to:
  /// **'Pass rate'**
  String get examOfficeBroadsheetPassRate;

  /// No description provided for @examOfficePercent.
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String examOfficePercent(Object value);

  /// No description provided for @examOfficeScoreGrade.
  ///
  /// In en, this message translates to:
  /// **'{score} {grade}'**
  String examOfficeScoreGrade(Object grade, Object score);

  /// No description provided for @examOfficeDossierTitle.
  ///
  /// In en, this message translates to:
  /// **'Student dossier'**
  String get examOfficeDossierTitle;

  /// No description provided for @examOfficeDossierSubtitle.
  ///
  /// In en, this message translates to:
  /// **'One student\'s semester, course by course.'**
  String get examOfficeDossierSubtitle;

  /// No description provided for @examOfficeDossierNotFound.
  ///
  /// In en, this message translates to:
  /// **'That student has no dossier.'**
  String get examOfficeDossierNotFound;

  /// No description provided for @examOfficeDossierLine.
  ///
  /// In en, this message translates to:
  /// **'{matric} - {programme}'**
  String examOfficeDossierLine(Object matric, Object programme);

  /// No description provided for @examOfficeDossierCgpa.
  ///
  /// In en, this message translates to:
  /// **'CGPA'**
  String get examOfficeDossierCgpa;

  /// No description provided for @examOfficeDossierUnits.
  ///
  /// In en, this message translates to:
  /// **'Units passed'**
  String get examOfficeDossierUnits;

  /// No description provided for @examOfficeDossierClassification.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get examOfficeDossierClassification;

  /// No description provided for @examOfficeUnitsOf.
  ///
  /// In en, this message translates to:
  /// **'{passed} of {taken}'**
  String examOfficeUnitsOf(Object passed, Object taken);

  /// No description provided for @examOfficeProvisionalTitle.
  ///
  /// In en, this message translates to:
  /// **'Provisional result'**
  String get examOfficeProvisionalTitle;

  /// No description provided for @examOfficeProvisionalBody.
  ///
  /// In en, this message translates to:
  /// **'The {course} mark is held back, so this semester\'s standing may change.'**
  String examOfficeProvisionalBody(Object course);

  /// No description provided for @examOfficeDossierCourses.
  ///
  /// In en, this message translates to:
  /// **'Courses, {term}'**
  String examOfficeDossierCourses(Object term);

  /// No description provided for @examOfficeDossierNoScore.
  ///
  /// In en, this message translates to:
  /// **'No score, {units} units'**
  String examOfficeDossierNoScore(Object units);

  /// No description provided for @examOfficeDossierScore.
  ///
  /// In en, this message translates to:
  /// **'{score} {grade}, {units} units'**
  String examOfficeDossierScore(Object grade, Object score, Object units);

  /// No description provided for @examOfficeBackTooltip.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get examOfficeBackTooltip;

  /// No description provided for @examOfficeTaskBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Examinations office'**
  String get examOfficeTaskBarTitle;

  /// No description provided for @examOfficeTaskBarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Staff portal'**
  String get examOfficeTaskBarSubtitle;

  /// No description provided for @examOfficeBreadcrumbRoot.
  ///
  /// In en, this message translates to:
  /// **'Examinations'**
  String get examOfficeBreadcrumbRoot;

  /// No description provided for @examOfficeSectionResults.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get examOfficeSectionResults;

  /// No description provided for @examOfficeSectionSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get examOfficeSectionSessions;

  /// No description provided for @examOfficeSectionGrading.
  ///
  /// In en, this message translates to:
  /// **'Grading'**
  String get examOfficeSectionGrading;

  /// No description provided for @examOfficeSectionIncidents.
  ///
  /// In en, this message translates to:
  /// **'Incidents'**
  String get examOfficeSectionIncidents;

  /// No description provided for @examOfficeSectionResits.
  ///
  /// In en, this message translates to:
  /// **'Resits'**
  String get examOfficeSectionResits;

  /// No description provided for @examOfficeSectionBroadsheets.
  ///
  /// In en, this message translates to:
  /// **'Broadsheets'**
  String get examOfficeSectionBroadsheets;

  /// No description provided for @examOfficeNoticeSent.
  ///
  /// In en, this message translates to:
  /// **'Sent for approval. The marks are fixed now.'**
  String get examOfficeNoticeSent;

  /// No description provided for @examOfficeNoticeSendBlocked.
  ///
  /// In en, this message translates to:
  /// **'Some students have no mark. Enter every mark, or hold it back with a reason.'**
  String get examOfficeNoticeSendBlocked;

  /// No description provided for @examOfficeNoticeHeld.
  ///
  /// In en, this message translates to:
  /// **'The mark is held back.'**
  String get examOfficeNoticeHeld;

  /// No description provided for @examOfficeNoticeReleased.
  ///
  /// In en, this message translates to:
  /// **'The hold is released.'**
  String get examOfficeNoticeReleased;

  /// No description provided for @examOfficeNoticeSessionOpened.
  ///
  /// In en, this message translates to:
  /// **'Session opened. Timetable its papers next.'**
  String get examOfficeNoticeSessionOpened;

  /// No description provided for @examOfficeNoticeCardWithdrawn.
  ///
  /// In en, this message translates to:
  /// **'Card withdrawn. The public check fails from now on.'**
  String get examOfficeNoticeCardWithdrawn;

  /// No description provided for @examOfficeNoticeCardReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Say why the card is withdrawn.'**
  String get examOfficeNoticeCardReasonRequired;

  /// No description provided for @examOfficeNoticeRoomAdded.
  ///
  /// In en, this message translates to:
  /// **'Room added. The remaining candidates are seated.'**
  String get examOfficeNoticeRoomAdded;

  /// No description provided for @examOfficeNoticePaperUpdated.
  ///
  /// In en, this message translates to:
  /// **'Paper updated.'**
  String get examOfficeNoticePaperUpdated;

  /// No description provided for @examOfficeNoticeCancelLocked.
  ///
  /// In en, this message translates to:
  /// **'A paper that has been sat cannot be cancelled.'**
  String get examOfficeNoticeCancelLocked;

  /// No description provided for @examOfficeNoticeCancelReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Say why the paper is cancelled.'**
  String get examOfficeNoticeCancelReasonRequired;

  /// No description provided for @examOfficeNoticeThresholdsSaved.
  ///
  /// In en, this message translates to:
  /// **'Standing thresholds updated.'**
  String get examOfficeNoticeThresholdsSaved;

  /// No description provided for @examOfficeNoticeThresholdsInvalid.
  ///
  /// In en, this message translates to:
  /// **'The withdrawal CGPA must be above 0 and under the probation CGPA.'**
  String get examOfficeNoticeThresholdsInvalid;

  /// No description provided for @examOfficeNoticeImported.
  ///
  /// In en, this message translates to:
  /// **'Incidents imported.'**
  String get examOfficeNoticeImported;

  /// No description provided for @examOfficeNoticeIncidentClosed.
  ///
  /// In en, this message translates to:
  /// **'Incident closed. Any mark it held is released.'**
  String get examOfficeNoticeIncidentClosed;

  /// No description provided for @examOfficeNoticeIncidentReferred.
  ///
  /// In en, this message translates to:
  /// **'Referred to discipline. The mark stays held.'**
  String get examOfficeNoticeIncidentReferred;

  /// No description provided for @examOfficeNoticeReleaseLocked.
  ///
  /// In en, this message translates to:
  /// **'These results are with the approvers, so the mark cannot be released. Speak to the head of department.'**
  String get examOfficeNoticeReleaseLocked;

  /// No description provided for @examOfficeNoticeWindowOpened.
  ///
  /// In en, this message translates to:
  /// **'Resit window opened.'**
  String get examOfficeNoticeWindowOpened;

  /// No description provided for @examOfficeNoticeRegistrationCancelled.
  ///
  /// In en, this message translates to:
  /// **'Registration cancelled. Any fee paid goes to the student\'s wallet.'**
  String get examOfficeNoticeRegistrationCancelled;

  /// No description provided for @examOfficeConfirmKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep as it is'**
  String get examOfficeConfirmKeep;

  /// No description provided for @examOfficeGradingTitle.
  ///
  /// In en, this message translates to:
  /// **'Grading scales'**
  String get examOfficeGradingTitle;

  /// No description provided for @examOfficeGradingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How marks become letters, and what puts a student on probation.'**
  String get examOfficeGradingSubtitle;

  /// No description provided for @examOfficeScaleBody.
  ///
  /// In en, this message translates to:
  /// **'{applies} - {count} bands'**
  String examOfficeScaleBody(Object applies, Object count);

  /// No description provided for @examOfficeScaleDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get examOfficeScaleDefault;

  /// No description provided for @examOfficeScaleBroken.
  ///
  /// In en, this message translates to:
  /// **'Has a gap'**
  String get examOfficeScaleBroken;

  /// No description provided for @examOfficeScaleDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Grading scale'**
  String get examOfficeScaleDetailTitle;

  /// No description provided for @examOfficeScaleDetailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The bands marks fall into.'**
  String get examOfficeScaleDetailSubtitle;

  /// No description provided for @examOfficeScaleNotFound.
  ///
  /// In en, this message translates to:
  /// **'That scale is not on the list.'**
  String get examOfficeScaleNotFound;

  /// No description provided for @examOfficeScaleGapTitle.
  ///
  /// In en, this message translates to:
  /// **'Some marks have no grade'**
  String get examOfficeScaleGapTitle;

  /// No description provided for @examOfficeScaleGapBody.
  ///
  /// In en, this message translates to:
  /// **'Marks 0 to {top} fall under every band, because the lowest band starts at {start}. A student scoring there would have no grade.'**
  String examOfficeScaleGapBody(Object start, Object top);

  /// No description provided for @examOfficeScaleAppliesTo.
  ///
  /// In en, this message translates to:
  /// **'Applies to {programmes}'**
  String examOfficeScaleAppliesTo(Object programmes);

  /// No description provided for @examOfficeBandFrom.
  ///
  /// In en, this message translates to:
  /// **'From {mark}'**
  String examOfficeBandFrom(Object mark);

  /// No description provided for @examOfficeBandPoints.
  ///
  /// In en, this message translates to:
  /// **'{points} points'**
  String examOfficeBandPoints(Object points);

  /// No description provided for @examOfficeBandFail.
  ///
  /// In en, this message translates to:
  /// **'Fail'**
  String get examOfficeBandFail;

  /// No description provided for @examOfficeDegreeClassesTitle.
  ///
  /// In en, this message translates to:
  /// **'Degree classes'**
  String get examOfficeDegreeClassesTitle;

  /// No description provided for @examOfficeDegreeFrom.
  ///
  /// In en, this message translates to:
  /// **'From {cgpa}'**
  String examOfficeDegreeFrom(Object cgpa);

  /// No description provided for @examOfficeStandingRulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Standing rules'**
  String get examOfficeStandingRulesTitle;

  /// No description provided for @examOfficeStandingRulesBody.
  ///
  /// In en, this message translates to:
  /// **'Below the probation CGPA a student is on probation. Below the withdrawal CGPA the office advises withdrawal.'**
  String get examOfficeStandingRulesBody;

  /// No description provided for @examOfficeProbationLabel.
  ///
  /// In en, this message translates to:
  /// **'Probation below CGPA'**
  String get examOfficeProbationLabel;

  /// No description provided for @examOfficeWithdrawalLabel.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal advised below CGPA'**
  String get examOfficeWithdrawalLabel;

  /// No description provided for @examOfficeStandingRulesSave.
  ///
  /// In en, this message translates to:
  /// **'Save thresholds'**
  String get examOfficeStandingRulesSave;

  /// No description provided for @examOfficeIncidentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Incidents'**
  String get examOfficeIncidentsTitle;

  /// No description provided for @examOfficeIncidentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What the halls reported, and which marks it is holding back.'**
  String get examOfficeIncidentsSubtitle;

  /// No description provided for @examOfficeIncidentsHolding.
  ///
  /// In en, this message translates to:
  /// **'{count} open incidents are holding a mark back.'**
  String examOfficeIncidentsHolding(Object count);

  /// No description provided for @examOfficeIncidentsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No incidents'**
  String get examOfficeIncidentsEmptyTitle;

  /// No description provided for @examOfficeIncidentsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches these filters.'**
  String get examOfficeIncidentsEmptyBody;

  /// No description provided for @examOfficeImportAction.
  ///
  /// In en, this message translates to:
  /// **'Import a batch'**
  String get examOfficeImportAction;

  /// No description provided for @examOfficeIncidentLine.
  ///
  /// In en, this message translates to:
  /// **'{kind} - {course}'**
  String examOfficeIncidentLine(Object course, Object kind);

  /// No description provided for @examOfficeIncidentBody.
  ///
  /// In en, this message translates to:
  /// **'{id} - {student}'**
  String examOfficeIncidentBody(Object id, Object student);

  /// No description provided for @examOfficeIncidentNoStudent.
  ///
  /// In en, this message translates to:
  /// **'No student attached'**
  String get examOfficeIncidentNoStudent;

  /// No description provided for @examOfficeIncidentHoldsMark.
  ///
  /// In en, this message translates to:
  /// **'Holds a mark'**
  String get examOfficeIncidentHoldsMark;

  /// No description provided for @examOfficeIncidentDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Incident'**
  String get examOfficeIncidentDetailTitle;

  /// No description provided for @examOfficeIncidentDetailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What was reported and how it is being settled.'**
  String get examOfficeIncidentDetailSubtitle;

  /// No description provided for @examOfficeIncidentNotFound.
  ///
  /// In en, this message translates to:
  /// **'That incident is not on the list.'**
  String get examOfficeIncidentNotFound;

  /// No description provided for @examOfficeIncidentFieldReference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get examOfficeIncidentFieldReference;

  /// No description provided for @examOfficeIncidentFieldStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get examOfficeIncidentFieldStudent;

  /// No description provided for @examOfficeIncidentFieldCourse.
  ///
  /// In en, this message translates to:
  /// **'Course'**
  String get examOfficeIncidentFieldCourse;

  /// No description provided for @examOfficeIncidentFieldSitting.
  ///
  /// In en, this message translates to:
  /// **'Sitting'**
  String get examOfficeIncidentFieldSitting;

  /// No description provided for @examOfficeIncidentFieldHall.
  ///
  /// In en, this message translates to:
  /// **'Hall'**
  String get examOfficeIncidentFieldHall;

  /// No description provided for @examOfficeIncidentFieldDiscipline.
  ///
  /// In en, this message translates to:
  /// **'Discipline case'**
  String get examOfficeIncidentFieldDiscipline;

  /// No description provided for @examOfficeIncidentFieldHearing.
  ///
  /// In en, this message translates to:
  /// **'Hearing'**
  String get examOfficeIncidentFieldHearing;

  /// No description provided for @examOfficeHoldingTitle.
  ///
  /// In en, this message translates to:
  /// **'A mark is held back'**
  String get examOfficeHoldingTitle;

  /// No description provided for @examOfficeHoldingBody.
  ///
  /// In en, this message translates to:
  /// **'The student\'s {course} mark stays out of the results until this incident is closed.'**
  String examOfficeHoldingBody(Object course);

  /// No description provided for @examOfficeIncidentRefer.
  ///
  /// In en, this message translates to:
  /// **'Refer to discipline'**
  String get examOfficeIncidentRefer;

  /// No description provided for @examOfficeIncidentClose.
  ///
  /// In en, this message translates to:
  /// **'Close incident'**
  String get examOfficeIncidentClose;

  /// No description provided for @examOfficeCloseTitle.
  ///
  /// In en, this message translates to:
  /// **'Close {id}?'**
  String examOfficeCloseTitle(Object id);

  /// No description provided for @examOfficeCloseBody.
  ///
  /// In en, this message translates to:
  /// **'The incident is settled and leaves the open list.'**
  String get examOfficeCloseBody;

  /// No description provided for @examOfficeCloseBodyHolding.
  ///
  /// In en, this message translates to:
  /// **'The incident is settled and the mark it holds is released.'**
  String get examOfficeCloseBodyHolding;

  /// No description provided for @examOfficeCloseConfirm.
  ///
  /// In en, this message translates to:
  /// **'Close incident'**
  String get examOfficeCloseConfirm;

  /// No description provided for @examOfficeImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Import incidents'**
  String get examOfficeImportTitle;

  /// No description provided for @examOfficeImportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check an invigilator\'s file before anything is written.'**
  String get examOfficeImportSubtitle;

  /// No description provided for @examOfficeImportIdle.
  ///
  /// In en, this message translates to:
  /// **'{count} rows are ready to check. Run a dry run first: nothing is written until you import.'**
  String examOfficeImportIdle(Object count);

  /// No description provided for @examOfficeImportDryRunTitle.
  ///
  /// In en, this message translates to:
  /// **'Dry run - nothing is written yet'**
  String get examOfficeImportDryRunTitle;

  /// No description provided for @examOfficeImportDryRunBody.
  ///
  /// In en, this message translates to:
  /// **'This is what the import would do with each row. Rows left out are not written.'**
  String get examOfficeImportDryRunBody;

  /// No description provided for @examOfficeImportDone.
  ///
  /// In en, this message translates to:
  /// **'{count} incidents imported.'**
  String examOfficeImportDone(Object count);

  /// No description provided for @examOfficeImportRunDry.
  ///
  /// In en, this message translates to:
  /// **'Run a dry run'**
  String get examOfficeImportRunDry;

  /// No description provided for @examOfficeImportCommit.
  ///
  /// In en, this message translates to:
  /// **'Import {count} incidents'**
  String examOfficeImportCommit(Object count);

  /// No description provided for @examOfficeImportStartOver.
  ///
  /// In en, this message translates to:
  /// **'Start over'**
  String get examOfficeImportStartOver;

  /// No description provided for @examOfficeImportBackToIncidents.
  ///
  /// In en, this message translates to:
  /// **'Back to incidents'**
  String get examOfficeImportBackToIncidents;

  /// No description provided for @examOfficeImportRowLine.
  ///
  /// In en, this message translates to:
  /// **'{course} - {subject}'**
  String examOfficeImportRowLine(Object course, Object subject);

  /// No description provided for @examOfficeImportRowKind.
  ///
  /// In en, this message translates to:
  /// **'{kind}, {time}'**
  String examOfficeImportRowKind(Object kind, Object time);

  /// No description provided for @examOfficeStageBeingMarked.
  ///
  /// In en, this message translates to:
  /// **'Being marked'**
  String get examOfficeStageBeingMarked;

  /// No description provided for @examOfficeStageSentBack.
  ///
  /// In en, this message translates to:
  /// **'Sent back'**
  String get examOfficeStageSentBack;

  /// No description provided for @examOfficeStageWithApprovers.
  ///
  /// In en, this message translates to:
  /// **'With approvers'**
  String get examOfficeStageWithApprovers;

  /// No description provided for @examOfficeStagePublished.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get examOfficeStagePublished;

  /// No description provided for @examOfficeFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get examOfficeFilterAll;

  /// No description provided for @examOfficeFilterUnmarked.
  ///
  /// In en, this message translates to:
  /// **'Unmarked'**
  String get examOfficeFilterUnmarked;

  /// No description provided for @examOfficeFilterHeld.
  ///
  /// In en, this message translates to:
  /// **'Held back'**
  String get examOfficeFilterHeld;

  /// No description provided for @examOfficeFilterMarked.
  ///
  /// In en, this message translates to:
  /// **'Marked'**
  String get examOfficeFilterMarked;

  /// No description provided for @examOfficeSessionScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get examOfficeSessionScheduled;

  /// No description provided for @examOfficeSessionLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get examOfficeSessionLive;

  /// No description provided for @examOfficeSessionClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get examOfficeSessionClosed;

  /// No description provided for @examOfficePaperScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get examOfficePaperScheduled;

  /// No description provided for @examOfficePaperInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get examOfficePaperInProgress;

  /// No description provided for @examOfficePaperSat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get examOfficePaperSat;

  /// No description provided for @examOfficePaperCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get examOfficePaperCancelled;

  /// No description provided for @examOfficeSeatingNone.
  ///
  /// In en, this message translates to:
  /// **'Not seated'**
  String get examOfficeSeatingNone;

  /// No description provided for @examOfficeSeatingPartial.
  ///
  /// In en, this message translates to:
  /// **'Partly seated'**
  String get examOfficeSeatingPartial;

  /// No description provided for @examOfficeSeatingFull.
  ///
  /// In en, this message translates to:
  /// **'Seated'**
  String get examOfficeSeatingFull;

  /// No description provided for @examOfficeKindMalpractice.
  ///
  /// In en, this message translates to:
  /// **'Malpractice'**
  String get examOfficeKindMalpractice;

  /// No description provided for @examOfficeKindAbsence.
  ///
  /// In en, this message translates to:
  /// **'Absence'**
  String get examOfficeKindAbsence;

  /// No description provided for @examOfficeKindIllness.
  ///
  /// In en, this message translates to:
  /// **'Illness'**
  String get examOfficeKindIllness;

  /// No description provided for @examOfficeKindDisruption.
  ///
  /// In en, this message translates to:
  /// **'Disruption'**
  String get examOfficeKindDisruption;

  /// No description provided for @examOfficeKindOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get examOfficeKindOther;

  /// No description provided for @examOfficeIncidentReported.
  ///
  /// In en, this message translates to:
  /// **'Reported'**
  String get examOfficeIncidentReported;

  /// No description provided for @examOfficeIncidentUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Under review'**
  String get examOfficeIncidentUnderReview;

  /// No description provided for @examOfficeIncidentReferredStatus.
  ///
  /// In en, this message translates to:
  /// **'Referred'**
  String get examOfficeIncidentReferredStatus;

  /// No description provided for @examOfficeIncidentClosedStatus.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get examOfficeIncidentClosedStatus;

  /// No description provided for @examOfficeImportActionImport.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get examOfficeImportActionImport;

  /// No description provided for @examOfficeImportActionUnattached.
  ///
  /// In en, this message translates to:
  /// **'Import unattached'**
  String get examOfficeImportActionUnattached;

  /// No description provided for @examOfficeImportActionLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave out'**
  String get examOfficeImportActionLeave;

  /// No description provided for @examOfficeImportReasonReady.
  ///
  /// In en, this message translates to:
  /// **'Ready to import.'**
  String get examOfficeImportReasonReady;

  /// No description provided for @examOfficeImportReasonMissingDescription.
  ///
  /// In en, this message translates to:
  /// **'There is no description.'**
  String get examOfficeImportReasonMissingDescription;

  /// No description provided for @examOfficeImportReasonUnknownKind.
  ///
  /// In en, this message translates to:
  /// **'The kind is not one the office uses.'**
  String get examOfficeImportReasonUnknownKind;

  /// No description provided for @examOfficeImportReasonDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Repeats an earlier row in this file.'**
  String get examOfficeImportReasonDuplicate;

  /// No description provided for @examOfficeImportReasonAlreadyImported.
  ///
  /// In en, this message translates to:
  /// **'Already imported.'**
  String get examOfficeImportReasonAlreadyImported;

  /// No description provided for @examOfficeImportReasonNoPaper.
  ///
  /// In en, this message translates to:
  /// **'No paper is timetabled for this course.'**
  String get examOfficeImportReasonNoPaper;

  /// No description provided for @examOfficeImportReasonNoStudent.
  ///
  /// In en, this message translates to:
  /// **'No student named. Imported for someone to attach.'**
  String get examOfficeImportReasonNoStudent;

  /// No description provided for @examOfficeImportReasonNotFound.
  ///
  /// In en, this message translates to:
  /// **'The student is not on the roll. Imported for someone to attach.'**
  String get examOfficeImportReasonNotFound;

  /// No description provided for @examOfficeVerdictCleared.
  ///
  /// In en, this message translates to:
  /// **'Cleared'**
  String get examOfficeVerdictCleared;

  /// No description provided for @examOfficeVerdictHeld.
  ///
  /// In en, this message translates to:
  /// **'Held back'**
  String get examOfficeVerdictHeld;

  /// No description provided for @examOfficeVerdictNotPass.
  ///
  /// In en, this message translates to:
  /// **'Not a pass'**
  String get examOfficeVerdictNotPass;

  /// No description provided for @examOfficeVerdictMarginal.
  ///
  /// In en, this message translates to:
  /// **'Marginal'**
  String get examOfficeVerdictMarginal;

  /// No description provided for @examOfficePaperTitle.
  ///
  /// In en, this message translates to:
  /// **'Paper'**
  String get examOfficePaperTitle;

  /// No description provided for @examOfficePaperSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Seating and running one paper.'**
  String get examOfficePaperSubtitle;

  /// No description provided for @examOfficePaperNotFound.
  ///
  /// In en, this message translates to:
  /// **'That paper is not in this session.'**
  String get examOfficePaperNotFound;

  /// No description provided for @examOfficePaperWhen.
  ///
  /// In en, this message translates to:
  /// **'{start} to {end}'**
  String examOfficePaperWhen(Object end, Object start);

  /// No description provided for @examOfficePaperEnrolled.
  ///
  /// In en, this message translates to:
  /// **'{count} registered'**
  String examOfficePaperEnrolled(Object count);

  /// No description provided for @examOfficeSeatingHeading.
  ///
  /// In en, this message translates to:
  /// **'Seating'**
  String get examOfficeSeatingHeading;

  /// No description provided for @examOfficeSeatingCount.
  ///
  /// In en, this message translates to:
  /// **'{seated} of {enrolled} seated'**
  String examOfficeSeatingCount(Object enrolled, Object seated);

  /// No description provided for @examOfficeRoomSeated.
  ///
  /// In en, this message translates to:
  /// **'{count} seated'**
  String examOfficeRoomSeated(Object count);

  /// No description provided for @examOfficeUnseatedTitle.
  ///
  /// In en, this message translates to:
  /// **'{count} candidates have no seat'**
  String examOfficeUnseatedTitle(Object count);

  /// No description provided for @examOfficeUnseatedBody.
  ///
  /// In en, this message translates to:
  /// **'Add a room to seat the rest. Nobody already seated is moved.'**
  String get examOfficeUnseatedBody;

  /// No description provided for @examOfficeAddRoom.
  ///
  /// In en, this message translates to:
  /// **'Add {room} ({capacity} seats)'**
  String examOfficeAddRoom(Object capacity, Object room);

  /// No description provided for @examOfficeRunningHeading.
  ///
  /// In en, this message translates to:
  /// **'Running the paper'**
  String get examOfficeRunningHeading;

  /// No description provided for @examOfficeRunningStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get examOfficeRunningStatus;

  /// No description provided for @examOfficeStartPaper.
  ///
  /// In en, this message translates to:
  /// **'Start the paper'**
  String get examOfficeStartPaper;

  /// No description provided for @examOfficeMarkSat.
  ///
  /// In en, this message translates to:
  /// **'Mark as sat'**
  String get examOfficeMarkSat;

  /// No description provided for @examOfficeCancelPaper.
  ///
  /// In en, this message translates to:
  /// **'Cancel the paper'**
  String get examOfficeCancelPaper;

  /// No description provided for @examOfficeCancelLockedNote.
  ///
  /// In en, this message translates to:
  /// **'This paper has been sat, so it can no longer be cancelled.'**
  String get examOfficeCancelLockedNote;

  /// No description provided for @examOfficeCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel {course}?'**
  String examOfficeCancelTitle(Object course);

  /// No description provided for @examOfficeCancelBody.
  ///
  /// In en, this message translates to:
  /// **'Students are told the paper is off. Say why.'**
  String get examOfficeCancelBody;

  /// No description provided for @examOfficeCancelConfirm.
  ///
  /// In en, this message translates to:
  /// **'Cancel the paper'**
  String get examOfficeCancelConfirm;

  /// No description provided for @examOfficeResitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Resit windows'**
  String get examOfficeResitsTitle;

  /// No description provided for @examOfficeResitsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When students may register to retake a failed course, and what it costs.'**
  String get examOfficeResitsSubtitle;

  /// No description provided for @examOfficeWindowOpenAction.
  ///
  /// In en, this message translates to:
  /// **'Open a window'**
  String get examOfficeWindowOpenAction;

  /// No description provided for @examOfficeWindowsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No resit windows'**
  String get examOfficeWindowsEmptyTitle;

  /// No description provided for @examOfficeWindowsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Open a window to let students register for resits.'**
  String get examOfficeWindowsEmptyBody;

  /// No description provided for @examOfficeWindowOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get examOfficeWindowOpen;

  /// No description provided for @examOfficeWindowClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get examOfficeWindowClosed;

  /// No description provided for @examOfficeWindowFee.
  ///
  /// In en, this message translates to:
  /// **'{fee} per unit, unit cap {cap}'**
  String examOfficeWindowFee(Object cap, Object fee);

  /// No description provided for @examOfficeWindowNoCap.
  ///
  /// In en, this message translates to:
  /// **'none'**
  String get examOfficeWindowNoCap;

  /// No description provided for @examOfficeWindowRegistered.
  ///
  /// In en, this message translates to:
  /// **'{count} registered'**
  String examOfficeWindowRegistered(Object count);

  /// No description provided for @examOfficeSignupsHeading.
  ///
  /// In en, this message translates to:
  /// **'Registrations in {window}'**
  String examOfficeSignupsHeading(Object window);

  /// No description provided for @examOfficeSignupAwaiting.
  ///
  /// In en, this message translates to:
  /// **'Awaiting payment'**
  String get examOfficeSignupAwaiting;

  /// No description provided for @examOfficeSignupPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get examOfficeSignupPaid;

  /// No description provided for @examOfficeSignupLine.
  ///
  /// In en, this message translates to:
  /// **'{matric} - {units} units - {fee}'**
  String examOfficeSignupLine(Object fee, Object matric, Object units);

  /// No description provided for @examOfficeSignupCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel registration'**
  String get examOfficeSignupCancel;

  /// No description provided for @examOfficeSignupCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel {matric}\'s registration?'**
  String examOfficeSignupCancelTitle(Object matric);

  /// No description provided for @examOfficeSignupCancelBody.
  ///
  /// In en, this message translates to:
  /// **'The student can register again while the window is open. Any fee paid goes to their wallet.'**
  String get examOfficeSignupCancelBody;

  /// No description provided for @examOfficeSignupCancelConfirm.
  ///
  /// In en, this message translates to:
  /// **'Cancel registration'**
  String get examOfficeSignupCancelConfirm;

  /// No description provided for @examOfficeWindowFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Open a resit window'**
  String get examOfficeWindowFormTitle;

  /// No description provided for @examOfficeWindowFormSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set the dates, the fee and how many units one student can register.'**
  String get examOfficeWindowFormSubtitle;

  /// No description provided for @examOfficeWindowFormBody.
  ///
  /// In en, this message translates to:
  /// **'Students see the window on their resits tab as soon as it opens.'**
  String get examOfficeWindowFormBody;

  /// No description provided for @examOfficeWindowNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Window name'**
  String get examOfficeWindowNameLabel;

  /// No description provided for @examOfficeWindowNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Give the window a name.'**
  String get examOfficeWindowNameRequired;

  /// No description provided for @examOfficeWindowOpensLabel.
  ///
  /// In en, this message translates to:
  /// **'Opens'**
  String get examOfficeWindowOpensLabel;

  /// No description provided for @examOfficeWindowClosesLabel.
  ///
  /// In en, this message translates to:
  /// **'Closes'**
  String get examOfficeWindowClosesLabel;

  /// No description provided for @examOfficeWindowCloseBeforeOpen.
  ///
  /// In en, this message translates to:
  /// **'The window must close after it opens.'**
  String get examOfficeWindowCloseBeforeOpen;

  /// No description provided for @examOfficeWindowFeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Fee per unit'**
  String get examOfficeWindowFeeLabel;

  /// No description provided for @examOfficeWindowFeeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount like 2000 or 2,000.50.'**
  String get examOfficeWindowFeeInvalid;

  /// No description provided for @examOfficeWindowCapLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit cap per student'**
  String get examOfficeWindowCapLabel;

  /// No description provided for @examOfficeReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get examOfficeReasonLabel;

  /// No description provided for @examOfficeReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Say why.'**
  String get examOfficeReasonRequired;

  /// No description provided for @examOfficeDatePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Choose a date'**
  String get examOfficeDatePlaceholder;

  /// No description provided for @examOfficeNoValue.
  ///
  /// In en, this message translates to:
  /// **'-'**
  String get examOfficeNoValue;

  /// No description provided for @examOfficeResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get examOfficeResultsTitle;

  /// No description provided for @examOfficeResultsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Every course\'s marks, from first entry to publication.'**
  String get examOfficeResultsSubtitle;

  /// No description provided for @examOfficeResultsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No courses to mark'**
  String get examOfficeResultsEmptyTitle;

  /// No description provided for @examOfficeResultsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Courses appear here once a semester\'s marking opens.'**
  String get examOfficeResultsEmptyBody;

  /// No description provided for @examOfficeCourseLine.
  ///
  /// In en, this message translates to:
  /// **'{code} - {title}'**
  String examOfficeCourseLine(Object code, Object title);

  /// No description provided for @examOfficeResultsBatchBody.
  ///
  /// In en, this message translates to:
  /// **'{marked} of {enrolled} marked, {units} units'**
  String examOfficeResultsBatchBody(
    Object enrolled,
    Object marked,
    Object units,
  );

  /// No description provided for @examOfficeCourseSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Marking sheet'**
  String get examOfficeCourseSheetTitle;

  /// No description provided for @examOfficeCourseSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the coursework and examination marks, then send the course for approval.'**
  String get examOfficeCourseSheetSubtitle;

  /// No description provided for @examOfficeCourseNotFound.
  ///
  /// In en, this message translates to:
  /// **'That course is not on the queue.'**
  String get examOfficeCourseNotFound;

  /// No description provided for @examOfficeMarkCoursework.
  ///
  /// In en, this message translates to:
  /// **'Coursework (max {max})'**
  String examOfficeMarkCoursework(Object max);

  /// No description provided for @examOfficeMarkExam.
  ///
  /// In en, this message translates to:
  /// **'Exam (max {max})'**
  String examOfficeMarkExam(Object max);

  /// No description provided for @examOfficeMarkOutOfRange.
  ///
  /// In en, this message translates to:
  /// **'A mark is outside its range.'**
  String get examOfficeMarkOutOfRange;

  /// No description provided for @examOfficeMarkHold.
  ///
  /// In en, this message translates to:
  /// **'Hold back'**
  String get examOfficeMarkHold;

  /// No description provided for @examOfficeMarkRelease.
  ///
  /// In en, this message translates to:
  /// **'Release'**
  String get examOfficeMarkRelease;

  /// No description provided for @examOfficeMarkHeldReason.
  ///
  /// In en, this message translates to:
  /// **'Held back: {reason}'**
  String examOfficeMarkHeldReason(Object reason);

  /// No description provided for @examOfficeMarkFlagged.
  ///
  /// In en, this message translates to:
  /// **'Flagged'**
  String get examOfficeMarkFlagged;

  /// No description provided for @examOfficeMarkPreviously.
  ///
  /// In en, this message translates to:
  /// **'Was {total}'**
  String examOfficeMarkPreviously(Object total);

  /// No description provided for @examOfficeMarkEmpty.
  ///
  /// In en, this message translates to:
  /// **'No students match this filter.'**
  String get examOfficeMarkEmpty;

  /// No description provided for @examOfficeHoldDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Hold this mark back'**
  String get examOfficeHoldDialogTitle;

  /// No description provided for @examOfficeHoldDialogBody.
  ///
  /// In en, this message translates to:
  /// **'The mark stays out of the results until you release it. The course can still be sent.'**
  String get examOfficeHoldDialogBody;

  /// No description provided for @examOfficeHoldConfirm.
  ///
  /// In en, this message translates to:
  /// **'Hold back'**
  String get examOfficeHoldConfirm;

  /// No description provided for @examOfficeSendButton.
  ///
  /// In en, this message translates to:
  /// **'Send for approval'**
  String get examOfficeSendButton;

  /// No description provided for @examOfficeSendConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Send {course} for approval?'**
  String examOfficeSendConfirmTitle(Object course);

  /// No description provided for @examOfficeSendConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'The marks are fixed once sent. Only the head of department can send them back.'**
  String get examOfficeSendConfirmBody;

  /// No description provided for @examOfficeSendConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get examOfficeSendConfirmAction;

  /// No description provided for @examOfficeSendBlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'{count} students have no mark'**
  String examOfficeSendBlockedTitle(Object count);

  /// No description provided for @examOfficeSendBlockedBody.
  ///
  /// In en, this message translates to:
  /// **'Enter a mark for each, or hold it back with a reason, then send again: {names}.'**
  String examOfficeSendBlockedBody(Object names);

  /// No description provided for @examOfficeStageNoteMarking.
  ///
  /// In en, this message translates to:
  /// **'Marks are saved as you type. Send the course when every student has a mark or a hold.'**
  String get examOfficeStageNoteMarking;

  /// No description provided for @examOfficeHodNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'{author} sent this back on {date}'**
  String examOfficeHodNoteTitle(Object author, Object date);

  /// No description provided for @examOfficeHodNoteBody.
  ///
  /// In en, this message translates to:
  /// **'{note} ({count} flagged marks to revise.)'**
  String examOfficeHodNoteBody(Object count, Object note);

  /// No description provided for @examOfficeFlaggedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} flagged marks to revise.'**
  String examOfficeFlaggedCount(Object count);

  /// No description provided for @examOfficeLockedApprovers.
  ///
  /// In en, this message translates to:
  /// **'With {desk}, due {date}. The marks are locked.'**
  String examOfficeLockedApprovers(Object date, Object desk);

  /// No description provided for @examOfficePublishedNote.
  ///
  /// In en, this message translates to:
  /// **'Published on {date}. Gazette {ref}.'**
  String examOfficePublishedNote(Object date, Object ref);

  /// No description provided for @examOfficeSessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Examination sessions'**
  String get examOfficeSessionsTitle;

  /// No description provided for @examOfficeSessionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The periods papers are sat in, semester by semester.'**
  String get examOfficeSessionsSubtitle;

  /// No description provided for @examOfficeSessionsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No session for {term}'**
  String examOfficeSessionsEmptyTitle(Object term);

  /// No description provided for @examOfficeSessionsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Open a session to timetable papers and let students collect their cards.'**
  String get examOfficeSessionsEmptyBody;

  /// No description provided for @examOfficeOpenSession.
  ///
  /// In en, this message translates to:
  /// **'Open a session'**
  String get examOfficeOpenSession;

  /// No description provided for @examOfficeOpenSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Open a session for {term}'**
  String examOfficeOpenSessionTitle(Object term);

  /// No description provided for @examOfficeSessionNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Session name'**
  String get examOfficeSessionNameLabel;

  /// No description provided for @examOfficeSessionNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Give the session a name.'**
  String get examOfficeSessionNameRequired;

  /// No description provided for @examOfficeSessionStarts.
  ///
  /// In en, this message translates to:
  /// **'First paper'**
  String get examOfficeSessionStarts;

  /// No description provided for @examOfficeSessionEnds.
  ///
  /// In en, this message translates to:
  /// **'Last paper'**
  String get examOfficeSessionEnds;

  /// No description provided for @examOfficeSessionCardsOpen.
  ///
  /// In en, this message translates to:
  /// **'Cards open'**
  String get examOfficeSessionCardsOpen;

  /// No description provided for @examOfficeDateRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose a date.'**
  String get examOfficeDateRequired;

  /// No description provided for @examOfficeSessionEndBeforeStart.
  ///
  /// In en, this message translates to:
  /// **'The last paper must come after the first.'**
  String get examOfficeSessionEndBeforeStart;

  /// No description provided for @examOfficeSessionCardsAfterStart.
  ///
  /// In en, this message translates to:
  /// **'Cards must open on or before the first paper.'**
  String get examOfficeSessionCardsAfterStart;

  /// No description provided for @examOfficeSessionBody.
  ///
  /// In en, this message translates to:
  /// **'{start} to {end}, {count} papers'**
  String examOfficeSessionBody(Object count, Object end, Object start);

  /// No description provided for @examOfficeSessionDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get examOfficeSessionDetailTitle;

  /// No description provided for @examOfficeSessionDetailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Papers, clashes and issued cards for one examination period.'**
  String get examOfficeSessionDetailSubtitle;

  /// No description provided for @examOfficeSessionNotFound.
  ///
  /// In en, this message translates to:
  /// **'That session is not on the list.'**
  String get examOfficeSessionNotFound;

  /// No description provided for @examOfficeSessionDates.
  ///
  /// In en, this message translates to:
  /// **'{start} to {end}'**
  String examOfficeSessionDates(Object end, Object start);

  /// No description provided for @examOfficeSessionCardsFrom.
  ///
  /// In en, this message translates to:
  /// **'Cards open on {date}'**
  String examOfficeSessionCardsFrom(Object date);

  /// No description provided for @examOfficeSessionMetricPapers.
  ///
  /// In en, this message translates to:
  /// **'Papers'**
  String get examOfficeSessionMetricPapers;

  /// No description provided for @examOfficeSessionMetricClashes.
  ///
  /// In en, this message translates to:
  /// **'Clashes'**
  String get examOfficeSessionMetricClashes;

  /// No description provided for @examOfficeSessionMetricCards.
  ///
  /// In en, this message translates to:
  /// **'Cards issued'**
  String get examOfficeSessionMetricCards;

  /// No description provided for @examOfficeClashesHeading.
  ///
  /// In en, this message translates to:
  /// **'Clashes'**
  String get examOfficeClashesHeading;

  /// No description provided for @examOfficeClashTitle.
  ///
  /// In en, this message translates to:
  /// **'{first} and {second} at the same time'**
  String examOfficeClashTitle(Object first, Object second);

  /// No description provided for @examOfficeClashBody.
  ///
  /// In en, this message translates to:
  /// **'{matric} is registered for both papers.'**
  String examOfficeClashBody(Object matric);

  /// No description provided for @examOfficeClashResolve.
  ///
  /// In en, this message translates to:
  /// **'Move {course}'**
  String examOfficeClashResolve(Object course);

  /// No description provided for @examOfficePapersHeading.
  ///
  /// In en, this message translates to:
  /// **'Papers'**
  String get examOfficePapersHeading;

  /// No description provided for @examOfficePaperBody.
  ///
  /// In en, this message translates to:
  /// **'{when}, {seated} of {enrolled} seated'**
  String examOfficePaperBody(Object enrolled, Object seated, Object when);

  /// No description provided for @examOfficeCardsHeading.
  ///
  /// In en, this message translates to:
  /// **'Issued cards'**
  String get examOfficeCardsHeading;

  /// No description provided for @examOfficeIssuedCardLine.
  ///
  /// In en, this message translates to:
  /// **'{matric} - {card}'**
  String examOfficeIssuedCardLine(Object card, Object matric);

  /// No description provided for @examOfficeCardValidTag.
  ///
  /// In en, this message translates to:
  /// **'Valid'**
  String get examOfficeCardValidTag;

  /// No description provided for @examOfficeCardWithdrawnTag.
  ///
  /// In en, this message translates to:
  /// **'Withdrawn'**
  String get examOfficeCardWithdrawnTag;

  /// No description provided for @examOfficeCardWithdrawnReason.
  ///
  /// In en, this message translates to:
  /// **'Withdrawn: {reason}'**
  String examOfficeCardWithdrawnReason(Object reason);

  /// No description provided for @examOfficeWithdrawAction.
  ///
  /// In en, this message translates to:
  /// **'Withdraw card'**
  String get examOfficeWithdrawAction;

  /// No description provided for @examOfficeWithdrawTitle.
  ///
  /// In en, this message translates to:
  /// **'Withdraw {name}\'s card'**
  String examOfficeWithdrawTitle(Object name);

  /// No description provided for @examOfficeWithdrawBody.
  ///
  /// In en, this message translates to:
  /// **'The public check fails from now on and the student cannot sit.'**
  String get examOfficeWithdrawBody;

  /// No description provided for @examOfficeWithdrawConfirm.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get examOfficeWithdrawConfirm;

  /// No description provided for @examResitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Resits'**
  String get examResitsTitle;

  /// No description provided for @examResitsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Matric number {matric}'**
  String examResitsSubtitle(Object matric);

  /// No description provided for @examResitPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Both attempts count'**
  String get examResitPolicyTitle;

  /// No description provided for @examResitPolicyBody.
  ///
  /// In en, this message translates to:
  /// **'Courses you failed and have not since passed. Taking one again does not replace the old mark - both attempts count towards your CGPA.'**
  String get examResitPolicyBody;

  /// No description provided for @examResitWorkedExample.
  ///
  /// In en, this message translates to:
  /// **'You failed CSC 201 with 22 in 25/26 • 1st Sem. If you resit it and score 61, both 22 and 61 count towards your CGPA.'**
  String get examResitWorkedExample;

  /// No description provided for @examResitAttemptPrevious.
  ///
  /// In en, this message translates to:
  /// **'Attempt 1 (previous)'**
  String get examResitAttemptPrevious;

  /// No description provided for @examResitAttemptResit.
  ///
  /// In en, this message translates to:
  /// **'Attempt 2 (resit)'**
  String get examResitAttemptResit;

  /// No description provided for @examResitExamplePreviousMark.
  ///
  /// In en, this message translates to:
  /// **'CSC 201: 22'**
  String get examResitExamplePreviousMark;

  /// No description provided for @examResitExampleResitMark.
  ///
  /// In en, this message translates to:
  /// **'Score: 61'**
  String get examResitExampleResitMark;

  /// No description provided for @examResitExampleFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get examResitExampleFailed;

  /// No description provided for @examResitBothCount.
  ///
  /// In en, this message translates to:
  /// **'Both count'**
  String get examResitBothCount;

  /// No description provided for @examResitWindowOpen.
  ///
  /// In en, this message translates to:
  /// **'Resit window {label} is open'**
  String examResitWindowOpen(Object label);

  /// No description provided for @examResitWindowClosed.
  ///
  /// In en, this message translates to:
  /// **'Resit window {label} is closed'**
  String examResitWindowClosed(Object label);

  /// No description provided for @examResitWindowCloses.
  ///
  /// In en, this message translates to:
  /// **'Closes {date}'**
  String examResitWindowCloses(Object date);

  /// No description provided for @examResitWindowClosedOn.
  ///
  /// In en, this message translates to:
  /// **'Closed {date}'**
  String examResitWindowClosedOn(Object date);

  /// No description provided for @examResitTagOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get examResitTagOpen;

  /// No description provided for @examResitTagClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get examResitTagClosed;

  /// No description provided for @examResitBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Unit allowance'**
  String get examResitBudgetTitle;

  /// No description provided for @examResitBudgetUsed.
  ///
  /// In en, this message translates to:
  /// **'{used} of {cap} units used'**
  String examResitBudgetUsed(Object cap, Object used);

  /// No description provided for @examResitBudgetLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} units left this semester.'**
  String examResitBudgetLeft(Object count);

  /// No description provided for @examResitCapCapacity.
  ///
  /// In en, this message translates to:
  /// **'{percent}% cap capacity'**
  String examResitCapCapacity(int percent);

  /// No description provided for @examResitBudgetRatio.
  ///
  /// In en, this message translates to:
  /// **'{used}/{cap}'**
  String examResitBudgetRatio(int used, int cap);

  /// No description provided for @examResitFailuresTitle.
  ///
  /// In en, this message translates to:
  /// **'Outstanding failures'**
  String get examResitFailuresTitle;

  /// No description provided for @examResitFailuresCount.
  ///
  /// In en, this message translates to:
  /// **'{count} pending'**
  String examResitFailuresCount(Object count);

  /// No description provided for @examResitFailuresNote.
  ///
  /// In en, this message translates to:
  /// **'A course leaves this list once you pass it.'**
  String get examResitFailuresNote;

  /// No description provided for @examResitFailuresEmpty.
  ///
  /// In en, this message translates to:
  /// **'You have no failed courses to resit.'**
  String get examResitFailuresEmpty;

  /// No description provided for @examResitFailedIn.
  ///
  /// In en, this message translates to:
  /// **'Failed with {score} in {term}'**
  String examResitFailedIn(Object score, Object term);

  /// No description provided for @examResitNotOpen.
  ///
  /// In en, this message translates to:
  /// **'Not open'**
  String get examResitNotOpen;

  /// No description provided for @examResitUsesLastUnits.
  ///
  /// In en, this message translates to:
  /// **'This would use your last {count} units.'**
  String examResitUsesLastUnits(Object count);

  /// No description provided for @examResitOverBudget.
  ///
  /// In en, this message translates to:
  /// **'This is over your unit allowance for the semester.'**
  String get examResitOverBudget;

  /// No description provided for @examResitRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get examResitRegister;

  /// No description provided for @examResitObligation.
  ///
  /// In en, this message translates to:
  /// **'Estimated total'**
  String get examResitObligation;

  /// No description provided for @examResitClosedHelp.
  ///
  /// In en, this message translates to:
  /// **'Registration is closed. Ask the examinations office if this affects you.'**
  String get examResitClosedHelp;

  /// No description provided for @examResitRegisteredTitle.
  ///
  /// In en, this message translates to:
  /// **'What you have registered'**
  String get examResitRegisteredTitle;

  /// No description provided for @examResitRegisteredCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 invoiced course} other{{count} invoiced courses}}'**
  String examResitRegisteredCount(int count);

  /// No description provided for @examResitRegisteredLine.
  ///
  /// In en, this message translates to:
  /// **'{units} units · {term}'**
  String examResitRegisteredLine(Object term, Object units);

  /// No description provided for @examResitRegisteredTag.
  ///
  /// In en, this message translates to:
  /// **'Registered'**
  String get examResitRegisteredTag;

  /// No description provided for @examResitAwaitingPayment.
  ///
  /// In en, this message translates to:
  /// **'Awaiting payment'**
  String get examResitAwaitingPayment;

  /// No description provided for @examResitPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get examResitPaid;

  /// No description provided for @examResitReceiptDocket.
  ///
  /// In en, this message translates to:
  /// **'Receipt docket'**
  String get examResitReceiptDocket;

  /// No description provided for @examResitInvoice.
  ///
  /// In en, this message translates to:
  /// **'Inv: #{reference}'**
  String examResitInvoice(Object reference);

  /// No description provided for @examResitSemester.
  ///
  /// In en, this message translates to:
  /// **'Semester: {term}'**
  String examResitSemester(String term);

  /// No description provided for @examResitPaymentRequired.
  ///
  /// In en, this message translates to:
  /// **'Payment action required'**
  String get examResitPaymentRequired;

  /// No description provided for @examResitBursaryClearance.
  ///
  /// In en, this message translates to:
  /// **'Bursary clearance'**
  String get examResitBursaryClearance;

  /// No description provided for @examResitSettleLedger.
  ///
  /// In en, this message translates to:
  /// **'Settle resit ledger item'**
  String get examResitSettleLedger;

  /// No description provided for @examResitPayFees.
  ///
  /// In en, this message translates to:
  /// **'Pay fees'**
  String get examResitPayFees;

  /// No description provided for @examResitHowTitle.
  ///
  /// In en, this message translates to:
  /// **'How a resit works'**
  String get examResitHowTitle;

  /// No description provided for @examResitRuleFailedOnly.
  ///
  /// In en, this message translates to:
  /// **'You may only register for a course you failed and have not since passed.'**
  String get examResitRuleFailedOnly;

  /// No description provided for @examResitRuleCap.
  ///
  /// In en, this message translates to:
  /// **'You may resit up to {cap} units in a semester.'**
  String examResitRuleCap(Object cap);

  /// No description provided for @examResitRuleFee.
  ///
  /// In en, this message translates to:
  /// **'The fee is {fee} per unit, invoiced when you register.'**
  String examResitRuleFee(Object fee);

  /// No description provided for @examResitRuleBoth.
  ///
  /// In en, this message translates to:
  /// **'Both the old attempt and the new one count towards your CGPA.'**
  String get examResitRuleBoth;

  /// No description provided for @examResitRuleWithdraw.
  ///
  /// In en, this message translates to:
  /// **'To withdraw from a resit, ask the examinations office. Any fee paid is credited back to your wallet.'**
  String get examResitRuleWithdraw;

  /// No description provided for @examResitConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Register for {code}?'**
  String examResitConfirmTitle(Object code);

  /// No description provided for @examResitConfirmSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{title} · {window} resit'**
  String examResitConfirmSubtitle(Object title, Object window);

  /// No description provided for @examResitConfirmPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous attempt'**
  String get examResitConfirmPrevious;

  /// No description provided for @examResitConfirmTag.
  ///
  /// In en, this message translates to:
  /// **'{window} resit'**
  String examResitConfirmTag(String window);

  /// No description provided for @examResitConfirmUnits.
  ///
  /// In en, this message translates to:
  /// **'Unit assessment breakdown'**
  String get examResitConfirmUnits;

  /// No description provided for @examResitConfirmRate.
  ///
  /// In en, this message translates to:
  /// **'{units} units · {rate} per unit'**
  String examResitConfirmRate(Object rate, Object units);

  /// No description provided for @examResitConfirmTotal.
  ///
  /// In en, this message translates to:
  /// **'Total payable'**
  String get examResitConfirmTotal;

  /// No description provided for @examResitConfirmTotalValue.
  ///
  /// In en, this message translates to:
  /// **'Total {amount}'**
  String examResitConfirmTotalValue(String amount);

  /// No description provided for @examResitConfirmBothTitle.
  ///
  /// In en, this message translates to:
  /// **'Statutory academic policy'**
  String get examResitConfirmBothTitle;

  /// No description provided for @examResitConfirmBothBody.
  ///
  /// In en, this message translates to:
  /// **'Both attempts count towards your CGPA. This mark will not replace your previous {score} in {term}.'**
  String examResitConfirmBothBody(Object score, Object term);

  /// No description provided for @examResitConfirmInvoiceNote.
  ///
  /// In en, this message translates to:
  /// **'The fee is invoiced when you register.'**
  String get examResitConfirmInvoiceNote;

  /// No description provided for @examResitConfirmWithdraw.
  ///
  /// In en, this message translates to:
  /// **'You are registering now. To withdraw later, ask the examinations office.'**
  String get examResitConfirmWithdraw;

  /// No description provided for @examResitConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get examResitConfirmAction;

  /// No description provided for @examResitConfirmDecline.
  ///
  /// In en, this message translates to:
  /// **'Not yet'**
  String get examResitConfirmDecline;

  /// No description provided for @examResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'My results'**
  String get examResultsTitle;

  /// No description provided for @examResultsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Each semester\'s marks, and where you stand overall.'**
  String get examResultsSubtitle;

  /// No description provided for @examResultsResitNote.
  ///
  /// In en, this message translates to:
  /// **'Both attempts at a resit count towards your CGPA.'**
  String get examResultsResitNote;

  /// No description provided for @examResultsDownloadSlip.
  ///
  /// In en, this message translates to:
  /// **'Download official grade slip (PDF)'**
  String get examResultsDownloadSlip;

  /// No description provided for @examResultsBreadcrumb.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get examResultsBreadcrumb;

  /// No description provided for @examResultsMatriculated.
  ///
  /// In en, this message translates to:
  /// **'Matriculated'**
  String get examResultsMatriculated;

  /// No description provided for @examResultsSenateApproved.
  ///
  /// In en, this message translates to:
  /// **'Senate approved'**
  String get examResultsSenateApproved;

  /// No description provided for @examResultsCumulativeLabel.
  ///
  /// In en, this message translates to:
  /// **'Cumulative grade point'**
  String get examResultsCumulativeLabel;

  /// No description provided for @examResultsSemesterGpaLabel.
  ///
  /// In en, this message translates to:
  /// **'Semester GPA'**
  String get examResultsSemesterGpaLabel;

  /// No description provided for @examResultsCumulativeCgpa.
  ///
  /// In en, this message translates to:
  /// **'Cumulative CGPA'**
  String get examResultsCumulativeCgpa;

  /// No description provided for @examResultsViewPrevious.
  ///
  /// In en, this message translates to:
  /// **'View previous semesters'**
  String get examResultsViewPrevious;

  /// No description provided for @examResultsHidePrevious.
  ///
  /// In en, this message translates to:
  /// **'Hide previous semesters'**
  String get examResultsHidePrevious;

  /// No description provided for @examResultsNoEarlier.
  ///
  /// In en, this message translates to:
  /// **'No earlier semester has been published.'**
  String get examResultsNoEarlier;

  /// No description provided for @examResultsLedgerStatus.
  ///
  /// In en, this message translates to:
  /// **'Status: Final ratified ledger'**
  String get examResultsLedgerStatus;

  /// No description provided for @examResultsSenateSection.
  ///
  /// In en, this message translates to:
  /// **'Senate Sec. 14'**
  String get examResultsSenateSection;

  /// No description provided for @examCourseResitWhen.
  ///
  /// In en, this message translates to:
  /// **'resit, {term}'**
  String examCourseResitWhen(String term);

  /// No description provided for @examStudentLine.
  ///
  /// In en, this message translates to:
  /// **'{level} level · {programme}'**
  String examStudentLine(Object level, Object programme);

  /// No description provided for @examCgpaValue.
  ///
  /// In en, this message translates to:
  /// **'CGPA {value}'**
  String examCgpaValue(Object value);

  /// No description provided for @examCgpaNote.
  ///
  /// In en, this message translates to:
  /// **'Counted from published results only.'**
  String get examCgpaNote;

  /// No description provided for @examResultsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No results published yet'**
  String get examResultsEmptyTitle;

  /// No description provided for @examResultsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Your marks for {session} appear here once the registry has approved and published them.'**
  String examResultsEmptyBody(Object session);

  /// No description provided for @examResultsStepLecturer.
  ///
  /// In en, this message translates to:
  /// **'Your lecturer marks the papers.'**
  String get examResultsStepLecturer;

  /// No description provided for @examResultsStepDepartment.
  ///
  /// In en, this message translates to:
  /// **'The head of department approves the marks.'**
  String get examResultsStepDepartment;

  /// No description provided for @examResultsStepRegistry.
  ///
  /// In en, this message translates to:
  /// **'The registry publishes them.'**
  String get examResultsStepRegistry;

  /// No description provided for @examStandingGood.
  ///
  /// In en, this message translates to:
  /// **'Good standing'**
  String get examStandingGood;

  /// No description provided for @examStandingProbation.
  ///
  /// In en, this message translates to:
  /// **'On probation'**
  String get examStandingProbation;

  /// No description provided for @examStandingWithdrawal.
  ///
  /// In en, this message translates to:
  /// **'Advised to withdraw'**
  String get examStandingWithdrawal;

  /// No description provided for @examStandingTitle.
  ///
  /// In en, this message translates to:
  /// **'Where you stand'**
  String get examStandingTitle;

  /// No description provided for @examStandingOutOf.
  ///
  /// In en, this message translates to:
  /// **'CGPA · of {max}'**
  String examStandingOutOf(Object max);

  /// No description provided for @examStandingThresholds.
  ///
  /// In en, this message translates to:
  /// **'Probation under {probation}. Withdrawal under {withdrawal}.'**
  String examStandingThresholds(Object probation, Object withdrawal);

  /// No description provided for @examStandingUnits.
  ///
  /// In en, this message translates to:
  /// **'{passed} of {taken} units passed'**
  String examStandingUnits(Object passed, Object taken);

  /// No description provided for @examStandingOnCourse.
  ///
  /// In en, this message translates to:
  /// **'On course for {classification}'**
  String examStandingOnCourse(Object classification);

  /// No description provided for @examAdvisoryProbationTitle.
  ///
  /// In en, this message translates to:
  /// **'Speak to your level adviser about how to bring your CGPA up.'**
  String get examAdvisoryProbationTitle;

  /// No description provided for @examAdvisoryStatute.
  ///
  /// In en, this message translates to:
  /// **'Academic Board Resolution · Stat. 14(B)'**
  String get examAdvisoryStatute;

  /// No description provided for @examAdvisoryProbationContinue.
  ///
  /// In en, this message translates to:
  /// **'You are below the CGPA this course needs to continue.'**
  String get examAdvisoryProbationContinue;

  /// No description provided for @examAdvisoryProbationSemester.
  ///
  /// In en, this message translates to:
  /// **'This semester counts towards it too.'**
  String get examAdvisoryProbationSemester;

  /// No description provided for @examAdvisoryProbationFinal.
  ///
  /// In en, this message translates to:
  /// **'Nothing here is final. Raising your CGPA next semester changes it.'**
  String get examAdvisoryProbationFinal;

  /// No description provided for @examAdvisoryAdviserRole.
  ///
  /// In en, this message translates to:
  /// **'Level adviser ({programme})'**
  String examAdvisoryAdviserRole(String programme);

  /// No description provided for @examAdvisoryBook.
  ///
  /// In en, this message translates to:
  /// **'Book urgent advising session'**
  String get examAdvisoryBook;

  /// No description provided for @examAdvisoryWithdrawalTitle.
  ///
  /// In en, this message translates to:
  /// **'You are advised to withdraw'**
  String get examAdvisoryWithdrawalTitle;

  /// No description provided for @examAdvisoryWithdrawalBody.
  ///
  /// In en, this message translates to:
  /// **'Your CGPA is under the withdrawal threshold. Speak to your level adviser about your options before the senate appeal window closes.'**
  String get examAdvisoryWithdrawalBody;

  /// No description provided for @examAdvisoryAdviser.
  ///
  /// In en, this message translates to:
  /// **'Level adviser · {office}'**
  String examAdvisoryAdviser(Object office);

  /// No description provided for @examScaleTitle.
  ///
  /// In en, this message translates to:
  /// **'Degree classification scale'**
  String get examScaleTitle;

  /// No description provided for @examScaleRange.
  ///
  /// In en, this message translates to:
  /// **'{from} – {to}'**
  String examScaleRange(Object from, Object to);

  /// No description provided for @examTermGpa.
  ///
  /// In en, this message translates to:
  /// **'GPA {value}'**
  String examTermGpa(Object value);

  /// No description provided for @examTermUnitsTaken.
  ///
  /// In en, this message translates to:
  /// **'Units taken'**
  String get examTermUnitsTaken;

  /// No description provided for @examTermUnitsPassed.
  ///
  /// In en, this message translates to:
  /// **'Units passed'**
  String get examTermUnitsPassed;

  /// No description provided for @examUnitsValue.
  ///
  /// In en, this message translates to:
  /// **'{count} units'**
  String examUnitsValue(Object count);

  /// No description provided for @examCourseResit.
  ///
  /// In en, this message translates to:
  /// **'Resit'**
  String get examCourseResit;

  /// No description provided for @examCourseHeldBack.
  ///
  /// In en, this message translates to:
  /// **'Held back'**
  String get examCourseHeldBack;

  /// No description provided for @examCourseOutOf.
  ///
  /// In en, this message translates to:
  /// **'of 100'**
  String get examCourseOutOf;

  /// No description provided for @examCourseNoGrade.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get examCourseNoGrade;

  /// No description provided for @examCourseNoMark.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get examCourseNoMark;

  /// No description provided for @examCourseResitNote.
  ///
  /// In en, this message translates to:
  /// **'Earlier attempt: {score} in {term}. Both attempts count towards your CGPA.'**
  String examCourseResitNote(Object score, Object term);

  /// No description provided for @examCourseHeldBackNote.
  ///
  /// In en, this message translates to:
  /// **'Your mark for this course is being held back. Speak to the examinations office.'**
  String get examCourseHeldBackNote;

  /// No description provided for @examCourseNotMarked.
  ///
  /// In en, this message translates to:
  /// **'Not marked yet.'**
  String get examCourseNotMarked;

  /// No description provided for @examVerifyBrandCaption.
  ///
  /// In en, this message translates to:
  /// **'Examination card check'**
  String get examVerifyBrandCaption;

  /// No description provided for @examVerifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Check an examination card'**
  String get examVerifyTitle;

  /// No description provided for @examVerifySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Type the check code printed on the card, or scan its QR mark.'**
  String get examVerifySubtitle;

  /// No description provided for @examVerifyCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Check code'**
  String get examVerifyCodeLabel;

  /// No description provided for @examVerifyCodeHint.
  ///
  /// In en, this message translates to:
  /// **'K7Q2M4XB9PTR'**
  String get examVerifyCodeHint;

  /// No description provided for @examVerifyCodeHelper.
  ///
  /// In en, this message translates to:
  /// **'Codes are {count} characters.'**
  String examVerifyCodeHelper(Object count);

  /// No description provided for @examVerifyAction.
  ///
  /// In en, this message translates to:
  /// **'Check card'**
  String get examVerifyAction;

  /// No description provided for @examVerifyValidTitle.
  ///
  /// In en, this message translates to:
  /// **'Valid card'**
  String get examVerifyValidTitle;

  /// No description provided for @examVerifyValidBody.
  ///
  /// In en, this message translates to:
  /// **'Cleared for hall entry.'**
  String get examVerifyValidBody;

  /// No description provided for @examVerifyName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get examVerifyName;

  /// No description provided for @examVerifyMatric.
  ///
  /// In en, this message translates to:
  /// **'Matric number'**
  String get examVerifyMatric;

  /// No description provided for @examVerifyProgramme.
  ///
  /// In en, this message translates to:
  /// **'Programme'**
  String get examVerifyProgramme;

  /// No description provided for @examVerifyCard.
  ///
  /// In en, this message translates to:
  /// **'Card number'**
  String get examVerifyCard;

  /// No description provided for @examVerifyPapers.
  ///
  /// In en, this message translates to:
  /// **'Eligible papers'**
  String get examVerifyPapers;

  /// No description provided for @examVerifyPapersValue.
  ///
  /// In en, this message translates to:
  /// **'{count} · session {session}'**
  String examVerifyPapersValue(Object count, Object session);

  /// No description provided for @examVerifyInvalidTitle.
  ///
  /// In en, this message translates to:
  /// **'This card is not valid'**
  String get examVerifyInvalidTitle;

  /// No description provided for @examVerifyWithdrawnBody.
  ///
  /// In en, this message translates to:
  /// **'The card was withdrawn.'**
  String get examVerifyWithdrawnBody;

  /// No description provided for @examVerifyWithdrawnWhy.
  ///
  /// In en, this message translates to:
  /// **'The card was withdrawn: {reason}.'**
  String examVerifyWithdrawnWhy(Object reason);

  /// No description provided for @examVerifyStandingBody.
  ///
  /// In en, this message translates to:
  /// **'The holder is not currently a student in good standing. Tell the student to see the examinations office.'**
  String get examVerifyStandingBody;

  /// No description provided for @examVerifyNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'No card matches this code.'**
  String get examVerifyNotFoundTitle;

  /// No description provided for @examVerifyNotFoundBody.
  ///
  /// In en, this message translates to:
  /// **'Codes are {count} characters. Check it was copied correctly.'**
  String examVerifyNotFoundBody(Object count);

  /// No description provided for @examVerifyPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Student privacy'**
  String get examVerifyPrivacyTitle;

  /// No description provided for @examVerifyPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'A valid card shows five facts and no photo. Nothing else about the student is disclosed.'**
  String get examVerifyPrivacyBody;

  /// No description provided for @examVerifySignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in to the portal'**
  String get examVerifySignIn;
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

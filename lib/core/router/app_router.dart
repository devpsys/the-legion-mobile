import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/admissions/presentation/bloc/admission_verification_cubit.dart';
import '../../features/admissions/presentation/bloc/admissions_cubit.dart';
import '../../features/admissions/presentation/bloc/jamb_claim_cubit.dart';
import '../../features/admissions/presentation/pages/admission_letter_page.dart';
import '../../features/admissions/presentation/pages/admissions_overview_page.dart';
import '../../features/admissions/presentation/pages/application_detail_page.dart';
import '../../features/admissions/presentation/pages/applications_page.dart';
import '../../features/admissions/presentation/pages/jamb_claim_page.dart';
import '../../features/admissions/presentation/pages/programmes_page.dart';
import '../../features/admissions/presentation/pages/verify_admission_page.dart';
import '../../features/admissions/presentation/widgets/admissions_shell.dart';
import '../../features/auth/presentation/pages/create_account_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/fees/presentation/bloc/fee_card_checkout_cubit.dart';
import '../../features/fees/presentation/bloc/fee_checkout_cubit.dart';
import '../../features/fees/presentation/bloc/fee_gateway_return_cubit.dart';
import '../../features/fees/presentation/bloc/fee_receipt_cubit.dart';
import '../../features/fees/presentation/bloc/fees_cubit.dart';
import '../../features/fees/presentation/bloc/receipt_verification_cubit.dart';
import '../../features/fees/presentation/pages/fee_card_checkout_page.dart';
import '../../features/fees/presentation/pages/fee_checkout_page.dart';
import '../../features/fees/presentation/pages/fee_gateway_return_page.dart';
import '../../features/fees/presentation/pages/fee_receipt_page.dart';
import '../../features/fees/presentation/pages/fees_page.dart';
import '../../features/fees/presentation/pages/verify_receipt_page.dart';
import '../../features/home/presentation/pages/home_overview_page.dart';
import '../../features/home/presentation/pages/home_shell_page.dart';
import '../../features/password_recovery/presentation/bloc/password_recovery_cubit.dart';
import '../../features/password_recovery/presentation/pages/recovery_success_page.dart';
import '../../features/password_recovery/presentation/pages/request_recovery_code_page.dart';
import '../../features/password_recovery/presentation/pages/set_new_password_page.dart';
import '../../features/password_recovery/presentation/pages/verify_recovery_code_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/registration/presentation/bloc/registration_cubit.dart';
import '../../features/registration/presentation/pages/course_form_page.dart';
import '../../features/registration/presentation/pages/course_registration_page.dart';
import '../../features/registration/presentation/pages/study_plan_page.dart';
import '../../features/registration/presentation/widgets/registration_shell.dart';
import '../di/injection.dart';
import 'auth_guard.dart';
import 'route_names.dart';
import 'router_refresh_notifier.dart';
import 'widgets/route_error_page.dart';

/// Decides where [location] must redirect to, or `null` to stay.
///
/// Extracted from [createRouter] as a pure function so the authentication
/// rules can be unit tested without a widget tree or a router instance.
///
/// | Session | Current location | Redirect |
/// | --- | --- | --- |
/// | unresolved | anything but `/` | `/` (splash) |
/// | resolved, anonymous | anything but the entry screens and the public screens | `/login` |
/// | resolved, authenticated | `/` or an entry screen | `/home` |
///
/// The entry screens (`Routes.entryPaths`) are sign-in, account creation and
/// the recovery flow. The public screens (`Routes.publicPaths`) are left alone
/// in both resolved states: letter verification is for whoever holds the
/// letter.
String? resolveRedirect({
  required AuthGuard authGuard,
  required String location,
}) {
  // Until the persisted session is restored, only the splash is reachable so
  // protected screens never flash before authentication is known.
  if (!authGuard.isSessionResolved) {
    return location == Routes.splash ? null : Routes.splash;
  }

  if (!authGuard.isAuthenticated) {
    // Anonymous: the splash has done its job. The entry screens and the
    // public screens are the only reachable ones — recovery and account
    // creation are exactly what a signed-out visitor needs, so they must not
    // bounce back to sign-in.
    final isReachable =
        Routes.entryPaths.contains(location) ||
        Routes.publicPaths.contains(location);
    return isReachable ? null : Routes.login;
  }

  // Authenticated: nothing left to do on the splash or any entry screen.
  if (location == Routes.splash || Routes.entryPaths.contains(location)) {
    return Routes.home;
  }
  return null;
}

/// Builds the application router.
///
/// Handles authentication-aware redirects, deep links and web URLs. The
/// router is the composition root of navigation: it is the only place allowed
/// to reference concrete feature pages.
GoRouter createRouter({
  required AuthGuard authGuard,
  required Stream<Object?> authStateChanges,
}) {
  return GoRouter(
    initialLocation: Routes.splash,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: RouterRefreshNotifier(authStateChanges),
    errorBuilder: (context, state) =>
        RouteErrorPage(location: state.uri.toString()),
    redirect: (context, state) =>
        resolveRedirect(authGuard: authGuard, location: state.matchedLocation),
    routes: [
      GoRoute(
        path: Routes.splash,
        name: Routes.splashName,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: Routes.login,
        name: Routes.loginName,
        builder: (context, state) => const LoginPage(),
      ),
      // Opening an applicant account reads the same session cubit as
      // sign-in: success is a session, and the redirect takes it from there.
      GoRoute(
        path: Routes.createAccount,
        name: Routes.createAccountName,
        builder: (context, state) => const CreateAccountPage(),
      ),
      // Public verification of an admission letter. Outside every shell: the
      // person holding the letter is not a candidate and has no portal to be
      // inside of. Its own cubit per visit, so one check never shows the
      // next visitor the last one's result.
      GoRoute(
        path: Routes.verifyAdmission,
        name: Routes.verifyAdmissionName,
        builder: (context, state) => BlocProvider<AdmissionVerificationCubit>(
          create: (context) => sl<AdmissionVerificationCubit>(),
          child: VerifyAdmissionPage(
            initialCode:
                state.uri.queryParameters[Routes.verifyAdmissionCodeParam],
          ),
        ),
      ),
      // Public verification of a bursary receipt — same privacy posture as
      // the letter check: five facts, no session, no shell.
      GoRoute(
        path: Routes.verifyReceipt,
        name: Routes.verifyReceiptName,
        builder: (context, state) => BlocProvider<ReceiptVerificationCubit>(
          create: (context) => sl<ReceiptVerificationCubit>(),
          child: VerifyReceiptPage(
            initialCode:
                state.uri.queryParameters[Routes.verifyReceiptCodeParam],
          ),
        ),
      ),
      // One cubit for the whole recovery flow: the identifier, the masked
      // destinations and the attempt counters survive step changes, and a new
      // entry into the flow starts clean.
      ShellRoute(
        builder: (context, state, child) => BlocProvider<PasswordRecoveryCubit>(
          create: (context) => sl<PasswordRecoveryCubit>(),
          child: child,
        ),
        routes: [
          GoRoute(
            path: Routes.forgotPassword,
            name: Routes.forgotPasswordName,
            builder: (context, state) => const RequestRecoveryCodePage(),
          ),
          GoRoute(
            path: Routes.verifyRecoveryCode,
            name: Routes.verifyRecoveryCodeName,
            builder: (context, state) => const VerifyRecoveryCodePage(),
          ),
          GoRoute(
            path: Routes.setNewPassword,
            name: Routes.setNewPasswordName,
            builder: (context, state) => const SetNewPasswordPage(),
          ),
          GoRoute(
            path: Routes.recoverySuccess,
            name: Routes.recoverySuccessName,
            builder: (context, state) => const RecoverySuccessPage(),
          ),
        ],
      ),
      // Branch order is `HomeTab` order: the shell reads its tabs from the
      // enum and the router must agree.
      StatefulShellRoute.indexedStack(
        // The URI's path, not `matchedLocation`: a shell match keeps the
        // location it was matched with, so after the checkout is popped off
        // the fees branch it would still read as the checkout and the tab
        // bar would stay hidden. The URI is recomputed on every pop.
        builder: (context, state, navigationShell) => HomeShellPage(
          navigationShell: navigationShell,
          location: state.uri.path,
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                name: Routes.homeName,
                builder: (context, state) => const HomeOverviewPage(),
              ),
            ],
          ),
          // The fees tab and the checkout above it share one cubit: the
          // checkout pays the invoices the tab lists, so both must read one
          // ledger. The shell route scopes it to the branch, where the
          // indexed stack keeps it alive across tab switches.
          StatefulShellBranch(
            routes: [
              ShellRoute(
                builder: (context, state, child) => BlocProvider<FeesCubit>(
                  create: (context) => sl<FeesCubit>(),
                  child: child,
                ),
                routes: [
                  GoRoute(
                    path: Routes.fees,
                    name: Routes.feesName,
                    builder: (context, state) => const FeesPage(),
                    routes: [
                      // Checkout + card + gateway return share one
                      // FeeCheckoutCubit so Proceed can hand the chosen
                      // invoices and amount to the card screen without
                      // re-encoding them. The shell replaces the child as
                      // the stack steps; back restores the previous child.
                      ShellRoute(
                        builder: (context, state, child) =>
                            BlocProvider<FeeCheckoutCubit>(
                              create: (context) => sl<FeeCheckoutCubit>(),
                              child: child,
                            ),
                        routes: [
                          GoRoute(
                            path: Routes.feesCheckoutSegment,
                            name: Routes.feesCheckoutName,
                            builder: (context, state) => FeeCheckoutPage(
                              invoiceIds: Routes.feesCheckoutInvoicesFrom(
                                state.uri.queryParameters[Routes
                                    .feesCheckoutInvoicesParam],
                              ),
                            ),
                            routes: [
                              GoRoute(
                                path: Routes.feesCardCheckoutSegment,
                                name: Routes.feesCardCheckoutName,
                                builder: (context, state) =>
                                    BlocProvider<FeeCardCheckoutCubit>(
                                      create: (context) =>
                                          sl<FeeCardCheckoutCubit>(),
                                      child: const FeeCardCheckoutPage(),
                                    ),
                              ),
                              GoRoute(
                                path: Routes.feesGatewayReturnSegment,
                                name: Routes.feesGatewayReturnName,
                                builder: (context, state) =>
                                    BlocProvider<FeeGatewayReturnCubit>(
                                      create: (context) =>
                                          sl<FeeGatewayReturnCubit>(),
                                      child: FeeGatewayReturnPage(
                                        reference:
                                            state.uri.queryParameters[Routes
                                                .feesGatewayReturnRefParam] ??
                                            '',
                                      ),
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      GoRoute(
                        path: '${Routes.feesReceiptSegment}/:id',
                        name: Routes.feesReceiptName,
                        builder: (context, state) =>
                            BlocProvider<FeeReceiptCubit>(
                              create: (context) => sl<FeeReceiptCubit>(),
                              child: FeeReceiptPage(
                                receiptId:
                                    state.pathParameters[Routes
                                        .feesReceiptIdParam] ??
                                    '',
                              ),
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profile,
                name: Routes.profileName,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
      // The candidate portal owns its own navigation chrome — a candidate is
      // not a student yet — so it sits outside the student shell rather than as
      // another tab inside it.
      //
      // One cubit across all three sections: the catalogue is large, the
      // chosen cycle is a decision the candidate made on one screen and
      // expects to still hold on the others, and the tab bar is the only
      // navigation between them. Back is handled once, by `AdmissionsShell`,
      // in the root navigator.
      ShellRoute(
        builder: (context, state, child) => AdmissionsShell(
          location: state.matchedLocation,
          child: BlocProvider<AdmissionsCubit>(
            create: (context) => sl<AdmissionsCubit>(),
            child: child,
          ),
        ),
        routes: [
          GoRoute(
            path: Routes.admissions,
            name: Routes.admissionsName,
            builder: (context, state) => const AdmissionsOverviewPage(),
          ),
          GoRoute(
            path: Routes.admissionsProgrammes,
            name: Routes.admissionsProgrammesName,
            builder: (context, state) => const ProgrammesPage(),
          ),
          GoRoute(
            path: Routes.admissionsApplications,
            name: Routes.admissionsApplicationsName,
            builder: (context, state) => const ApplicationsPage(),
          ),
          // The fourth tab. Its own cubit per visit for the form — a half-typed
          // number is not worth keeping across tabs — while the result, once
          // linked, lives on the portal's cubit with the rest of the record.
          GoRoute(
            path: Routes.admissionsJamb,
            name: Routes.admissionsJambName,
            builder: (context, state) => BlocProvider<JambClaimCubit>(
              create: (context) => sl<JambClaimCubit>(),
              child: const JambClaimPage(),
            ),
          ),
          // A stack step above the record, not a fourth tab: the design gives
          // it its own back chevron and no tab bar, because a candidate
          // reading a checklist is not moving between sections.
          GoRoute(
            path: Routes.admissionsApplicationDetailTemplate,
            name: Routes.admissionsApplicationDetailName,
            builder: (context, state) => ApplicationDetailPage(
              applicationId: state.pathParameters['id'] ?? '',
            ),
          ),
          // The letter: one more step above the record. It reads the same
          // cubit as the detail, so the document and the card that opened it
          // are drawn from one record.
          GoRoute(
            path: Routes.admissionsAdmissionLetterTemplate,
            name: Routes.admissionsAdmissionLetterName,
            builder: (context, state) => AdmissionLetterPage(
              applicationId: state.pathParameters['id'] ?? '',
            ),
          ),
        ],
      ),
      // Registration & Records: enrolled-student academic portal. Outside the
      // student shell so it can keep its own Registration / Study plan / Form
      // tabs, the same way Admissions keeps Overview / Programmes / ….
      ShellRoute(
        builder: (context, state, child) => RegistrationShell(
          location: state.matchedLocation,
          child: BlocProvider<RegistrationCubit>(
            create: (context) => sl<RegistrationCubit>(),
            child: child,
          ),
        ),
        routes: [
          GoRoute(
            path: Routes.registration,
            name: Routes.registrationName,
            builder: (context, state) => const CourseRegistrationPage(),
          ),
          GoRoute(
            path: Routes.registrationStudyPlan,
            name: Routes.registrationStudyPlanName,
            builder: (context, state) => const StudyPlanPage(),
          ),
          GoRoute(
            path: Routes.registrationForm,
            name: Routes.registrationFormName,
            builder: (context, state) => const CourseFormPage(),
          ),
        ],
      ),
    ],
  );
}

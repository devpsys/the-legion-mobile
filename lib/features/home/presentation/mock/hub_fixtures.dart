import 'package:flutter/material.dart';

import '../../../../core/router/route_names.dart';
import '../models/hub_models.dart';

/// Sample content for the student landing hub.
///
/// Presentation-only placeholders: delete this file once the hub's endpoints
/// exist and feed the models from a repository. The names, amounts and
/// announcements are invented for the mock.
abstract final class HubFixtures {
  // --- Student ------------------------------------------------------------

  /// Standing shown under the greeting.
  static const HubStanding standing = HubStanding(
    level: '300 Level',
    programme: 'B.Sc. Computer Science',
  );

  // --- Term ---------------------------------------------------------------

  static final HubTerm term = HubTerm(
    session: '2025/2026',
    semesterShort: '2nd Sem',
    semesterLong: '2nd Semester',
    startsOn: DateTime(2026, 9),
    endsOn: DateTime(2027, 1, 20),
  );

  // --- Do this next -------------------------------------------------------

  /// The sequential flow: each step depends on the one above it.
  static final List<TimelineStep> nextSteps = [
    TimelineStep(
      id: 'accommodation-fee',
      title: 'Pay your accommodation fee',
      detail: [
        HubTextRun('Bed held until 3 October · '),
        HubTextRun('₦35,000.00', isEmphasised: true),
      ],
      state: TimelineStepState.actionable,
      icon: Icons.home_outlined,
      dueOn: DateTime(2026, 10, 3),
    ),
    TimelineStep(
      id: 'course-form',
      title: 'Submit your course form',
      detail: [HubTextRun('18 units added · not yet submitted')],
      state: TimelineStepState.blocked,
      icon: Icons.description_outlined,
    ),
    TimelineStep(
      id: 'exam-card',
      title: 'Your exam card is not ready',
      detail: [
        HubTextRun('Needs registration submitted & '),
        HubTextRun('₦50,000.00', isEmphasised: true),
        HubTextRun(' paid'),
      ],
      state: TimelineStepState.blocked,
      icon: Icons.military_tech_outlined,
    ),
    TimelineStep(
      id: 'passport-photo',
      title: 'Upload your passport photo',
      detail: [HubTextRun('Required before your ID card can be printed')],
      state: TimelineStepState.waiting,
      icon: Icons.upload_outlined,
    ),
    TimelineStep(
      id: 'first-term-fees',
      title: 'First term fees paid',
      detail: [
        HubTextRun('₦99,000.00', isEmphasised: true),
        HubTextRun(' paid at bank · 12 Sep'),
      ],
      state: TimelineStepState.done,
      icon: Icons.check,
      isInteractive: false,
    ),
  ];

  // --- Module directory ---------------------------------------------------

  static const List<ModuleCluster> clusters = [
    ModuleCluster(
      id: 'academic-records',
      label: 'Academic & Records',
      modules: [
        PortalModule(
          id: 'admissions',
          label: 'Admissions',
          icon: Icons.description_outlined,
          routeName: Routes.admissionsName,
        ),
        PortalModule(
          id: 'learning',
          label: 'Learning',
          icon: Icons.menu_book_outlined,
        ),
        PortalModule(
          id: 'examinations',
          label: 'Examinations & Results',
          icon: Icons.military_tech_outlined,
        ),
        PortalModule(
          id: 'registration',
          label: 'Registration & Records',
          icon: Icons.school_outlined,
        ),
      ],
    ),
    ModuleCluster(
      id: 'campus-life',
      label: 'Campus Life & Facilities',
      modules: [
        PortalModule(
          id: 'accommodation',
          label: 'Accommodation',
          icon: Icons.home_outlined,
        ),
        PortalModule(
          id: 'library',
          label: 'Library',
          icon: Icons.local_library_outlined,
        ),
        PortalModule(
          id: 'clinic',
          label: 'Clinic',
          icon: Icons.local_hospital_outlined,
        ),
        PortalModule(
          id: 'fees',
          label: 'Fees & Payments',
          icon: Icons.account_balance_wallet_outlined,
        ),
        PortalModule(
          id: 'affairs',
          label: 'Student Affairs',
          icon: Icons.groups_outlined,
        ),
      ],
    ),
    ModuleCluster(
      id: 'career',
      label: 'Career & Advancement',
      modules: [
        PortalModule(
          id: 'clearance',
          label: 'Clearance',
          icon: Icons.verified_outlined,
        ),
        PortalModule(
          id: 'research',
          label: 'Postgraduate & Research',
          icon: Icons.science_outlined,
        ),
        PortalModule(
          id: 'siwes',
          label: 'Industrial Training',
          icon: Icons.work_outline,
        ),
        PortalModule(
          id: 'alumni',
          label: 'Graduation & Alumni',
          icon: Icons.workspace_premium_outlined,
        ),
      ],
    ),
  ];

  // --- Announcements ------------------------------------------------------

  static const List<Announcement> announcements = [
    Announcement(
      id: 'exam-venue',
      category: AnnouncementCategory.urgent,
      publishedLabel: '3 hours ago',
      title: 'Examination venue changes for Faculty of Science',
      body:
          'All CSC301 and CSC305 examinations scheduled for Hall B have been '
          'moved to LT-2 New Science Complex due to power repairs.',
    ),
    Announcement(
      id: 'hostel-maintenance',
      category: AnnouncementCategory.notice,
      publishedLabel: 'Yesterday',
      title: 'Hostel maintenance protocol & inspection window',
      body:
          'Suleiman and Amina Halls will undergo statutory electrical '
          'inspection this Saturday between 09:00 and 14:00.',
    ),
    Announcement(
      id: 'library-archive',
      category: AnnouncementCategory.information,
      publishedLabel: '2 days ago',
      title: 'Library digital archive access extended',
      body:
          'Off-campus proxy credentials now authenticate directly via your '
          'institutional matriculation ID.',
    ),
  ];

  // --- Account panel ------------------------------------------------------

  /// `profile` is the only shortcut wired to a real route today.
  static const List<AccountUtility> accountUtilities = [
    AccountUtility(
      id: 'profile',
      label: 'Profile',
      icon: Icons.person_outline,
      routeName: Routes.profileName,
    ),
    AccountUtility(
      id: 'academic-info',
      label: 'Personal & academic',
      icon: Icons.description_outlined,
    ),
    AccountUtility(
      id: 'documents',
      label: 'Documents',
      icon: Icons.find_in_page_outlined,
    ),
    AccountUtility(
      id: 'payments',
      label: 'Payments',
      icon: Icons.credit_card_outlined,
    ),
    AccountUtility(
      id: 'notifications',
      label: 'Notifications',
      icon: Icons.notifications_outlined,
    ),
    AccountUtility(id: 'security', label: 'Security', icon: Icons.lock_outline),
  ];
}

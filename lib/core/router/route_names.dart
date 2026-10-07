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

  /// The student's fees: a tab of the student shell, like the profile.
  static const String fees = '/home/fees';

  /// The checkout's own segment under [fees]; the router nests it there so
  /// the tab's navigator stacks the two and back pops to the tab.
  static const String feesCheckoutSegment = 'checkout';

  /// The checkout, a stack step above the fees tab. Which open invoices it
  /// is for travels in the query under [feesCheckoutInvoicesParam]; none
  /// named means all of them.
  static const String feesCheckout = '$fees/$feesCheckoutSegment';

  /// Name of the query parameter [feesCheckout] reads invoice ids from, as a
  /// comma-separated list.
  static const String feesCheckoutInvoicesParam = 'invoices';

  /// The query value naming [ids] for [feesCheckout].
  static String feesCheckoutInvoicesQuery(Iterable<String> ids) =>
      ids.join(',');

  /// The ids a [feesCheckout] query value names; empty for a missing or
  /// blank value.
  static List<String> feesCheckoutInvoicesFrom(String? query) => [
    if (query != null)
      for (final id in query.split(','))
        if (id.trim().isNotEmpty) id.trim(),
  ];

  /// Card entry nested under [feesCheckout].
  static const String feesCardCheckoutSegment = 'card';

  /// Card checkout location: `/home/fees/checkout/card`.
  static const String feesCardCheckout =
      '$feesCheckout/$feesCardCheckoutSegment';

  /// Gateway return nested under [feesCheckout].
  static const String feesGatewayReturnSegment = 'return';

  /// Gateway return location: `/home/fees/checkout/return`.
  static const String feesGatewayReturn =
      '$feesCheckout/$feesGatewayReturnSegment';

  /// Query parameter naming the gateway-return payment reference.
  static const String feesGatewayReturnRefParam = 'ref';

  /// Official receipt nested under [fees].
  static const String feesReceiptSegment = 'receipts';

  /// Path template of one official receipt; `:id` is the payment's id.
  static const String feesReceiptTemplate = '$fees/$feesReceiptSegment/:id';

  /// Concrete receipt location for [id].
  static String feesReceipt(String id) =>
      feesReceiptTemplate.replaceFirst(':id', id);

  /// Public verification of a bursary receipt — for whoever is handed one.
  ///
  /// Outside every shell: no session, no tab bar, no bell. A code may arrive
  /// in the query (`?code=…`), which is what the receipt's QR mark encodes.
  static const String verifyReceipt = '/verify/receipt';

  /// Name of the query parameter [verifyReceipt] reads a code from.
  static const String verifyReceiptCodeParam = 'code';

  // Account recovery flow
  static const String forgotPassword = '/forgot-password';
  static const String verifyRecoveryCode = '/forgot-password/verify';
  static const String setNewPassword = '/forgot-password/new-password';
  static const String recoverySuccess = '/forgot-password/success';

  // Candidate admissions portal
  static const String admissions = '/admissions';
  static const String admissionsProgrammes = '/admissions/programmes';
  static const String admissionsApplications = '/admissions/applications';

  /// The portal's fourth tab: claiming the JAMB result CAPS sent.
  static const String admissionsJamb = '/admissions/jamb';

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

  /// Student Registration & Records portal — course registration, study plan,
  /// course form, requests, and discipline. Outside the student shell: own tab
  /// chrome, back to the hub from the registration tab.
  static const String registration = '/registration';

  /// Study plan tab of the registration portal.
  static const String registrationStudyPlan = '/registration/study-plan';

  /// Official course form document tab.
  static const String registrationForm = '/registration/form';

  /// Academic requests tab of the registration portal.
  static const String registrationRequests = '/registration/requests';

  /// Student ID card request screen (sibling of Requests; not its own tab).
  static const String registrationIdCard = '/registration/id-card';

  /// Student discipline list (sibling of Registration; not its own tab).
  static const String registrationDiscipline = '/registration/discipline';

  /// Path template of one disciplinary case; `:caseId` is the case id.
  static const String registrationDisciplineCaseTemplate =
      '$registrationDiscipline/:caseId';

  /// Concrete case location for [caseId].
  static String registrationDisciplineCase(String caseId) =>
      registrationDisciplineCaseTemplate.replaceFirst(':caseId', caseId);

  /// Path parameter name for [registrationDisciplineCaseTemplate].
  static const String registrationDisciplineCaseIdParam = 'caseId';

  /// Staff Registration & Records root (HoD approvals + registry). Authenticated
  /// but not linked from the student hub — reserved for the staff portal.
  static const String staffRegistration = '/registration/staff';

  /// HoD course-registration approvals queue.
  static const String staffRegistrationApprovals =
      '$staffRegistration/approvals';

  /// Path template of one student's course form under review.
  static const String staffRegistrationDecisionTemplate =
      '$staffRegistrationApprovals/:studentId';

  static String staffRegistrationDecision(String studentId) =>
      staffRegistrationDecisionTemplate.replaceFirst(':studentId', studentId);

  static const String staffRegistrationStudentIdParam = 'studentId';

  /// HoD student-requests decision queue.
  static const String staffStudentRequests = '$staffRegistration/requests';

  /// Path template of study-plan advising for one student.
  static const String staffStudyPlanAdvisingTemplate =
      '$staffRegistration/study-plan/:studentId';

  static String staffStudyPlanAdvising(String studentId) =>
      staffStudyPlanAdvisingTemplate.replaceFirst(':studentId', studentId);

  /// Registry students directory.
  static const String staffStudents = '$staffRegistration/students';

  /// Path template of one registry student record.
  static const String staffStudentRecordTemplate = '$staffStudents/:studentId';

  static String staffStudentRecord(String studentId) =>
      staffStudentRecordTemplate.replaceFirst(':studentId', studentId);

  /// Registry ID card production queue.
  static const String staffIdCards = '$staffRegistration/id-cards';

  /// Path template of one ID card print preview.
  static const String staffIdCardPreviewTemplate = '$staffIdCards/:serial';

  static String staffIdCardPreview(String serial) => staffIdCardPreviewTemplate
      .replaceFirst(':serial', Uri.encodeComponent(serial));

  static const String staffIdCardSerialParam = 'serial';

  /// Public verification of a student ID card (QR / code). Outside every shell.
  static const String verifyIdCard = '/verify/id-card';

  /// Query parameter [verifyIdCard] reads a code from.
  static const String verifyIdCardCodeParam = 'code';

  /// Student Accommodation hub — term selector, the held / offered / confirmed
  /// bed, and the booking entry points. Outside the student shell with its own
  /// task bar; back leads to the hub.
  static const String accommodation = '/accommodation';

  /// Accept the accommodation agreement before booking.
  static const String accommodationTerms = '/accommodation/terms';

  /// Bookable rooms for the selected term.
  static const String accommodationRooms = '/accommodation/rooms';

  /// Past bed records.
  static const String accommodationHistory = '/accommodation/history';

  /// Housing Directorate root. Authenticated but not linked from the student
  /// hub — reserved for the staff portal.
  static const String staffAccommodation = '/accommodation/staff';

  /// Allocations queue and tool entries.
  static const String staffAllocations = '$staffAccommodation/allocations';

  /// Path template of one allocation; `:allocationId` is the record id.
  static const String staffAllocationTemplate =
      '$staffAllocations/:allocationId';

  static String staffAllocation(String allocationId) =>
      staffAllocationTemplate.replaceFirst(':allocationId', allocationId);

  static const String staffAllocationIdParam = 'allocationId';

  /// Hostels and rooms directory.
  static const String staffHostels = '$staffAccommodation/hostels';

  /// Path template of one hostel's bed grid.
  static const String staffHostelTemplate = '$staffHostels/:hostelId';

  static String staffHostel(String hostelId) =>
      staffHostelTemplate.replaceFirst(':hostelId', hostelId);

  static const String staffHostelIdParam = 'hostelId';

  /// Occupant list of one hostel.
  static const String staffOccupantsTemplate = '$staffHostelTemplate/occupants';

  static String staffOccupants(String hostelId) =>
      staffOccupantsTemplate.replaceFirst(':hostelId', hostelId);

  /// Room settings of one room in one hostel.
  static const String staffRoomTemplate = '$staffHostelTemplate/rooms/:roomId';

  static String staffRoom(String hostelId, String roomId) => staffRoomTemplate
      .replaceFirst(':hostelId', hostelId)
      .replaceFirst(':roomId', roomId);

  static const String staffRoomIdParam = 'roomId';

  /// Block settings and bulk add of rooms.
  static const String staffBlockTemplate =
      '$staffHostelTemplate/blocks/:blockId';

  static String staffBlock(String hostelId, String blockId) =>
      staffBlockTemplate
          .replaceFirst(':hostelId', hostelId)
          .replaceFirst(':blockId', blockId);

  static const String staffBlockIdParam = 'blockId';

  /// Openings, prices, quotas, methods, deadlines, refunds and closed days.
  static const String staffOpenings = '$staffAccommodation/openings';

  /// Allocate from a spreadsheet.
  static const String staffUpload = '$staffAccommodation/upload';

  /// Allocate one student by hand.
  static const String staffAllocate = '$staffAccommodation/allocate';

  /// Automatic allocation.
  static const String staffAutoAllocation = '$staffAccommodation/auto';

  /// The draw (ballot or priority).
  static const String staffDraw = '$staffAccommodation/draw';

  /// Offer last term's residents their own beds.
  static const String staffKeepMyRoom = '$staffAccommodation/keep-my-room';

  /// Publish a version of the accommodation agreement.
  static const String staffAgreement = '$staffAccommodation/agreement';

  /// Housing notices wording.
  static const String staffNotices = '$staffAccommodation/notices';

  /// Housing categories and their weights.
  static const String staffCategories = '$staffAccommodation/categories';

  /// Housing bans.
  static const String staffBans = '$staffAccommodation/bans';

  /// Cancellation refund share.
  static const String staffRefunds = '$staffAccommodation/refunds';

  // Route names, used for navigation so paths can change freely.
  static const String splashName = 'splash';
  static const String loginName = 'login';
  static const String homeName = 'home';
  static const String profileName = 'profile';
  static const String feesName = 'fees';
  static const String feesCheckoutName = 'feesCheckout';
  static const String feesCardCheckoutName = 'feesCardCheckout';
  static const String feesGatewayReturnName = 'feesGatewayReturn';
  static const String feesReceiptName = 'feesReceipt';
  static const String verifyReceiptName = 'verifyReceipt';
  static const String forgotPasswordName = 'forgotPassword';
  static const String verifyRecoveryCodeName = 'verifyRecoveryCode';
  static const String setNewPasswordName = 'setNewPassword';
  static const String recoverySuccessName = 'recoverySuccess';
  static const String admissionsName = 'admissions';
  static const String admissionsProgrammesName = 'admissionsProgrammes';
  static const String admissionsApplicationsName = 'admissionsApplications';
  static const String admissionsJambName = 'admissionsJamb';
  static const String admissionsApplicationDetailName =
      'admissionsApplicationDetail';
  static const String admissionsAdmissionLetterName =
      'admissionsAdmissionLetter';
  static const String verifyAdmissionName = 'verifyAdmission';
  static const String createAccountName = 'createAccount';
  static const String registrationName = 'registration';
  static const String registrationStudyPlanName = 'registrationStudyPlan';
  static const String registrationFormName = 'registrationForm';
  static const String registrationRequestsName = 'registrationRequests';
  static const String registrationIdCardName = 'registrationIdCard';
  static const String registrationDisciplineName = 'registrationDiscipline';
  static const String registrationDisciplineCaseName =
      'registrationDisciplineCase';
  static const String staffRegistrationApprovalsName =
      'staffRegistrationApprovals';
  static const String staffRegistrationDecisionName =
      'staffRegistrationDecision';
  static const String staffStudentRequestsName = 'staffStudentRequests';
  static const String staffStudyPlanAdvisingName = 'staffStudyPlanAdvising';
  static const String staffStudentsName = 'staffStudents';
  static const String staffStudentRecordName = 'staffStudentRecord';
  static const String staffIdCardsName = 'staffIdCards';
  static const String staffIdCardPreviewName = 'staffIdCardPreview';
  static const String verifyIdCardName = 'verifyIdCard';
  static const String accommodationName = 'accommodation';
  static const String accommodationTermsName = 'accommodationTerms';
  static const String accommodationRoomsName = 'accommodationRooms';
  static const String accommodationHistoryName = 'accommodationHistory';
  static const String staffAllocationsName = 'staffAllocations';
  static const String staffAllocationName = 'staffAllocation';
  static const String staffHostelsName = 'staffHostels';
  static const String staffHostelName = 'staffHostel';
  static const String staffOccupantsName = 'staffOccupants';
  static const String staffRoomName = 'staffRoom';
  static const String staffBlockName = 'staffBlock';
  static const String staffOpeningsName = 'staffOpenings';
  static const String staffUploadName = 'staffUpload';
  static const String staffAllocateName = 'staffAllocate';
  static const String staffAutoAllocationName = 'staffAutoAllocation';
  static const String staffDrawName = 'staffDraw';
  static const String staffKeepMyRoomName = 'staffKeepMyRoom';
  static const String staffAgreementName = 'staffAgreement';
  static const String staffNoticesName = 'staffNotices';
  static const String staffCategoriesName = 'staffCategories';
  static const String staffBansName = 'staffBans';
  static const String staffRefundsName = 'staffRefunds';

  /// Path parameter name for [feesReceiptTemplate].
  static const String feesReceiptIdParam = 'id';

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
    admissionsJamb,
  };

  /// Every screen inside the Registration & Records portal, as a literal path.
  ///
  /// Same contract as [admissionsPaths]: listed here so anonymous deep links
  /// bounce to sign-in, and so the portal's back handling can recognise its
  /// own front door.
  static const Set<String> registrationPaths = {
    registration,
    registrationStudyPlan,
    registrationForm,
    registrationRequests,
    registrationIdCard,
    registrationDiscipline,
    staffRegistrationApprovals,
    staffStudentRequests,
    staffStudents,
    staffIdCards,
  };

  /// Every screen inside the Accommodation portal, as a literal path.
  ///
  /// Same contract as [registrationPaths]: listed here so anonymous deep links
  /// bounce to sign-in. Parameterised staff screens inherit the protection
  /// from the shared prefix.
  static const Set<String> accommodationPaths = {
    accommodation,
    accommodationTerms,
    accommodationRooms,
    accommodationHistory,
    staffAllocations,
    staffHostels,
    staffOpenings,
    staffUpload,
    staffAllocate,
    staffAutoAllocation,
    staffDraw,
    staffKeepMyRoom,
    staffAgreement,
    staffNotices,
    staffCategories,
    staffBans,
    staffRefunds,
  };

  /// Screens of the student shell that own the whole canvas on phones: no
  /// tab bar under them.
  ///
  /// The hub navigates through its own directory and account panel, and the
  /// checkout is a task with its own back chevron — a student choosing how
  /// to pay is not moving between sections. Every other screen in the shell
  /// keeps the bar.
  static const Set<String> fullCanvasPaths = {
    home,
    feesCheckout,
    feesCardCheckout,
    feesGatewayReturn,
    // Receipts share a prefix; the shell matches on `uri.path`, so any
    // concrete `/home/fees/receipts/…` location is listed via the helper
    // below rather than this set alone.
  };

  /// `true` when [location] is an official receipt under the fees tab.
  static bool isFeesReceiptPath(String location) =>
      location.startsWith('$fees/$feesReceiptSegment/');

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
  static const Set<String> publicPaths = {
    verifyAdmission,
    verifyReceipt,
    verifyIdCard,
  };
}

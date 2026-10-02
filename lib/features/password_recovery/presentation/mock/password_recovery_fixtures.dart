/// Sample data for the recovery flow while the API is pending.
///
/// Presentation-only placeholders: delete the whole file when the endpoints
/// land and read these values from the recovery response instead.
abstract final class RecoveryFixtures {
  /// Channels the recovery code is dispatched to.
  static const String demoMaskedPhone = '•••• ••• 4567';

  /// Shown on the audit summary after a completed recovery.
  static const String accountName = 'Amaka Bello';
  static const String registrationNumber = '23/CSC/0412';
  static const String sessionReference = '#8820-NX';
  static const String auditReference = 'SEC-9F82-AUTH-CLR';
  static const String registryReference = 'Ref: REC-2025';
  static const String protocolReference = 'Security Protocol v4.2';
  static const String policyReference = 'POL-SEC-v4.2';
  static const String emergencyHotline = '+234 1 800 LEGION';
  static const String helpdeskEmail = 'helpdesk@legion.edu.ng';
}

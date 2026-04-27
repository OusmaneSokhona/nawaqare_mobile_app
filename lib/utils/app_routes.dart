/// Application Routes
/// Centralize all route names and paths for the app
class AppRoutes {
  // Pharmacy Routes
  static const String pharmacyPrescriptions = '/pharmacy-prescriptions';
  static const String pharmacyDispensingScreen = '/pharmacy-dispensing';
  static const String pharmacySubstitutionScreen = '/pharmacy-substitution';
  static const String pharmacyAccessLogScreen = '/pharmacy-access-log';

  // Chat Routes
  static const String chatScreen = '/chat';
  static const String chatDetailScreen = '/chat-detail';

  // Auth Routes
  static const String splashScreen = '/splash';
  static const String loginScreen = '/login';
  static const String signupScreen = '/signup';
  static const String forgotPasswordScreen = '/forgot-password';

  // Patient Routes
  static const String patientHome = '/patient-home';
  static const String patientProfile = '/patient-profile';
  static const String appointmentScreen = '/appointments';

  // Doctor Routes
  static const String doctorHome = '/doctor-home';
  static const String doctorProfile = '/doctor-profile';
  static const String doctorAppointments = '/doctor-appointments';

  // Pharmacy Routes - Profile & Settings
  static const String pharmacyHome = '/pharmacy-home';
  static const String pharmacyProfile = '/pharmacy-profile';
  static const String pharmacySettings = '/pharmacy-settings';
}

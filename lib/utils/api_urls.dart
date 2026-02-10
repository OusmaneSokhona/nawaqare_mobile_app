class ApiUrls {
  static String baseUrl="http://54.219.14.133/";
  static String signUpUrl="/api/auth/signup";
  static String signInUrl="/api/auth/signin";
  static String sendEmailOtpUrl="/api/auth/send-email";
  static String sendPhoneOtpUrl="/api/auth/send-phone";
  static String verifyEmailOtpUrl="/api/auth/verify-email";
  static String verifyPhoneOtpUrl="/api/auth/verify-phone";
  static String resetPasswordUrl="/api/auth/user-reset-password";
  static String sendResetPasswordEmailOtpUrl="/api/auth/send-otp";
  static String sendResetPasswordPhoneOtpUrl="/api/auth/sendotpwhatsapp";
  static String verifyResetPasswordEmailOtpUrl="/api/auth/verify-otp";
  static String updateProfileUrl="/api/auth/update-profile";
  static String deleteUserUrl="/api/auth/delete-profile";
  static String meUrl="/api/auth/me";
  static String getDoctorsUrl="/api/doctor/doctors";
  static String getDoctorTimeSlots="/api/timeslots/get-timeslot/";
  static String createAppointment="/api/appointments/create-appointment";
  static String getAppointments="/api/appointments/all-appointments";
  static String videoCallApi="api/appointments/generate_token";
  static String homeVisitStatusApi="api/appointments/homevisitstatus/";
  static String doctorSlotsApi = '/api/timeslots/doctorAll-timeslot';
  static String createSlotApi = '/api/timeslots/create-timeslot';
  static String deleteSlotApi = '/api/timeslots/cancel-timeslot/';
}
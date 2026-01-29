class ApiUrls {
  static String baseUrl="http://localhost:4000";
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
}
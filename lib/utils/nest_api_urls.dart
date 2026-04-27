/// NestJS Backend API URLs
/// Base URL: http://localhost:3000/api/v1/
class NestApiUrls {
  static String baseUrl = "http://localhost:3000";
  static String apiVersion = "/api/v1";

  // SOAP Notes Endpoints
  static String getSoapNotes(String consultationId) =>
      "$apiVersion/consultations/$consultationId/soap-notes";
  static String createSoapNote(String consultationId) =>
      "$apiVersion/consultations/$consultationId/soap-notes";

  // Exam Orders Endpoints
  static String getExamOrders(String consultationId) =>
      "$apiVersion/consultations/$consultationId/exam-orders";
  static String createExamOrder(String consultationId) =>
      "$apiVersion/consultations/$consultationId/exam-orders";
  static String updateExamOrderStatus(String examOrderId) =>
      "$apiVersion/consultations/exam-orders/$examOrderId";

  // Reference Letters Endpoints
  static String getReferenceLetters(String consultationId) =>
      "$apiVersion/consultations/$consultationId/reference-letters";
  static String createReferenceLetter(String consultationId) =>
      "$apiVersion/consultations/$consultationId/reference-letters";

  // Medical Certificates Endpoints
  static String getCertificates(String consultationId) =>
      "$apiVersion/consultations/$consultationId/certificates";
  static String createCertificate(String consultationId) =>
      "$apiVersion/consultations/$consultationId/certificates";

  // Patient Overview Endpoint
  static String getPatientOverview(String patientId) =>
      "$apiVersion/patients/$patientId/records/overview";

  // Follow-Up Plans Endpoints
  static String getFollowUpPlans(String consultationId) =>
      "$apiVersion/consultations/$consultationId/follow-up-plans";
  static String createFollowUpPlan(String consultationId) =>
      "$apiVersion/consultations/$consultationId/follow-up-plans";

  // Pharmacy Prescription Endpoints
  static String getPharmacyPrescriptions() =>
      "$apiVersion/pharmacy/prescriptions";
  static String getPharmacyPrescriptionDetail(String prescriptionId) =>
      "$apiVersion/pharmacy/prescriptions/$prescriptionId";
  static String getPharmacyPrescriptionByQR(String token) =>
      "$apiVersion/pharmacy/prescriptions/qr/$token";

  // Pharmacy Dispensing Endpoints
  static String dispensePrescription(String prescriptionId) =>
      "$apiVersion/pharmacy/prescriptions/$prescriptionId/dispense";
  static String partiallyDispensePrescription(String prescriptionId) =>
      "$apiVersion/pharmacy/prescriptions/$prescriptionId/partial";
  static String rejectPrescription(String prescriptionId) =>
      "$apiVersion/pharmacy/prescriptions/$prescriptionId/reject";

  // Pharmacy Substitution Endpoint
  static String substitutePrescription(String prescriptionId) =>
      "$apiVersion/pharmacy/prescriptions/$prescriptionId/substitution";

  // Pharmacy Access Log Endpoint
  static String getPharmacyAccessLog() =>
      "$apiVersion/pharmacy/access-log";
}

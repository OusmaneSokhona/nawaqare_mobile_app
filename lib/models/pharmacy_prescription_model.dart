class PharmacyPrescriptionModel {
  final String id;
  final String patientId;
  final String doctorName;
  final String date;
  final String status;
  final bool hasQr;
  final bool hasDoc;

  PharmacyPrescriptionModel({
    required this.id,
    required this.patientId,
    required this.doctorName,
    required this.date,
    required this.status,
    this.hasQr = false,
    this.hasDoc = false,
  });
}
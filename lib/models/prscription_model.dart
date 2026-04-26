enum PrescriptionStatus { active, expirySoon, expired, completed }

class PrescriptionModel {
  final String id;
  final String doctorName;
  final String specialization;
  final String medicationName;
  final String dosageInstruction;
  final PrescriptionStatus status;
  final String dateInfo;
  final int? refillsLeft;
  final String doctorImageUrl;
  final String? diagnosis;
  final String? notes;
  final String? prescriptionNumber;
  final List<Map<String, dynamic>>? medications;
  final Map<String, dynamic>? appointmentData;

  PrescriptionModel({
    required this.id,
    required this.doctorName,
    required this.specialization,
    required this.medicationName,
    required this.dosageInstruction,
    required this.status,
    required this.dateInfo,
    this.refillsLeft,
    required this.doctorImageUrl,
    this.diagnosis,
    this.notes,
    this.prescriptionNumber,
    this.medications,
    this.appointmentData,
  });
}
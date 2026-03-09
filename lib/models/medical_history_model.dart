class MedicationHistoryResponse {
  final String? medicineName;
  final String? dosage;
  final String? doctorId; // Renamed for clarity
  final bool? refill;
  final String? status;

  MedicationHistoryResponse({
    this.medicineName,
    this.dosage,
    this.doctorId,
    this.refill,
    this.status,
  });

  factory MedicationHistoryResponse.fromJson(Map<String, dynamic> json) {
    String? extractedDoctorId;

    // Check if doctor is a Map (Object) or a String (ID)
    if (json['doctor'] is Map) {
      extractedDoctorId = json['doctor']['_id'] ?? json['doctor']['id'];
    } else if (json['doctor'] is String) {
      extractedDoctorId = json['doctor'];
    }

    return MedicationHistoryResponse(
      medicineName: json['medicineName'],
      dosage: json['dosage'],
      doctorId: extractedDoctorId,
      refill: json['refill'] ?? false,
      status: json['status'],
    );
  }
}

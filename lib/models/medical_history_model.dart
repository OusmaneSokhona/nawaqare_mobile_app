class MedicalHistoryModel {
  final DoctorInformation doctor;

  final String medicationName;
  final String dosage;
  final String? instructions;
  final String refillLimitDate;
  final String lastUpdated;

  MedicalHistoryModel({
    required this.doctor,
    required this.medicationName,
    required this.dosage,
     this.instructions,
    required this.refillLimitDate,
    required this.lastUpdated,
  });
}


class DoctorInformation {
  final String name;
  final String image;
  final String specialty;
  final String status;

  DoctorInformation({
    required this.name,
    required this.image,
    required this.specialty,
    required this.status,
  });
}
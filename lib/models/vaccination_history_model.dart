class VaccinationHistoryModel {
  final String vaccineName;
  final String testName;
  final String status;
  final String lastUpdated;
  final String? certificate;

  VaccinationHistoryModel({
    required this.vaccineName,
    required this.testName,
    required this.status,
    required this.lastUpdated,
    this.certificate,
  });
}
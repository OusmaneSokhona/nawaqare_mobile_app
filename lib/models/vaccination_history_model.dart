class VaccinationHistoryModel {

  final String vaccineName;
  final String testName;
  final String lastUpdated;
  final String status;

  VaccinationHistoryModel({
    required this.vaccineName,
    required this.testName,
    required this.lastUpdated,
    required this.status,
  });
}

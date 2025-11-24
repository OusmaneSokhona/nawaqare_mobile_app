class AllergyData {
  final String medication;
  final String reaction;
  final String severity;
  final String dateIdentified;
  final String documentFileName;
  final String note;
  final String status;

  AllergyData({
    required this.medication,
    required this.reaction,
    required this.severity,
    required this.dateIdentified,
    required this.documentFileName,
    required this.note,
    required this.status,
  });
}

class ConsultationModel {
  final String name;

  final String status;

  final String consultationType;

  final DateTime expirationDate;

  final double cost;

  final int creditsUsed;

  final int totalCredits;

  ConsultationModel({
    required this.name,
    required this.status,
    required this.consultationType,
    required this.expirationDate,
    required this.cost,
    required this.creditsUsed,
    required this.totalCredits,
  });
}
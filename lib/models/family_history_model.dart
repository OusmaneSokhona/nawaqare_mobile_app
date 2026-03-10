// models/family_history_model.dart
class FamilyHistoryModel {
  final String id;
  final String patientId;
  final String relation;
  final String condition;
  final String severity;
  final int age;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  FamilyHistoryModel({
    required this.id,
    required this.patientId,
    required this.relation,
    required this.condition,
    required this.severity,
    required this.age,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FamilyHistoryModel.fromJson(Map<String, dynamic> json) {
    return FamilyHistoryModel(
      id: json['_id'] ?? json['id'] ?? '',
      patientId: json['patientId'] ?? '',
      relation: json['relation'] ?? '',
      condition: json['condition'] ?? '',
      severity: json['severity'] ?? '',
      age: json['age'] ?? 0,
      notes: json['notes'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }
}
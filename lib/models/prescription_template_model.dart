class PrescriptionTemplateModel {
  final String id;
  final String doctorId;
  final String templateName;
  final String diagnosis;
  final String medicationsName;
  final String dosage;
  final String form;
  final String roa;
  final String qtd;
  final DateTime? refillDate;
  final String specialInstruction;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  PrescriptionTemplateModel({
    required this.id,
    required this.doctorId,
    required this.templateName,
    required this.diagnosis,
    required this.medicationsName,
    required this.dosage,
    required this.form,
    required this.roa,
    required this.qtd,
    this.refillDate,
    required this.specialInstruction,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PrescriptionTemplateModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionTemplateModel(
      id: json['_id'] ?? '',
      doctorId: json['doctorId'] ?? '',
      templateName: json['templateName'] ?? '',
      diagnosis: json['diagnosis'] ?? '',
      medicationsName: json['medicationsName'] ?? '',
      dosage: json['dosage'] ?? '',
      form: json['form'] ?? '',
      roa: json['roa'] ?? '',
      qtd: json['qtd'] ?? '',
      refillDate: json['refildate'] != null
          ? DateTime.tryParse(json['refildate'])
          : null,
      specialInstruction: json['specialInsturuction'] ?? '',
      notes: json['notes'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'doctorId': doctorId,
      'templateName': templateName,
      'diagnosis': diagnosis,
      'medicationsName': medicationsName,
      'dosage': dosage,
      'form': form,
      'roa': roa,
      'qtd': qtd,
      'refildate': refillDate?.toIso8601String(),
      'specialInsturuction': specialInstruction,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
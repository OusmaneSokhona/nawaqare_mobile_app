class MedicalHistoryResponse {
  String? id;
  String? patientId;
  dynamic addMedications;
  dynamic addLifestyle;
  dynamic addVaccinations;
  dynamic addFamilyHistory;
  dynamic addSurgical;
  dynamic addAllergical;
  dynamic addInfectional;
  dynamic addVitals;
  dynamic addProblem;
  String? createdAt;
  String? updatedAt;
  int? v;

  MedicalHistoryResponse({
    this.id,
    this.patientId,
    this.addMedications,
    this.addLifestyle,
    this.addVaccinations,
    this.addFamilyHistory,
    this.addSurgical,
    this.addAllergical,
    this.addInfectional,
    this.addVitals,
    this.addProblem,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory MedicalHistoryResponse.fromJson(Map<String, dynamic> json) {
    return MedicalHistoryResponse(
      id: json['_id'] as String?,
      patientId: json['patientId'] as String?,
      addMedications: json['addMedications'],
      addLifestyle: json['addLifestyle'],
      addVaccinations: json['addVaccinations'],
      addFamilyHistory: json['addFamilyHistory'],
      addSurgical: json['addSurgical'],
      addAllergical: json['addAllergical'],
      addInfectional: json['addInfectional'],
      addVitals: json['addVitals'],
      addProblem: json['addProblem'],
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'patientId': patientId,
      'addMedications': addMedications,
      'addLifestyle': addLifestyle,
      'addVaccinations': addVaccinations,
      'addFamilyHistory': addFamilyHistory,
      'addSurgical': addSurgical,
      'addAllergical': addAllergical,
      'addInfectional': addInfectional,
      'addVitals': addVitals,
      'addProblem': addProblem,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}
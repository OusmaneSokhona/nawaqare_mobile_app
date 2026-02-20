class SoapNoteModel {
  final String? subjective;
  final String? objective;
  final String? assessment;
  final String? plan;
  final String? diagnosis;

  SoapNoteModel({
    this.subjective,
    this.objective,
    this.assessment,
    this.plan,
    this.diagnosis,
  });

  Map<String, dynamic> toJson() {
    return {
      'subjective': subjective,
      'objective': objective,
      'assessment': assessment,
      'plan': plan,
      'diagnosis': diagnosis,
    };
  }
}
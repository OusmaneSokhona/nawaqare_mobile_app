class ClinicalNotes {
  final String appointmentId;
  final String drNotes;

  ClinicalNotes({
    required this.appointmentId,
    required this.drNotes,
  });

  factory ClinicalNotes.fromJson(Map<String, dynamic> json) {
    return ClinicalNotes(
      appointmentId: json['appointmentId']?.toString() ?? '',
      drNotes: json['drNotes']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'drNotes': drNotes,
    };
  }

  factory ClinicalNotes.empty() {
    return ClinicalNotes(
      appointmentId: '',
      drNotes: '',
    );
  }
}
class PatientModel {
  final String patientName;
  final String patientImageUrl;
  final String lastAppointmentDate;
  final String consultationType; // e.g., 'Remote Consultation', 'In-Person Visit'
  final String period; // e.g., 'This Week', 'Today'

  PatientModel({
    required this.patientName,
    required this.patientImageUrl,
    required this.lastAppointmentDate,
    required this.consultationType,
    required this.period,
  });
}
class AppointmentModel {
  final String name;
  final String specialty;
  final String consultationType;
  final double rating;
  final double fee;
  final String date;
  final String time;
  final String status;
  final String imageUrl;

  AppointmentModel({
    required this.name,
    required this.specialty,
    required this.consultationType,
    required this.rating,
    required this.fee,
    required this.date,
    required this.time,
    required this.status,
    required this.imageUrl,
  });
}

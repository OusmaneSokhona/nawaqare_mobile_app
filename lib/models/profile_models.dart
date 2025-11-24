class User {
  final String name;
  final String title;
  final String lastUpdate;
  final String patientId;
  final String country;
  final String email;
  final String phone;
  final String address;
  final String profileImageUrl;

  User({
    required this.name,
    required this.title,
    required this.lastUpdate,
    required this.patientId,
    required this.country,
    required this.email,
    required this.phone,
    required this.address,
    required this.profileImageUrl,
  });
}

class Vitals {
  final double heightCm;
  final double weightKg;
  final String bloodPressure;
  final int heartRateBpm;

  Vitals({
    required this.heightCm,
    required this.weightKg,
    required this.bloodPressure,
    required this.heartRateBpm,
  });

  double get bmi => weightKg / ((heightCm / 100) * (heightCm / 100));
}

class Document {
  final String type;
  final String date;

  Document({
    required this.type,
    required this.date,
  });
}
class AccessRecord {
  final String name;
  final String role;
  final String data;
  final String dateTime;

  AccessRecord({
    required this.name,
    required this.role,
    required this.data,
    required this.dateTime,
  });
}
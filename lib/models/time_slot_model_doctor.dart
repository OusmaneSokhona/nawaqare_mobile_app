class TimeSlotModelDoctor {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final String status;

  TimeSlotModelDoctor({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  factory TimeSlotModelDoctor.fromJson(Map<String, dynamic> json) {
    // FIX: Parse UTC time and convert to local
    final startTimeUtc = DateTime.parse(json['startTime']);
    final endTimeUtc = DateTime.parse(json['endTime']);

    return TimeSlotModelDoctor(
      id: json['_id'] ?? '',
      // Convert UTC to local time (Pakistan Time - UTC+5)
      startTime: startTimeUtc.toLocal(),
      endTime: endTimeUtc.toLocal(),
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      // FIX: When sending to backend, convert to UTC
      'startTime': startTime.toUtc().toIso8601String(),
      'endTime': endTime.toUtc().toIso8601String(),
      'status': status,
    };
  }
}

class DoctorSlotsResponse {
  final String message;
  final DoctorWithSlots doctor;

  DoctorSlotsResponse({
    required this.message,
    required this.doctor,
  });

  factory DoctorSlotsResponse.fromJson(Map<String, dynamic> json) {
    return DoctorSlotsResponse(
      message: json['message'] ?? '',
      doctor: DoctorWithSlots.fromJson(json['doctor']),
    );
  }
}

class DoctorWithSlots {
  final String id;
  final String fullName;
  final String medicalSpecialty;
  final List<TimeSlotModelDoctor> allSlots;

  DoctorWithSlots({
    required this.id,
    required this.fullName,
    required this.medicalSpecialty,
    required this.allSlots,
  });

  factory DoctorWithSlots.fromJson(Map<String, dynamic> json) {
    return DoctorWithSlots(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      medicalSpecialty: json['medicalSpecialty'] ?? '',
      allSlots: (json['allSlots'] as List? ?? [])
          .map((slot) => TimeSlotModelDoctor.fromJson(slot))
          .toList(),
    );
  }
}
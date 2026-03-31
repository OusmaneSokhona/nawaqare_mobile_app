import 'package:intl/intl.dart';

class TimeSlotResponse {
  final Doctor doctor;
  final List<TimeSlot> slots;

  TimeSlotResponse({
    required this.doctor,
    required this.slots,
  });

  factory TimeSlotResponse.fromJson(Map<String, dynamic> json) {
    return TimeSlotResponse(
      doctor: Doctor.fromJson(json['doctor']),
      slots: (json['slots'] as List)
          .map((slot) => TimeSlot.fromJson(slot))
          .toList(),
    );
  }
}

class Doctor {
  final String id;
  final String fullName;
  final String medicalSpecialty;
  final List<TimeSlot> allSlots;
  final String clinicAddress;

  Doctor({
    required this.id,
    required this.fullName,
    required this.medicalSpecialty,
    required this.allSlots,
    required this.clinicAddress,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      medicalSpecialty: json['medicalSpecialty'] ?? '',
      allSlots: (json['allSlots'] as List)
          .map((slot) => TimeSlot.fromJson(slot))
          .toList(),
      clinicAddress: json['clinicAddress'] ?? '',
    );
  }
}

class TimeSlot {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final String consultationType;
  final String status;
  String? slotDate;

  TimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.consultationType,
    required this.status,
    this.slotDate,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    final startTimeUtc = DateTime.parse(json['startTime']);
    final endTimeUtc = DateTime.parse(json['endTime']);

    return TimeSlot(
      id: json['_id'] ?? '',
      startTime: startTimeUtc.toLocal(),
      endTime: endTimeUtc.toLocal(),
      consultationType: json['consultationType'] ?? '',
      status: json['status'] ?? '',
      slotDate: DateFormat('yyyy-MM-dd').format(startTimeUtc.toLocal()),
    );
  }

  String get formattedTime {
    final startFormat = DateFormat('h:mm a');
    final endFormat = DateFormat('h:mm a');
    return '${startFormat.format(startTime)} - ${endFormat.format(endTime)}';
  }

  String get simpleTime {
    final format = DateFormat('h:mm a');
    return format.format(startTime);
  }

  String get slotDateFormatted {
    if (slotDate != null) return slotDate!;
    final format = DateFormat('yyyy-MM-dd');
    return format.format(startTime);
  }
}
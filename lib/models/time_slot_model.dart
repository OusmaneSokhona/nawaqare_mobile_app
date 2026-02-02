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
  final List<TimeSlot> availableSlots;

  Doctor({
    required this.id,
    required this.fullName,
    required this.availableSlots,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['_id'],
      fullName: json['fullName'],
      availableSlots: (json['availableSlots'] as List)
          .map((slot) => TimeSlot.fromJson(slot))
          .toList(),
    );
  }
}

class TimeSlot {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final String status;

  TimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['_id'], // Maps the underscore ID from your JSON
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      status: json['status'],
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

  String get slotDate {
    final format = DateFormat('yyyy-MM-dd');
    return format.format(startTime);
  }
}
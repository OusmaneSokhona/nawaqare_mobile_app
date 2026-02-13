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
  final List<TimeSlot> allSlots;

  Doctor({
    required this.id,
    required this.fullName,
    required this.allSlots,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['_id'],
      fullName: json['fullName'],
      allSlots: (json['allSlots'] as List)
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
  String? slotDate; // Add slotDate field

  TimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.slotDate,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    // FIX: Parse UTC time and convert to local
    final startTimeUtc = DateTime.parse(json['startTime']);
    final endTimeUtc = DateTime.parse(json['endTime']);

    return TimeSlot(
      id: json['_id'] ?? '',
      // Convert UTC to local time (Pakistan Time - UTC+5)
      startTime: startTimeUtc.toLocal(),
      endTime: endTimeUtc.toLocal(),
      status: json['status'] ?? '',
      slotDate: json['date'] ?? DateFormat('yyyy-MM-dd').format(startTimeUtc.toLocal()),
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
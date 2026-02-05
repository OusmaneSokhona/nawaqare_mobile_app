import 'dart:convert';

class AppointmentResponse {
  final String message;
  final int total;
  final List<Appointment> appointments;
  final List<Appointment> upcomingAppointments;
  final List<Appointment> pastAppointments;

  AppointmentResponse({
    required this.message,
    required this.total,
    required this.appointments,
    required this.upcomingAppointments,
    required this.pastAppointments,
  });

  factory AppointmentResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentResponse(
      message: json['message'] as String,
      total: json['total'] as int,
      appointments: (json['appointments'] as List)
          .map((item) => Appointment.fromJson(item))
          .toList(),
      upcomingAppointments: (json['upcomingAppointments'] as List)
          .map((item) => Appointment.fromJson(item))
          .toList(),
      pastAppointments: (json['pastAppointments'] as List)
          .map((item) => Appointment.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'total': total,
      'appointments': appointments.map((appointment) => appointment.toJson()).toList(),
      'upcomingAppointments': upcomingAppointments.map((appointment) => appointment.toJson()).toList(),
      'pastAppointments': pastAppointments.map((appointment) => appointment.toJson()).toList(),
    };
  }

  String toJsonString() => json.encode(toJson());
}

class Appointment {
  final String id;
  final Patient patient;
  final Doctor doctor;
  final Timeslot timeslot;
  final int fee;
  final String currency;
  final DateTime date;
  final ConsultationType consultationType;
  final AppointmentStatus status;
  final String? visitAddress;
  final String? notes;
  final String rescheduleReason;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Appointment({
    required this.id,
    required this.patient,
    required this.doctor,
    required this.timeslot,
    required this.fee,
    required this.currency,
    required this.date,
    required this.consultationType,
    required this.status,
    this.visitAddress,
    this.notes,
    required this.rescheduleReason,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['_id'] as String,
      patient: Patient.fromJson(json['patientId']),
      doctor: Doctor.fromJson(json['doctorId']),
      timeslot: Timeslot.fromJson(json['timeslot']),
      fee: json['fee'] as int,
      currency: json['currency'] as String,
      date: DateTime.parse(json['date'] as String),
      consultationType: ConsultationTypeExtension.fromString(json['consultationType'] as String),
      status: AppointmentStatusExtension.fromString(json['status'] as String),
      visitAddress: json['visitAddress'] as String?,
      notes: json['notes'] as String?,
      rescheduleReason: json['rescheduleReason'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      v: json['__v'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'patientId': patient.toJson(),
      'doctorId': doctor.toJson(),
      'timeslot': timeslot.toJson(),
      'fee': fee,
      'currency': currency,
      'date': date.toIso8601String(),
      'consultationType': consultationType.name,
      'status': status.name,
      'visitAddress': visitAddress,
      'notes': notes,
      'rescheduleReason': rescheduleReason,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }

  bool get isUpcoming => date.isAfter(DateTime.now());
  bool get isPast => date.isBefore(DateTime.now());
  String get formattedDate => '${date.day}/${date.month}/${date.year}';
  String get formattedTime => '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}

class Patient {
  final String id;
  final String fullName;
  final String email;
  final String? profileImage;

  Patient({
    required this.id,
    required this.fullName,
    required this.email,
    this.profileImage,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['_id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      profileImage: json['profileImage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'email': email,
      'profileImage': profileImage,
    };
  }
}

class Doctor {
  final String id;
  final String email;
  final String fullName;
  final String? profileImage;

  Doctor({
    required this.id,
    required this.email,
    required this.fullName,
    this.profileImage,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['_id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      profileImage: json['profileImage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'fullName': fullName,
      'profileImage': profileImage,
    };
  }
}

class Timeslot {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final TimeslotStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Timeslot({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Timeslot.fromJson(Map<String, dynamic> json) {
    return Timeslot(
      id: json['_id'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      status: TimeslotStatusExtension.fromString(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      v: json['__v'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }

  String get formattedDuration {
    final duration = endTime.difference(startTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }
}

enum ConsultationType {
  homevisit,
  inperson,
  remote;

  String get displayName {
    switch (this) {
      case ConsultationType.homevisit:
        return 'homevisit';
      case ConsultationType.inperson:
        return 'inperson';
      case ConsultationType.remote:
        return 'remote';
    }
  }
}

class ConsultationTypeExtension {
  static ConsultationType fromString(String value) {
    switch (value) {
      case 'homevisit':
        return ConsultationType.homevisit;
      case 'inperson':
        return ConsultationType.inperson;
      case 'remote':
        return ConsultationType.remote;
      default:
        return ConsultationType.remote;
    }
  }
}

enum AppointmentStatus {
  pending,
  confirmed,
  completed,
  cancelled,
  rescheduled;

  String get displayName {
    switch (this) {
      case AppointmentStatus.pending:
        return 'pending';
      case AppointmentStatus.confirmed:
        return 'confirmed';
      case AppointmentStatus.completed:
        return 'completed';
      case AppointmentStatus.cancelled:
        return 'cancelled';
      case AppointmentStatus.rescheduled:
        return 'rescheduled';
    }
  }
}

class AppointmentStatusExtension {
  static AppointmentStatus fromString(String value) {
    switch (value) {
      case 'pending':
        return AppointmentStatus.pending;
      case 'confirmed':
        return AppointmentStatus.confirmed;
      case 'completed':
        return AppointmentStatus.completed;
      case 'cancelled':
        return AppointmentStatus.cancelled;
      case 'rescheduled':
        return AppointmentStatus.rescheduled;
      default:
        return AppointmentStatus.pending;
    }
  }
}

enum TimeslotStatus {
  available,
  booked,
  cancelled;

  String get displayName {
    switch (this) {
      case TimeslotStatus.available:
        return 'Available';
      case TimeslotStatus.booked:
        return 'Booked';
      case TimeslotStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class TimeslotStatusExtension {
  static TimeslotStatus fromString(String value) {
    switch (value) {
      case 'available':
        return TimeslotStatus.available;
      case 'booked':
        return TimeslotStatus.booked;
      case 'cancelled':
        return TimeslotStatus.cancelled;
      default:
        return TimeslotStatus.booked;
    }
  }
}

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
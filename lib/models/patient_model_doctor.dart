import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PatientAppointmentModel {
  String id;
  String patientId;
  String doctorId;
  DateTime date;
  String consultationType;
  String status;
  double fee;
  String currency;
  String? visitAddress;
  String? notes;
  String? rescheduleReason;
  DateTime createdAt;
  DateTime updatedAt;
  TimeSlot? timeslot;
  Patient? patient;
  HomeVisitStatus? homevisitstatus;
  Reschedule? isReschedule;

  PatientAppointmentModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.date,
    required this.consultationType,
    required this.status,
    required this.fee,
    required this.currency,
    this.visitAddress,
    this.notes,
    this.rescheduleReason,
    required this.createdAt,
    required this.updatedAt,
    this.timeslot,
    this.patient,
    this.homevisitstatus,
    this.isReschedule,
  });

  factory PatientAppointmentModel.fromJson(Map<String, dynamic> json) {
    // Extract patient info
    late String extractedPatientId;
    Patient? extractedPatient;

    if (json['patientId'] is Map) {
      // PatientId is an object with patient details
      final patientMap = json['patientId'] as Map<String, dynamic>;
      extractedPatientId = patientMap['_id'] ?? '';
      extractedPatient = Patient.fromJson(patientMap);
    } else {
      // PatientId is just a string ID
      extractedPatientId = json['patientId'] ?? '';
      extractedPatient = null;
    }

    return PatientAppointmentModel(
      id: json['_id'] ?? '',
      patientId: extractedPatientId,
      doctorId: json['doctorId'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      consultationType: json['consultationType'] ?? '',
      status: json['status'] ?? '',
      fee: json['fee'] != null ? (json['fee'] is double ? json['fee'] : (json['fee'] as num).toDouble()) : 0.0,
      currency: json['currency'] ?? '',
      visitAddress: json['visitAddress'],
      notes: json['notes'],
      rescheduleReason: json['rescheduleReason'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
      timeslot: json['timeslot'] != null ? TimeSlot.fromJson(json['timeslot']) : null,
      patient: extractedPatient,
      homevisitstatus: json['homevisitstatus'] != null
          ? HomeVisitStatus.fromString(json['homevisitstatus'])
          : null,
      isReschedule: json['isReschedule'] != null && json['isReschedule'] is Map
          ? Reschedule.fromJson(json['isReschedule'])
          : null,
    );
  }

  String get formattedDate {
    final format = DateFormat('EEEE, MMM d, yyyy');
    return format.format(date);
  }

  String get formattedTime {
    final format = DateFormat('h:mm a');
    return format.format(date);
  }

  String get statusText {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'ongoing':
        return 'Ongoing';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  String get consultationTypeText {
    switch (consultationType) {
      case 'remote':
        return 'Remote Consultation';
      case 'inperson':
        return 'In-Person Consultation';
      case 'homevisit':
        return 'Home Visit';
      case 'video':
        return 'Video Consultation';
      default:
        return consultationType;
    }
  }

  Color get statusColor {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'ongoing':
        return Colors.blue;
      case 'completed':
        return Colors.teal;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class TimeSlot {
  String id;
  DateTime startTime;
  DateTime endTime;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  TimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['_id'] ?? '',
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : DateTime.now(),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : DateTime.now(),
      status: json['status'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }
}

class Patient {
  String id;
  String fullName;
  String email;
  String profileImage;

  Patient({
    required this.id,
    required this.fullName,
    required this.email,
    required this.profileImage,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? 'Unknown Patient',
      email: json['email'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }
}

enum HomeVisitStatus {
  pending,
  accept,
  reject;

  factory HomeVisitStatus.fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return HomeVisitStatus.pending;
      case 'accept':
        return HomeVisitStatus.accept;
      case 'reject':
        return HomeVisitStatus.reject;
      default:
        return HomeVisitStatus.pending;
    }
  }

  String get value {
    switch (this) {
      case HomeVisitStatus.pending:
        return 'Pending';
      case HomeVisitStatus.accept:
        return 'Accepted';
      case HomeVisitStatus.reject:
        return 'Rejected';
    }
  }
}

class Reschedule {
  String? isAccept;
  String? reason;
  String? role;

  Reschedule({
    this.isAccept,
    this.reason,
    this.role,
  });

  factory Reschedule.fromJson(Map<String, dynamic> json) {
    return Reschedule(
      isAccept: json['isAccept'],
      reason: json['reason'],
      role: json['role'],
    );
  }

  String get statusText {
    switch (isAccept) {
      case 'accepted':
        return 'Accepted';
      case 'rejected':
        return 'Rejected';
      case 'pending':
        return 'Pending';
      default:
        return 'Not Set';
    }
  }
}

class AppointmentsResponse {
  String message;
  List<PatientAppointmentModel> appointments;

  AppointmentsResponse({
    required this.message,
    required this.appointments,
  });

  factory AppointmentsResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentsResponse(
      message: json['message'] ?? '',
      appointments: json['appointments'] != null
          ? List<PatientAppointmentModel>.from(
        json['appointments'].map((x) => PatientAppointmentModel.fromJson(x)),
      )
          : [],
    );
  }
}

class PatientSummary {
  String patientId;
  String fullName;
  String email;
  String? imageUrl;
  DateTime? lastAppointmentDate;
  String? lastConsultationType;
  int totalAppointments;
  double totalSpent;

  PatientSummary({
    required this.patientId,
    required this.fullName,
    required this.email,
    this.imageUrl,
    this.lastAppointmentDate,
    this.lastConsultationType,
    required this.totalAppointments,
    required this.totalSpent,
  });

  String get lastAppointmentFormatted {
    if (lastAppointmentDate == null) return 'No appointments';
    final format = DateFormat('MMM d, yyyy');
    return format.format(lastAppointmentDate!);
  }

  String get consultationTypeText {
    switch (lastConsultationType) {
      case 'remote':
        return 'Remote';
      case 'inperson':
        return 'In-Person';
      case 'homevisit':
        return 'Home Visit';
      case 'video':
        return 'Video';
      default:
        return lastConsultationType ?? 'Unknown';
    }
  }

  String get totalSpentFormatted {
    return '\$${totalSpent.toStringAsFixed(2)}';
  }
}
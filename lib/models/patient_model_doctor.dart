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
    return PatientAppointmentModel(
      id: json['_id'],
      patientId: json['patientId'] is String
          ? json['patientId']
          : json['patientId']['_id'],
      doctorId: json['doctorId'],
      date: DateTime.parse(json['date']),
      consultationType: json['consultationType'],
      status: json['status'],
      fee: json['fee'] is double ? json['fee'] : (json['fee'] as num).toDouble(),
      currency: json['currency'],
      visitAddress: json['visitAddress'],
      notes: json['notes'],
      rescheduleReason: json['rescheduleReason'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      timeslot: json['timeslot'] != null ? TimeSlot.fromJson(json['timeslot']) : null,
      patient: json['patientId'] is Map ? Patient.fromJson(json['patientId']) : null,
      homevisitstatus: json['homevisitstatus'] != null
          ? HomeVisitStatus.fromString(json['homevisitstatus'])
          : null,
      isReschedule: json['isReschedule'] != null
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
      id: json['_id'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
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
      id: json['_id'],
      fullName: json['fullName'],
      email: json['email'],
      profileImage: json["profileImage"],
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
      message: json['message'],
      appointments: List<PatientAppointmentModel>.from(
        json['appointments'].map((x) => PatientAppointmentModel.fromJson(x)),
      ),
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
}
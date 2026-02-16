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
      message: json['message']?.toString() ?? '',
      total: (json['total'] as num?)?.toInt() ?? 0,
      appointments: (json['appointments'] as List<dynamic>?)
          ?.map((item) => Appointment.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      upcomingAppointments: (json['upcomingAppointments'] as List<dynamic>?)
          ?.map((item) => Appointment.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      pastAppointments: (json['pastAppointments'] as List<dynamic>?)
          ?.map((item) => Appointment.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
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
  final String patientId;
  final Doctor doctor;
  final Timeslot? timeslot;
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
  final String? homevisitstatus;
  final RescheduleInfo? isReschedule;
  final List<dynamic>? followUps;
  final String? paymentStatus;
  final Prescription? prescriptionId;

  Appointment({
    required this.id,
    required this.patientId,
    required this.doctor,
    this.timeslot,
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
    this.homevisitstatus,
    this.isReschedule,
    this.followUps,
    this.paymentStatus,
    this.prescriptionId,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['_id']?.toString() ?? '',
      patientId: json['patientId']?.toString() ?? '',
      doctor: Doctor.fromJson(json['doctorId'] as Map<String, dynamic>? ?? {}),
      timeslot: json['timeslot'] != null
          ? Timeslot.fromJson(json['timeslot'] as Map<String, dynamic>)
          : null,
      fee: (json['fee'] as num?)?.toInt() ?? 0,
      currency: json['currency']?.toString() ?? 'USD',
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      consultationType: ConsultationTypeExtension.fromString(json['consultationType']?.toString() ?? 'remote'),
      status: AppointmentStatusExtension.fromString(json['status']?.toString() ?? 'pending'),
      visitAddress: json['visitAddress']?.toString(),
      notes: json['notes']?.toString(),
      rescheduleReason: json['rescheduleReason']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? DateTime.now(),
      v: (json['__v'] as num?)?.toInt() ?? 0,
      homevisitstatus: json['homevisitstatus']?.toString(),
      isReschedule: json['isReschedule'] != null
          ? RescheduleInfo.fromJson(json['isReschedule'] as Map<String, dynamic>)
          : null,
      followUps: json['followUps'] as List<dynamic>?,
      paymentStatus: json['paymentStatus']?.toString(),
      prescriptionId: json['prescriptionId'] != null
          ? Prescription.fromJson(json['prescriptionId'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'patientId': patientId,
      'doctorId': doctor.toJson(),
      'timeslot': timeslot?.toJson(),
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
      'homevisitstatus': homevisitstatus,
      'isReschedule': isReschedule?.toJson(),
      'followUps': followUps,
      'paymentStatus': paymentStatus,
      'prescriptionId': prescriptionId?.toJson(),
    };
  }

  bool get isUpcoming => date.isAfter(DateTime.now());
  bool get isPast => date.isBefore(DateTime.now());
  String get formattedDate => '${date.day}/${date.month}/${date.year}';
  String get formattedTime => '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
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
      id: json['_id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      profileImage: json['profileImage']?.toString(),
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
      id: json['_id']?.toString() ?? '',
      startTime: DateTime.tryParse(json['startTime']?.toString() ?? '') ?? DateTime.now(),
      endTime: DateTime.tryParse(json['endTime']?.toString() ?? '') ?? DateTime.now(),
      status: TimeslotStatusExtension.fromString(json['status']?.toString() ?? 'booked'),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? DateTime.now(),
      v: (json['__v'] as num?)?.toInt() ?? 0,
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

class RescheduleInfo {
  final String isAccept;
  final String? reason;
  final String? role;

  RescheduleInfo({
    required this.isAccept,
    this.reason,
    this.role,
  });

  factory RescheduleInfo.fromJson(Map<String, dynamic> json) {
    return RescheduleInfo(
      isAccept: json['isAccept']?.toString() ?? 'pending',
      reason: json['reason']?.toString(),
      role: json['role']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isAccept': isAccept,
      'reason': reason,
      'role': role,
    };
  }
}

class Prescription {
  final String id;
  final String doctorId;
  final String patientId;
  final String activestatus;
  final String appointmentId;
  final String diagnosis;
  final String notes;
  final List<Medication> medications;
  final String prescriptionNumber;
  final DateTime issueDate;
  final DateTime validUntil;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Prescription({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.activestatus,
    required this.appointmentId,
    required this.diagnosis,
    required this.notes,
    required this.medications,
    required this.prescriptionNumber,
    required this.issueDate,
    required this.validUntil,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['_id']?.toString() ?? '',
      doctorId: json['doctorId']?.toString() ?? '',
      patientId: json['patientId']?.toString() ?? '',
      activestatus: json['activestatus']?.toString() ?? '',
      appointmentId: json['appointmentId']?.toString() ?? '',
      diagnosis: json['diagnosis']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
      medications: (json['medications'] as List<dynamic>?)
          ?.map((item) => Medication.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      prescriptionNumber: json['prescriptionNumber']?.toString() ?? '',
      issueDate: DateTime.tryParse(json['issueDate']?.toString() ?? '') ?? DateTime.now(),
      validUntil: DateTime.tryParse(json['validUntil']?.toString() ?? '') ?? DateTime.now(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? DateTime.now(),
      v: (json['__v'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'doctorId': doctorId,
      'patientId': patientId,
      'activestatus': activestatus,
      'appointmentId': appointmentId,
      'diagnosis': diagnosis,
      'notes': notes,
      'medications': medications.map((med) => med.toJson()).toList(),
      'prescriptionNumber': prescriptionNumber,
      'issueDate': issueDate.toIso8601String(),
      'validUntil': validUntil.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}

class Medication {
  final String name;
  final String dosage;
  final String frequency;
  final String duration;
  final String id;

  Medication({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.id,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      name: json['name']?.toString() ?? '',
      dosage: json['dosage']?.toString() ?? '',
      frequency: json['frequency']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '',
      id: json['_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'duration': duration,
      '_id': id,
    };
  }
}

enum ConsultationType {
  homevisit,
  inperson,
  remote,
  video;

  String get displayName {
    switch (this) {
      case ConsultationType.homevisit:
        return 'Home Visit';
      case ConsultationType.inperson:
        return 'In Person';
      case ConsultationType.remote:
        return 'Remote';
      case ConsultationType.video:
        return 'Video';
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
      case 'video':
        return ConsultationType.video;
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
  rescheduled,
  ongoing;

  String get displayName {
    switch (this) {
      case AppointmentStatus.pending:
        return 'Pending';
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
      case AppointmentStatus.ongoing:
        return 'Ongoing';
      case AppointmentStatus.rescheduled:
        return "rescheduled";
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
      case 'ongoing':
        return AppointmentStatus.ongoing;
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
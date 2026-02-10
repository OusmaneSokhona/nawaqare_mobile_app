class DoctorAppointmentResponse {
  final String message;
  final int total;
  final List<DoctorAppointment> appointments;
  final List<DoctorAppointment> upcomingAppointments;
  final List<DoctorAppointment> pastAppointments;

  DoctorAppointmentResponse({
    required this.message,
    required this.total,
    required this.appointments,
    required this.upcomingAppointments,
    required this.pastAppointments,
  });

  factory DoctorAppointmentResponse.fromJson(Map<String, dynamic> json) {
    return DoctorAppointmentResponse(
      message: json['message'] as String? ?? '',
      total: json['total'] as int? ?? 0,
      appointments: (json['appointments'] as List<dynamic>? ?? [])
          .map((item) => DoctorAppointment.fromJson(item as Map<String, dynamic>))
          .toList(),
      upcomingAppointments: (json['upcomingAppointments'] as List<dynamic>? ?? [])
          .map((item) => DoctorAppointment.fromJson(item as Map<String, dynamic>))
          .toList(),
      pastAppointments: (json['pastAppointments'] as List<dynamic>? ?? [])
          .map((item) => DoctorAppointment.fromJson(item as Map<String, dynamic>))
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
}

class DoctorAppointment {
  final String id;
  final RescheduleInfo? isReschedule;
  final PatientInfo patientId;
  final String doctorId;
  final TimeSlot timeslot;
  final double fee;
  final String currency;
  final DateTime date;
  final String consultationType;
  final String status;
  final String? visitAddress;
  final String? notes;
  final String rescheduleReason;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final String? homevisitstatus;

  DoctorAppointment({
    required this.id,
    this.isReschedule,
    required this.patientId,
    required this.doctorId,
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
    this.homevisitstatus,
  });

  factory DoctorAppointment.fromJson(Map<String, dynamic> json) {
    return DoctorAppointment(
      id: json['_id'] as String? ?? '',
      isReschedule: json['isReschedule'] != null
          ? RescheduleInfo.fromJson(json['isReschedule'] as Map<String, dynamic>)
          : null,
      patientId: PatientInfo.fromJson(json['patientId'] as Map<String, dynamic>? ?? {}),
      doctorId: json['doctorId'] is String
          ? json['doctorId'] as String
          : (json['doctorId'] as Map<String, dynamic>?)?['_id'] as String? ?? '',
      timeslot: TimeSlot.fromJson(json['timeslot'] as Map<String, dynamic>? ?? {}),
      fee: (json['fee'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? '',
      date: DateTime.parse(json['date'] as String? ?? DateTime.now().toIso8601String()),
      consultationType: json['consultationType'] as String? ?? '',
      status: json['status'] as String? ?? '',
      visitAddress: json['visitAddress'] as String?,
      notes: json['notes'] as String?,
      rescheduleReason: json['rescheduleReason'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] as String? ?? DateTime.now().toIso8601String()),
      v: json['__v'] as int? ?? 0,
      homevisitstatus: json['homevisitstatus'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'isReschedule': isReschedule?.toJson(),
      'patientId': patientId.toJson(),
      'doctorId': doctorId,
      'timeslot': timeslot.toJson(),
      'fee': fee,
      'currency': currency,
      'date': date.toIso8601String(),
      'consultationType': consultationType,
      'status': status,
      'visitAddress': visitAddress,
      'notes': notes,
      'rescheduleReason': rescheduleReason,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
      'homevisitstatus': homevisitstatus,
    };
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
      isAccept: json['isAccept'] as String? ?? 'pending',
      reason: json['reason'] as String?,
      role: json['role'] as String?,
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

class PatientInfo {
  final String id;
  final String fullName;
  final String email;
  final String profileImage;

  PatientInfo({
    required this.id,
    required this.fullName,
    required this.email,
    required this.profileImage,
  });

  factory PatientInfo.fromJson(Map<String, dynamic> json) {
    return PatientInfo(
      id: json['_id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      profileImage: json['profileImage'] as String? ?? '',
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

class TimeSlot {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  TimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['_id'] as String? ?? '',
      startTime: DateTime.parse(json['startTime'] as String? ?? DateTime.now().toIso8601String()),
      endTime: DateTime.parse(json['endTime'] as String? ?? DateTime.now().toIso8601String()),
      status: json['status'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] as String? ?? DateTime.now().toIso8601String()),
      v: json['__v'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}
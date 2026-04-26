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
  final Patient patientId;
  final Doctor doctorId;
  final Timeslot? timeslot;
  final int fee;
  final String currency;
  final DateTime date;
  final ConsultationType consultationType;
  final AppointmentStatus status;
  final String? visitAddress;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final String? homevisitstatus;
  final RescheduleInfo? isReschedule;
  final List<FollowUp>? followUps;
  final String? paymentStatus;
  final Prescription? prescriptionId;
  final SOAP? soap;
  final List<Reviews>? reviews; // Changed from Reviews? to List<Reviews>?

  Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    this.timeslot,
    required this.fee,
    required this.currency,
    required this.date,
    required this.consultationType,
    required this.status,
    this.visitAddress,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.homevisitstatus,
    this.isReschedule,
    this.followUps,
    this.paymentStatus,
    this.prescriptionId,
    this.soap,
    this.reviews,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['_id']?.toString() ?? '',
      patientId: Patient.fromJson(json['patientId'] as Map<String, dynamic>? ?? {}),
      doctorId: Doctor.fromJson(json['doctorId'] as Map<String, dynamic>? ?? {}),
      timeslot: json['timeslot'] != null
          ? Timeslot.fromJson(json['timeslot'] as Map<String, dynamic>)
          : null,
      fee: (json['fee'] as num?)?.toInt() ?? 0,
      currency: json['currency']?.toString() ?? 'USD',
      date: _parseToLocalDateTime(json['date']),
      consultationType: ConsultationTypeExtension.fromString(json['consultationType']?.toString() ?? 'remote'),
      status: AppointmentStatusExtension.fromString(json['status']?.toString() ?? 'pending'),
      visitAddress: json['visitAddress']?.toString(),
      notes: json['notes']?.toString(),
      createdAt: _parseToLocalDateTime(json['createdAt']),
      updatedAt: _parseToLocalDateTime(json['updatedAt']),
      v: (json['__v'] as num?)?.toInt() ?? 0,
      homevisitstatus: json['homevisitstatus']?.toString(),
      isReschedule: json['isReschedule'] != null
          ? RescheduleInfo.fromJson(json['isReschedule'] as Map<String, dynamic>)
          : null,
      followUps: json['followUps'] != null
          ? (json['followUps'] as List<dynamic>)
          .map((item) => FollowUp.fromJson(item as Map<String, dynamic>))
          .toList()
          : null,
      paymentStatus: json['paymentStatus']?.toString(),
      prescriptionId: json['prescriptionId'] != null
          ? Prescription.fromJson(json['prescriptionId'] as Map<String, dynamic>)
          : null,
      soap: json['SOAP'] != null
          ? SOAP.fromJson(json['SOAP'] as Map<String, dynamic>)
          : null,
      reviews: json['reviews'] != null
          ? (json['reviews'] as List<dynamic>)
          .map((item) => Reviews.fromJson(item as Map<String, dynamic>))
          .toList()
          : null,
    );
  }

  static DateTime _parseToLocalDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    try {
      final utcDateTime = DateTime.parse(value.toString());
      return utcDateTime.toLocal();
    } catch (e) {
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'patientId': patientId.toJson(),
      'doctorId': doctorId.toJson(),
      'timeslot': timeslot?.toJson(),
      'fee': fee,
      'currency': currency,
      'date': date.toUtc().toIso8601String(),
      'consultationType': consultationType.name,
      'status': status.name,
      'visitAddress': visitAddress,
      'notes': notes,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
      '__v': v,
      'homevisitstatus': homevisitstatus,
      'isReschedule': isReschedule?.toJson(),
      'followUps': followUps?.map((f) => f.toJson()).toList(),
      'paymentStatus': paymentStatus,
      'prescriptionId': prescriptionId?.toJson(),
      'SOAP': soap?.toJson(),
      'reviews': reviews?.map((r) => r.toJson()).toList(),
    };
  }

  bool get isUpcoming {
    if (timeslot == null) return date.isAfter(DateTime.now());
    return timeslot!.startTime.isAfter(DateTime.now());
  }

  bool get isPast {
    if (timeslot == null) return date.isBefore(DateTime.now());
    return timeslot!.endTime.isBefore(DateTime.now());
  }

  String get formattedDate {
    if (timeslot != null) {
      return '${timeslot!.startTime.day.toString().padLeft(2, '0')}/${timeslot!.startTime.month.toString().padLeft(2, '0')}/${timeslot!.startTime.year}';
    }
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String get formattedTime {
    if (timeslot != null) {
      return timeslot!.formattedStartTime;
    }
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String get formattedTimeRange {
    if (timeslot != null) {
      return '${timeslot!.formattedStartTime} - ${timeslot!.formattedEndTime}';
    }
    return formattedTime;
  }

  String getFormattedDateWithDay() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final appointmentDate = date;

    if (appointmentDate.year == today.year &&
        appointmentDate.month == today.month &&
        appointmentDate.day == today.day) {
      return "Today";
    } else if (appointmentDate.year == today.year &&
        appointmentDate.month == today.month &&
        appointmentDate.day == today.day + 1) {
      return "Tomorrow";
    } else {
      final weekdayMap = {
        1: 'Mon',
        2: 'Tue',
        3: 'Wed',
        4: 'Thu',
        5: 'Fri',
        6: 'Sat',
        7: 'Sun',
      };

      final monthMap = {
        1: 'Jan',
        2: 'Feb',
        3: 'Mar',
        4: 'Apr',
        5: 'May',
        6: 'Jun',
        7: 'Jul',
        8: 'Aug',
        9: 'Sep',
        10: 'Oct',
        11: 'Nov',
        12: 'Dec',
      };

      final weekday = weekdayMap[appointmentDate.weekday] ?? 'Day';
      final month = monthMap[appointmentDate.month] ?? 'Month';

      return '$weekday, ${appointmentDate.day} $month';
    }
  }
}

class SOAP {
  final String? subjective;
  final String? objective;
  final String? assessment;
  final String? plan;
  final String? diagnosis;

  SOAP({
    this.subjective,
    this.objective,
    this.assessment,
    this.plan,
    this.diagnosis,
  });

  factory SOAP.fromJson(Map<String, dynamic> json) {
    return SOAP(
      subjective: json['subjective']?.toString(),
      objective: json['objective']?.toString(),
      assessment: json['assessment']?.toString(),
      plan: json['plan']?.toString(),
      diagnosis: json['diagnosis']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subjective': subjective,
      'objective': objective,
      'assessment': assessment,
      'plan': plan,
      'diagnosis': diagnosis,
    };
  }
}

class FollowUp {
  final String id;
  final TimeSlotId timeSlotId;
  final List<dynamic> prescriptions;
  final int followupPrice;
  final String paymentIntent;
  final String paymentStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  FollowUp({
    required this.id,
    required this.timeSlotId,
    required this.prescriptions,
    required this.followupPrice,
    required this.paymentIntent,
    required this.paymentStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory FollowUp.fromJson(Map<String, dynamic> json) {
    return FollowUp(
      id: json['_id']?.toString() ?? '',
      timeSlotId: TimeSlotId.fromJson(json['timeSlotId'] as Map<String, dynamic>? ?? {}),
      prescriptions: json['prescriptions'] as List<dynamic>? ?? [],
      followupPrice: (json['followupPrice'] as num?)?.toInt() ?? 0,
      paymentIntent: json['paymentIntent']?.toString() ?? '',
      paymentStatus: json['paymentStatus']?.toString() ?? 'pending',
      createdAt: _parseToLocalDateTime(json['createdAt']),
      updatedAt: _parseToLocalDateTime(json['updatedAt']),
      v: (json['__v'] as num?)?.toInt() ?? 0,
    );
  }

  static DateTime _parseToLocalDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    try {
      final utcDateTime = DateTime.parse(value.toString());
      return utcDateTime.toLocal();
    } catch (e) {
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'timeSlotId': timeSlotId.toJson(),
      'prescriptions': prescriptions,
      'followupPrice': followupPrice,
      'paymentIntent': paymentIntent,
      'paymentStatus': paymentStatus,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
      '__v': v,
    };
  }
}

class TimeSlotId {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  TimeSlotId({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory TimeSlotId.fromJson(Map<String, dynamic> json) {
    return TimeSlotId(
      id: json['_id']?.toString() ?? '',
      startTime: _parseToLocalDateTime(json['startTime']),
      endTime: _parseToLocalDateTime(json['endTime']),
      status: json['status']?.toString() ?? 'booked',
      createdAt: _parseToLocalDateTime(json['createdAt']),
      updatedAt: _parseToLocalDateTime(json['updatedAt']),
      v: (json['__v'] as num?)?.toInt() ?? 0,
    );
  }

  static DateTime _parseToLocalDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    try {
      final utcDateTime = DateTime.parse(value.toString());
      return utcDateTime.toLocal();
    } catch (e) {
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'startTime': startTime.toUtc().toIso8601String(),
      'endTime': endTime.toUtc().toIso8601String(),
      'status': status,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
      '__v': v,
    };
  }
}

class Reviews {
  final String id;
  final Doctor doctorId;
  final Patient patientId;
  final String appointmentId;
  final int rating;
  final String review;
  final bool ratingGiven;
  final int v;

  Reviews({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.appointmentId,
    required this.rating,
    required this.review,
    required this.ratingGiven,
    required this.v,
  });

  factory Reviews.fromJson(Map<String, dynamic> json) {
    return Reviews(
      id: json['_id'] as String? ?? '',
      doctorId: Doctor.fromJson(json['doctorId'] as Map<String, dynamic>? ?? {}),
      patientId: Patient.fromJson(json['patientId'] as Map<String, dynamic>? ?? {}),
      appointmentId: json['appointmentId'] as String? ?? '',
      rating: json['rating'] as int? ?? 0,
      review: json['review'] as String? ?? '',
      ratingGiven: json['ratingGiven'] as bool? ?? false,
      v: json['__v'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'doctorId': doctorId.toJson(),
      'patientId': patientId.toJson(),
      'appointmentId': appointmentId,
      'rating': rating,
      'review': review,
      'ratingGiven': ratingGiven,
      '__v': v,
    };
  }
}

class Patient {
  final String id;
  final String userId;
  final String fullName;
  final String phoneNumber;
  final String email;
  final List<String> allergies;
  final List<String> appointments;
  final List<String> reports;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final String? address;
  final String? bloodPressure;
  final double? bmi;
  final String? country;
  final DateTime? dob;
  final String? gender;
  final String? heartRate;
  final String? height;
  final String? profileImage;
  final String? religion;
  final String? weight;

  Patient({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.allergies,
    required this.appointments,
    required this.reports,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.address,
    this.bloodPressure,
    this.bmi,
    this.country,
    this.dob,
    this.gender,
    this.heartRate,
    this.height,
    this.profileImage,
    this.religion,
    this.weight,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['_id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      allergies: (json['allergies'] as List<dynamic>?)
          ?.map((item) => item.toString())
          .toList() ?? [],
      appointments: (json['appointments'] as List<dynamic>?)
          ?.map((item) => item.toString())
          .toList() ?? [],
      reports: (json['reports'] as List<dynamic>?)
          ?.map((item) => item.toString())
          .toList() ?? [],
      createdAt: _parseToLocalDateTime(json['createdAt']),
      updatedAt: _parseToLocalDateTime(json['updatedAt']),
      v: (json['__v'] as num?)?.toInt() ?? 0,
      address: json['address']?.toString(),
      bloodPressure: json['bloodPressure']?.toString(),
      bmi: (json['bmi'] as num?)?.toDouble(),
      country: json['country']?.toString(),
      dob: json['dob'] != null ? _parseToLocalDateTime(json['dob']) : null,
      gender: json['gender']?.toString(),
      heartRate: json['heartRate']?.toString(),
      height: json['height']?.toString(),
      profileImage: json['profileImage']?.toString(),
      religion: json['religion']?.toString(),
      weight: json['weight']?.toString(),
    );
  }

  static DateTime _parseToLocalDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    try {
      final utcDateTime = DateTime.parse(value.toString());
      return utcDateTime.toLocal();
    } catch (e) {
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'email': email,
      'allergies': allergies,
      'appointments': appointments,
      'reports': reports,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
      '__v': v,
      'address': address,
      'bloodPressure': bloodPressure,
      'bmi': bmi,
      'country': country,
      'dob': dob?.toUtc().toIso8601String(),
      'gender': gender,
      'heartRate': heartRate,
      'height': height,
      'profileImage': profileImage,
      'religion': religion,
      'weight': weight,
    };
  }

  int? get age {
    if (dob == null) return null;
    final now = DateTime.now();
    int age = now.year - dob!.year;
    if (now.month < dob!.month || (now.month == dob!.month && now.day < dob!.day)) {
      age--;
    }
    return age;
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
      startTime: _parseToLocalDateTime(json['startTime']),
      endTime: _parseToLocalDateTime(json['endTime']),
      status: TimeslotStatusExtension.fromString(json['status']?.toString() ?? 'booked'),
      createdAt: _parseToLocalDateTime(json['createdAt']),
      updatedAt: _parseToLocalDateTime(json['updatedAt']),
      v: (json['__v'] as num?)?.toInt() ?? 0,
    );
  }

  static DateTime _parseToLocalDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    try {
      final utcDateTime = DateTime.parse(value.toString());
      return utcDateTime.toLocal();
    } catch (e) {
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'startTime': startTime.toUtc().toIso8601String(),
      'endTime': endTime.toUtc().toIso8601String(),
      'status': status.name,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
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

  String get formattedStartTime {
    final hour = startTime.hour % 12 == 0 ? 12 : startTime.hour % 12;
    final minute = startTime.minute.toString().padLeft(2, '0');
    final period = startTime.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String get formattedEndTime {
    final hour = endTime.hour % 12 == 0 ? 12 : endTime.hour % 12;
    final minute = endTime.minute.toString().padLeft(2, '0');
    final period = endTime.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String get formattedStartDate {
    return '${startTime.day.toString().padLeft(2, '0')}/${startTime.month.toString().padLeft(2, '0')}/${startTime.year}';
  }

  String get formattedTimeRange {
    return '$formattedStartTime - $formattedEndTime';
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
      isAccept: json['isAccept']?.toString() ?? 'notset',
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

  bool get isPending => isAccept == 'pending';
  bool get isAccepted => isAccept == 'accepted';
  bool get isRejected => isAccept == 'rejected';
  bool get isNotSet => isAccept == 'notset';
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
      issueDate: _parseToLocalDateTime(json['issueDate']),
      validUntil: _parseToLocalDateTime(json['validUntil']),
      createdAt: _parseToLocalDateTime(json['createdAt']),
      updatedAt: _parseToLocalDateTime(json['updatedAt']),
      v: (json['__v'] as num?)?.toInt() ?? 0,
    );
  }

  static DateTime _parseToLocalDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    try {
      final utcDateTime = DateTime.parse(value.toString());
      return utcDateTime.toLocal();
    } catch (e) {
      return DateTime.now();
    }
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
      'issueDate': issueDate.toUtc().toIso8601String(),
      'validUntil': validUntil.toUtc().toIso8601String(),
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
      '__v': v,
    };
  }

  bool get isValid => validUntil.isAfter(DateTime.now());

  String get formattedIssueDate {
    return '${issueDate.day}/${issueDate.month}/${issueDate.year}';
  }

  String get formattedValidUntil {
    return '${validUntil.day}/${validUntil.month}/${validUntil.year}';
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
    switch (value.toLowerCase()) {
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
  ongoing,
  rescheduled;

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
        return "Rescheduled";
    }
  }
}

class AppointmentStatusExtension {
  static AppointmentStatus fromString(String value) {
    switch (value.toLowerCase()) {
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
    switch (value.toLowerCase()) {
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
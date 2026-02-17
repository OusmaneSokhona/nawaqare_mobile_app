import 'package:patient_app/models/appointment_model.dart';
import 'package:patient_app/utils/appointment_status.dart';

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
  final TimeSlot? timeslot;
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
  final String? paymentStatus;
  final PrescriptionInfo? prescriptionId;
  final List<FollowUp>? followUps;

  DoctorAppointment({
    required this.id,
    this.isReschedule,
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
    required this.rescheduleReason,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.homevisitstatus,
    this.paymentStatus,
    this.prescriptionId,
    this.followUps,
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
      timeslot: json['timeslot'] != null
          ? TimeSlot.fromJson(json['timeslot'] as Map<String, dynamic>)
          : null,
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
      paymentStatus: json['paymentStatus'] as String?,
      prescriptionId: json['prescriptionId'] != null
          ? PrescriptionInfo.fromJson(json['prescriptionId'] as Map<String, dynamic>)
          : null,
      followUps: json['followUps'] != null
          ? (json['followUps'] as List)
          .map((item) => FollowUp.fromJson(item as Map<String, dynamic>))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'isReschedule': isReschedule?.toJson(),
      'patientId': patientId.toJson(),
      'doctorId': doctorId,
      'timeslot': timeslot?.toJson(),
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
      'paymentStatus': paymentStatus,
      'prescriptionId': prescriptionId?.toJson(),
      'followUps': followUps?.map((item) => item.toJson()).toList(),
    };
  }
}

class FollowUp {
  final String id;
  final TimeSlot timeSlotId;
  final List<dynamic> prescriptions;
  final int followupPrice;
  final String paymentIntent;
  final String paymentStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final SOAP? soap;

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
    this.soap,
  });

  factory FollowUp.fromJson(Map<String, dynamic> json) {
    return FollowUp(
      id: json['_id'] as String? ?? '',
      timeSlotId: TimeSlot.fromJson(json['timeSlotId'] as Map<String, dynamic>? ?? {}),
      prescriptions: json['prescriptions'] as List? ?? [],
      followupPrice: json['followupPrice'] as int? ?? 0,
      paymentIntent: json['paymentIntent'] as String? ?? '',
      paymentStatus: json['paymentStatus'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] as String? ?? DateTime.now().toIso8601String()),
      v: json['__v'] as int? ?? 0,
      soap: json['SOAP'] != null ? SOAP.fromJson(json['SOAP'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'timeSlotId': timeSlotId.toJson(),
      'prescriptions': prescriptions,
      'followupPrice': followupPrice,
      'paymentIntent': paymentIntent,
      'paymentStatus': paymentStatus,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
      'SOAP': soap?.toJson(),
    };
  }
}

class SOAP {
  final String subjective;
  final String objective;
  final String assessment;
  final String plan;
  final String diagnosis;

  SOAP({
    required this.subjective,
    required this.objective,
    required this.assessment,
    required this.plan,
    required this.diagnosis,
  });

  factory SOAP.fromJson(Map<String, dynamic> json) {
    return SOAP(
      subjective: json['subjective'] as String? ?? '',
      objective: json['objective'] as String? ?? '',
      assessment: json['assessment'] as String? ?? '',
      plan: json['plan'] as String? ?? '',
      diagnosis: json['diagnosis'] as String? ?? '',
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
  final String? phoneNumber;
  final List<String>? appointments;
  final List<String>? reports;
  final List<String>? allergies;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? address;
  final String? bloodPressure;
  final double? bmi;
  final String? country;
  final DateTime? dob;
  final String? gender;
  final String? heartRate;
  final String? height;
  final String? religion;
  final String? weight;

  PatientInfo({
    required this.id,
    required this.fullName,
    required this.email,
    required this.profileImage,
    this.phoneNumber,
    this.appointments,
    this.reports,
    this.allergies,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.address,
    this.bloodPressure,
    this.bmi,
    this.country,
    this.dob,
    this.gender,
    this.heartRate,
    this.height,
    this.religion,
    this.weight,
  });

  factory PatientInfo.fromJson(Map<String, dynamic> json) {
    return PatientInfo(
      id: json['_id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      profileImage: json['profileImage'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String?,
      appointments: json['appointments'] != null
          ? List<String>.from(json['appointments'] as List)
          : null,
      reports: json['reports'] != null
          ? List<String>.from(json['reports'] as List)
          : null,
      allergies: json['allergies'] != null
          ? List<String>.from(json['allergies'] as List)
          : null,
      userId: json['userId'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      v: json['__v'] as int?,
      address: json['address'] as String?,
      bloodPressure: json['bloodPressure'] as String?,
      bmi: (json['bmi'] as num?)?.toDouble(),
      country: json['country'] as String?,
      dob: json['dob'] != null ? DateTime.parse(json['dob'] as String) : null,
      gender: json['gender'] as String?,
      heartRate: json['heartRate'] as String?,
      height: json['height'] as String?,
      religion: json['religion'] as String?,
      weight: json['weight'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'email': email,
      'profileImage': profileImage,
      'phoneNumber': phoneNumber,
      'appointments': appointments,
      'reports': reports,
      'allergies': allergies,
      'userId': userId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
      'address': address,
      'bloodPressure': bloodPressure,
      'bmi': bmi,
      'country': country,
      'dob': dob?.toIso8601String(),
      'gender': gender,
      'heartRate': heartRate,
      'height': height,
      'religion': religion,
      'weight': weight,
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

class PrescriptionInfo {
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

  PrescriptionInfo({
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

  factory PrescriptionInfo.fromJson(Map<String, dynamic> json) {
    return PrescriptionInfo(
      id: json['_id'] as String? ?? '',
      doctorId: json['doctorId'] as String? ?? '',
      patientId: json['patientId'] as String? ?? '',
      activestatus: json['activestatus'] as String? ?? '',
      appointmentId: json['appointmentId'] as String? ?? '',
      diagnosis: json['diagnosis'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      medications: (json['medications'] as List<dynamic>? ?? [])
          .map((item) => Medication.fromJson(item as Map<String, dynamic>))
          .toList(),
      prescriptionNumber: json['prescriptionNumber'] as String? ?? '',
      issueDate: DateTime.parse(json['issueDate'] as String? ?? DateTime.now().toIso8601String()),
      validUntil: DateTime.parse(json['validUntil'] as String? ?? DateTime.now().toIso8601String()),
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] as String? ?? DateTime.now().toIso8601String()),
      v: json['__v'] as int? ?? 0,
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
      'medications': medications.map((medication) => medication.toJson()).toList(),
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
      name: json['name'] as String? ?? '',
      dosage: json['dosage'] as String? ?? '',
      frequency: json['frequency'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      id: json['_id'] as String? ?? '',
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
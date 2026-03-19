// lib/models/doctor_prescription_model.dart

class DoctorPrescriptionModel {
  final String id;
  final String doctorId;
  final PatientInfo patientInfo;
  final String activeStatus;
  final AppointmentInfo appointmentInfo;
  final String diagnosis;
  final String notes;
  final List<MedicationInfo> medications;
  final String prescriptionNumber;
  final DateTime issueDate;
  final DateTime validUntil;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  DoctorPrescriptionModel({
    required this.id,
    required this.doctorId,
    required this.patientInfo,
    required this.activeStatus,
    required this.appointmentInfo,
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

  factory DoctorPrescriptionModel.fromJson(Map<String, dynamic> json) {
    return DoctorPrescriptionModel(
      id: json['_id'] ?? '',
      doctorId: json['doctorId'] ?? '',
      patientInfo: PatientInfo.fromJson(json['patientId'] ?? {}),
      activeStatus: json['activestatus'] ?? '',
      appointmentInfo: AppointmentInfo.fromJson(json['appointmentId'] ?? {}),
      diagnosis: json['diagnosis'] ?? '',
      notes: json['notes'] ?? '',
      medications: (json['medications'] as List? ?? [])
          .map((med) => MedicationInfo.fromJson(med))
          .toList(),
      prescriptionNumber: json['prescriptionNumber'] ?? '',
      issueDate: DateTime.parse(json['issueDate']),
      validUntil: DateTime.parse(json['validUntil']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'doctorId': doctorId,
      'patientId': patientInfo.toJson(),
      'activestatus': activeStatus,
      'appointmentId': appointmentInfo.toJson(),
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

  PrescriptionStatus get status {
    final now = DateTime.now();
    if (now.isAfter(validUntil)) {
      return PrescriptionStatus.expired;
    } else if (validUntil.difference(now).inDays <= 7) {
      return PrescriptionStatus.expirySoon;
    } else {
      return PrescriptionStatus.active;
    }
  }
}

class PatientInfo {
  final String id;
  final String fullName;
  final String profileImage;

  PatientInfo({
    required this.id,
    required this.fullName,
    required this.profileImage,
  });

  factory PatientInfo.fromJson(Map<String, dynamic> json) {
    return PatientInfo(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'profileImage': profileImage,
    };
  }
}

class AppointmentInfo {
  final String id;
  final DateTime date;
  final String consultationType;
  final String status;
  final String visitAddress;

  AppointmentInfo({
    required this.id,
    required this.date,
    required this.consultationType,
    required this.status,
    required this.visitAddress,
  });

  factory AppointmentInfo.fromJson(Map<String, dynamic> json) {
    return AppointmentInfo(
      id: json['_id'] ?? '',
      date: DateTime.parse(json['date']),
      consultationType: json['consultationType'] ?? '',
      status: json['status'] ?? '',
      visitAddress: json['visitAddress'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'date': date.toIso8601String(),
      'consultationType': consultationType,
      'status': status,
      'visitAddress': visitAddress,
    };
  }
}

class MedicationInfo {
  final String name;
  final String dosage;
  final String frequency;
  final String duration;
  final String instructions;
  final DateTime refillDate;
  final String specialInstruction;

  MedicationInfo({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.instructions,
    required this.refillDate,
    required this.specialInstruction,
  });

  factory MedicationInfo.fromJson(Map<String, dynamic> json) {
    return MedicationInfo(
      name: json['name'] ?? '',
      dosage: json['dosage'] ?? '',
      frequency: json['frequency'] ?? '',
      duration: json['duration'] ?? '',
      instructions: json['instructions'] ?? '',
      refillDate: DateTime.parse(json['refildate']),
      specialInstruction: json['specialInstruction'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'duration': duration,
      'instructions': instructions,
      'refildate': refillDate.toIso8601String(),
      'specialInstruction': specialInstruction,
    };
  }
}

enum PrescriptionStatus {
  active,
  expirySoon,
  expired,
  completed,
}
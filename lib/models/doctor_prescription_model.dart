class DoctorPrescriptionModel {
  final String id;
  final String doctorId;
  final PatientInfo? patientInfo; // Made nullable
  final String activeStatus;
  final AppointmentInfo? appointmentInfo; // Made nullable
  final String diagnosis;
  final String notes;
  final List<MedicationInfo> medications;
  final String prescriptionNumber;
  final DateTime issueDate;
  final DateTime? validUntil; // Made nullable (some prescriptions don't have it)
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final String? patientName; // Added from the JSON

  DoctorPrescriptionModel({
    required this.id,
    required this.doctorId,
    this.patientInfo,
    required this.activeStatus,
    this.appointmentInfo,
    required this.diagnosis,
    required this.notes,
    required this.medications,
    required this.prescriptionNumber,
    required this.issueDate,
    this.validUntil,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.patientName,
  });

  factory DoctorPrescriptionModel.fromJson(Map<String, dynamic> json) {
    return DoctorPrescriptionModel(
      id: json['_id'] ?? '',
      doctorId: json['doctorId'] ?? '',
      patientInfo: _parsePatientInfo(json['patientId']),
      activeStatus: json['activestatus'] ?? '',
      appointmentInfo: _parseAppointmentInfo(json['appointmentId']),
      diagnosis: json['diagnosis'] ?? '',
      notes: json['notes'] ?? '',
      medications: (json['medications'] as List? ?? [])
          .map((med) => MedicationInfo.fromJson(med))
          .toList(),
      prescriptionNumber: json['prescriptionNumber'] ?? '',
      issueDate: json['issueDate'] != null
          ? DateTime.parse(json['issueDate'])
          : DateTime.now(),
      validUntil: json['validUntil'] != null
          ? DateTime.parse(json['validUntil'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'] ?? 0,
      patientName: json['patientName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'doctorId': doctorId,
      'patientId': patientInfo?.toJson(),
      'activestatus': activeStatus,
      'appointmentId': appointmentInfo?.toJson(),
      'diagnosis': diagnosis,
      'notes': notes,
      'medications': medications.map((med) => med.toJson()).toList(),
      'prescriptionNumber': prescriptionNumber,
      'issueDate': issueDate.toIso8601String(),
      if (validUntil != null) 'validUntil': validUntil!.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
      'patientName': patientName,
    };
  }

  PrescriptionStatus get status {
    if (validUntil == null) return PrescriptionStatus.active;

    final now = DateTime.now();
    if (now.isAfter(validUntil!)) {
      return PrescriptionStatus.expired;
    } else if (validUntil!.difference(now).inDays <= 7) {
      return PrescriptionStatus.expirySoon;
    } else {
      return PrescriptionStatus.active;
    }
  }

  String getPatientName() {
    if (patientName != null && patientName!.isNotEmpty) {
      return patientName!;
    }
    return patientInfo?.fullName ?? 'Unknown Patient';
  }

  String getPatientId() {
    return patientInfo?.id ?? '';
  }

  String getProfileImage() {
    return patientInfo?.profileImage ?? '';
  }
}

// Helper function to safely parse PatientInfo
PatientInfo? _parsePatientInfo(dynamic patientData) {
  if (patientData == null) return null;

  // If it's a Map (object), parse it
  if (patientData is Map<String, dynamic>) {
    return PatientInfo.fromJson(patientData);
  }

  // If it's a String (just the ID), return null or create minimal object
  if (patientData is String) {
    // You might want to create a minimal PatientInfo with just the ID
    // return PatientInfo(id: patientData, fullName: '', profileImage: '');
    return null;
  }

  return null;
}

// Helper function to safely parse AppointmentInfo
AppointmentInfo? _parseAppointmentInfo(dynamic appointmentData) {
  if (appointmentData == null) return null;

  // If it's a Map (object), parse it
  if (appointmentData is Map<String, dynamic>) {
    return AppointmentInfo.fromJson(appointmentData);
  }

  // If it's a String (just the ID), return null
  if (appointmentData is String) {
    return null;
  }

  return null;
}

// Update PatientInfo to handle nullable fields
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
      id: json['_id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      profileImage: json['profileImage']?.toString() ?? '',
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

// Update AppointmentInfo to handle nullable date and fields
class AppointmentInfo {
  final String id;
  final DateTime? date; // Made nullable
  final String consultationType;
  final String status;
  final String? visitAddress; // Made nullable

  AppointmentInfo({
    required this.id,
    this.date,
    required this.consultationType,
    required this.status,
    this.visitAddress,
  });

  factory AppointmentInfo.fromJson(Map<String, dynamic> json) {
    return AppointmentInfo(
      id: json['_id']?.toString() ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      consultationType: json['consultationType']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      visitAddress: json['visitAddress']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      if (date != null) 'date': date!.toIso8601String(),
      'consultationType': consultationType,
      'status': status,
      'visitAddress': visitAddress,
    };
  }
}

// Update MedicationInfo to handle missing fields
class MedicationInfo {
  final String name;
  final String dosage;
  final String frequency;
  final String duration;
  final String instructions;
  final DateTime? refillDate; // Made nullable
  final String specialInstruction;

  MedicationInfo({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.instructions,
    this.refillDate,
    required this.specialInstruction,
  });

  factory MedicationInfo.fromJson(Map<String, dynamic> json) {
    return MedicationInfo(
      name: json['name']?.toString() ?? '',
      dosage: json['dosage']?.toString() ?? '',
      frequency: json['frequency']?.toString() ?? '',
      duration: json['duration']?.toString() ?? 'Not specified',
      instructions: json['instructions']?.toString() ?? 'As directed',
      refillDate: json['refildate'] != null
          ? DateTime.tryParse(json['refildate'].toString())
          : null,
      specialInstruction: json['specialInstruction']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'duration': duration,
      'instructions': instructions,
      if (refillDate != null) 'refildate': refillDate!.toIso8601String(),
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
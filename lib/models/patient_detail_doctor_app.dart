

class PatientProfile {
  final String fullName;
  final Map<String, dynamic> vitals;

  PatientProfile({
    required this.fullName,
    required this.vitals,
  });

  factory PatientProfile.fromJson(Map<String, dynamic> json) {
    return PatientProfile(
      fullName: json['fullName']?.toString() ?? '',
      vitals: json['vitals'] is Map<String, dynamic>
          ? json['vitals'] as Map<String, dynamic>
          : {},
    );
  }
}

class LatestAllergy {
  final String id;
  final String allergyType;
  final String allergenName;
  final String reaction;
  final String severity;
  final DateTime dateIdentified;
  final String notes;
  final String createdBy;

  LatestAllergy({
    required this.id,
    required this.allergyType,
    required this.allergenName,
    required this.reaction,
    required this.severity,
    required this.dateIdentified,
    required this.notes,
    required this.createdBy,
  });

  factory LatestAllergy.fromJson(Map<String, dynamic> json) {
    return LatestAllergy(
      id: json['_id']?.toString() ?? '',
      allergyType: json['allergyType']?.toString() ?? '',
      allergenName: json['allergenName']?.toString() ?? '',
      reaction: json['reaction']?.toString() ?? '',
      severity: json['severity']?.toString() ?? '',
      dateIdentified: json['dateIdentified'] != null
          ? DateTime.parse(json['dateIdentified'].toString())
          : DateTime.now(),
      notes: json['notes']?.toString() ?? '',
      createdBy: json['createdBy']?.toString() ?? '',
    );
  }
}

class Medication {
  final String name;
  final String dosage;
  final String frequency;
  final String duration;
  final String instructions;
  final DateTime refillDate;
  final String specialInstruction;

  Medication({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.instructions,
    required this.refillDate,
    required this.specialInstruction,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      name: json['name']?.toString() ?? '',
      dosage: json['dosage']?.toString() ?? '',
      frequency: json['frequency']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '',
      instructions: json['instructions']?.toString() ?? '',
      refillDate: json['refildate'] != null
          ? DateTime.parse(json['refildate'].toString())
          : DateTime.now(),
      specialInstruction: json['specialInstruction']?.toString() ?? '',
    );
  }
}

class PrescriptionDetails {
  final String prescriptionNumber;
  final String diagnosis;
  final List<Medication> medications;
  final String notes;
  final DateTime issueDate;

  PrescriptionDetails({
    required this.prescriptionNumber,
    required this.diagnosis,
    required this.medications,
    required this.notes,
    required this.issueDate,
  });

  factory PrescriptionDetails.fromJson(Map<String, dynamic> json) {
    List<Medication> medicationList = [];
    if (json['medications'] != null && json['medications'] is List) {
      medicationList = (json['medications'] as List)
          .where((med) => med != null && med is Map<String, dynamic>)
          .map((med) => Medication.fromJson(med as Map<String, dynamic>))
          .toList();
    }

    return PrescriptionDetails(
      prescriptionNumber: json['prescriptionNumber']?.toString() ?? '',
      diagnosis: json['diagnosis']?.toString() ?? '',
      medications: medicationList,
      notes: json['notes']?.toString() ?? '',
      issueDate: json['issueDate'] != null
          ? DateTime.parse(json['issueDate'].toString())
          : DateTime.now(),
    );
  }
}

class FollowUp {
  final String followUpId;
  final String timeSlotId;
  final DateTime scheduledDate;
  final DateTime endTime;
  final int followupPrice;
  final String paymentStatus;
  final DateTime createdAt;

  FollowUp({
    required this.followUpId,
    required this.timeSlotId,
    required this.scheduledDate,
    required this.endTime,
    required this.followupPrice,
    required this.paymentStatus,
    required this.createdAt,
  });

  factory FollowUp.fromJson(Map<String, dynamic> json) {
    return FollowUp(
      followUpId: json['followUpId']?.toString() ?? '',
      timeSlotId: json['timeSlotId']?.toString() ?? '',
      scheduledDate: json['scheduledDate'] != null
          ? DateTime.parse(json['scheduledDate'].toString())
          : DateTime.now(),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'].toString())
          : DateTime.now(),
      followupPrice: json['followupPrice'] != null
          ? int.tryParse(json['followupPrice'].toString()) ?? 0
          : 0,
      paymentStatus: json['paymentStatus']?.toString() ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
    );
  }
}

class LatestAppointment {
  final String id;
  final DateTime date;
  final String status;
  final Map<String, dynamic> diagnosisData;
  final String notes;
  final PrescriptionDetails? prescriptionDetails;
  final FollowUp? followUp;

  LatestAppointment({
    required this.id,
    required this.date,
    required this.status,
    required this.diagnosisData,
    required this.notes,
    this.prescriptionDetails,
    this.followUp,
  });

  factory LatestAppointment.fromJson(Map<String, dynamic> json) {
    return LatestAppointment(
      id: json['_id']?.toString() ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'].toString())
          : DateTime.now(),
      status: json['status']?.toString() ?? '',
      diagnosisData: json['diagnosisData'] is Map<String, dynamic>
          ? json['diagnosisData'] as Map<String, dynamic>
          : {},
      notes: json['notes']?.toString() ?? '',
      prescriptionDetails: json['prescriptionDetails'] != null && json['prescriptionDetails'] is Map<String, dynamic>
          ? PrescriptionDetails.fromJson(json['prescriptionDetails'] as Map<String, dynamic>)
          : null,
      followUp: json['FollowUp'] != null && json['FollowUp'] is Map<String, dynamic>
          ? FollowUp.fromJson(json['FollowUp'] as Map<String, dynamic>)
          : null,
    );
  }
}

class PatientMedicalData {
  final PatientProfile profile;
  final LatestAllergy? latestAllergy;
  final LatestAppointment? latestAppointment;
  final List<String> reports;

  PatientMedicalData({
    required this.profile,
    this.latestAllergy,
    this.latestAppointment,
    required this.reports,
  });

  factory PatientMedicalData.fromJson(Map<String, dynamic> json) {
    return PatientMedicalData(
      profile: json['profile'] != null && json['profile'] is Map<String, dynamic>
          ? PatientProfile.fromJson(json['profile'] as Map<String, dynamic>)
          : PatientProfile(fullName: '', vitals: {}),
      latestAllergy: json['latestAllergy'] != null && json['latestAllergy'] is Map<String, dynamic>
          ? LatestAllergy.fromJson(json['latestAllergy'] as Map<String, dynamic>)
          : null,
      latestAppointment: json['latestAppointment'] != null && json['latestAppointment'] is Map<String, dynamic>
          ? LatestAppointment.fromJson(json['latestAppointment'] as Map<String, dynamic>)
          : null,
      reports: json['reports'] != null && json['reports'] is List
          ? List<String>.from(json['reports'].map((r) => r.toString()))
          : [],
    );
  }
}


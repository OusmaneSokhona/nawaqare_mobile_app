class NoteModel {
  final String id;
  final String patientId;
  final DoctorInfo doctorId;
  final String diagnosis;
  final String note;
  final String icdCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  NoteModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.diagnosis,
    required this.note,
    required this.icdCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['_id']?.toString() ?? '',
      patientId: json['patientId']?.toString() ?? '',
      doctorId: DoctorInfo.fromJson(json['doctorId']),
      diagnosis: json['diagnosis']?.toString() ?? '',
      note: json['note']?.toString() ?? '',
      icdCode: json['icdCode']?.toString() ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'patientId': patientId,
      'doctorId': doctorId.toJson(),
      'diagnosis': diagnosis,
      'note': note,
      'icdCode': icdCode,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class DoctorInfo {
  final String id;
  final String fullName;
  final String profileImage;

  DoctorInfo({
    required this.id,
    required this.fullName,
    required this.profileImage,
  });

  factory DoctorInfo.fromJson(Map<String, dynamic> json) {
    return DoctorInfo(
      id: json['_id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      profileImage: json['profileImage']?.toString() ?? '',
    );
  }

  factory DoctorInfo.fromString(String id) {
    return DoctorInfo(
      id: id,
      fullName: '',
      profileImage: '',
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
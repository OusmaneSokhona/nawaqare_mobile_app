import 'dart:convert';

class UserModel {
  final String? id;
  final String? userId;
  final String email;
  final UserRole role;
  final String? fullName;
  final String? phoneNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isVerified;
  final bool isActive;
  final PatientData? patientData;
  final DoctorData? doctorData;
  final PharmacyData? pharmacyData;

  UserModel({
    this.id,
    this.userId,
    required this.email,
    required this.role,
    this.fullName,
    this.phoneNumber,
    this.createdAt,
    this.updatedAt,
    this.isVerified = false,
    this.isActive = true,
    this.patientData,
    this.doctorData,
    this.pharmacyData,
  });

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) {
    try {
      print('UserModel.fromJson - json keys: ${json.keys}');

      // Check if the response has a 'data' field (your API structure)
      if (json.containsKey('data') && json['data'] is Map<String, dynamic>) {
        final data = json['data'] as Map<String, dynamic>;
        print('Processing data object with keys: ${data.keys}');

        // Extract userId from the data object
        String? extractedUserId;
        if (data.containsKey('userId')) {
          if (data['userId'] is Map<String, dynamic>) {
            extractedUserId = data['userId']['_id']?.toString();
          } else {
            extractedUserId = data['userId']?.toString();
          }
        }

        // Parse role from the main response or data
        UserRole userRole = _parseRole(json['role'] ?? data['role']);

        return UserModel(
          id: data['_id']?.toString(),
          userId: extractedUserId,
          email: data['email']?.toString() ?? '',
          role: userRole,
          fullName: data['fullName']?.toString(),
          phoneNumber: data['phoneNumber']?.toString(),
          createdAt: data['createdAt'] != null
              ? DateTime.tryParse(data['createdAt'].toString())
              : null,
          updatedAt: data['updatedAt'] != null
              ? DateTime.tryParse(data['updatedAt'].toString())
              : null,
          isVerified: data['isVerified'] ?? false,
          isActive: data['isActive'] ?? true,
          patientData: userRole == UserRole.patient
              ? PatientData.fromJson(data)
              : null,
          doctorData: userRole == UserRole.doctor
              ? DoctorData.fromJson(data)
              : null,
          pharmacyData: userRole == UserRole.pharmacy
              ? PharmacyData.fromJson(data)
              : null,
        );
      }

      // Fallback to original parsing if 'data' field doesn't exist
      String? extractedUserId;
      if (json['userId'] != null) {
        if (json['userId'] is Map<String, dynamic>) {
          extractedUserId = json['userId']['_id']?.toString();
        } else {
          extractedUserId = json['userId']?.toString();
        }
      }

      return UserModel(
        id: json['_id'] ?? json['id'],
        userId: extractedUserId,
        email: json['email']?.toString() ?? '',
        role: _parseRole(json['role']),
        fullName: json['fullName']?.toString(),
        phoneNumber: json['phoneNumber']?.toString(),
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'].toString())
            : null,
        isVerified: json['isVerified'] ?? false,
        isActive: json['isActive'] ?? true,
        patientData: json['patientData'] != null
            ? PatientData.fromJson(
            json['patientData'] is Map
                ? json['patientData']
                : Map<String, dynamic>.from(json['patientData']))
            : null,
        doctorData: json['doctorData'] != null
            ? DoctorData.fromJson(
            json['doctorData'] is Map
                ? json['doctorData']
                : Map<String, dynamic>.from(json['doctorData']))
            : null,
        pharmacyData: json['pharmacyData'] != null
            ? PharmacyData.fromJson(
            json['pharmacyData'] is Map
                ? json['pharmacyData']
                : Map<String, dynamic>.from(json['pharmacyData']))
            : null,
      );
    } catch (e, stackTrace) {
      print('Error in UserModel.fromJson: $e');
      print('Stack trace: $stackTrace');
      print('Problematic JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      if (userId != null) 'userId': userId,
      'email': email,
      'role': role.value,
      if (fullName != null) 'fullName': fullName,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      'isVerified': isVerified,
      'isActive': isActive,
      if (patientData != null) 'data': patientData!.toJson(),
      if (doctorData != null) 'doctorData': doctorData!.toJson(),
      if (pharmacyData != null) 'pharmacyData': pharmacyData!.toJson(),
    };
  }

  static UserRole _parseRole(dynamic role) {
    if (role is String) {
      switch (role.toLowerCase()) {
        case 'patient':
          return UserRole.patient;
        case 'doctor':
          return UserRole.doctor;
        case 'pharmacy':
          return UserRole.pharmacy;
        case 'admin':
          return UserRole.admin;
        default:
          return UserRole.patient;
      }
    }
    return UserRole.patient;
  }

  UserModel copyWith({
    String? id,
    String? userId,
    String? email,
    UserRole? role,
    String? fullName,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isVerified,
    bool? isActive,
    PatientData? patientData,
    DoctorData? doctorData,
    PharmacyData? pharmacyData,
  }) {
    return UserModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      role: role ?? this.role,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      patientData: patientData ?? this.patientData,
      doctorData: doctorData ?? this.doctorData,
      pharmacyData: pharmacyData ?? this.pharmacyData,
    );
  }
}

enum UserRole {
  patient,
  doctor,
  pharmacy,
  admin,
}

class PatientData {
  final String? id;
  final UserIdData? userId;
  final String? fullName;
  final String? phoneNumber;
  final String? email;
  final List<Allergy> allergies;
  final List<Appointment> appointments;
  final List<String> reports;
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
  final String? profileImage;
  final String? religion;
  final String? weight;
  final BloodGroup? bloodGroup;

  PatientData({
    this.id,
    this.userId,
    this.fullName,
    this.phoneNumber,
    this.email,
    List<Allergy>? allergies,
    List<Appointment>? appointments,
    List<String>? reports,
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
    this.profileImage,
    this.religion,
    this.weight,
    this.bloodGroup,
  }) : allergies = allergies ?? [],
        appointments = appointments ?? [],
        reports = reports ?? [];

  factory PatientData.fromJson(Map<String, dynamic> json) {
    try {
      print('PatientData.fromJson - json keys: ${json.keys}');

      return PatientData(
        id: json['_id']?.toString(),
        userId: json['userId'] != null
            ? (json['userId'] is Map<String, dynamic>
            ? UserIdData.fromJson(json['userId'])
            : null)
            : null,
        fullName: json['fullName']?.toString(),
        phoneNumber: json['phoneNumber']?.toString(),
        email: json['email']?.toString(),
        allergies: json['allergies'] != null && json['allergies'] is List
            ? List<Allergy>.from(json['allergies'].map((x) => Allergy.fromJson(x)))
            : [],
        appointments: json['appointments'] != null && json['appointments'] is List
            ? List<Appointment>.from(json['appointments'].map((x) => Appointment.fromJson(x)))
            : [],
        reports: json['reports'] != null && json['reports'] is List
            ? List<String>.from(json['reports'].map((x) => x.toString()))
            : [],
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'].toString())
            : null,
        v: json['__v'] != null
            ? (json['__v'] is int ? json['__v'] : int.tryParse(json['__v'].toString()))
            : null,
        address: json['address']?.toString(),
        bloodPressure: json['bloodPressure']?.toString(),
        bmi: json['bmi'] != null
            ? (json['bmi'] is num ? json['bmi'].toDouble() : double.tryParse(json['bmi'].toString()))
            : null,
        country: json['country']?.toString(),
        dob: json['dob'] != null ? DateTime.tryParse(json['dob'].toString()) : null,
        gender: json['gender']?.toString(),
        heartRate: json['heartRate']?.toString(),
        height: json['height']?.toString(),
        profileImage: json['profileImage']?.toString(),
        religion: json['religion']?.toString(),
        weight: json['weight']?.toString(),
        bloodGroup: json['bloodGroup'] != null ? BloodGroup.fromJson(json['bloodGroup']) : null,
      );
    } catch (e, stackTrace) {
      print('Error in PatientData.fromJson: $e');
      print('Stack trace: $stackTrace');
      print('Problematic JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      if (userId != null) 'userId': userId!.toJson(),
      if (fullName != null) 'fullName': fullName,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (email != null) 'email': email,
      'allergies': allergies.map((x) => x.toJson()).toList(),
      'appointments': appointments.map((x) => x.toJson()).toList(),
      'reports': reports,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (v != null) '__v': v,
      if (address != null) 'address': address,
      if (bloodPressure != null) 'bloodPressure': bloodPressure,
      if (bmi != null) 'bmi': bmi,
      if (country != null) 'country': country,
      if (dob != null) 'dob': dob!.toIso8601String(),
      if (gender != null) 'gender': gender,
      if (heartRate != null) 'heartRate': heartRate,
      if (height != null) 'height': height,
      if (profileImage != null) 'profileImage': profileImage,
      if (religion != null) 'religion': religion,
      if (weight != null) 'weight': weight,
      if (bloodGroup != null) 'bloodGroup': bloodGroup!.toJson(),
    };
  }

  PatientData copyWith({
    String? id,
    UserIdData? userId,
    String? fullName,
    String? phoneNumber,
    String? email,
    List<Allergy>? allergies,
    List<Appointment>? appointments,
    List<String>? reports,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    String? address,
    String? bloodPressure,
    double? bmi,
    String? country,
    DateTime? dob,
    String? gender,
    String? heartRate,
    String? height,
    String? profileImage,
    String? religion,
    String? weight,
    BloodGroup? bloodGroup,
  }) {
    return PatientData(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      allergies: allergies ?? this.allergies,
      appointments: appointments ?? this.appointments,
      reports: reports ?? this.reports,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
      address: address ?? this.address,
      bloodPressure: bloodPressure ?? this.bloodPressure,
      bmi: bmi ?? this.bmi,
      country: country ?? this.country,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      heartRate: heartRate ?? this.heartRate,
      height: height ?? this.height,
      profileImage: profileImage ?? this.profileImage,
      religion: religion ?? this.religion,
      weight: weight ?? this.weight,
      bloodGroup: bloodGroup ?? this.bloodGroup,
    );
  }
}

class UserIdData {
  final String? id;
  final String? email;
  final String? phoneNumber;
  final String? role;
  final dynamic otp;
  final dynamic otpExpiresAt;
  final bool? otpVerified;
  final bool? emailVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? currentToken;
  final bool? isActive;

  UserIdData({
    this.id,
    this.email,
    this.phoneNumber,
    this.role,
    this.otp,
    this.otpExpiresAt,
    this.otpVerified,
    this.emailVerified,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.currentToken,
    this.isActive,
  });

  factory UserIdData.fromJson(Map<String, dynamic> json) {
    try {
      return UserIdData(
        id: json['_id']?.toString(),
        email: json['email']?.toString(),
        phoneNumber: json['phoneNumber']?.toString(),
        role: json['role']?.toString(),
        otp: json['otp'],
        otpExpiresAt: json['otpExpiresAt'],
        otpVerified: json['otpVerified'],
        emailVerified: json['emailVerified'],
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'].toString())
            : null,
        v: json['__v'] != null
            ? (json['__v'] is int ? json['__v'] : int.tryParse(json['__v'].toString()))
            : null,
        currentToken: json['currentToken']?.toString(),
        isActive: json['isActive'],
      );
    } catch (e) {
      print('Error in UserIdData.fromJson: $e');
      print('Problematic JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      if (email != null) 'email': email,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (role != null) 'role': role,
      if (otp != null) 'otp': otp,
      if (otpExpiresAt != null) 'otpExpiresAt': otpExpiresAt,
      if (otpVerified != null) 'otpVerified': otpVerified,
      if (emailVerified != null) 'emailVerified': emailVerified,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (v != null) '__v': v,
      if (currentToken != null) 'currentToken': currentToken,
      if (isActive != null) 'isActive': isActive,
    };
  }
}

class Allergy {
  final String? id;
  final String? allergyType;
  final String? allergenName;
  final String? reaction;
  final String? createdBy;
  final String? severity;
  final DateTime? dateIdentified;
  final String? photo;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Allergy({
    this.id,
    this.allergyType,
    this.allergenName,
    this.reaction,
    this.createdBy,
    this.severity,
    this.dateIdentified,
    this.photo,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Allergy.fromJson(Map<String, dynamic> json) {
    try {
      return Allergy(
        id: json['_id']?.toString(),
        allergyType: json['allergyType']?.toString(),
        allergenName: json['allergenName']?.toString(),
        reaction: json['reaction']?.toString(),
        createdBy: json['createdBy']?.toString(),
        severity: json['severity']?.toString(),
        dateIdentified: json['dateIdentified'] != null
            ? DateTime.tryParse(json['dateIdentified'].toString())
            : null,
        photo: json['photo']?.toString(),
        notes: json['notes']?.toString(),
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'].toString())
            : null,
        v: json['__v'] != null
            ? (json['__v'] is int ? json['__v'] : int.tryParse(json['__v'].toString()))
            : null,
      );
    } catch (e) {
      print('Error in Allergy.fromJson: $e');
      print('Problematic JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      if (allergyType != null) 'allergyType': allergyType,
      if (allergenName != null) 'allergenName': allergenName,
      if (reaction != null) 'reaction': reaction,
      if (createdBy != null) 'createdBy': createdBy,
      if (severity != null) 'severity': severity,
      if (dateIdentified != null) 'dateIdentified': dateIdentified!.toIso8601String(),
      if (photo != null) 'photo': photo,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (v != null) '__v': v,
    };
  }
}

class Appointment {
  final String? id;
  final String? patientId;
  final DoctorId? doctorId;
  final Timeslot? timeslot;
  final int? fee;
  final String? currency;
  final DateTime? date;
  final String? consultationType;
  final String? status;
  final String? visitAddress;
  final String? homevisitstatus;
  final IsReschedule? isReschedule;
  final List<String>? followUps;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final SOAP? soap;
  final String? prescriptionId;
  final List<String>? reviews;
  final String? notes;

  Appointment({
    this.id,
    this.patientId,
    this.doctorId,
    this.timeslot,
    this.fee,
    this.currency,
    this.date,
    this.consultationType,
    this.status,
    this.visitAddress,
    this.homevisitstatus,
    this.isReschedule,
    this.followUps,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.soap,
    this.prescriptionId,
    this.reviews,
    this.notes,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    try {
      return Appointment(
        id: json['_id']?.toString(),
        patientId: json['patientId']?.toString(),
        doctorId: json['doctorId'] != null && json['doctorId'] is Map<String, dynamic>
            ? DoctorId.fromJson(json['doctorId'])
            : null,
        timeslot: json['timeslot'] != null && json['timeslot'] is Map<String, dynamic>
            ? Timeslot.fromJson(json['timeslot'])
            : null,
        fee: json['fee'] != null
            ? (json['fee'] is int ? json['fee'] : int.tryParse(json['fee'].toString()))
            : null,
        currency: json['currency']?.toString(),
        date: json['date'] != null ? DateTime.tryParse(json['date'].toString()) : null,
        consultationType: json['consultationType']?.toString(),
        status: json['status']?.toString(),
        visitAddress: json['visitAddress']?.toString(),
        homevisitstatus: json['homevisitstatus']?.toString(),
        isReschedule: json['isReschedule'] != null && json['isReschedule'] is Map<String, dynamic>
            ? IsReschedule.fromJson(json['isReschedule'])
            : null,
        followUps: json['followUps'] != null && json['followUps'] is List
            ? List<String>.from(json['followUps'].map((x) => x.toString()))
            : [],
        createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
        updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) : null,
        v: json['__v'] != null
            ? (json['__v'] is int ? json['__v'] : int.tryParse(json['__v'].toString()))
            : null,
        soap: json['SOAP'] != null && json['SOAP'] is Map<String, dynamic>
            ? SOAP.fromJson(json['SOAP'])
            : null,
        prescriptionId: json['prescriptionId']?.toString(),
        reviews: json['reviews'] != null && json['reviews'] is List
            ? List<String>.from(json['reviews'].map((x) => x.toString()))
            : [],
        notes: json['notes']?.toString(),
      );
    } catch (e) {
      print('Error in Appointment.fromJson: $e');
      print('Problematic JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      if (patientId != null) 'patientId': patientId,
      if (doctorId != null) 'doctorId': doctorId!.toJson(),
      if (timeslot != null) 'timeslot': timeslot!.toJson(),
      if (fee != null) 'fee': fee,
      if (currency != null) 'currency': currency,
      if (date != null) 'date': date!.toIso8601String(),
      if (consultationType != null) 'consultationType': consultationType,
      if (status != null) 'status': status,
      if (visitAddress != null) 'visitAddress': visitAddress,
      if (homevisitstatus != null) 'homevisitstatus': homevisitstatus,
      if (isReschedule != null) 'isReschedule': isReschedule!.toJson(),
      if (followUps != null) 'followUps': followUps,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (v != null) '__v': v,
      if (soap != null) 'SOAP': soap!.toJson(),
      if (prescriptionId != null) 'prescriptionId': prescriptionId,
      if (reviews != null) 'reviews': reviews,
      if (notes != null) 'notes': notes,
    };
  }
}

class DoctorId {
  final String? id;
  final String? email;

  DoctorId({
    this.id,
    this.email,
  });

  factory DoctorId.fromJson(Map<String, dynamic> json) {
    return DoctorId(
      id: json['_id']?.toString(),
      email: json['email']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      if (email != null) 'email': email,
    };
  }
}

class Timeslot {
  final String? id;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Timeslot({
    this.id,
    this.startTime,
    this.endTime,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Timeslot.fromJson(Map<String, dynamic> json) {
    return Timeslot(
      id: json['_id']?.toString(),
      startTime: json['startTime'] != null ? DateTime.tryParse(json['startTime'].toString()) : null,
      endTime: json['endTime'] != null ? DateTime.tryParse(json['endTime'].toString()) : null,
      status: json['status']?.toString(),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) : null,
      v: json['__v'] != null
          ? (json['__v'] is int ? json['__v'] : int.tryParse(json['__v'].toString()))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      if (startTime != null) 'startTime': startTime!.toIso8601String(),
      if (endTime != null) 'endTime': endTime!.toIso8601String(),
      if (status != null) 'status': status,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (v != null) '__v': v,
    };
  }
}

class IsReschedule {
  final String? isAccept;
  final String? reason;
  final String? role;

  IsReschedule({
    this.isAccept,
    this.reason,
    this.role,
  });

  factory IsReschedule.fromJson(Map<String, dynamic> json) {
    return IsReschedule(
      isAccept: json['isAccept']?.toString(),
      reason: json['reason']?.toString(),
      role: json['role']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (isAccept != null) 'isAccept': isAccept,
      if (reason != null) 'reason': reason,
      if (role != null) 'role': role,
    };
  }
}

class SOAP {
  final String? assessment;
  final String? diagnosis;
  final String? objective;
  final String? plan;
  final String? subjective;

  SOAP({
    this.assessment,
    this.diagnosis,
    this.objective,
    this.plan,
    this.subjective,
  });

  factory SOAP.fromJson(Map<String, dynamic> json) {
    return SOAP(
      assessment: json['assessment']?.toString(),
      diagnosis: json['diagnosis']?.toString(),
      objective: json['objective']?.toString(),
      plan: json['plan']?.toString(),
      subjective: json['subjective']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (assessment != null) 'assessment': assessment,
      if (diagnosis != null) 'diagnosis': diagnosis,
      if (objective != null) 'objective': objective,
      if (plan != null) 'plan': plan,
      if (subjective != null) 'subjective': subjective,
    };
  }
}

class BloodGroup {
  final DateTime? lastConfirmed;
  final String? type;
  final String? report;

  BloodGroup({
    this.lastConfirmed,
    this.type,
    this.report,
  });

  factory BloodGroup.fromJson(Map<String, dynamic> json) {
    return BloodGroup(
      lastConfirmed: json['lastConfirmed'] != null
          ? DateTime.tryParse(json['lastConfirmed'].toString())
          : null,
      type: json['type']?.toString(),
      report: json['report']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (lastConfirmed != null) 'lastConfirmed': lastConfirmed!.toIso8601String(),
      if (type != null) 'type': type,
      if (report != null) 'report': report,
    };
  }
}

class DoctorData {
  final String? userId;
  final String? email;
  final String? fullName;
  final String? phoneNumber;
  final DateTime? dob;
  final String? gender;
  final String? nationality;
  final String? idNumber;
  final String? clinicAddress;
  final String? aboutMe;
  final String? medicalSpecialty;
  final int? experience;
  final ConsultationFee? fee;
  final String? currency;
  final DateTime? dateOfRegistration;
  final String? placeOfPractice;
  final int? year;
  final List<String>? availableSlots;
  final String? country;
  final String? nationalIdentityDocument;
  final String? passportOrIdFront;
  final String? medicalLicence;
  final String? certification;
  final String? liabilityInsuranceProof;
  final String? cnpd;
  final String? bankVerificationLetter;
  final String? paymentAuthorization;
  final String? profileImage;
  final String? ratings;

  DoctorData({
    this.userId,
    this.email,
    this.fullName,
    this.phoneNumber,
    this.dob,
    this.gender,
    this.nationality,
    this.idNumber,
    this.clinicAddress,
    this.aboutMe,
    this.medicalSpecialty,
    this.experience,
    this.fee,
    this.currency,
    this.dateOfRegistration,
    this.placeOfPractice,
    this.year,
    this.availableSlots,
    this.country,
    this.nationalIdentityDocument,
    this.passportOrIdFront,
    this.medicalLicence,
    this.certification,
    this.liabilityInsuranceProof,
    this.cnpd,
    this.bankVerificationLetter,
    this.paymentAuthorization,
    this.profileImage,
    this.ratings,
  });

  factory DoctorData.fromJson(Map<String, dynamic> json) {
    return DoctorData(
      userId: json['userId'],
      email: json['email'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      dob: json['dob'] != null ? DateTime.tryParse(json['dob'].toString()) : null,
      gender: json['gender'],
      nationality: json['nationality'],
      idNumber: json['idNumber'],
      clinicAddress: json['clinicAddress'],
      aboutMe: json['aboutMe'],
      medicalSpecialty: json['medicalSpecialty'],
      experience: json['experience'],
      fee: json['fee'] != null ? ConsultationFee.fromJson(json['fee']) : null,
      currency: json['currency'],
      dateOfRegistration: json['dateOfRegistration'] != null
          ? DateTime.tryParse(json['dateOfRegistration'].toString())
          : null,
      placeOfPractice: json['placeOfPractice'],
      year: json['year'],
      availableSlots: json['availableSlots'] != null
          ? List<String>.from(json['availableSlots'].map((x) => x.toString()))
          : [],
      country: json['country'],
      nationalIdentityDocument: json['nationalIdentityDocument'],
      passportOrIdFront: json['passportOrIdFront'],
      medicalLicence: json['medicalLicence'],
      certification: json['certification'],
      liabilityInsuranceProof: json['liabilityInsuranceProof'],
      cnpd: json['cnpd'],
      bankVerificationLetter: json['bankVerificationLetter'],
      paymentAuthorization: json['paymentAuthorization'],
      profileImage: json['profileImage'],
      ratings: json['ratings'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'userId': userId,
      if (email != null) 'email': email,
      if (fullName != null) 'fullName': fullName,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (dob != null) 'dob': dob!.toIso8601String(),
      if (gender != null) 'gender': gender,
      if (nationality != null) 'nationality': nationality,
      if (idNumber != null) 'idNumber': idNumber,
      if (clinicAddress != null) 'clinicAddress': clinicAddress,
      if (aboutMe != null) 'aboutMe': aboutMe,
      if (medicalSpecialty != null) 'medicalSpecialty': medicalSpecialty,
      if (experience != null) 'experience': experience,
      if (fee != null) 'fee': fee!.toJson(),
      if (currency != null) 'currency': currency,
      if (dateOfRegistration != null) 'dateOfRegistration': dateOfRegistration!.toIso8601String(),
      if (placeOfPractice != null) 'placeOfPractice': placeOfPractice,
      if (year != null) 'year': year,
      if (availableSlots != null) 'availableSlots': availableSlots,
      if (country != null) 'country': country,
      if (nationalIdentityDocument != null) 'nationalIdentityDocument': nationalIdentityDocument,
      if (passportOrIdFront != null) 'passportOrIdFront': passportOrIdFront,
      if (medicalLicence != null) 'medicalLicence': medicalLicence,
      if (certification != null) 'certification': certification,
      if (liabilityInsuranceProof != null) 'liabilityInsuranceProof': liabilityInsuranceProof,
      if (cnpd != null) 'cnpd': cnpd,
      if (bankVerificationLetter != null) 'bankVerificationLetter': bankVerificationLetter,
      if (paymentAuthorization != null) 'paymentAuthorization': paymentAuthorization,
      if (profileImage != null) 'profileImage': profileImage,
      if (ratings != null) 'ratings': ratings,
    };
  }

  DoctorData copyWith({
    String? userId,
    String? email,
    String? fullName,
    String? phoneNumber,
    DateTime? dob,
    String? gender,
    String? nationality,
    String? idNumber,
    String? clinicAddress,
    String? aboutMe,
    String? medicalSpecialty,
    int? experience,
    ConsultationFee? fee,
    String? currency,
    DateTime? dateOfRegistration,
    String? placeOfPractice,
    int? year,
    List<String>? availableSlots,
    String? country,
    String? nationalIdentityDocument,
    String? passportOrIdFront,
    String? medicalLicence,
    String? certification,
    String? liabilityInsuranceProof,
    String? cnpd,
    String? bankVerificationLetter,
    String? paymentAuthorization,
    String? profileImage,
    String? ratings,
  }) {
    return DoctorData(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      nationality: nationality ?? this.nationality,
      idNumber: idNumber ?? this.idNumber,
      clinicAddress: clinicAddress ?? this.clinicAddress,
      aboutMe: aboutMe ?? this.aboutMe,
      medicalSpecialty: medicalSpecialty ?? this.medicalSpecialty,
      experience: experience ?? this.experience,
      fee: fee ?? this.fee,
      currency: currency ?? this.currency,
      dateOfRegistration: dateOfRegistration ?? this.dateOfRegistration,
      placeOfPractice: placeOfPractice ?? this.placeOfPractice,
      year: year ?? this.year,
      availableSlots: availableSlots ?? this.availableSlots,
      country: country ?? this.country,
      nationalIdentityDocument: nationalIdentityDocument ?? this.nationalIdentityDocument,
      passportOrIdFront: passportOrIdFront ?? this.passportOrIdFront,
      medicalLicence: medicalLicence ?? this.medicalLicence,
      certification: certification ?? this.certification,
      liabilityInsuranceProof: liabilityInsuranceProof ?? this.liabilityInsuranceProof,
      cnpd: cnpd ?? this.cnpd,
      bankVerificationLetter: bankVerificationLetter ?? this.bankVerificationLetter,
      paymentAuthorization: paymentAuthorization ?? this.paymentAuthorization,
      profileImage: profileImage ?? this.profileImage,
      ratings: ratings ?? this.ratings,
    );
  }
}

class ConsultationFee {
  final double? remoteconsultation;
  final double? inpersonconsultation;
  final double? homevisitconsultation;

  ConsultationFee({
    this.remoteconsultation,
    this.inpersonconsultation,
    this.homevisitconsultation,
  });

  factory ConsultationFee.fromJson(Map<String, dynamic> json) {
    return ConsultationFee(
      remoteconsultation: json['remoteconsultation'] != null
          ? (json['remoteconsultation'] is num ? json['remoteconsultation'].toDouble() : double.tryParse(json['remoteconsultation'].toString()))
          : null,
      inpersonconsultation: json['inpersonconsultation'] != null
          ? (json['inpersonconsultation'] is num ? json['inpersonconsultation'].toDouble() : double.tryParse(json['inpersonconsultation'].toString()))
          : null,
      homevisitconsultation: json['homevisitconsultation'] != null
          ? (json['homevisitconsultation'] is num ? json['homevisitconsultation'].toDouble() : double.tryParse(json['homevisitconsultation'].toString()))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (remoteconsultation != null) 'remoteconsultation': remoteconsultation,
      if (inpersonconsultation != null) 'inpersonconsultation': inpersonconsultation,
      if (homevisitconsultation != null) 'homevisitconsultation': homevisitconsultation,
    };
  }

  ConsultationFee copyWith({
    double? remoteconsultation,
    double? inpersonconsultation,
    double? homevisitconsultation,
  }) {
    return ConsultationFee(
      remoteconsultation: remoteconsultation ?? this.remoteconsultation,
      inpersonconsultation: inpersonconsultation ?? this.inpersonconsultation,
      homevisitconsultation: homevisitconsultation ?? this.homevisitconsultation,
    );
  }
}

class PharmacyData {
  final String? userId;
  final String? email;
  final String? fullName;
  final String? registrationID;
  final String? phoneNumber;
  final String? address;
  final String? city;
  final String? area;
  final String? operatingHours;
  final String? licenseNumber;
  final String? issuingAuthority;
  final DateTime? issueDate;
  final DateTime? expiryDate;
  final String? businessRegistrationNo;
  final String? registerName;
  final String? profileImage;
  final String? taxCertificate;
  final String? nocCertificate;
  final String? paymentBankVerificationLetter;
  final String? paymentAuthorization;

  PharmacyData({
    this.userId,
    this.email,
    this.fullName,
    this.registrationID,
    this.phoneNumber,
    this.address,
    this.city,
    this.area,
    this.operatingHours,
    this.licenseNumber,
    this.issuingAuthority,
    this.issueDate,
    this.expiryDate,
    this.businessRegistrationNo,
    this.registerName,
    this.profileImage,
    this.taxCertificate,
    this.nocCertificate,
    this.paymentBankVerificationLetter,
    this.paymentAuthorization,
  });

  factory PharmacyData.fromJson(Map<String, dynamic> json) {
    return PharmacyData(
      userId: json['userId'],
      email: json['email'],
      fullName: json['fullName'],
      registrationID: json['registrationID'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      city: json['city'],
      area: json['area'],
      operatingHours: json['operatingHours'],
      licenseNumber: json['licenseNumber'],
      issuingAuthority: json['issuingAuthority'],
      issueDate: json['issueDate'] != null ? DateTime.tryParse(json['issueDate'].toString()) : null,
      expiryDate: json['expiryDate'] != null ? DateTime.tryParse(json['expiryDate'].toString()) : null,
      businessRegistrationNo: json['businessRegistrationNo'],
      registerName: json['registerName'],
      profileImage: json['profileImage'],
      taxCertificate: json['taxCertificate'],
      nocCertificate: json['nocCertificate'],
      paymentBankVerificationLetter: json['paymentBankVerificationLetter'],
      paymentAuthorization: json['paymentAuthorization'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'userId': userId,
      if (email != null) 'email': email,
      if (fullName != null) 'fullName': fullName,
      if (registrationID != null) 'registrationID': registrationID,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (area != null) 'area': area,
      if (operatingHours != null) 'operatingHours': operatingHours,
      if (licenseNumber != null) 'licenseNumber': licenseNumber,
      if (issuingAuthority != null) 'issuingAuthority': issuingAuthority,
      if (issueDate != null) 'issueDate': issueDate!.toIso8601String(),
      if (expiryDate != null) 'expiryDate': expiryDate!.toIso8601String(),
      if (businessRegistrationNo != null) 'businessRegistrationNo': businessRegistrationNo,
      if (registerName != null) 'registerName': registerName,
      if (profileImage != null) 'profileImage': profileImage,
      if (taxCertificate != null) 'taxCertificate': taxCertificate,
      if (nocCertificate != null) 'nocCertificate': nocCertificate,
      if (paymentBankVerificationLetter != null) 'paymentBankVerificationLetter': paymentBankVerificationLetter,
      if (paymentAuthorization != null) 'paymentAuthorization': paymentAuthorization,
    };
  }

  PharmacyData copyWith({
    String? userId,
    String? email,
    String? fullName,
    String? registrationID,
    String? phoneNumber,
    String? address,
    String? city,
    String? area,
    String? operatingHours,
    String? licenseNumber,
    String? issuingAuthority,
    DateTime? issueDate,
    DateTime? expiryDate,
    String? businessRegistrationNo,
    String? registerName,
    String? profileImage,
    String? taxCertificate,
    String? nocCertificate,
    String? paymentBankVerificationLetter,
    String? paymentAuthorization,
  }) {
    return PharmacyData(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      registrationID: registrationID ?? this.registrationID,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      city: city ?? this.city,
      area: area ?? this.area,
      operatingHours: operatingHours ?? this.operatingHours,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      issuingAuthority: issuingAuthority ?? this.issuingAuthority,
      issueDate: issueDate ?? this.issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
      businessRegistrationNo: businessRegistrationNo ?? this.businessRegistrationNo,
      registerName: registerName ?? this.registerName,
      profileImage: profileImage ?? this.profileImage,
      taxCertificate: taxCertificate ?? this.taxCertificate,
      nocCertificate: nocCertificate ?? this.nocCertificate,
      paymentBankVerificationLetter: paymentBankVerificationLetter ?? this.paymentBankVerificationLetter,
      paymentAuthorization: paymentAuthorization ?? this.paymentAuthorization,
    );
  }
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.patient:
        return 'Patient';
      case UserRole.doctor:
        return 'Doctor';
      case UserRole.pharmacy:
        return 'Pharmacy';
      case UserRole.admin:
        return 'Admin';
    }
  }

  String get value {
    switch (this) {
      case UserRole.patient:
        return 'patient';
      case UserRole.doctor:
        return 'doctor';
      case UserRole.pharmacy:
        return 'pharmacy';
      case UserRole.admin:
        return 'admin';
    }
  }
}
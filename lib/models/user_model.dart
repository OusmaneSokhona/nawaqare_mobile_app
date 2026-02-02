import 'dart:convert';


class UserModel {
  final String? id;
  final String? userId; // Add this field
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
    this.userId, // Add this
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
    // Extract userId from nested object if exists
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
      userId: extractedUserId ?? json['userId'], // Use extracted userId
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
              : Map<String, dynamic>.from(json['patientData'])
      )
          : null,
      doctorData: json['doctorData'] != null
          ? DoctorData.fromJson(
          json['doctorData'] is Map
              ? json['doctorData']
              : Map<String, dynamic>.from(json['doctorData'])
      )
          : null,
      pharmacyData: json['pharmacyData'] != null
          ? PharmacyData.fromJson(
          json['pharmacyData'] is Map
              ? json['pharmacyData']
              : Map<String, dynamic>.from(json['pharmacyData'])
      )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (userId != null) 'userId': userId,
      'email': email,
      'role': role.value,
      if (fullName != null) 'fullName': fullName,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      'isVerified': isVerified,
      'isActive': isActive,
      if (patientData != null) 'patientData': patientData!.toJson(),
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
  final String? userId;
  final String? email;
  final String? phoneNumber;
  final DateTime? dob;
  final String? gender;
  final String? country;
  final String? religion;
  final List<String> allergies;
  final List<Map<String, dynamic>> appointments; // Changed from List<String>
  final String? address;
  final String? height;
  final String? weight;
  final double? bmi;
  final String? bloodPressure;
  final String? heartRate;
  final List<String> reports;
  final String? profileImage;

  PatientData({
    this.userId,
    this.email,
    this.phoneNumber,
    this.dob,
    this.gender,
    this.country,
    this.religion,
    List<String>? allergies,
    List<Map<String, dynamic>>? appointments, // Changed type
    this.address,
    this.height,
    this.weight,
    this.bmi,
    this.bloodPressure,
    this.heartRate,
    List<String>? reports,
    this.profileImage,
  }) : allergies = allergies ?? [],
        appointments = appointments ?? [],
        reports = reports ?? [];

  factory PatientData.fromJson(Map<String, dynamic> json) {
    // Convert appointments to List<Map<String, dynamic>>
    List<Map<String, dynamic>> appointmentList = [];
    if (json['appointments'] is List) {
      for (var item in json['appointments']) {
        if (item is Map<String, dynamic>) {
          appointmentList.add(item);
        } else if (item is Map) {
          appointmentList.add(Map<String, dynamic>.from(item));
        }
      }
    }

    return PatientData(
      userId: json['userId']?.toString(),
      email: json['email']?.toString(),
      phoneNumber: json['phoneNumber']?.toString(),
      dob: json['dob'] != null
          ? DateTime.tryParse(json['dob'].toString())
          : null,
      gender: json['gender']?.toString(),
      country: json['country']?.toString(),
      religion: json['religion']?.toString(),
      allergies: json['allergies'] != null
          ? List<String>.from(json['allergies'].map((x) => x.toString()))
          : [],
      appointments: appointmentList, // Use converted list
      address: json['address']?.toString(),
      height: json['height']?.toString(),
      weight: json['weight']?.toString(),
      bmi: json['bmi'] != null
          ? (json['bmi'] is num ? json['bmi'].toDouble() : double.tryParse(json['bmi'].toString()))
          : null,
      bloodPressure: json['bloodPressure']?.toString(),
      heartRate: json['heartRate']?.toString(),
      reports: json['reports'] != null
          ? List<String>.from(json['reports'].map((x) => x.toString()))
          : [],
      profileImage: json['profileImage']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'userId': userId,
      if (email != null) 'email': email,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (dob != null) 'dob': dob!.toIso8601String(),
      if (gender != null) 'gender': gender,
      if (country != null) 'country': country,
      if (religion != null) 'religion': religion,
      'allergies': allergies,
      'appointments': appointments,
      if (address != null) 'address': address,
      if (height != null) 'height': height,
      if (weight != null) 'weight': weight,
      if (bmi != null) 'bmi': bmi,
      if (bloodPressure != null) 'bloodPressure': bloodPressure,
      if (heartRate != null) 'heartRate': heartRate,
      'reports': reports,
      if (profileImage != null) 'profileImage': profileImage,
    };
  }

  PatientData copyWith({
    String? userId,
    String? email,
    String? phoneNumber,
    DateTime? dob,
    String? gender,
    String? country,
    String? religion,
    List<String>? allergies,
    List<Map<String, dynamic>>? appointments,
    String? address,
    String? height,
    String? weight,
    double? bmi,
    String? bloodPressure,
    String? heartRate,
    List<String>? reports,
    String? profileImage,
  }) {
    return PatientData(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      country: country ?? this.country,
      religion: religion ?? this.religion,
      allergies: allergies ?? this.allergies,
      appointments: appointments ?? this.appointments,
      address: address ?? this.address,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      bmi: bmi ?? this.bmi,
      bloodPressure: bloodPressure ?? this.bloodPressure,
      heartRate: heartRate ?? this.heartRate,
      reports: reports ?? this.reports,
      profileImage: profileImage ?? this.profileImage,
    );
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
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
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
          ? DateTime.parse(json['dateOfRegistration'])
          : null,
      placeOfPractice: json['placeOfPractice'],
      year: json['year'],
      availableSlots: json['availableSlots'] != null
          ? List<String>.from(json['availableSlots'])
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
          ? json['remoteconsultation'].toDouble()
          : null,
      inpersonconsultation: json['inpersonconsultation'] != null
          ? json['inpersonconsultation'].toDouble()
          : null,
      homevisitconsultation: json['homevisitconsultation'] != null
          ? json['homevisitconsultation'].toDouble()
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
      issueDate: json['issueDate'] != null ? DateTime.parse(json['issueDate']) : null,
      expiryDate: json['expiryDate'] != null ? DateTime.parse(json['expiryDate']) : null,
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
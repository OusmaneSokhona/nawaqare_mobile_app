
class UserModel {
  final String? id;
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'],
      email: json['email'],
      role: _parseRole(json['role']),
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isVerified: json['isVerified'] ?? false,
      isActive: json['isActive'] ?? true,
      patientData: json['patientData'] != null ? PatientData.fromJson(json['patientData']) : null,
      doctorData: json['doctorData'] != null ? DoctorData.fromJson(json['doctorData']) : null,
      pharmacyData: json['pharmacyData'] != null ? PharmacyData.fromJson(json['pharmacyData']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'email': email,
      'role': role.toString().split('.').last,
      if (fullName != null) 'fullName': fullName,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      'isVerified': isVerified,
      'isActive': isActive,
      if (patientData != null) 'patientData': patientData!.toJson(),
      if (doctorData != null) 'doctorData': doctorData!.toJson(),
      if (pharmacyData != null) 'pharmacyData': pharmacyData!.toJson(),
    };
  }

  static UserRole _parseRole(String role) {
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

  UserModel copyWith({
    String? id,
    String? email,
    String? password,
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
  final List<String>? allergies;
  final List<String>? appointments;
  final String? address;
  final String? height;
  final String? weight;
  final double? bmi;
  final String? bloodPressure;
  final String? heartRate;
  final List<String>? reports;
  final String? profileImage;

  PatientData({
    this.userId,
    this.email,
    this.phoneNumber,
    this.dob,
    this.gender,
    this.country,
    this.religion,
    this.allergies,
    this.appointments,
    this.address,
    this.height,
    this.weight,
    this.bmi,
    this.bloodPressure,
    this.heartRate,
    this.reports,
    this.profileImage,
  });

  factory PatientData.fromJson(Map<String, dynamic> json) {
    return PatientData(
      userId: json['userId'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      gender: json['gender'],
      country: json['country'],
      religion: json['religion'],
      allergies: json['allergies'] != null ? List<String>.from(json['allergies']) : null,
      appointments: json['appointments'] != null ? List<String>.from(json['appointments']) : null,
      address: json['address'],
      height: json['height'],
      weight: json['weight'],
      bmi: json['bmi'] != null ? json['bmi'].toDouble() : null,
      bloodPressure: json['bloodPressure'],
      heartRate: json['heartRate'],
      reports: json['reports'] != null ? List<String>.from(json['reports']) : null,
      profileImage: json['profileImage'],
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
      if (allergies != null) 'allergies': allergies,
      if (appointments != null) 'appointments': appointments,
      if (address != null) 'address': address,
      if (height != null) 'height': height,
      if (weight != null) 'weight': weight,
      if (bmi != null) 'bmi': bmi,
      if (bloodPressure != null) 'bloodPressure': bloodPressure,
      if (heartRate != null) 'heartRate': heartRate,
      if (reports != null) 'reports': reports,
      if (profileImage != null) 'profileImage': profileImage,
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
      dateOfRegistration: json['dateOfRegistration'] != null
          ? DateTime.parse(json['dateOfRegistration'])
          : null,
      placeOfPractice: json['placeOfPractice'],
      year: json['year'],
      availableSlots: json['availableSlots'] != null
          ? List<String>.from(json['availableSlots'])
          : null,
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
}

class ConsultationFee {
  final double? videoConsultation;
  final double? inPersonConsultation;

  ConsultationFee({
    this.videoConsultation,
    this.inPersonConsultation,
  });

  factory ConsultationFee.fromJson(Map<String, dynamic> json) {
    return ConsultationFee(
      videoConsultation: json['videoconsultation'] != null
          ? json['videoconsultation'].toDouble()
          : null,
      inPersonConsultation: json['inpersonconsultation'] != null
          ? json['inpersonconsultation'].toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (videoConsultation != null) 'videoconsultation': videoConsultation,
      if (inPersonConsultation != null) 'inpersonconsultation': inPersonConsultation,
    };
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
}

// Helper extension for UserRole
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
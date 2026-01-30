class DoctorListResponse {
  final bool success;
  final String message;
  final int total;
  final int page;
  final int totalPages;
  final List<DoctorModel> data;

  DoctorListResponse({
    required this.success,
    required this.message,
    required this.total,
    required this.page,
    required this.totalPages,
    required this.data,
  });

  factory DoctorListResponse.fromJson(Map<String, dynamic> json) {
    return DoctorListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => DoctorModel.fromJson(item as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'total': total,
      'page': page,
      'totalPages': totalPages,
      'data': data.map((doctor) => doctor.toJson()).toList(),
    };
  }
}

class DoctorModel {
  final String? id;
  final String currency;
  final UserId? userId;
  final String email;
  final String fullName;
  final String phoneNumber;
  final List<String> availableSlots;
  final DateTime dateOfRegistration;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? v;
  final String? aboutMe;
  final String? bankVerificationLetter;
  final String? certification;
  final String? clinicAddress;
  final String? cnpd;
  final String? country;
  final DateTime? dob;
  final int? experience;
  final String? gender;
  final String? idNumber;
  final String? liabilityInsuranceProof;
  final String? medicalLicence;
  final String? nationalIdentityDocument;
  final String? nationality;
  final String? passportOrIdFront;
  final String? paymentAuthorization;
  final String? placeOfPractice;
  final String? profileImage;
  final String ratings;
  final int? year;
  final ConsultationFee? fee;
  final String? medicalSpecialty;

  DoctorModel({
    this.id,
    required this.currency,
    this.userId,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.availableSlots,
    required this.dateOfRegistration,
    required this.createdAt,
    required this.updatedAt,
    this.v,
    this.aboutMe,
    this.bankVerificationLetter,
    this.certification,
    this.clinicAddress,
    this.cnpd,
    this.country,
    this.dob,
    this.experience,
    this.gender,
    this.idNumber,
    this.liabilityInsuranceProof,
    this.medicalLicence,
    this.nationalIdentityDocument,
    this.nationality,
    this.passportOrIdFront,
    this.paymentAuthorization,
    this.placeOfPractice,
    this.profileImage,
    this.ratings = "0",
    this.year,
    this.fee,
    this.medicalSpecialty,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['_id']?.toString(),
      currency: json['currency']?.toString() ?? 'USD',
      userId: json['userId'] != null ? UserId.fromJson(json['userId'] as Map<String, dynamic>) : null,
      email: json['email']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      availableSlots: (json['availableSlots'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      dateOfRegistration: DateTime.parse(json['dateOfRegistration'].toString()),
      createdAt: DateTime.parse(json['createdAt'].toString()),
      updatedAt: DateTime.parse(json['updatedAt'].toString()),
      v: json['__v'] as int?,
      aboutMe: json['aboutMe']?.toString(),
      bankVerificationLetter: json['bankVerificationLetter']?.toString(),
      certification: json['certification']?.toString(),
      clinicAddress: json['clinicAddress']?.toString(),
      cnpd: json['cnpd']?.toString(),
      country: json['country']?.toString(),
      dob: json['dob'] != null ? DateTime.parse(json['dob'].toString()) : null,
      experience: json['experience'] as int?,
      gender: json['gender']?.toString(),
      idNumber: json['idNumber']?.toString(),
      liabilityInsuranceProof: json['liabilityInsuranceProof']?.toString(),
      medicalLicence: json['medicalLicence']?.toString(),
      nationalIdentityDocument: json['nationalIdentityDocument']?.toString(),
      nationality: json['nationality']?.toString(),
      passportOrIdFront: json['passportOrIdFront']?.toString(),
      paymentAuthorization: json['paymentAuthorization']?.toString(),
      placeOfPractice: json['placeOfPractice']?.toString(),
      profileImage: json['profileImage']?.toString(),
      ratings: json['ratings']?.toString() ?? "0",
      year: json['year'] as int?,
      fee: json['fee'] != null ? ConsultationFee.fromJson(json['fee'] as Map<String, dynamic>) : null,
      medicalSpecialty: json['medicalSpecialty']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'currency': currency,
      if (userId != null) 'userId': userId!.toJson(),
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'availableSlots': availableSlots,
      'dateOfRegistration': dateOfRegistration.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      if (v != null) '__v': v,
      if (aboutMe != null) 'aboutMe': aboutMe,
      if (bankVerificationLetter != null) 'bankVerificationLetter': bankVerificationLetter,
      if (certification != null) 'certification': certification,
      if (clinicAddress != null) 'clinicAddress': clinicAddress,
      if (cnpd != null) 'cnpd': cnpd,
      if (country != null) 'country': country,
      if (dob != null) 'dob': dob!.toIso8601String(),
      if (experience != null) 'experience': experience,
      if (gender != null) 'gender': gender,
      if (idNumber != null) 'idNumber': idNumber,
      if (liabilityInsuranceProof != null) 'liabilityInsuranceProof': liabilityInsuranceProof,
      if (medicalLicence != null) 'medicalLicence': medicalLicence,
      if (nationalIdentityDocument != null) 'nationalIdentityDocument': nationalIdentityDocument,
      if (nationality != null) 'nationality': nationality,
      if (passportOrIdFront != null) 'passportOrIdFront': passportOrIdFront,
      if (paymentAuthorization != null) 'paymentAuthorization': paymentAuthorization,
      if (placeOfPractice != null) 'placeOfPractice': placeOfPractice,
      if (profileImage != null) 'profileImage': profileImage,
      'ratings': ratings,
      if (year != null) 'year': year,
      if (fee != null) 'fee': fee!.toJson(),
      if (medicalSpecialty != null) 'medicalSpecialty': medicalSpecialty,
    };
  }

  double get ratingValue {
    try {
      return double.parse(ratings);
    } catch (e) {
      return 0.0;
    }
  }

  String get displayName => fullName.isNotEmpty ? fullName : email.split('@').first;

  String get displayImage {
    if (profileImage?.isNotEmpty == true) {
      if (profileImage!.startsWith('http') || profileImage!.startsWith('https')) {
        return profileImage!;
      }
    }
    return 'assets/demo_images/demo_doctor.jpeg';
  }}

class UserId {
  final String id;
  final String email;
  final String role;

  UserId({
    required this.id,
    required this.email,
    required this.role,
  });

  factory UserId.fromJson(Map<String, dynamic> json) {
    return UserId(
      id: json['_id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'role': role,
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

  String get displayVideoFee {
    if (videoConsultation == null) return 'N/A';
    return '\$${videoConsultation!.toStringAsFixed(2)}';
  }

  String get displayInPersonFee {
    if (inPersonConsultation == null) return 'N/A';
    return '\$${inPersonConsultation!.toStringAsFixed(2)}';
  }
}
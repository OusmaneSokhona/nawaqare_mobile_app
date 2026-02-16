class DoctorModel {
  final String? id;
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
  final dynamic medicalSpecialty; // Can be String or Object
  final int? experience;
  final ConsultationFee? fee;
  final String? currency;
  final DateTime? dateOfRegistration;
  final String? placeOfPractice;
  final int? year;
  final List<String>? allSlots;
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
  final double? averageRating;
  final int? ratingCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  DoctorModel({
    this.id,
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
    this.currency = 'USD',
    this.dateOfRegistration,
    this.placeOfPractice,
    this.year,
    this.allSlots,
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
    this.ratings = '0',
    this.averageRating,
    this.ratingCount,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['_id']?.toString(),
      userId: json['userId'] != null
          ? (json['userId'] is Map<String, dynamic>
          ? json['userId']['_id']?.toString()
          : json['userId'].toString())
          : null,
      email: json['email']?.toString(),
      fullName: json['fullName']?.toString(),
      phoneNumber: json['phoneNumber']?.toString(),
      dob: json['dob'] != null ? DateTime.tryParse(json['dob'].toString()) : null,
      gender: json['gender']?.toString(),
      nationality: json['nationality']?.toString(),
      idNumber: json['idNumber']?.toString(),
      clinicAddress: json['clinicAddress']?.toString(),
      aboutMe: json['aboutMe']?.toString(),
      medicalSpecialty: json['medicalSpecialty'],
      experience: json['experience'] != null
          ? (json['experience'] is int ? json['experience'] : int.tryParse(json['experience'].toString()))
          : null,
      fee: json['fee'] != null
          ? ConsultationFee.fromJson(json['fee'] is Map<String, dynamic> ? json['fee'] : {})
          : null,
      currency: json['currency']?.toString() ?? 'USD',
      dateOfRegistration: json['dateOfRegistration'] != null
          ? DateTime.tryParse(json['dateOfRegistration'].toString())
          : null,
      placeOfPractice: json['placeOfPractice']?.toString(),
      year: json['year'] != null
          ? (json['year'] is int ? json['year'] : int.tryParse(json['year'].toString()))
          : null,
      allSlots: json['allSlots'] != null
          ? (json['allSlots'] as List<dynamic>?)?.map((e) => e.toString()).toList()
          : null,
      availableSlots: json['availableSlots'] != null
          ? (json['availableSlots'] as List<dynamic>?)?.map((e) => e.toString()).toList()
          : null,
      country: json['country']?.toString(),
      nationalIdentityDocument: json['nationalIdentityDocument']?.toString(),
      passportOrIdFront: json['passportOrIdFront']?.toString(),
      medicalLicence: json['medicalLicence']?.toString(),
      certification: json['certification']?.toString(),
      liabilityInsuranceProof: json['liabilityInsuranceProof']?.toString(),
      cnpd: json['cnpd']?.toString(),
      bankVerificationLetter: json['bankVerificationLetter']?.toString(),
      paymentAuthorization: json['paymentAuthorization']?.toString(),
      profileImage: json['profileImage']?.toString(),
      ratings: json['ratings']?.toString() ?? '0',
      averageRating: json['averageRating'] != null
          ? (json['averageRating'] is num ? json['averageRating'].toDouble() : double.tryParse(json['averageRating'].toString()))
          : null,
      ratingCount: json['ratingCount'] != null
          ? (json['ratingCount'] is int ? json['ratingCount'] : int.tryParse(json['ratingCount'].toString()))
          : null,
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
      'currency': currency,
      if (dateOfRegistration != null) 'dateOfRegistration': dateOfRegistration!.toIso8601String(),
      if (placeOfPractice != null) 'placeOfPractice': placeOfPractice,
      if (year != null) 'year': year,
      if (allSlots != null) 'allSlots': allSlots,
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
      'ratings': ratings,
      if (averageRating != null) 'averageRating': averageRating,
      if (ratingCount != null) 'ratingCount': ratingCount,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (v != null) '__v': v,
    };
  }

  double get ratingValue {
    try {
      return double.parse(ratings ?? '0');
    } catch (e) {
      return 0.0;
    }
  }

  String get displayName => fullName?.isNotEmpty == true ? fullName! : (email ?? '').split('@').first;

  String get displayImage {
    if (profileImage?.isNotEmpty == true) {
      if (profileImage!.startsWith('http') || profileImage!.startsWith('https')) {
        return profileImage!;
      }
    }
    return 'assets/demo_images/demo_doctor.jpeg';
  }

  String get medicalSpecialtyName {
    if (medicalSpecialty == null) return '';
    if (medicalSpecialty is String) return medicalSpecialty as String;
    if (medicalSpecialty is Map) {
      final map = medicalSpecialty as Map<String, dynamic>;
      return map['name']?.toString() ?? '';
    }
    return '';
  }
}

class ConsultationFee {
  final double? remoteConsultation;
  final double? inPersonConsultation;
  final double? homeVisitConsultation;

  ConsultationFee({
    this.remoteConsultation,
    this.inPersonConsultation,
    this.homeVisitConsultation,
  });

  factory ConsultationFee.fromJson(Map<String, dynamic> json) {
    return ConsultationFee(
      remoteConsultation: json['remoteconsultation'] != null
          ? (json['remoteconsultation'] is num ? json['remoteconsultation'].toDouble() : double.tryParse(json['remoteconsultation'].toString()))
          : null,
      inPersonConsultation: json['inpersonconsultation'] != null
          ? (json['inpersonconsultation'] is num ? json['inpersonconsultation'].toDouble() : double.tryParse(json['inpersonconsultation'].toString()))
          : null,
      homeVisitConsultation: json['homevisitconsultation'] != null
          ? (json['homevisitconsultation'] is num ? json['homevisitconsultation'].toDouble() : double.tryParse(json['homevisitconsultation'].toString()))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (remoteConsultation != null) 'remoteconsultation': remoteConsultation,
      if (inPersonConsultation != null) 'inpersonconsultation': inPersonConsultation,
      if (homeVisitConsultation != null) 'homevisitconsultation': homeVisitConsultation,
    };
  }

  String get displayRemoteFee {
    if (remoteConsultation == null) return 'N/A';
    return '\$${remoteConsultation!.toStringAsFixed(2)}';
  }

  String get displayInPersonFee {
    if (inPersonConsultation == null) return 'N/A';
    return '\$${inPersonConsultation!.toStringAsFixed(2)}';
  }

  String get displayHomeVisitFee {
    if (homeVisitConsultation == null) return 'N/A';
    return '\$${homeVisitConsultation!.toStringAsFixed(2)}';
  }
}

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
      total: json['total'] != null ? (json['total'] is int ? json['total'] : int.tryParse(json['total'].toString()) ?? 0) : 0,
      page: json['page'] != null ? (json['page'] is int ? json['page'] : int.tryParse(json['page'].toString()) ?? 1) : 1,
      totalPages: json['totalPages'] != null ? (json['totalPages'] is int ? json['totalPages'] : int.tryParse(json['totalPages'].toString()) ?? 1) : 1,
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
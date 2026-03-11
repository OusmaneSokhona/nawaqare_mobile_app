// lib/models/service_model.dart

class ServiceModel {
  final String id;
  final String doctor;
  final String serviceName;
  final String duration;
  final String fee;
  final String aDTfee;
  final String status;
  final String description;
  final String mode;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceModel({
    required this.id,
    required this.doctor,
    required this.serviceName,
    required this.duration,
    required this.fee,
    required this.aDTfee,
    required this.status,
    required this.description,
    required this.mode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['_id'] ?? '',
      doctor: json['doctor'] ?? '',
      serviceName: json['serviceName'] ?? '',
      duration: json['duration'] ?? '',
      fee: json['fee'] ?? '',
      aDTfee: json['ADTfee'] ?? '',
      status: json['status'] ?? '',
      description: json['description'] ?? '',
      mode: json['mode'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'doctor': doctor,
      'serviceName': serviceName,
      'duration': duration,
      'fee': fee,
      'ADTfee': aDTfee,
      'status': status,
      'description': description,
      'mode': mode,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Helper getter to check if service is active
  bool get isActive => status.toLowerCase() == 'active';

  // Helper to format price with currency
  String get formattedFee => '\$$fee';
  String get formattedADTfee => '\$$aDTfee';
}
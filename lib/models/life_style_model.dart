// models/lifestyle_model.dart
class LifestyleModel {
  final String smoking;
  final String alcohol;
  final String physicalActivity;
  final String dietType;
  final String sleepQuality;
  final String? id;
  final String? patientId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LifestyleModel({
    required this.smoking,
    required this.alcohol,
    required this.physicalActivity,
    required this.dietType,
    required this.sleepQuality,
    this.id,
    this.patientId,
    this.createdAt,
    this.updatedAt,
  });

  factory LifestyleModel.fromJson(Map<String, dynamic> json) {
    return LifestyleModel(
      id: json['_id'] ?? json['id'],
      patientId: json['patientId'],
      smoking: json['smoking'] ?? '',
      alcohol: json['alcohol'] ?? '',
      physicalActivity: json['physicalActivity'] ?? '',
      dietType: json['dietType'] ?? '',
      sleepQuality: json['sleepQuality'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  String get capitalizedSmoking {
    if (smoking.isEmpty) return '';
    return smoking[0].toUpperCase() + smoking.substring(1);
  }

  String get capitalizedAlcohol {
    if (alcohol.isEmpty) return '';
    return alcohol[0].toUpperCase() + alcohol.substring(1);
  }

  String get capitalizedPhysicalActivity {
    if (physicalActivity.isEmpty) return '';
    return physicalActivity[0].toUpperCase() + physicalActivity.substring(1);
  }

  String get capitalizedDietType {
    if (dietType.isEmpty) return '';
    if (dietType == 'high protein') return 'High Protein';
    return dietType.split(' ').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
  }

  String get capitalizedSleepQuality {
    if (sleepQuality.isEmpty) return '';
    return sleepQuality[0].toUpperCase() + sleepQuality.substring(1);
  }
}
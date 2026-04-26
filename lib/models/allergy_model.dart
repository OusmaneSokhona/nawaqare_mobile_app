

import 'dart:convert';

AllergyResponse allergyResponseFromJson(String str) => AllergyResponse.fromJson(json.decode(str));

String allergyResponseToJson(AllergyResponse data) => json.encode(data.toJson());

class AllergyResponse {
  bool success;
  String message;
  List<Allergy> data;

  AllergyResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AllergyResponse.fromJson(Map<String, dynamic> json) => AllergyResponse(
    success: json["success"],
    message: json["message"],
    data: List<Allergy>.from(json["data"].map((x) => Allergy.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Allergy {
  String id;
  String allergyType;
  String allergenName;
  String reaction;
  String createdBy;
  String severity;
  DateTime dateIdentified;
  String? photo; // Made nullable since it's not present in first item
  String notes;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Allergy({
    required this.id,
    required this.allergyType,
    required this.allergenName,
    required this.reaction,
    required this.createdBy,
    required this.severity,
    required this.dateIdentified,
    this.photo,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Allergy.fromJson(Map<String, dynamic> json) => Allergy(
    id: json["_id"],
    allergyType: json["allergyType"],
    allergenName: json["allergenName"],
    reaction: json["reaction"],
    createdBy: json["createdBy"],
    severity: json["severity"],
    dateIdentified: DateTime.parse(json["dateIdentified"]),
    photo: json["photo"], // Will be null if not present
    notes: json["notes"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "allergyType": allergyType,
    "allergenName": allergenName,
    "reaction": reaction,
    "createdBy": createdBy,
    "severity": severity,
    "dateIdentified": dateIdentified.toIso8601String(),
    "photo": photo,
    "notes": notes,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}

// Optional: Enum for severity if you want type safety
enum Severity { mild, moderate, severe }

extension SeverityExtension on Severity {
  String get value {
    switch (this) {
      case Severity.mild:
        return 'mild';
      case Severity.moderate:
        return 'moderate';
      case Severity.severe:
        return 'severe';
    }
  }
}
class WeeklySummaryModel {
  final bool success;
  final WeeklySummaryData data;

  WeeklySummaryModel({required this.success, required this.data});

  factory WeeklySummaryModel.fromJson(Map<String, dynamic> json) {
    return WeeklySummaryModel(
      success: json['success'],
      data: WeeklySummaryData.fromJson(json['data']),
    );
  }
}

class WeeklySummaryData {
  final String doctorId;
  final String doctorName;
  final int slotsBooked;
  final int plannedAbsence;
  final String availableHours;

  WeeklySummaryData({
    required this.doctorId,
    required this.doctorName,
    required this.slotsBooked,
    required this.plannedAbsence,
    required this.availableHours,
  });

  factory WeeklySummaryData.fromJson(Map<String, dynamic> json) {
    return WeeklySummaryData(
      doctorId: json['doctorId'],
      doctorName: json['doctorName'],
      slotsBooked: json['slotsBooked'],
      plannedAbsence: json['plannedAbsence'],
      availableHours: json['availableHours'],
    );
  }
}
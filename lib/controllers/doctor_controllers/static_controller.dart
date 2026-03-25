import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


class StaticsController extends GetxController {
  final RxString selectedConsultationPeriod = 'Weekly'.obs;
  final RxString selectedPerformancePeriod = 'Weekly'.obs;

  List<FlSpot> get clinicalActivitySpots => const [
    FlSpot(0, 26.5),
    FlSpot(1, 26.8),
    FlSpot(2, 28),
    FlSpot(3, 26.5),
    FlSpot(4, 26.5),
    FlSpot(5, 27.2),
    FlSpot(6, 26.2),
  ];

  List<PieChartSectionData> get consultationSections => [
    PieChartSectionData(value: 60, color: const Color(0xFF4CAF50), radius: 20, showTitle: false),
    PieChartSectionData(value: 25, color: const Color(0xFF448AFF), radius: 20, showTitle: false),
    PieChartSectionData(value: 15, color: const Color(0xFFFFB74D), radius: 20, showTitle: false),
  ];

  List<BarChartGroupData> get evolutionBarGroups => [
    makeGroupData(0, 12, const Color(0xFFE0E0E0)),
    makeGroupData(1, 18, const Color(0xFF4CAF50)),
    makeGroupData(2, 14, const Color(0xFFE0E0E0)),
    makeGroupData(3, 8, const Color(0xFFE65100)),
  ];

  BarChartGroupData makeGroupData(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 35,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
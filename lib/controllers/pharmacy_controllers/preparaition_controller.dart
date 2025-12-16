import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_colors.dart';

class PreparationController extends GetxController {
  RxBool itemsPacked = true.obs;
  RxBool lotVerified = false.obs;
  RxBool expiryChecked = false.obs;
  RxBool qrGenerated = false.obs;
  RxBool genrateQrButton = false.obs;
  final List<Map<String, dynamic>> deliveries = [
    {
      'id': 'DLV-00932',
      'date': 'Oct 29, 2025 • 3:45 PM',
      'name': 'M. Khan',
      'status': 'In Transit',
      'statusColor': AppColors.orange,
      'update': 'Today, 5:30 PM'
    },
    {
      'id': 'DLV-00932',
      'date': 'Oct 29, 2025 • 3:45 PM',
      'name': 'M. Khan',
      'status': 'Delivered',
      'statusColor': const Color(0xFF5CB85C),
      'update': 'Today, 5:30 PM'
    },
    {
      'id': 'DLV-00932',
      'date': 'Oct 29, 2025 • 3:45 PM',
      'name': 'M. Khan',
      'status': 'Failed',
      'statusColor': const Color(0xFFD9534F),
      'update': 'Today, 5:30 PM'
    },
    {
      'id': 'DLV-00932',
      'date': 'Oct 29, 2025 • 3:45 PM',
      'name': 'M. Khan',
      'status': 'Delivered',
      'statusColor': const Color(0xFF5CB85C),
      'update': 'Today, 5:30 PM'
    },
  ];
}
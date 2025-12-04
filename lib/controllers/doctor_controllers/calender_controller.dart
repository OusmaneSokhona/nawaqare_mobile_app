import 'package:get/get.dart';

class CalenderController extends GetxController {
  final DateTime initialDate = DateTime.now();
  final selectedDate = DateTime.now().obs;
  final selectedTime = '10.00 AM'.obs;
  final selectedDuration = 'Weekly'.obs;

  void selectNewDate(DateTime date) {
    selectedDate.value = date;
  }

  void selectNewTime(String time) {
    selectedTime.value = time;
  }

  final List<String> availableTimes = [
    '09.00 AM',
    '09.30 AM',
    '10.00 AM',
    '10.30 AM',
    '11.00 AM',
    '11.30 AM',
    '02.00 PM',
    '02.30 PM',
    '03.00 PM',
    '03.30 PM',
    '04.00 PM',
    '04.30 PM',
  ];
}
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BookAppointmentController extends GetxController{
  RxString appointmentType="inPerson".obs;
  final duration = '30 mint'.obs;
  final fee = '\$156'.obs;
  final selectedDate = DateTime.now().obs;
  final selectedTime = '10.00 AM'.obs;
  final Rx<DateTime> _focusedMonth = DateTime.now().obs;

  DateTime get focusedMonth => _focusedMonth.value;

  final appointmentOptions = [
    'inPerson',
    'remote',
    "homeVisit",
  ];

  final availableTimes = [
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

  void selectAppointmentType(String? newValue) {
    if (newValue != null) {
      appointmentType.value = newValue;
    }
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  void selectTime(String time) {
    selectedTime.value = time;
  }
  String get formattedMonthYear {
    return DateFormat('MMMM yyyy').format(_focusedMonth.value);
  }

  // Method to move to the previous month
  void previousMonth() {
    _focusedMonth.value = DateTime(
      _focusedMonth.value.year,
      _focusedMonth.value.month - 1,
      _focusedMonth.value.day,
    );
    // You might also need to call update() if not using GetX's .obs
    // update();
  }

  // Method to move to the next month
  void nextMonth() {
    _focusedMonth.value = DateTime(
      _focusedMonth.value.year,
      _focusedMonth.value.month + 1,
      _focusedMonth.value.day,
    );
    // update();
  }
}
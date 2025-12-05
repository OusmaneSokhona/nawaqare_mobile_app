import 'package:get/get.dart';

class DuplicateConfigurationController extends GetxController{
  RxString selectedDuration="Next Week".obs;
  RxList<String> daysList=["Mon","Tue","Wed","Thu","Fri","Sat","Sun"].obs;
  RxList<String> selectedDays=<String>["Mon"].obs;
  final DateTime initialDate = DateTime.now();
  final selectedDate = DateTime.now().obs;
  RxBool hours=true.obs;
  RxBool services=false.obs;
  RxBool location=false.obs;
  RxBool buffers=false.obs;

  void selectNewDate(DateTime date) {
    selectedDate.value = date;
  }
}
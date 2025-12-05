import 'package:get/get.dart';

class AbsenceExceptionController extends GetxController{
  final selectedDate = DateTime.now().obs;
  RxBool allService=true.obs;
  RxBool specific=false.obs;
  RxBool notifyAffectedPatient=false.obs;
  RxString selectedReason="Vacation".obs;
  final DateTime initialDate = DateTime.now();
  void selectNewDate(DateTime date) {
    selectedDate.value = date;
  }
}
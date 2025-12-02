import 'package:get/get.dart';

class PatientController extends GetxController{
  List<String> statusOptions = [
    'All',
    'Active',
    'Expiry Soon',
    'Expired',
  ];
  RxString selectedStatus = 'All'.obs;
}
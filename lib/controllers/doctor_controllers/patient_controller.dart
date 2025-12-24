import 'package:get/get.dart';
import '../../utils/app_strings.dart';

class PatientController extends GetxController {
  RxString selectedCategory = AppStrings.overview.tr.obs;

  List<String> statusOptions = [
    AppStrings.all.tr,
    AppStrings.active.tr,
    AppStrings.expirySoon.tr,
    AppStrings.expired.tr,
  ];

  RxString selectedStatus = AppStrings.all.tr.obs;
}
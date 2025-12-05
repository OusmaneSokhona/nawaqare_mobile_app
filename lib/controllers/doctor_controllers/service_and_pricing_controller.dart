import 'package:get/get.dart';

class ServiceAndPricingController extends GetxController{
  RxString type="Availability per Service".obs;
  List<String> daysList=["Mon-Friday","Tue-Sat","Wed-Sun"];
  List<String> modeList=["In Person Consultation","Remote","Any"];
  RxString selectedDay="Mon-Friday".obs;
  RxString selectedMode="In Person Consultation".obs;
  RxString selectedTime="2 hours".obs;
  RxString selectedBufferTime="10 mint".obs;
  RxBool selectPolicy=true.obs;
}
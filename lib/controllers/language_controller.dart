import 'package:get/get.dart';

class LanguageController extends GetxController{
  RxString language="english".obs;
  void changeLanguage(String newLanguage){
    language.value=newLanguage;
  }
}
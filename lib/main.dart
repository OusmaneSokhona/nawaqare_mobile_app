import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/on_boarding_and_splash_screens/splash_screen.dart';
import 'package:patient_app/utils/app_bindings.dart';
import 'package:patient_app/utils/languages.dart';
import 'package:patient_app/utils/locat_storage.dart';
bool isWeb=false;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageUtils.init();
  if(kIsWeb){
    isWeb=true;
  }else{
    isWeb=false;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 812),
      builder: (__,_){
        return GetMaterialApp(
            initialBinding: AppBinding(),
            translations: Languages(),
            locale: LocalStorageUtils.getLanguage()=="french"?Locale('fr', 'FR'):Locale('en', 'US'), // Default language
            fallbackLocale: const Locale('en', 'US'),
            debugShowCheckedModeBanner: false,
            home: SplashScreen()
        );
      },
    );
  }
}
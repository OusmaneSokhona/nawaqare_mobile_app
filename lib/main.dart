import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/on_boarding_and_splash_screens/splash_screen.dart';
import 'package:patient_app/utils/app_bindings.dart';
import 'package:patient_app/utils/shared_prefrence.dart';

Future<void> main() async {
  LocalStorageUtils.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 812),
      child: GetMaterialApp(
        initialBinding: AppBinding(),
        debugShowCheckedModeBanner: false,
        home: SplashScreen()
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/on_boarding_splash_controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
   SplashScreen({super.key});
  SplashController splashController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.sh,
      width: 1.sw,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/images/splash_screen.png"),fit: BoxFit.fill),
      ),
    );
  }
}

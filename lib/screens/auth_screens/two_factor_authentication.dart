// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:patient_app/screens/auth_screens/verification_screen.dart';
// import 'package:patient_app/utils/app_colors.dart';
// import 'package:patient_app/utils/app_fonts.dart';
// import 'package:patient_app/utils/app_images.dart';
// import 'package:patient_app/utils/app_strings.dart';
// import 'package:patient_app/widgets/custom_button.dart';
// import 'package:patient_app/widgets/verification_via_widget.dart';
//
// import '../../controllers/auth_controllers/sign_up_controller.dart';
//
// class TwoFactorAuthentication extends StatelessWidget {
//   TwoFactorAuthentication({super.key});
//
//   final SignUpController signUpController = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: 1.sh,
//         width: 1.sw,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [AppColors.onboardingBackground, AppColors.lightWhite],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w),
//           child: Column(
//             children: [
//               80.verticalSpace,
//               Row(
//                 children: [
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       AppStrings.twoFactorAuth.tr,
//                       textAlign: TextAlign.start,
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontFamily: AppFonts.jakartaBold,
//                         fontSize: 29.sp,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               20.verticalSpace,
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   AppStrings.twoFactorSub.tr,
//                   style: TextStyle(
//                     color: AppColors.darkGrey,
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ),
//               20.verticalSpace,
//               VerificationViaWidget(
//                 title: AppStrings.verifyViaEmail.tr,
//                 subtitle: AppStrings.verifyEmailSub.tr,
//                 iconPath: AppImages.mailIcon,
//                 onTap: () {
//                   Get.to(
//                     VerificationScreen(
//                       authController: signUpController,
//                       title: AppStrings.emailCodeSent.tr,
//                       subTitle: signUpController.emailController.text,
//                     ),
//                   );
//                 },
//                 iconColor: AppColors.darkGrey,
//               ),
//               25.verticalSpace,
//               VerificationViaWidget(
//                 title: AppStrings.verifyViaWhatsapp.tr,
//                 subtitle: AppStrings.verifyWhatsappSub.tr,
//                 iconPath: AppImages.whatsAppIcon,
//                 onTap: () {
//                   Get.to(
//                     VerificationScreen(
//                       authController: signUpController,
//                       title: AppStrings.whatsappCodeSent.tr,
//                       subTitle: "+33 3 6 12 34 56 78",
//                     ),
//                   );
//                 },
//               ),
//               70.verticalSpace,
//               CustomButton(
//                 borderRadius: 15,
//                 text: AppStrings.back.tr,
//                 onTap: () {
//                   signUpController.safeBack();
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

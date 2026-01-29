import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/client/api_client.dart';
import 'package:patient_app/widgets/patient_widgets/profile_widgets/success_dialog.dart';
import '../../controllers/auth_controllers/sign_up_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_strings.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/progress_stepper.dart';

class DocumentsReports extends StatelessWidget {
  DocumentsReports({super.key});

  SignUpController signUpController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.onboardingBackground, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              80.verticalSpace,
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Image.asset(
                      "assets/images/back_icon.png",
                      height: 32.h,
                      width: 32.w,
                    ),
                  ),
                  7.horizontalSpace,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppStrings.docsAndReports.tr,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: AppFonts.jakartaBold,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),

              20.verticalSpace,
              ProgressStepper(currentStep:4, totalSteps: 4),
              15.verticalSpace,
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppStrings.uploadLabel.tr,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  3.verticalSpace,
                  InkWell(
                    onTap: (){
                      signUpController.pickFile(signUpController.selectedFileName);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.05),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Obx(
                            () => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 40,
                              color: Colors.blue.shade700,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              signUpController.selectedFileName.value == null ||signUpController.selectedFileName.value == 'No file selected' || signUpController.selectedFileName.value == 'File selection cancelled'
                                  ? AppStrings.uploadFormat.tr
                                  : signUpController.selectedFileName.value!,
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue.shade700,
                              ),
                            ),
                            if (signUpController.selectedFileName.value != 'No file selected' && signUpController.selectedFileName.value != 'File selection cancelled')
                              Text(
                                AppStrings.tapToSelectNew.tr,
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              40.verticalSpace,
              Obx(
                  ()=>signUpController.isLoading.value?CircularProgressIndicator(color: AppColors.primaryColor,):CustomButton(borderRadius: 15, text: AppStrings.submit.tr, onTap: () async {
                  if(signUpController.selectedFileName.value == null || signUpController.selectedFileName.value == 'No file selected' || signUpController.selectedFileName.value == 'File selection cancelled'){
                    Get.snackbar(
                      AppStrings.warning.tr,
                      AppStrings.pleaseUploadDocument.tr,
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  bool isSuccessRegister=await signUpController.registerUser();
                  print("isSuccessRegister: $isSuccessRegister");
                  if(isSuccessRegister){
                    Future.delayed(Duration(seconds: 1));
                    ApiClient.getToken();
                    Future.delayed(Duration(seconds: 1));
                    bool isSuccessUpdate=await signUpController.updatePatientProfile();
                    if(isSuccessUpdate){
                      Get.dialog(SuccessDialog());
                      await Future.delayed(Duration(seconds: 3),(){
                        signUpController.signInController.moveToMainScreenBasedOnRole(signUpController.type.value);
                      });
                    }
                  }

                }),
              ),
              20.verticalSpace,
              // CustomButton(borderRadius: 15, text: AppStrings.skip.tr, onTap: () {
              //   signUpController.moveToSignInScreen();
              // },bgColor: AppColors.inACtiveButtonColor,fontColor: Colors.black,),
              50.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
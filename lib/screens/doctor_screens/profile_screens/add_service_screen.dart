import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_images.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import '../../../controllers/doctor_controllers/service_controller.dart';
import '../../../widgets/patient_widgets/video_call_widgets/setting widgets.dart';

class AddServiceScreen extends StatelessWidget {
  AddServiceScreen({super.key});

  final ServiceController serviceController = Get.find<ServiceController>();
  final TextEditingController serviceNameController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController feeController = TextEditingController();
  final TextEditingController adtFeeController = TextEditingController();
  final TextEditingController mrtController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final RxString selectedMode = 'inperson'.obs;

  final List<String> modeOptions = ['inperson', 'remote'];

  Future<void> createService() async {
    if (serviceNameController.text.isEmpty ||
        durationController.text.isEmpty ||
        feeController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all required fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      Get.dialog(
        Center(child: CircularProgressIndicator(color: AppColors.primaryColor)),
        barrierDismissible: false,
      );

      final Map<String, dynamic> serviceData = {
        'serviceName': serviceNameController.text,
        'fee': feeController.text,
        'duration': durationController.text,
        'ADTfee': adtFeeController.text.isEmpty ? '0' : adtFeeController.text,
        'MRT': mrtController.text.isEmpty ? '0' : mrtController.text,
        'description': descriptionController.text.isEmpty ? 'Basic checkup' : descriptionController.text,
        'mode': selectedMode.value,
      };

      final response = await serviceController.createService(serviceData);

      Get.back();

      if (response) {
        Get.back();
        Get.snackbar(
          'Success',
          'Service added successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          serviceController.errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

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
          child: Column(children: [
            70.verticalSpace,
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Image.asset(
                    AppImages.backIcon,
                    height: 33.h,
                    fit: BoxFit.fill,
                  ),
                ),
                10.horizontalSpace,
                Text(
                  AppStrings.addServices.tr,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 23.sp,
                    fontWeight: FontWeight.w800,
                    fontFamily: AppFonts.jakartaBold,
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.verticalSpace,
                    Text(
                      AppStrings.addServicesSubtitle.tr,
                      style: TextStyle(
                        color: AppColors.lightGrey,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppFonts.jakartaRegular,
                      ),
                    ),
                    20.verticalSpace,
                    CustomTextField(
                      controller: serviceNameController,
                      labelText: AppStrings.serviceName.tr,
                      hintText: "General Consultation",
                    ),
                    10.verticalSpace,
                    CustomTextField(
                      controller: durationController,
                      labelText: AppStrings.defaultDuration.tr,
                      hintText: "30min",
                    ),
                    10.verticalSpace,
                    CustomTextField(
                      controller: feeController,
                      labelText: "${AppStrings.fee.tr} *",
                      hintText: "1000",
                    ),
                    10.verticalSpace,
                    CustomTextField(
                      controller: adtFeeController,
                      labelText: "ADT Fee",
                      hintText: "500",
                    ),
                    10.verticalSpace,
                    CustomTextField(
                      controller: mrtController,
                      labelText: "MRT",
                      hintText: "200",
                    ),
                    10.verticalSpace,
                    CustomTextField(
                      controller: descriptionController,
                      labelText: AppStrings.description.tr,
                      hintText: "Basic checkup",
                    ),
                    10.verticalSpace,
                    Obx(() => CustomDropdown(
                      label: AppStrings.mode.tr,
                      options: modeOptions,
                      currentValue: selectedMode.value,
                      onChanged: (val) {
                        if (val != null) selectedMode.value = val;
                      },
                    )),
                    30.verticalSpace,
                    Obx(() => CustomButton(
                      text: AppStrings.addAndSave.tr,
                      onTap: serviceController.isLoading.value ? (){} : createService,
                      borderRadius: 15,
                      isLoading: serviceController.isLoading.value,
                    )),
                    10.verticalSpace,
                    CustomButton(
                      text: AppStrings.pdfExportService.tr,
                      onTap: () {},
                      borderRadius: 15,
                      bgColor: AppColors.inACtiveButtonColor,
                      fontColor: Colors.black,
                    ),
                    30.verticalSpace,
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
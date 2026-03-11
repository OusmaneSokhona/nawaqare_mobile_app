import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/models/service_model.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import '../../../controllers/doctor_controllers/service_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/patient_widgets/video_call_widgets/setting widgets.dart';

class EditExistingService extends StatelessWidget {
  EditExistingService({super.key});

  final ServiceController serviceController = Get.find<ServiceController>();
  final ServiceModel? service = Get.arguments;
  final TextEditingController serviceNameController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController feeController = TextEditingController();
  final TextEditingController adtFeeController = TextEditingController();
  final TextEditingController mrtController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final RxString selectedMode = 'inperson'.obs;
  final RxString selectedStatus = 'active'.obs;

  final List<String> modeOptions = ['inperson', 'remote'];
  final List<String> statusOptions = ['active', 'inactive'];

  @override
  Widget build(BuildContext context) {
    if (service != null) {
      serviceNameController.text = service!.serviceName;
      durationController.text = service!.duration;
      feeController.text = service!.fee;
      adtFeeController.text = service!.aDTfee;
      descriptionController.text = service!.description;
      selectedMode.value = service!.mode;
      selectedStatus.value = service!.status;
    }

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
                    AppStrings.editExistingService.tr,
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
                    children: [
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
                      Obx(() => CustomDropdown(
                        label: AppStrings.mode.tr,
                        options: modeOptions,
                        currentValue: selectedMode.value,
                        onChanged: (val) {
                          if (val != null) selectedMode.value = val;
                        },
                      )),
                      10.verticalSpace,
                      Obx(() => CustomDropdown(
                        label: AppStrings.status.tr,
                        options: statusOptions,
                        currentValue: selectedStatus.value,
                        onChanged: (val) {
                          if (val != null) selectedStatus.value = val;
                        },
                      )),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.description.tr,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ),
                      3.verticalSpace,
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300, width: 1),
                        ),
                        child: TextField(
                          controller: descriptionController,
                          maxLines: 3,
                          onTapOutside: (_) {
                            FocusManager.instance.primaryFocus!.unfocus();
                          },
                          decoration: InputDecoration(
                            hintText: AppStrings.aboutMeHint.tr,
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                          ),
                        ),
                      ),
                      20.verticalSpace,
                      Obx(() => CustomButton(
                        text: AppStrings.update.tr,
                        onTap: serviceController.isLoading.value ? (){} : updateService,
                        borderRadius: 15,
                        isLoading: serviceController.isLoading.value,
                      )),
                      10.verticalSpace,
                      CustomButton(
                        text: AppStrings.cancel.tr,
                        onTap: () {
                          Get.back();
                        },
                        borderRadius: 15,
                        bgColor: AppColors.inACtiveButtonColor,
                        fontColor: Colors.black,
                      ),
                      30.verticalSpace,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateService() async {
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
        'status': selectedStatus.value,
      };

      final bool success = await serviceController.updateService(
        service!.id,
        serviceData,
      );

      Get.back();

      if (success) {
        Get.back();
        Get.snackbar(
          'Success',
          'Service updated successfully',
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
}
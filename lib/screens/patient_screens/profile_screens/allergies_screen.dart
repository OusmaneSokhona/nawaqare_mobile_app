import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/widgets/custom_button.dart';
import '../../../controllers/patient_controllers/allergies_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/patient_widgets/profile_widgets/medication_allergy_card.dart';
import 'add_allergy_screen.dart';
import '../../../utils/app_strings.dart';

class AllergiesScreen extends StatelessWidget {
  AllergiesScreen({super.key});

  final AllergyController controller = Get.put(AllergyController());

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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    AppStrings.allergies.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              20.verticalSpace,
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => controller.refreshAllergies(),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
                    }

                    if (controller.errorMessage.isNotEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Error loading allergies',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16.sp,
                              ),
                            ),
                            10.verticalSpace,
                            Text(
                              controller.errorMessage.value,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            20.verticalSpace,
                            CustomButton(
                              text: 'Retry',
                              onTap: () => controller.fetchAllergies(),
                              height: 45.h, borderRadius: 15,
                            ),
                          ],
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          if (controller.allergiesData.isEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 50.h),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.medical_services_outlined,
                                    size: 80.sp,
                                    color: Colors.grey,
                                  ),
                                  20.verticalSpace,
                                  Text(
                                    'No allergies found',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      color: Colors.grey,
                                      fontFamily: AppFonts.jakartaMedium,
                                    ),
                                  ),
                                  10.verticalSpace,
                                  Text(
                                    'Tap the button below to add your first allergy',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey,
                                      fontFamily: AppFonts.jakartaRegular,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          else
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: controller.allergiesData.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 18.sp),
                                  child: MedicationAllergyCard(
                                    data: controller.allergiesData[index],
                                  ),
                                );
                              },
                            ),
                          CustomButton(
                            borderRadius: 15,
                            text: AppStrings.addAllergy.tr,
                            onTap: () {
                              Get.to(() => AddAllergyScreen());
                            },
                          ),
                          30.verticalSpace,
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
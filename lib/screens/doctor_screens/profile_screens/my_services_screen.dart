
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/doctor_screens/profile_screens/add_service_screen.dart';
import 'package:patient_app/screens/doctor_screens/profile_screens/edit_existing_service.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import 'package:patient_app/widgets/doctor_widgets/profile_widgets/confirm_deactivation_dialog.dart';

import '../../../controllers/doctor_controllers/service_controller.dart';
import '../../../models/service_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';

class MyServicesScreen extends StatelessWidget {
  MyServicesScreen({super.key});

  final ServiceController serviceController = Get.put(ServiceController());
  final TextEditingController searchController = TextEditingController();

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
                    AppStrings.myServices.tr,
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
                child: RefreshIndicator(
                  onRefresh: () => serviceController.refreshServices(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      5.verticalSpace,
                      Text(
                        AppStrings.myServicesSubtitle.tr,
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: AppFonts.jakartaMedium,
                            fontWeight: FontWeight.w500,
                            color: AppColors.lightGrey),
                      ),
                      10.verticalSpace,
                      Obx(() => _buildStatsContainer()),
                      20.verticalSpace,
                      CustomTextField(
                        controller: searchController,
                        prefixIcon: Icons.search,
                        hintText: AppStrings.searchHint.tr,
                        onChanged: (value) {
                          serviceController.filterServices(value);
                        },
                      ),
                      20.verticalSpace,
                      Obx(() {
                        if (serviceController.isLoading.value) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.h),
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          );
                        }

                        if (serviceController.isError.value) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.h),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 60.sp,
                                    color: Colors.red,
                                  ),
                                  10.verticalSpace,
                                  Text(
                                    'Error: ${serviceController.errorMessage.value}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.red,
                                    ),
                                  ),
                                  20.verticalSpace,
                                  ElevatedButton(
                                    onPressed: () =>
                                        serviceController.refreshServices(),
                                    child: Text('Retry'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        if (serviceController.filteredServices.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.h),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 60.sp,
                                    color: AppColors.lightGrey,
                                  ),
                                  10.verticalSpace,
                                  Text(
                                    serviceController.searchQuery.isEmpty
                                        ? 'No services available'
                                        : 'No services match your search',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppColors.lightGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return SizedBox(
                          height: 0.48.sh,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: serviceController.filteredServices.length,
                            itemBuilder: (context, index) {
                              final service = serviceController.filteredServices[index];return _buildServiceCard(
                                    () {
                                  Get.to(
                                        () => EditExistingService(),
                                    arguments: service,
                                  );
                                },
                                service,
                                    () {
                                  Get.dialog(
                                    ConfirmDeactivationDialog(
                                      isActivation: !service.isActive,
                                      onConfirm: () async {
                                        final success = await serviceController.deActiveServiceStatus(
                                          service.id,
                                        );

                                        Get.back();

                                        if (success) {
                                          Get.snackbar(
                                            'Success',
                                            service.isActive
                                                ? 'Service deactivated successfully'
                                                : 'Service activated successfully',
                                            backgroundColor: Colors.green,
                                            colorText: Colors.white,
                                            snackPosition: SnackPosition.BOTTOM,
                                          );
                                        } else {
                                          Get.snackbar(
                                            'Error',
                                            'Failed to update service status',
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                            snackPosition: SnackPosition.BOTTOM,
                                          );
                                        }
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      }),
                      20.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.addNewServices.tr,
                        onTap: () {
                          Get.to(() => AddServiceScreen());
                        },
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

  Widget _buildStatsContainer() {
    return Container(
      height: 70.h,
      width: 1.sw,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
              color: AppColors.lightGrey.withOpacity(0.2))),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: AppColors.primaryColor,
              ),
              5.verticalSpace,
              Text(
                "${AppStrings.activeServices.tr} : ${serviceController.activeServicesCount.toString().padLeft(2, '0')}",
                style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: AppFonts.jakartaMedium,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ],
          ),
          80.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/minus_icon.png",
                  height: 20.h),
              5.verticalSpace,
              Text(
                "${AppStrings.total.tr}: ${serviceController.totalServicesCount}",
                style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: AppFonts.jakartaMedium,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isActive) {
    Color backgroundColor =
    isActive ? AppColors.green : AppColors.inACtiveButtonColor;
    Color textColor = isActive ? Colors.white : Colors.black;
    String text = isActive ? AppStrings.active.tr : AppStrings.inactive.tr;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 12.0,
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
          size: 18,
          color: AppColors.primaryColor,
        ),
        SizedBox(width: 6.0),
        Text(
          text,
          style: TextStyle(
            fontSize: 16.0,
            color: AppColors.lightGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(
      Function onTap, ServiceModel data, Function onDeactivate) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 24.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        data.serviceName,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D2939),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.0),
                      Row(
                        children: [
                          Icon(
                            data.mode == 'inperson'
                                ? Icons.person
                                : Icons.videocam,
                            size: 14,
                            color: AppColors.primaryColor,
                          ),
                          SizedBox(width: 4.0),
                          Text(
                            data.mode == 'inperson'
                                ? 'In-Person'
                                : 'Remote',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Color(0xFF667085),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(data.isActive),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: <Widget>[
                _buildDetailItem(
                  Icons.access_time,
                  data.duration,
                ),
                SizedBox(width: 24.0),
                _buildDetailItem(
                  Icons.attach_money,
                  data.formattedFee,
                ),
              ],
            ),
            if (data.description.isNotEmpty) ...[
              SizedBox(height: 8.0),
              Text(
                data.description,
                style: TextStyle(
                  fontSize: 14.0,
                  color: AppColors.lightGrey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            SizedBox(height: 24.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      onTap();
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      backgroundColor: AppColors.inACtiveButtonColor,
                      side: BorderSide.none,
                    ),
                    child: Text(
                      AppStrings.edit.tr,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.0),
                data.isActive?Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      onDeactivate();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      backgroundColor: AppColors.primaryColor,
                      elevation: 0,
                    ),
                    child: Text(
                      data.isActive
                          ? AppStrings.deactivate.tr
                          : AppStrings.active.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ):SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
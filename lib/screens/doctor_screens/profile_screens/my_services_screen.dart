import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/doctor_screens/profile_screens/add_service_screen.dart';
import 'package:patient_app/screens/doctor_screens/profile_screens/edit_existing_service.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/custom_text_field.dart';
import 'package:patient_app/widgets/doctor_widgets/profile_widgets/confirm_deactivation_dialog.dart';

import '../../../models/service_data_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';

class MyServicesScreen extends StatelessWidget {
  MyServicesScreen({super.key});
  final List<ServiceData> services = [
    ServiceData(
      title: 'Initial Consultation',
      type: 'Remote Consultation',
      duration: '30 min',
      price: '30\$',
      isActive: true,
    ),
    ServiceData(
      title: 'Tests',
      type: 'Both',
      duration: '20 min',
      price: '\$50',
      isActive: false,
    ),
    ServiceData(
      title: 'Follow-ups',
      type: 'In -Person',
      duration: '20 min',
      price: '\$50',
      isActive: true,
    ),
    ServiceData(
      title: 'Initial Consultation',
      type: 'Remote Consultation',
      duration: '30 min',
      price: '30\$',
      isActive: true,
    ),
  ];
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
                child: SingleChildScrollView(
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
                      Container(
                        height: 70.h,
                        width: 1.sw,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                                color: AppColors.lightGrey.withOpacity(0.2))),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 10.h),
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
                                  "${AppStrings.activeServices.tr} : 04",
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
                                  "${AppStrings.total.tr}: 6",
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
                      ),
                      20.verticalSpace,
                      CustomTextField(
                        prefixIcon: Icons.search,
                        suffixIcon: Icons.filter_list,
                        prefixIconColor: AppColors.lightGrey,
                        hintText: AppStrings.searchHint.tr,
                      ),
                      20.verticalSpace,
                      ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: services.length,
                          itemBuilder: (context, index) {
                            return _buildServiceCard(() {
                              Get.to(EditExistingService());
                            }, services[index], () {
                              Get.dialog(ConfirmDeactivationDialog());
                            });
                          }),
                      CustomButton(
                          borderRadius: 15,
                          text: AppStrings.addNewServices.tr,
                          onTap: () {
                            Get.to(AddServiceScreen());
                          }),
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
      Function onTap, ServiceData data, Function onDeactivate) {
    return InkWell(
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 24.0),
        elevation: 4,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        data.title,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D2939),
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Row(
                        children: [
                          Icon(
                            Icons.sensors_rounded,
                            size: 14,
                            color: AppColors.primaryColor,
                          ),
                          SizedBox(width: 4.0),
                          Text(
                            data.type,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Color(0xFF667085),
                            ),
                          ),
                        ],
                      ),
                    ],
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
                    Icons.cases_outlined,
                    data.price,
                  ),
                ],
              ),
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
                  Expanded(
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
                        AppStrings.deactivate.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
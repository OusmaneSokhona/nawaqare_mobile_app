import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/profile_controller.dart';
import 'package:patient_app/widgets/profile_widgets/privacy_toggle_item.dart';

import '../../models/profile_models.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_images.dart';

class PrivacySecurity extends GetView<ProfileController> {
  PrivacySecurity({super.key});

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
                    "Privacy & Security",
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Data Sharing Preferences",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 17.sp,
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Control How Your Medical Data Is Shared And Used",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                      20.verticalSpace,
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.sp,
                          vertical: 20.h,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your Data is Protected',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Control How Your Medical Data Is Shared And Used',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF6C7B8A),
                                  ),
                                ),
                              ],
                            ),

                            Obx(
                              () => PrivacyToggleItem(
                                title:
                                    'Allow Data Sharing With Other Healthcare Professionals',
                                subtitle:
                                    'Enable to share medical history for coordinated care',
                                value: controller.allowSharing.value,
                                onChanged: controller.toggleSharing,
                                activeColor: AppColors.primaryColor,
                              ),
                            ),
                            const Divider(
                              height: 1,
                              thickness: 1,
                              indent: 20,
                              endIndent: 20,
                              color: Color(0xFFE0E0E0),
                            ),

                            Obx(
                              () => PrivacyToggleItem(
                                title: 'Allow Anonymized Data For Research',
                                subtitle:
                                    'Used only for aggregated medical insights',
                                value: controller.allowResearch.value,
                                onChanged: controller.toggleResearch,
                                activeColor: AppColors.primaryColor,
                              ),
                            ),
                            const Divider(
                              thickness: 1,
                              color: Color(0xFFE0E0E0),
                            ),

                            Obx(
                              () => PrivacyToggleItem(
                                title: 'Receive Data-Related Notifications',
                                subtitle:
                                    'Get alerts when your data is accessed or shared',
                                value: controller.receiveNotifications.value,
                                onChanged: controller.toggleNotifications,
                                activeColor: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      20.verticalSpace,
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.sp,
                          vertical: 20.h,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Who Can Access My Data?',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),

                            Obx(
                              () => PrivacyToggleItem(
                                title: 'Who Can Access My Data?',
                                subtitle: 'Always has access by default',
                                value: controller.accessMyData.value,
                                onChanged: controller.toggleAccessMyData,
                                activeColor: AppColors.primaryColor,
                              ),
                            ),
                            const Divider(
                              height: 1,
                              thickness: 1,
                              indent: 20,
                              endIndent: 20,
                              color: Color(0xFFE0E0E0),
                            ),

                            Obx(
                              () => PrivacyToggleItem(
                                title: 'Specialists',
                                subtitle: 'Can view upon your authorization',
                                value: controller.specialist.value,
                                onChanged: controller.toggleSpeacialist,
                                activeColor: AppColors.primaryColor,
                              ),
                            ),
                            const Divider(
                              thickness: 1,
                              color: Color(0xFFE0E0E0),
                            ),

                            Obx(
                              () => PrivacyToggleItem(
                                title: 'Emergency Services',
                                subtitle: 'Temporary 30-day access possible',
                                value: controller.emergencyServices.value,
                                onChanged: controller.toggleEmergencyServices,
                                activeColor: AppColors.primaryColor,
                              ),
                            ),
                            const Divider(
                              thickness: 1,
                              color: Color(0xFFE0E0E0),
                            ),
                            Obx(
                              () => PrivacyToggleItem(
                                title: 'Pharmacy',
                                subtitle:
                                    'Only for prescriptions or test uploads',
                                value: controller.pharmacy.value,
                                onChanged: controller.togglePharmacy,
                                activeColor: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      20.verticalSpace,
                      Container(
                        constraints: const BoxConstraints(maxWidth: 800),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Access History',
                                style: TextStyle(
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Track Who Viewed Or Modified Your Records',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 24),
                              _buildHeaderRow(context),
                              const Divider(
                                height: 1,
                                thickness: 1,
                                color: Color(0xFFF0F0F0),
                              ),
                              ListView.separated(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.records.length,
                                separatorBuilder:
                                    (context, index) => const Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: Color(0xFFF0F0F0),
                                    ),
                                itemBuilder: (context, index) {
                                  return _buildRecordRow(
                                    context,
                                    controller.records[index],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      Container(
                        padding: EdgeInsets.all(15.sp),
                        width: 1.sw,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.sp),
                          border: Border.all(
                            color: AppColors.lightGrey.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Export My Data",style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.w600,fontFamily: AppFonts.jakartaBold),),
                            InkWell(
                              onTap: (){
                                controller.isPdf.value=!controller.isPdf.value;
                                controller.isEmail.value=false;
                              },
                              child: Row(
                                children: [
                                  Obx(() {
                                    return Container(
                                      height: 20.h,
                                      width: 20.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.transparent,
                                        border: Border.all(
                                          color:
                                          controller
                                              .isPdf
                                              .value
                                              ? AppColors.primaryColor
                                              : AppColors.lightGrey,
                                          width: 2,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(3.sp),
                                      alignment: Alignment.center,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                          controller
                                              .isPdf
                                              .value
                                              ? AppColors.primaryColor
                                              : Colors.transparent,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    );
                                  }),
                                  8.horizontalSpace,
                                  Text("PDF",style: TextStyle(fontSize: 18.sp,fontFamily: AppFonts.jakartaMedium,fontWeight: FontWeight.w600),)
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                controller.isEmail.value=!controller.isEmail.value;
                                controller.isPdf.value=false;
                              },
                              child: Row(
                                children: [
                                  Obx(() {
                                    return Container(
                                      height: 20.h,
                                      width: 20.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.transparent,
                                        border: Border.all(
                                          color:
                                          controller
                                              .isEmail
                                              .value
                                              ? AppColors.primaryColor
                                              : AppColors.lightGrey,
                                          width: 2,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(3.sp),
                                      alignment: Alignment.center,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                          controller
                                              .isEmail
                                              .value
                                              ? AppColors.primaryColor
                                              : Colors.transparent,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    );
                                  }),
                                  8.horizontalSpace,
                                  Text("Email",style: TextStyle(fontSize: 18.sp,fontFamily: AppFonts.jakartaMedium,fontWeight: FontWeight.w600),)
                                ],
                              ),
                            ),
                            buildDropdownField(title: "Select data type", items: controller.dataTypeList, selectedValue: controller.dataType, onChanged: (_){}),
                            10.verticalSpace,
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: (){},
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: AppColors.lightGrey.withOpacity(0.2),
                                      foregroundColor: Colors.black,
                                      side: BorderSide(color: Colors.grey.shade100),
                                      padding: EdgeInsets.symmetric(vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text('Cancel', style: TextStyle(fontSize: 16)),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed:(){},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade700,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text('Confirm', style: TextStyle(fontSize: 16)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      10.verticalSpace,
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Data Controller',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                             buildInfoRow(
                              'Data Controller',
                               'Nawa Care Digital Health (EU)',
                            ),
                            const Divider(height: 1.0, thickness: 1.0),
                             buildInfoRow('DPO Contact',
                               'dpo@nawecare.eu',
                            ),
                            const Divider(height: 1.0, thickness: 1.0),
                            buildInfoRow(
                              'Hosting:',
                              'HDS-certified cloud',
                            ),
                            const Divider(height: 1.0, thickness: 1.0),
                            const SizedBox(height: 16.0),
                            const Text(
                              'All operations comply with GDPR, CNPD, and HDS standards.',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Color(0xFF333333),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
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
  static Widget buildDropdownField({
    required String title,
    required List<String> items,
    required Rx<String?> selectedValue,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0, left: 10.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Obx(
                () => DropdownButtonFormField<String>(
              value: selectedValue.value,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:  BorderSide(color: AppColors.lightGrey.withOpacity(0.2), width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:  BorderSide(color:AppColors.lightGrey.withOpacity(0.2) , width: 2.0),
                    ),
                filled: true,
                fillColor: Colors.white,
              ),
              isExpanded: true,
              icon:  Icon(Icons.keyboard_arrow_down, color: AppColors.darkGrey),
              style: TextStyle(fontSize: 16.sp, color: Colors.black),
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildHeaderRow(BuildContext context) {
    final headerStyle = TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text('Name', style: headerStyle)),
          Expanded(flex: 2, child: Text('Role', style: headerStyle)),
          Expanded(flex: 2, child: Text('Data', style: headerStyle)),
          Expanded(flex: 3, child: Text('Date & Time', style: headerStyle)),
          Expanded(flex: 2, child: Text('Action', style: headerStyle)),
        ],
      ),
    );
  }

  Widget _buildRecordRow(BuildContext context, AccessRecord record) {
    final textStyle = TextStyle(fontSize: 7.sp, color: Color(0xFF333333));
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(record.name, style: textStyle),
          Text(record.role, style: textStyle),
          Text(record.data, style: textStyle),
          Text(record.dateTime, style: textStyle),
          Row(
            children: [
              _buildActionButton(Icons.file_copy),
              25.horizontalSpace,
              _buildActionButton(Icons.edit_note_outlined),
              25.horizontalSpace,
              _buildActionButton(Icons.upload_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon) {
    return SizedBox(
      width: 2.w,
      height: 2.h,
      child: Icon(icon, color: AppColors.primaryColor, size: 15),
    );
  }
  Widget buildInfoRow(String label,String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style:  TextStyle(
              fontSize: 14.sp,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 16.0),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style:  TextStyle(
                fontSize: 12.sp,
                color: Color(0xFF666666),
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

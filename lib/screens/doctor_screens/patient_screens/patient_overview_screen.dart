import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/doctor_controllers/patient_overview_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_button.dart';

class PatientOverviewScreen extends StatelessWidget {
  final String patientId;
  final String? patientName;

  PatientOverviewScreen({
    super.key,
    required this.patientId,
    this.patientName,
  });

  late final PatientOverviewController controller =
      Get.put(PatientOverviewController(patientId: patientId));

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
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              70.verticalSpace,
              _buildHeader(),
              15.verticalSpace,
              Expanded(
                child: Obx(
                  () => controller.isLoading.value
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              if (controller.patientOverview.value != null) ...[
                                _buildAccessBadge(),
                                20.verticalSpace,
                                if (controller.patientOverview.value!.allergies.isNotEmpty)
                                  _buildAllergiesSection(),
                                if (controller.patientOverview.value!.allergies.isNotEmpty)
                                  20.verticalSpace,
                                if (controller.patientOverview.value!.currentMedications.isNotEmpty)
                                  _buildMedicationsSection(),
                                if (controller.patientOverview.value!.currentMedications.isNotEmpty)
                                  20.verticalSpace,
                                if (controller.patientOverview.value!.vitalSigns != null)
                                  _buildVitalSignsSection(),
                                if (controller.patientOverview.value!.vitalSigns != null)
                                  20.verticalSpace,
                                if (controller.patientOverview.value!.lastEvents.isNotEmpty)
                                  _buildRecentEventsSection(),
                                if (controller.patientOverview.value!.lastEvents.isNotEmpty)
                                  20.verticalSpace,
                                if (controller.patientOverview.value!.consultingDoctors.isNotEmpty)
                                  _buildCareTeamSection(),
                                if (controller.patientOverview.value!.consultingDoctors.isNotEmpty)
                                  20.verticalSpace,
                                _buildActionButtons(),
                              ] else
                                _buildNoDataState(),
                              30.verticalSpace,
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        InkWell(
          onTap: () => Get.back(),
          child: Image.asset(
            AppImages.backIcon,
            height: 33.h,
            fit: BoxFit.fill,
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Patient Overview",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 23.sp,
                  fontWeight: FontWeight.w800,
                  fontFamily: AppFonts.jakartaBold,
                ),
              ),
              5.verticalSpace,
              Text(
                patientName ?? "At a Glance",
                style: TextStyle(
                  color: AppColors.lightGrey,
                  fontSize: 12.sp,
                  fontFamily: AppFonts.jakartaRegular,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccessBadge() {
    final overview = controller.patientOverview.value;
    if (overview == null) return SizedBox.shrink();

    return Container(
      width: 1.sw,
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: controller.getAccessLevelColor(overview.accessLevel).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: controller.getAccessLevelColor(overview.accessLevel)),
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: controller.getAccessLevelColor(overview.accessLevel),
              shape: BoxShape.circle,
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.getAccessLevelText(overview.accessLevel),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.jakartaBold,
                  ),
                ),
                3.verticalSpace,
                Text(
                  "Source: ${overview.accessSource}",
                  style: TextStyle(
                    color: AppColors.darkGrey,
                    fontSize: 10.sp,
                    fontFamily: AppFonts.jakartaRegular,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllergiesSection() {
    final allergies = controller.patientOverview.value!.allergies;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Active Allergies",
          style: TextStyle(
            color: Colors.black,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        10.verticalSpace,
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: allergies.map((allergy) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.red.withOpacity(0.15),
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(color: AppColors.red),
              ),
              child: Text(
                allergy,
                style: TextStyle(
                  color: AppColors.red,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.jakartaBold,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMedicationsSection() {
    final medications = controller.patientOverview.value!.currentMedications;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Current Medications",
          style: TextStyle(
            color: Colors.black,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        10.verticalSpace,
        Container(
          width: 1.sw,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: medications
                .asMap()
                .entries
                .map(
                  (entry) => Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          10.horizontalSpace,
                          Expanded(
                            child: Text(
                              entry.value,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13.sp,
                                fontFamily: AppFonts.jakartaRegular,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (entry.key < medications.length - 1) 10.verticalSpace,
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildVitalSignsSection() {
    final vitals = controller.patientOverview.value!.vitalSigns!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Last Vital Signs",
          style: TextStyle(
            color: Colors.black,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        10.verticalSpace,
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 1.2,
          children: [
            if (vitals.weight != null) _buildVitalCard("Weight", "${vitals.weight} kg"),
            if (vitals.height != null) _buildVitalCard("Height", "${vitals.height} cm"),
            if (vitals.systolic != null && vitals.diastolic != null)
              _buildVitalCard("BP", "${vitals.systolic}/${vitals.diastolic} mmHg"),
            if (vitals.heartRate != null) _buildVitalCard("Heart Rate", "${vitals.heartRate} bpm"),
            if (vitals.temperature != null) _buildVitalCard("Temp", "${vitals.temperature}°C"),
            if (vitals.oxygenSaturation != null)
              _buildVitalCard("O₂ Sat", "${vitals.oxygenSaturation}%"),
          ],
        ),
      ],
    );
  }

  Widget _buildVitalCard(String label, String value) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.darkGrey,
              fontSize: 11.sp,
              fontFamily: AppFonts.jakartaRegular,
            ),
          ),
          8.verticalSpace,
          Text(
            value,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.jakartaBold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentEventsSection() {
    final events = controller.patientOverview.value!.lastEvents.take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recent Events",
          style: TextStyle(
            color: Colors.black,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        10.verticalSpace,
        ...events.map((event) => _buildEventCard(event)).toList(),
      ],
    );
  }

  Widget _buildEventCard(PatientEvent event) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              controller.getEventIcon(event.type),
              color: AppColors.primaryColor,
              size: 18.sp,
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.description,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.jakartaBold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                3.verticalSpace,
                Text(
                  DateFormat('MMM d, yyyy').format(event.date),
                  style: TextStyle(
                    color: AppColors.lightGrey,
                    fontSize: 10.sp,
                    fontFamily: AppFonts.jakartaRegular,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareTeamSection() {
    final doctors = controller.patientOverview.value!.consultingDoctors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Care Team",
          style: TextStyle(
            color: Colors.black,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        10.verticalSpace,
        ...doctors.map((doctor) => _buildDoctorCard(doctor)).toList(),
      ],
    );
  }

  Widget _buildDoctorCard(CareTeamMember doctor) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_outline,
              color: AppColors.primaryColor,
              size: 18.sp,
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.jakartaBold,
                  ),
                ),
                3.verticalSpace,
                Text(
                  "${doctor.specialty} (${doctor.role})",
                  style: TextStyle(
                    color: AppColors.lightGrey,
                    fontSize: 10.sp,
                    fontFamily: AppFonts.jakartaRegular,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final overview = controller.patientOverview.value;
    if (overview == null) return SizedBox.shrink();

    if (overview.accessLevel == "Read-only") {
      return CustomButton(
        borderRadius: 15,
        text: "Request Full Access",
        onTap: () => _showRequestAccessDialog(),
      );
    }

    if (overview.accessLevel != "Full") {
      return Column(
        children: [
          CustomButton(
            borderRadius: 15,
            text: "Emergency Access",
            onTap: () => _showEmergencyAccessDialog(),
          ),
          12.verticalSpace,
          CustomButton(
            borderRadius: 15,
            text: "Request Access",
            onTap: () => _showRequestAccessDialog(),
            bgColor: AppColors.inACtiveButtonColor,
            fontColor: Colors.black,
          ),
        ],
      );
    }

    return SizedBox.shrink();
  }

  Widget _buildNoDataState() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 50.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 80.sp,
            color: AppColors.lightGrey,
          ),
          20.verticalSpace,
          Text(
            "No Data Available",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.jakartaBold,
            ),
          ),
          10.verticalSpace,
          Text(
            "Patient information will appear here",
            style: TextStyle(
              color: AppColors.lightGrey,
              fontSize: 13.sp,
              fontFamily: AppFonts.jakartaRegular,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showRequestAccessDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        title: Text(
          "Request Access",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Please provide a reason for access:",
                style: TextStyle(
                  color: AppColors.darkGrey,
                  fontSize: 13.sp,
                  fontFamily: AppFonts.jakartaRegular,
                ),
              ),
              15.verticalSpace,
              Container(
                decoration: BoxDecoration(
                  color: AppColors.lightWhite,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: AppColors.inACtiveButtonColor),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  child: TextField(
                    controller: controller.accessJustification,
                    maxLines: 4,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      hintText: "Enter justification...",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: AppColors.lightGrey,
                        fontSize: 13.sp,
                        fontFamily: AppFonts.jakartaRegular,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: AppFonts.jakartaRegular,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 14.sp,
                fontFamily: AppFonts.jakartaBold,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final success = await controller.requestAccess();
              if (success) {
                Get.back();
              }
            },
            child: Text(
              "Send Request",
              style: TextStyle(
                color: AppColors.green,
                fontSize: 14.sp,
                fontFamily: AppFonts.jakartaBold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEmergencyAccessDialog() {
    final justification = TextEditingController();
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        title: Text(
          "Emergency Access",
          style: TextStyle(
            color: AppColors.red,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: AppColors.red),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning,
                      color: AppColors.red,
                      size: 18.sp,
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: Text(
                        "Emergency access will be logged for audit purposes",
                        style: TextStyle(
                          color: AppColors.red,
                          fontSize: 12.sp,
                          fontFamily: AppFonts.jakartaRegular,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              15.verticalSpace,
              Text(
                "Provide justification for emergency access:",
                style: TextStyle(
                  color: AppColors.darkGrey,
                  fontSize: 13.sp,
                  fontFamily: AppFonts.jakartaRegular,
                ),
              ),
              15.verticalSpace,
              Container(
                decoration: BoxDecoration(
                  color: AppColors.lightWhite,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: AppColors.inACtiveButtonColor),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  child: TextField(
                    controller: justification,
                    maxLines: 4,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      hintText: "Explain emergency situation...",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: AppColors.lightGrey,
                        fontSize: 13.sp,
                        fontFamily: AppFonts.jakartaRegular,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: AppFonts.jakartaRegular,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              justification.dispose();
              Get.back();
            },
            child: Text(
              "Cancel",
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 14.sp,
                fontFamily: AppFonts.jakartaBold,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final success = await controller.requestEmergencyAccess(justification.text);
              if (success) {
                justification.dispose();
                Get.back();
              }
            },
            child: Text(
              "Grant Access",
              style: TextStyle(
                color: AppColors.red,
                fontSize: 14.sp,
                fontFamily: AppFonts.jakartaBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

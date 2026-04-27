import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/doctor_controllers/exam_orders_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/custom_button.dart';

class ExamOrdersScreen extends StatelessWidget {
  final String consultationId;

  ExamOrdersScreen({super.key, required this.consultationId});

  late final ExamOrdersController controller =
      Get.put(ExamOrdersController(consultationId: consultationId));

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
              20.verticalSpace,
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
                              if (controller.examOrders.isEmpty)
                                _buildEmptyState(),
                              if (controller.examOrders.isNotEmpty)
                                _buildExamOrdersList(),
                              30.verticalSpace,
                              CustomButton(
                                borderRadius: 15,
                                text: "Request Test",
                                onTap: () => _showRequestTestBottomSheet(),
                              ),
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
                "Exam Orders",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 23.sp,
                  fontWeight: FontWeight.w800,
                  fontFamily: AppFonts.jakartaBold,
                ),
              ),
              5.verticalSpace,
              Text(
                "Manage laboratory and imaging orders",
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

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 50.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_turned_in_outlined,
            size: 80.sp,
            color: AppColors.lightGrey,
          ),
          20.verticalSpace,
          Text(
            "No Exam Orders Yet",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.jakartaBold,
            ),
          ),
          10.verticalSpace,
          Text(
            "Request tests and imaging exams for your patient",
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

  Widget _buildExamOrdersList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Active Orders",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        15.verticalSpace,
        ...controller.examOrders.map((order) => _buildExamOrderCard(order)).toList(),
      ],
    );
  }

  Widget _buildExamOrderCard(ExamOrder order) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getExamTypeName(order.type),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.jakartaBold,
                      ),
                    ),
                    5.verticalSpace,
                    Text(
                      order.description,
                      style: TextStyle(
                        color: AppColors.darkGrey,
                        fontSize: 12.sp,
                        fontFamily: AppFonts.jakartaRegular,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              10.horizontalSpace,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: controller.getStatusColor(order.status).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  controller.getStatusLabel(order.status),
                  style: TextStyle(
                    color: controller.getStatusColor(order.status),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.jakartaBold,
                  ),
                ),
              ),
            ],
          ),
          15.verticalSpace,
          Row(
            children: [
              Icon(
                Icons.priority_high,
                size: 16.sp,
                color: order.priority == 'URGENT' ? AppColors.red : AppColors.orange,
              ),
              5.horizontalSpace,
              Text(
                order.priority == 'URGENT' ? 'Urgent' : 'Routine',
                style: TextStyle(
                  color: order.priority == 'URGENT' ? AppColors.red : AppColors.orange,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.jakartaBold,
                ),
              ),
            ],
          ),
          if (order.instructions.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Text(
                "Instructions: ${order.instructions}",
                style: TextStyle(
                  color: AppColors.darkGrey,
                  fontSize: 11.sp,
                  fontFamily: AppFonts.jakartaRegular,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          if (order.status == 'RESULTS_AVAILABLE')
            Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: SizedBox(
                width: 1.sw,
                child: Obx(
                  () => CustomButton(
                    borderRadius: 10,
                    text: "Mark as Reviewed",
                    isLoading: controller.isSaving.value,
                    onTap: () => controller.updateExamOrderStatus(order.id!, 'REVIEWED'),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showRequestTestBottomSheet() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.r),
            topRight: Radius.circular(25.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Request Test",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    fontFamily: AppFonts.jakartaBold,
                  ),
                ),
                20.verticalSpace,
                _buildDropdownField(
                  label: "Test Type",
                  value: controller.typeController.value.toString().split('.').last,
                  items: ['BLOOD_TEST', 'URINE_TEST', 'IMAGING', 'BIOPSY', 'OTHER'],
                  onChanged: (value) {
                    final examType = ExamType.values.firstWhere(
                      (e) => e.toString().split('.').last == value,
                      orElse: () => ExamType.OTHER,
                    );
                    controller.typeController.value = examType;
                  },
                ),
                15.verticalSpace,
                _buildDropdownField(
                  label: "Priority",
                  value: controller.priorityController.value.toString().split('.').last,
                  items: ['ROUTINE', 'URGENT'],
                  onChanged: (value) {
                    final priority = ExamPriority.values.firstWhere(
                      (e) => e.toString().split('.').last == value,
                      orElse: () => ExamPriority.ROUTINE,
                    );
                    controller.priorityController.value = priority;
                  },
                ),
                15.verticalSpace,
                _buildTextField(
                  label: "Description",
                  controller: controller.descriptionController,
                  hint: "Test description",
                  maxLines: 3,
                ),
                15.verticalSpace,
                _buildTextField(
                  label: "Instructions for Patient",
                  controller: controller.instructionsController,
                  hint: "e.g., Fasting required, collect sample in morning",
                  maxLines: 3,
                ),
                25.verticalSpace,
                Obx(
                  () => CustomButton(
                    borderRadius: 15,
                    text: "Send Order",
                    isLoading: controller.isSaving.value,
                    onTap: () async {
                      final success = await controller.createExamOrder();
                      if (success) {
                        Get.back();
                      }
                    },
                  ),
                ),
                12.verticalSpace,
                CustomButton(
                  borderRadius: 15,
                  text: "Cancel",
                  onTap: () => Get.back(),
                  bgColor: AppColors.inACtiveButtonColor,
                  fontColor: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        10.verticalSpace,
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightWhite,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.inACtiveButtonColor),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              underline: const SizedBox(),
              items: items.map((String val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(
                    _formatDropdownValue(val),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: AppFonts.jakartaRegular,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        10.verticalSpace,
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightWhite,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.inACtiveButtonColor),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: AppColors.lightGrey,
                  fontSize: 13.sp,
                  fontFamily: AppFonts.jakartaRegular,
                ),
              ),
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: AppFonts.jakartaRegular,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getExamTypeName(String type) {
    switch (type) {
      case 'BLOOD_TEST':
        return 'Blood Test';
      case 'URINE_TEST':
        return 'Urine Test';
      case 'IMAGING':
        return 'Imaging';
      case 'BIOPSY':
        return 'Biopsy';
      case 'OTHER':
        return 'Other Test';
      default:
        return type;
    }
  }

  String _formatDropdownValue(String value) {
    return value.replaceAll('_', ' ').replaceAllMapped(RegExp(r'(?:^|_)([a-z])'), (match) {
      return match.group(1)?.toUpperCase() ?? '';
    });
  }
}

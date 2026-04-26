import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/appointment_controllers/video_call_controller.dart';

class ConsentAccessDrawer extends GetView<VideoCallController> {
  const ConsentAccessDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width,
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Stack(
        children: [
          Row(
            children: [
              const Spacer(),
              Container(
                width: 0.85.sw,
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F9FF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(40.w, 10.h, 20.w, 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Consent & Access",
                          style: TextStyle(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF333333),
                          ),
                        ),
                        5.verticalSpace,
                        Text(
                          "Access Scope",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF444444),
                          ),
                        ),
                        20.verticalSpace,
                        Text(
                          "Record access",
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF333333),
                          ),
                        ),
                        15.verticalSpace,
                        _buildAccessDropdown(),
                        30.verticalSpace,
                        Text(
                          "Consents",
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF333333),
                          ),
                        ),
                        15.verticalSpace,
                        _buildConsentItem("Teleconsultation consent", true),
                        12.verticalSpace,
                        _buildConsentItem("Teleconsultation consent", false),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: (0.15.sw) - 20,
            top: 55.h,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                height: 40.h,
                width: 40.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF4A80F0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccessDropdown() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFC8E6D9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Access Granted",
            style: TextStyle(
              fontSize: 15.sp,
              color: const Color(0xFF2E7D32),
              fontWeight: FontWeight.w500,
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFF333333),
          ),
        ],
      ),
    );
  }

  Widget _buildConsentItem(String title, bool isSigned) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: isSigned ? const Color(0xFF3CB371) : const Color(0xFFF4511E),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isSigned ? "Signed" : "Not Signed",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
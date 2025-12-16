import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/pharmacy_screens/prescription_screens/delivery_log.dart';
import 'package:patient_app/widgets/custom_button.dart';
import '../../../controllers/pharmacy_controllers/preparaition_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';

class PrepartionAndDeliveryScreen extends StatelessWidget {
  PrepartionAndDeliveryScreen({super.key});
  PreparationController controller =Get.put(PreparationController());
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
                    "Preparation And Delivery",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 21.sp,
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
                    children: <Widget>[
                      10.verticalSpace,
                      headerWidget(),
                      const SizedBox(height: 24),
                      const Text(
                        'Preparation Checklist',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3133),
                        ),
                      ),
                      const SizedBox(height: 16),
                      checklistWidget(),
                       10.verticalSpace,
                       Obx(
                         ()=> controller.genrateQrButton.value?Text(
                          'Delivery QR Section',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3133),
                          ),
                                               ):SizedBox(),
                       ),
                       Obx(()=> controller.genrateQrButton.value?SizedBox(height: 16):SizedBox()),
                      Obx(()=>controller.genrateQrButton.value? qrCardWidget():SizedBox()),
                      20.verticalSpace,
                      Obx(
                        ()=>!controller.genrateQrButton.value? CustomButton(
                          borderRadius: 15,
                          text: "Generate Delivery QR",
                          onTap: () {
                            controller.genrateQrButton.value=true;
                          },
                          bgColor: AppColors.inACtiveButtonColor,
                          fontColor: Colors.black,
                        ):SizedBox(),
                      ),
                      10.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: "View Delivery Log",
                        onTap: () {
                          Get.to(DeliveryLog());
                        },
                      ),
                      10.verticalSpace,
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
  Widget headerWidget() {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: 6.w,vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/demo_images/patient_1.png', // Placeholder for user image
              width: 60.w,
              height: 60.h,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    '#A10482',
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  70.horizontalSpace,
                  Container(
                    padding:  EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color:  AppColors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child:  Text(
                      'Preparation',
                      style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              RichText(
                textAlign: TextAlign.start,
                text: const TextSpan(
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  children: [
                    TextSpan(text: 'Prescription Id: ',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.black)),
                    TextSpan(
                      text: 'RX-20410',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '3 Medications To Prepare For Delivery.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget checklistWidget() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildCheckItem('Items packed', controller.itemsPacked),
          _buildCheckItem('Lot numbers verified', controller.lotVerified),
          _buildCheckItem('Expiry checked', controller.expiryChecked),
          _buildCheckItem('QR token generated', controller.qrGenerated),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String title, RxBool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => value.toggle(),
        child: Row(
          children: [
            Obx(() => Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: value.value ? const Color(0xFF5CB85C) : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: value.value ? const Color(0xFF5CB85C) : Colors.grey.shade400,
                  width: 1.5,
                ),
              ),
              child: value.value
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            )),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF4A4A4A),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget qrCardWidget() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEBEFF7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.qr_code_2_rounded,
              size: 80,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Scan This Code At Pickup To Confirm Delivery.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8E8E8E),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(Icons.history_rounded, size: 18, color: Color(0xFF4A80F0)),
                    SizedBox(width: 6),
                    Text(
                      'Expires in 24 hours.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4A4A4A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Delivery ID:DLV-0093}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFA0A0A0),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Generated: Oct 29, 2025 • 3:40 PM',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFA0A0A0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

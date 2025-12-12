import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_images.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/patient_widgets/video_call_widgets/setting widgets.dart';

class PartialFulfillmentProposalScreen extends StatelessWidget {
  PartialFulfillmentProposalScreen({super.key});

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
                    "Partial Fulfillment Proposal",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.sp,
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
                      Text(
                        "Some Items In This Prescription Are Unavailable.\nSuggest Replacements Or Partial Quantities.",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      10.verticalSpace,

                      Text(
                        'Unavailable Medication',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          fontFamily: AppFonts.jakartaBold,
                        ),
                      ),
                      10.verticalSpace,
                      CustomDropdown(
                        label: "Medication Name",
                        options: [
                          "Paracetamol 500mg",
                          "Paracetamol 1000mg",
                          "Paracetamol 200mg",
                        ],
                        currentValue: "Paracetamol 500mg",
                        onChanged: (_) {},
                      ),

                      10.verticalSpace,
                      CustomTextField(
                        labelText: "Qty Requested",
                        hintText: "10",
                      ),

                      10.verticalSpace,
                      CustomDropdown(
                        label: "Qty Available",
                        options: ["10", "8", "5", "0"],
                        currentValue: "10",
                        onChanged: (_) {},
                      ),

                      10.verticalSpace,
                      CustomDropdown(
                        label: "Substitute",
                        options: ["Select", "Ibuprofen 200mg", "Aspirin 81mg"],
                        currentValue: "Select",
                        onChanged: (_) {},
                      ),

                      10.verticalSpace,
                      CustomTextField(labelText: "Price", hintText: "\$120"),

                      30.verticalSpace,
                      Text(
                        'Additional Notes',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          fontFamily: AppFonts.jakartaBold,
                        ),
                      ),
                      10.verticalSpace,
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          maxLines: 3,
                          onTapOutside: (_) {
                            FocusManager.instance.primaryFocus!.unfocus();
                          },
                          decoration: InputDecoration(
                            hintText:
                                'Partial availability, replacement suggested.',
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                          ),
                        ),
                      ),

                      30.verticalSpace,
                      Text(
                        'Price Summary (Live)',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          fontFamily: AppFonts.jakartaBold,
                        ),
                      ),
                      10.verticalSpace,
                      Container(
                        padding: EdgeInsets.all(10.sp),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(13.sp),
                          border: Border.all(
                            color: AppColors.lightGrey.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildPriceSummaryRow(
                              "Subtotal",
                              "\$156",
                              AppColors.primaryColor,
                            ),
                            5.verticalSpace,
                            _buildPriceSummaryRow(
                              "Delivery Charges",
                              "\$2.00",
                              AppColors.primaryColor,
                              subText: "if home delivery",
                            ),
                            5.verticalSpace,
                            Divider(color:AppColors.lightGrey.withOpacity(0.2), height: 20.h),
                            _buildPriceSummaryRow(
                              "New Total",
                              "\$158",
                              AppColors.primaryColor,
                              isTotal: true,
                            ),
                          ],
                        ),
                      ),
                      30.verticalSpace,

                      CustomButton(
                        borderRadius: 15,
                        text: "Submit Proposal",
                        onTap: () {},
                      ),
                      10.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: "Cancel",
                        onTap: () {
                          Get.back();
                        },
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

  Widget _buildPriceSummaryRow(
    String label,
    String value,
    Color valueColor, {
    String? subText,
    bool isTotal = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: isTotal ? 16.sp : 14.sp,
                  fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
                  color: isTotal ? Colors.black : Colors.black87,
                ),
              ),
              if (subText != null)
                Text(
                  subText,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18.sp : 14.sp,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

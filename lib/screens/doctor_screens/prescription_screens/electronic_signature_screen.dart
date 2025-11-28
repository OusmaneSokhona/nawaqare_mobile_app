import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/widgets/custom_button.dart';

import '../../../utils/app_colors.dart';

class ElectronicSignatureScreen extends StatelessWidget {
  const ElectronicSignatureScreen({super.key});

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
      child: Padding(padding: EdgeInsets.symmetric(horizontal: 20.w),child: Column(
        children: [
          70.verticalSpace,
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  'assets/images/back_icon.png',
                  height: 33.h,
                  fit: BoxFit.fill,
                ),
              ),
              10.horizontalSpace,
              Text(
                "Electronic Signature",
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
          _buildSignatureValidationSection(),
          30.verticalSpace,
          CustomButton(borderRadius: 15, text: "Save", onTap: (){}),
          15.verticalSpace,
          CustomButton(borderRadius: 15, text: "Clear", onTap: (){},bgColor: AppColors.inACtiveButtonColor,fontColor: Colors.black,),

        ],
      ),),
      ),
    );
  }

  Widget _buildSignatureValidationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sign To Legally Validate This Prescription',
          style: TextStyle(
            fontSize: 15,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(alignment:Alignment.centerLeft,child: Text("Signature",style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,fontFamily: AppFonts.jakartaBold),)),
            TextButton(
              onPressed: () {},
              child: Text(
                'Use saved signature',
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        Container(
          height: 150,
          width: 1.sw,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color:AppColors.lightGrey.withOpacity(0.2)),
          ),
          child: const Text(
            'Signature',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),

        const SizedBox(height: 16),

        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Note: ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
              const TextSpan(
                text: 'Secure digital signature compliant with eIDAS / HIPAA',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

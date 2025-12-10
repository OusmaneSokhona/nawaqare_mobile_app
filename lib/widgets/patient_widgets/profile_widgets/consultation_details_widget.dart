import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/widgets/custom_button.dart';

class ConsultationDetailsWidget extends StatelessWidget {
  const ConsultationDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPlanHeader(),
        10.verticalSpace,
        Text(
          'Plan Info',
          style: TextStyle(
            fontSize: 19.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        _buildPlanInfo(),
        _buildPlanDescription(),
        15.verticalSpace,
        _buildUsageLog(),
        20.verticalSpace,
        CustomButton(borderRadius: 15, text: "Renew Plan", onTap: (){}),
        10.verticalSpace,
        CustomButton(borderRadius: 15, text: "Download Invoice", onTap: (){},bgColor: AppColors.inACtiveButtonColor,fontColor: Colors.black,),
        20.verticalSpace,
      ],
    );
  }

  Widget _buildPlanHeader() {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: 15.w,vertical: 15.h),
      decoration:  BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12.sp),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            'Premium Tele-Consultation\nPlan',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            decoration: BoxDecoration(
              color: const Color(0xFF5ABF77),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child:  Text(
              'Active',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 11.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color:AppColors.primaryColor),
          const SizedBox(width: 10),
          Text(
            text,
            style:  TextStyle(
              fontSize: 16,
              color:Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(Icons.videocam_outlined, 'Video Consultation'),
        _buildInfoRow(Icons.calendar_today_outlined, 'Expires on 21 Feb 2025'),
        _buildInfoRow(Icons.monetization_on_outlined, '\$45'),
        const Divider(height: 10, color: Colors.transparent),
        const Text('Duration: 30 days', style: TextStyle(fontSize: 16, color: Colors.black)),
        const Text('12 credits', style: TextStyle(fontSize: 16, color: Colors.black)),
      ],
    );
  }

  Widget _buildPlanDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.verticalSpace,
        Text(
          'Description',
          style: TextStyle(
            fontSize: 19.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'Symptoms improving, headache frequency reduced from 5 to 2 times per week. Advised patient to continue current regimen and maintain sleep hygiene',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.lightGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildUsageLog() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration:  BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.sp),border: Border.all(color: AppColors.lightGrey.withOpacity(0.2))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            'Usage Log',
            style: TextStyle(
              fontSize: 19.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Track Who Viewed Or Modified Your Records',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6E6E6E),
            ),
          ),
          const SizedBox(height: 15),
          _buildUsageLogTable(),
          20.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildUsageLogTable() {
    final List<Map<String, String>> logData = [
      {'date': '03 Feb 2025', 'type': 'Video', 'doctor': 'Dr. C.A.', 'status': 'COMPLETED', 'color': '0xFF5ABF77'},
      {'date': '03 Feb 2025', 'type': 'In-person', 'doctor': 'Dr. C.A.', 'status': 'Missed', 'color': '0xFFE74C3C'},
      {'date': '03 Feb 2025', 'type': 'In-person', 'doctor': 'Dr. C.A.', 'status': 'Missed', 'color': '0xFFE74C3C'},
      {'date': '03 Feb 2025', 'type': 'In-person', 'doctor': 'Dr. C.A.', 'status': 'Missed', 'color': '0xFFE74C3C'},
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
            Expanded(child: Text('Consultation Date', style: TextStyle(fontSize: 9.sp,fontWeight: FontWeight.bold, color: Colors.black))),
            Expanded(child: Text('Type', style: TextStyle(fontSize: 11.sp,fontWeight: FontWeight.bold, color: Colors.black))),
            Expanded(child: Text('Doctor', style: TextStyle(fontSize: 11.sp,fontWeight: FontWeight.bold, color: Colors.black))),
            Expanded(child: Text('Status', style: TextStyle(fontSize: 11.sp,fontWeight: FontWeight.bold, color: Colors.black))),
          ],
        ),
        const Divider(height: 10, color: Colors.transparent),
        ...logData.map((data) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(data['date']!, style:TextStyle(fontSize: 11.sp,color:AppColors.lightGrey))),
                    Expanded(child: Text(data['type']!, style: TextStyle(fontSize: 11.sp,color:AppColors.lightGrey))),
                    Expanded(child: Text(data['doctor']!, style:  TextStyle(fontSize: 11.sp,color:AppColors.lightGrey))),
                    Expanded(
                      child: Text(
                        data['status']!,
                        style: TextStyle(
                          color: Color(int.parse(data['color']!)),
                          fontWeight: FontWeight.bold,
                          fontSize: 11.sp
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 8.h,color: AppColors.lightGrey.withOpacity(0.2),),
            ],
          );
        }).toList(),
      ],
    );
  }
}
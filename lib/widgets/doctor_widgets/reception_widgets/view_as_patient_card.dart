import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient_app/utils/app_fonts.dart';
import '../../../models/appointment_model.dart';
import '../../../utils/app_colors.dart';

class ViewAsPatientCard extends StatelessWidget {
  final AppointmentModel appointmentModel;
  Function onTap;

  ViewAsPatientCard({
    Key? key,
    required this.appointmentModel,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(width: 6),
                Row(
                  children: [
                    Text(
                      "${appointmentModel.date}",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12.sp,
                      ),
                    ),
                    8.horizontalSpace,
                    Icon(
                      Icons.watch_later_outlined,
                      size: 16,
                      color: AppColors.primaryColor,
                    ),
                    4.horizontalSpace,
                    Text(
                      "${appointmentModel.time}",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 4),
            Divider(thickness: 0.3, color: Colors.black45),
            const SizedBox(height: 4),

            Row(
              children: [
                Image.asset(
                  appointmentModel.imageUrl,
                  height: 105.h,
                  fit: BoxFit.fill,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointmentModel.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            appointmentModel.consultationType
                                .toLowerCase()
                                .contains("remote")
                                ? Icons.add_ic_call
                                : Icons.meeting_room_outlined,
                            color: Colors.blue,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            appointmentModel.consultationType,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Period:",
                            style:  TextStyle(fontSize: 14.sp,fontFamily: AppFonts.jakartaMedium,fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "This Week",
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      7.verticalSpace,
                    ],
                  ),
                ),
              ],
            ),
5.verticalSpace,
Divider(height: 5.h,color: AppColors.lightGrey,thickness: 0.4,),
            const SizedBox(height: 12),
            Row(children: [
              _buildButton(
                onTap: () {},
                text: "Cancel",
                backgroundColor:AppColors.inACtiveButtonColor,
                textColor: Colors.black,
              ),
              _buildButton(
                onTap: () {
                  onTap();
                },
                text: "Book",
                backgroundColor: AppColors.primaryColor,
                textColor: Colors.white,
              ),
            ],)
          ],
        ),
      ),
    );
  }
  Widget _buildButton({
    required String text,
    required Color backgroundColor,
    required Color textColor,
    required Function onTap,
  }) {
    return Expanded(
      child: Container(
        height: 45.h,
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        child: TextButton(
          onPressed: () {
            onTap();
          },
          style: TextButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 0,
            alignment: Alignment.center,
          ),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

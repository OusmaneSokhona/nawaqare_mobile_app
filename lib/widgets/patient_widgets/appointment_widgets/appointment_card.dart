import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';

class AppointmentCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String title;
  final String type;
  final IconData consultationTypeIcon;
  final String consultationTypeText;
  final bool showGreenDot;
  final bool showRating;
  final Function? onTap;
  final String buttonText;

  const AppointmentCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.type,
    required this.title,
    this.showGreenDot = true,
    this.showRating = true,
    this.consultationTypeIcon = Icons.phone,
    this.consultationTypeText = "Remote Consultation",
    this.onTap,
    this.buttonText='Join',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontFamily: AppFonts.jakartaMedium,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
        5.verticalSpace,
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: AppColors.primaryColor.withOpacity(0.6), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Image.asset(
                        imagePath,
                        height: 70,
                        width: 70,
                        fit: BoxFit.cover,
                      ),
                      showGreenDot
                          ? Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          )
                          : SizedBox(),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          type,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      onTap!();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      elevation: 0,
                    ),
                    child:  Text(buttonText, style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
              const Divider(height: 30, color: Color(0xFFE5E7EB)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildDetailItem(Icons.calendar_today, 'Sunday, 12 June'),
                  _buildDetailItem(Icons.schedule, '11:00-12:00 AM'),
                  showRating
                      ? _buildDetailItem(Icons.star, '4.3/5')
                      : _buildDetailItem(
                        consultationTypeIcon,
                        consultationTypeText,
                      ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 16, color: AppColors.primaryColor),
        const SizedBox(width: 6),
        SizedBox(
          width: 75.w,
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12.sp, color: Color(0xFF4B5563)),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:patient_app/utils/app_strings.dart';

import '../utils/app_fonts.dart';
import '../utils/appointment_status.dart';

class AppointmentStatusWidget extends StatelessWidget {
  final String status;
  final double? iconSize;
  final double? textSize;
  final bool showIcon;

  const AppointmentStatusWidget({
    Key? key,
    required this.status,
    this.iconSize,
    this.textSize,
    this.showIcon = true,
  }) : super(key: key);

  Color getStatusColor() {
    switch (status.toLowerCase()) {
      case AppointmentStatus.PENDING:
        return Colors.orange;
      case AppointmentStatus.CONFIRMED:
        return Colors.green;
      case AppointmentStatus.ONGOING:
        return Colors.blue;
      case AppointmentStatus.COMPLETED:
        return Colors.purple;
      case AppointmentStatus.CANCELLED:
        return Colors.red;
      case AppointmentStatus.MISSED:
        return Colors.grey;
      case "accepted":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon() {
    switch (status.toLowerCase()) {
      case AppointmentStatus.PENDING:
        return Icons.access_time;
      case AppointmentStatus.CONFIRMED:
        return Icons.check;
      case AppointmentStatus.ONGOING:
        return Icons.play_circle_fill;
      case AppointmentStatus.COMPLETED:
        return Icons.done_all;
      case AppointmentStatus.CANCELLED:
        return Icons.cancel;
      case AppointmentStatus.MISSED:
        return Icons.not_interested;
      case "accepted":
        return Icons.done_all;
      default:
        return Icons.help;
    }
  }

  String getStatusText() {
    switch (status.toLowerCase()) {
      case AppointmentStatus.PENDING:
        return AppStrings.pending.tr;
      case AppointmentStatus.CONFIRMED:
        return AppStrings.confirmed.tr;
      case AppointmentStatus.ONGOING:
        return "ongoing";
      case AppointmentStatus.COMPLETED:
        return AppStrings.completed.tr;
      case AppointmentStatus.CANCELLED:
        return AppStrings.cancelled.tr;
      case AppointmentStatus.MISSED:
        return AppStrings.missed.tr;
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIcon)
          Container(
            height: iconSize ?? 30.h,
            width: iconSize ?? 30.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: getStatusColor(),
            ),
            child: Icon(
              getStatusIcon(),
              color: Colors.white,
              size: (iconSize ?? 30.h) * 0.6,
            ),
          ),
        if (showIcon) SizedBox(width: 10.w),
        Text(
          getStatusText(),
          style: TextStyle(
            color: getStatusColor(),
            fontSize: textSize ?? 16.sp,
            fontWeight: FontWeight.w500,
            fontFamily: AppFonts.jakartaMedium,
          ),
        ),
      ],
    );
  }
}
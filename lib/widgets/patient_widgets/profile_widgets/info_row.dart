import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient_app/utils/app_colors.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool showDivider;
  final double labelTextSize;
  final double valueTextSize;

  const InfoRow({
    required this.label,
    required this.value,
    this.labelTextSize=16,
    this.valueTextSize=16,
     this.showDivider=true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: labelTextSize.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGrey,
                ),
              ),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style:  TextStyle(
                    fontSize: valueTextSize.sp,
                    color: AppColors.lightGrey,
                    fontWeight: FontWeight.w500,

                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          showDivider?Divider(height: 1, color: Colors.grey.shade300):SizedBox(),
        ],
      ),
    );
  }
}
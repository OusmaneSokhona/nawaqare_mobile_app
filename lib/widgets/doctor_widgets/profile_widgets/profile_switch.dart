import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient_app/utils/app_colors.dart';

class ProfileSwitch extends StatelessWidget {
  final bool isEnabled;
  final String title;
  const ProfileSwitch({super.key,required this.title,this.isEnabled=false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.lightGrey,
          ),
        ),
        CupertinoSwitch(
          value: isEnabled,
          onChanged: (bool value) {
          },
          activeColor: AppColors.primaryColor,

        ),
      ],
    );
  }
}

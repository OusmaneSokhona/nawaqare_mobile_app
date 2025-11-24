import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyToggleItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;

  const PrivacyToggleItem({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(left: 5.w,right: 10.w, top: 12.h,bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E272E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6C7B8A),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // The Switch widget
          SizedBox(
            height: 15.h,
            width: 20.w,
            child: Switch(
               padding: EdgeInsets.zero,
              value: value,
              onChanged: onChanged,
              activeColor: activeColor,
              inactiveTrackColor: Colors.grey[300],
              inactiveThumbColor: Colors.grey[50],
            ),
          ),
        ],
      ),
    );
  }
}
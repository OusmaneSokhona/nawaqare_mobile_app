import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';

class OrderDetailCard extends StatelessWidget {
  final String status;
  const OrderDetailCard({super.key,required this.status});
  @override
  Widget build(BuildContext context) {
    const List<String> steps = [
      'Order',
      'Preparig',
      'In Delivery',
      'Delivered',
    ];
    const int completedStepIndex = 3;

    return Card(
      elevation: 4,color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Header Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Order #12456',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Delivery Sep 30, 2025',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:  Text(
                        status,
                        style: TextStyle(color:_getStatusTextColor(status), fontWeight: FontWeight.w600, fontSize: 12.sp),
                      ),
                    ),
                   8.horizontalSpace,
                     Text(
                      'ETA: Today, 5:30 PM',
                      style: TextStyle(fontSize: 12.sp, color: AppColors.darkGrey),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 30, thickness: 1, color: Color(0xFFE0E0E0)),

            // Order Summary Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Order Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Amoxicillin 500mg',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                _buildInfoRow("Order ID:", "#12456"),
                const SizedBox(height: 4),
                _buildInfoRow("Expected By:", "Sep 30, 2025"),
              ],
            ),
            const Divider(height: 30, thickness: 1, color: Color(0xFFE0E0E0)),

            // Delivery Address Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Delivery Address',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'John Doe, 123 Main Street, Anytown, CA 90210, USA',
                  style: TextStyle(fontSize: 16, color: AppColors.lightGrey),
                ),
              ],
            ),
            const Divider(height: 30, thickness: 1, color: Color(0xFFE0E0E0)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Delivery Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                10.verticalSpace,
                _buildInfoRow("Courier Name", "Adam Asmith"),
              ],
            ),
            30.verticalSpace,
            _buildProgressBar(context),
            10.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: steps
                  .map(
                    (stage) => Text(
                  stage,
                  style: TextStyle(
                    color: stage.indexOf(stage) <= 2
                        ? Colors.black
                        : Colors.grey.shade500,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.jakartaMedium,
                  ),
                ),
              )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildProgressBar(BuildContext context) {
    double totalStages = 4.0;
    double progressValue = (4) / totalStages;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.sp),
      child: LinearProgressIndicator(
        value: progressValue,
        minHeight: 12.h,
        backgroundColor: AppColors.lightGrey.withOpacity(0.3),
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
      ),
    );
  }
  Widget _buildInfoRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 14.sp,
          fontFamily: AppFonts.jakartaRegular,
        ),
        children: <TextSpan>[
          TextSpan(
            text: label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.darkGrey,
              fontFamily: AppFonts.jakartaMedium,
            ),
          ),
          TextSpan(
            text: value,
          ),
        ],
      ),
    );
  }
  Color _getStatusColor(String status) {
    switch (status) {
      case 'In Progress':
        return Colors.blue.shade100;
      case 'Out For Delivered':
        return Colors.green.shade100;
      case 'Awaiting Confirmation':
        return Colors.orange.shade100;
      case 'Delivered':
        return AppColors.green;
      case 'Cancelled':
        return AppColors.red;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'In Progress':
        return AppColors.primaryColor;
      case 'Out For Delivered':
        return AppColors.green;
      case 'Awaiting Confirmation':
        return AppColors.orange;
      case 'Delivered':
        return Colors.white;
      case 'Cancelled':
        return Colors.white;
      default:
        return Colors.grey.shade800;
    }
  }
}
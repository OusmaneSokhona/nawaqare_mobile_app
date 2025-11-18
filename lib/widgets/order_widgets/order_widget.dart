import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/order_screens/order_detail_screen.dart';
import 'package:patient_app/screens/order_screens/order_status_screen.dart';
import 'package:patient_app/screens/order_screens/track_order_screen.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/widgets/custom_button.dart';

import '../../models/orders_model.dart';

class OrderWidget extends StatelessWidget {
  final Order order;
 final bool isComplete;

  const OrderWidget({super.key, required this.order,this.isComplete=false});

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

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 2.0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/nawa_qare_icon_orders_screen.png',
                      height: 29.h,
                      width: 29.w,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.orderId} | ${order.date}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        order.items,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        order.deliveryType,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            16.verticalSpace,
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status),
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Text(
                    order.status,
                    style: TextStyle(
                      color: _getStatusTextColor(order.status),
                      fontWeight: FontWeight.bold,
                      fontSize: 11.sp,
                    ),
                  ),
                ),
                12.horizontalSpace,
                Text(
                  'Last Update: ${order.lastUpdate}',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
            16.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Cost: ${order.cost}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
                Spacer(),
                Text(
                  'Mode:',
                  style: TextStyle(fontSize: 14.0, color: AppColors.darkGrey),
                ),

                Text(
                  order.status == 'In Progress'
                      ? 'Pick Up Delivery'
                      : 'Home Delivery',
                  style: TextStyle(
                    fontSize: 14.0,
                    color:
                        order.status == 'In Progress'
                            ? Colors.blue
                            : Colors.grey.shade700,
                    fontWeight:
                        order.status == 'In Progress'
                            ? FontWeight.bold
                            : FontWeight.normal,
                  ),
                ),
              ],
            ),
            5.verticalSpace,
           isComplete? CustomButton(borderRadius: 15, text: "View Details", onTap: (){
             Get.to(OrderDetailScreen(status: order.status));
           }):Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                order.status == 'In Progress'
                    ? OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.inACtiveButtonColor,
                        foregroundColor: Colors.grey.shade700,
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 10.0,
                        ),
                      ),
                      child:  Text('Cancel Order',
                        style: TextStyle(
                          color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 19.sp,
                        fontFamily: AppFonts.jakartaMedium,
                      ),
                      ),
                    )
                    : OutlinedButton(
                      onPressed: () {
                        Get.to(TrackOrderScreen());
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.inACtiveButtonColor,
                        foregroundColor: Colors.grey.shade700,
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 10.0,
                        ),
                      ),
                      child:  Text('Track Order',
    style: TextStyle(
      color: Colors.black,
    fontWeight: FontWeight.w600,
    fontSize: 19.sp,
    fontFamily: AppFonts.jakartaMedium,
    ),
                      ),
                    ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {

                    order.status == 'In Progress'
                        ? Get.to(OrderStatusScreen())
                        : Get.to(OrderDetailScreen(status: order.status,));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10.0,
                    ),
                  ),
                  child: Text(
                    order.status == 'In Progress'
                        ? 'View Status'
                        : 'View Detail',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 19.sp,
                      fontFamily: AppFonts.jakartaMedium,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import '../../../models/orders_model.dart';
import '../../../screens/patient_screens/order_screens/order_detail_screen.dart';
import '../../../screens/patient_screens/order_screens/order_status_screen.dart';
import '../../../screens/patient_screens/order_screens/track_order_screen.dart';

class OrderWidget extends StatelessWidget {
  final Order order;
  final bool isComplete;

  const OrderWidget({super.key, required this.order, this.isComplete = false});

  // Keep internal logic but use localized keys for comparison if necessary
  // Best practice: Model should hold keys, but here we adapt to current logic
  Color _getStatusColor(String status) {
    if (status == AppStrings.inProgress.tr) return Colors.blue;
    if (status == AppStrings.outForDelivered.tr) return Colors.green;
    if (status == AppStrings.awaitingConfirmation.tr) return Colors.orange;
    if (status == AppStrings.delivered.tr) return AppColors.green;
    if (status == AppStrings.cancelled.tr) return AppColors.red;
    return Colors.grey;
  }

  Color _getStatusTextColor(String status) {
    if (status == AppStrings.inProgress.tr) return AppColors.primaryColor;
    if (status == AppStrings.outForDelivered.tr) return AppColors.green;
    if (status == AppStrings.awaitingConfirmation.tr) return AppColors.orange;
    if (status == AppStrings.delivered.tr || status == AppStrings.cancelled.tr) return Colors.white;
    return Colors.grey.shade800;
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
                        '${AppStrings.order.tr} #${order.orderId} | ${order.date}',
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
            8.verticalSpace,
            Divider(color: AppColors.lightGrey.withOpacity(0.4),height:5,),
            8.verticalSpace,
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
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: Get.locale?.languageCode == 'fr' ? 10.sp : 11.sp,
                    ),
                  ),
                ),
                12.horizontalSpace,
                Text(
                  '${AppStrings.lastUpdate.tr}: ${order.lastUpdate}',
                  style: TextStyle(
                    fontSize: Get.locale?.languageCode == 'fr' ? 9.sp : 11.sp,
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
                  '${AppStrings.cost.tr}: ${order.cost}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
                const Spacer(),
                Text(
                  '${AppStrings.mode.tr}:',
                  style: TextStyle(fontSize: 14.0, color: AppColors.darkGrey),
                ),
                Text(
                  order.status == AppStrings.inProgress.tr
                      ? AppStrings.pickUpDelivery.tr
                      : AppStrings.homeDelivery.tr,
                  style: TextStyle(
                    fontSize: 14.0,
                    color:
                    order.status == AppStrings.inProgress.tr
                        ? Colors.blue
                        : Colors.grey.shade700,
                    fontWeight:
                    order.status == AppStrings.inProgress.tr
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
            5.verticalSpace,
            isComplete ? CustomButton(
                borderRadius: 15,
                text: AppStrings.viewDetail.tr,
                onTap: (){
                  Get.to(OrderDetailScreen(status: order.status));
                }) : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                order.status == AppStrings.inProgress.tr
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
                  child: Text(AppStrings.cancelOrder.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: Get.locale?.languageCode == 'fr' ? 14.sp : 19.sp,
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
                  child: Text(AppStrings.trackOrder.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: Get.locale?.languageCode == 'fr' ? 14.sp : 19.sp,
                      fontFamily: AppFonts.jakartaMedium,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    order.status == AppStrings.inProgress.tr
                        ? Get.to(OrderStatusScreen())
                        : Get.to(OrderDetailScreen(status: order.status,));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
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
                    order.status == AppStrings.inProgress.tr
                        ? AppStrings.viewStatus.tr
                        : AppStrings.viewDetail.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: Get.locale?.languageCode == 'fr' ? 14.sp : 19.sp,
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
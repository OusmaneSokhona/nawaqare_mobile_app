import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/order_controller.dart';
import 'package:patient_app/widgets/order_widgets/order_widget.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_images.dart';

class OrderScreen extends StatelessWidget {
  OrderScreen({super.key});
  OrderController orderController=Get.put(OrderController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.onboardingBackground, Colors.white,],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              70.verticalSpace,
              Row(
                children: [
                  InkWell(
                    onTap: (){
                      Get.back();
                    },
                    child: Image.asset(
                      AppImages.backIcon,
                      height: 33.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    "Orders",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              20.verticalSpace,
              Container(
                height: 55.h,
                width: 1.sw,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.sp),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                          () => InkWell(
                        onTap: () {
                          orderController.orderType.value =
                          "ongoingOrders";
                          orderController.searchQuery.value = '';
                        },
                        child: Container(
                          height: 55.h,
                          width: 0.455.sw,
                          decoration: BoxDecoration(
                            color:
                            orderController.orderType.value ==
                                "ongoingOrders"
                                ? AppColors.primaryColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14.sp),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Ongoing Orders",
                            style: TextStyle(
                              color:
                              orderController.orderType.value ==
                                  "ongoingOrders"
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 14.5.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: AppFonts.jakartaMedium,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Obx(
                          () => InkWell(
                        onTap: () {
                          orderController.orderType.value = "deliveryHistory";
                          orderController.searchQuery.value = '';
                        },
                        child: Container(
                          height: 55.h,
                          width: 0.455.sw,
                          decoration: BoxDecoration(
                            color:
                            orderController.orderType.value == "deliveryHistory"
                                ? AppColors.primaryColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14.sp),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Delivery History",
                            style: TextStyle(
                              color:
                              orderController.orderType.value == "deliveryHistory"
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 14.5.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: AppFonts.jakartaMedium,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              20.verticalSpace,
              Container(
                height: 55.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.sp),
                ),
                child: TextField(
                  onTapOutside: (_){
                    FocusManager.instance.primaryFocus!.unfocus();
                  },
                  onChanged: (value) {
                    orderController.searchQuery.value = value;
                  },
                  decoration: InputDecoration(
                    hintText: "Search by date,status...",
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[600],
                      size: 24.sp,
                    ),
                    suffixIcon: Icon(
                      Icons.filter_list_outlined,
                      color: AppColors.darkGrey,
                      size: 24.sp,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 18.h),
                  ),
                ),
              ),
              Obx(
                    () {
                  final filteredList = orderController.filteredOrders;
                  final isHistory = orderController.orderType.value == "deliveryHistory";

                  if (filteredList.isEmpty) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          "No orders found.",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }

                  return Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 20.h,bottom: 20.h,left: 0,right: 0),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        return OrderWidget(
                          isComplete: isHistory,
                          order: filteredList[index],
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
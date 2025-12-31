import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/order_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../../widgets/patient_widgets/order_widgets/order_widget.dart';

class OrderScreen extends StatelessWidget {
  OrderScreen({super.key});
  final OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.onboardingBackground, Colors.white],
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
                    onTap: () {
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
                    AppStrings.orders.tr,
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
                          orderController.orderType.value = "ongoingOrders";
                          orderController.searchQuery.value = '';
                          orderController.currentPage.value = 1;
                        },
                        child: Container(
                          height: 55.h,
                          width: 0.455.sw,
                          decoration: BoxDecoration(
                            color: orderController.orderType.value == "ongoingOrders"
                                ? AppColors.primaryColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14.sp),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            AppStrings.ongoingOrders.tr,
                            style: TextStyle(
                              color: orderController.orderType.value == "ongoingOrders"
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
                          orderController.currentPage.value = 1;
                        },
                        child: Container(
                          height: 55.h,
                          width: 0.455.sw,
                          decoration: BoxDecoration(
                            color: orderController.orderType.value == "deliveryHistory"
                                ? AppColors.primaryColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14.sp),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            AppStrings.deliveryHistory.tr,
                            style: TextStyle(
                              color: orderController.orderType.value == "deliveryHistory"
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
                  onTapOutside: (_) {
                    FocusManager.instance.primaryFocus!.unfocus();
                  },
                  onChanged: (value) {
                    orderController.searchQuery.value = value;
                    orderController.currentPage.value = 1;
                  },
                  decoration: InputDecoration(
                    hintText: AppStrings.searchOrderHint.tr,
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
              10.verticalSpace,
              Expanded(
                child: Obx(() {
                  final filteredList = orderController.paginatedList;
                  final isHistory = orderController.orderType.value == "deliveryHistory";

                  if (filteredList.isEmpty) {
                    return Center(
                      child: Text(
                        AppStrings.noOrdersFound.tr,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      return OrderWidget(
                        isComplete: isHistory,
                        order: filteredList[index],
                      );
                    },
                  );
                }),
              ),
              10.verticalSpace,
              _buildPagination(),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Obx(
          () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _paginationArrow(Icons.arrow_back, () {
            if (orderController.currentPage.value > 1) {
              orderController.currentPage.value--;
            }
          }),
          15.horizontalSpace,
          ...List.generate(orderController.totalPages, (index) {
            int page = index + 1;
            return GestureDetector(
              onTap: () => orderController.currentPage.value = page,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  "$page",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: AppFonts.jakartaMedium,
                    fontWeight: FontWeight.w600,
                    color: orderController.currentPage.value == page
                        ? AppColors.primaryColor
                        : Colors.grey,
                  ),
                ),
              ),
            );
          }),
          15.horizontalSpace,
          _paginationArrow(Icons.arrow_forward, () {
            if (orderController.currentPage.value < orderController.totalPages) {
              orderController.currentPage.value++;
            }
          }),
        ],
      ),
    );
  }

  Widget _paginationArrow(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 17.h,
          color: Colors.black,
        ),
      ),
    );
  }
}
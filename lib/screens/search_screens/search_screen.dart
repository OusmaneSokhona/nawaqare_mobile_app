import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/search_controller.dart';
import 'package:patient_app/screens/search_screens/search_doctor_detail_screen.dart';
import 'package:patient_app/widgets/search_widgets/doctor_widget.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../widgets/search_widgets/search_bottom_sheet.dart';
import '../notifications_screens/notifications_screen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  SearchControllerCustom searchController = Get.put(SearchControllerCustom());

  @override
  Widget build(BuildContext context) {
    // searchController.scrollChange(); // No longer needed here as it's in onInit
    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor,
              AppColors.primaryColor.withOpacity(0.01),
              AppColors.primaryColor.withOpacity(0.01),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Obx(() {
              final bool isScrolledPastThreshold =
                  searchController.scrollValue.value >= 330;

              final double targetHeight = isScrolledPastThreshold ? 120.0 : 0.0;

              final Color targetColor =
              isScrolledPastThreshold
                  ? AppColors.primaryColor
                  : Colors.transparent;

              return isScrolledPastThreshold
                  ? AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                height: targetHeight,
                width: 1.sw,
                color: targetColor,
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 8.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(13.sp),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: TextField(
                          onTapOutside: (_) {
                            FocusManager.instance.primaryFocus!.unfocus();
                          },
                          onChanged: searchController.updateSearchQuery, // Use controller method
                          decoration: InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none,
                            suffixIcon: InkWell(
                              onTap: (){
                                Get.bottomSheet(
                                  SearchBottomSheet(),
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.filter_list_outlined,
                                size: 20.sp,
                              ),
                            ),
                            icon: Icon(Icons.search, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: InkWell(
                        onTap: (){
                          Get.to(NotificationScreen());
                        },
                        child: Image.asset(
                          "assets/images/bell_icon.png",
                          height: 25.h,
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  : SizedBox();
            }),
            Expanded(
              child: SingleChildScrollView(
                controller: searchController.scrollController,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.sp),
                  child: Column(
                    children: [
                      60.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 35.h,
                            backgroundColor: Colors.white,
                            foregroundImage: AssetImage(
                              "assets/demo_images/home_demo_image.png",
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(NotificationScreen());
                            },
                            child: Image.asset(
                              "assets/images/bell_icon.png",
                              height: 30.h,
                            ),
                          ),
                        ],
                      ),
                      10.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Search",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 35.sp,
                            fontWeight: FontWeight.w800,
                            fontFamily: AppFonts.jakartaBold,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Let’s find a suitable doctor for you",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: AppFonts.jakartaMedium,
                            fontSize: 16.sp,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ),
                      15.verticalSpace,
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(13.sp),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: TextField(
                          onTapOutside: (_) {
                            FocusManager.instance.primaryFocus!.unfocus();
                          },
                          onChanged: searchController.updateSearchQuery, // Use controller method
                          decoration: InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none,
                            icon: Icon(Icons.search, color: Colors.grey),
                            suffixIcon: InkWell(
                              onTap: (){
                                Get.bottomSheet(
                                  SearchBottomSheet(),
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.filter_list_outlined,
                                size: 20.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      SizedBox(
                        height: 40.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: searchController.doctorsTypeList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(right: 8.sp),
                              child: Obx(
                                    ()=> InkWell(
                                  onTap: (){
                                    searchController.selectedCategory.value=searchController.doctorsTypeList[index];
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(12.sp),
                                    decoration: BoxDecoration(
                                      color:
                                      searchController.selectedCategory.value ==
                                          searchController
                                              .doctorsTypeList[index]
                                          ? AppColors.primaryColor
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Text(
                                      searchController.doctorsTypeList[index],
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color:
                                        searchController
                                            .selectedCategory
                                            .value ==
                                            searchController
                                                .doctorsTypeList[index]
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      10.verticalSpace,
                      Obx(
                            () => Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${searchController.doctorList.length} doctors found",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      Obx(
                            () => ListView.builder(
                          physics:NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 20.h,bottom: 20.h),
                          itemCount: searchController.doctorList.length,
                          itemBuilder: (context, index) {
                            return DoctorWidget(
                              onTap: (){
                                Get.to(SearchDoctorDetailScreen(model:searchController.doctorList[index],));
                              },
                              appointmentModel: searchController.doctorList[index],
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
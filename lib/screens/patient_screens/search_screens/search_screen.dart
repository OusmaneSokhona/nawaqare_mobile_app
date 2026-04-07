import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/search_controller.dart';
import 'package:patient_app/screens/patient_screens/search_screens/search_doctor_detail_screen.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../../controllers/patient_controllers/home_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../widgets/patient_widgets/search_widgets/doctor_widget.dart';
import '../../../widgets/patient_widgets/search_widgets/search_bottom_sheet.dart';
import '../notifications_screens/notifications_screen.dart';
import '../../help_center_screen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final SearchControllerCustom searchController = Get.put(SearchControllerCustom());
  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final user = homeController.currentUser.value;
        final userName = user?.fullName ?? 'User';
        final userImage = user?.patientData?.profileImage;

        if (searchController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        }

        return Container(
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
                final bool isScrolledPastThreshold = searchController.scrollValue.value >= 330;
                final double targetHeight = isScrolledPastThreshold ? 120.0 : 0.0;
                final Color targetColor = isScrolledPastThreshold ? AppColors.primaryColor : Colors.transparent;

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
                            onChanged: searchController.updateSearchQuery,
                            decoration: InputDecoration(
                              hintText: AppStrings.searchHint.tr,
                              border: InputBorder.none,
                              suffixIcon: InkWell(
                                onTap: () {
                                  Get.bottomSheet(
                                    isDismissible: false,
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
                              icon: const Icon(Icons.search, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      5.horizontalSpace,
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: InkWell(
                          onTap: () {
                            Get.to(HelpCenterScreen());
                          },
                          child: Image.asset(
                            "assets/images/help_center_icon.png",
                            height: 25.h,
                          ),
                        ),
                      ),
                      5.horizontalSpace,
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: InkWell(
                          onTap: () {
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
                    : const SizedBox();
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 35.h,
                              backgroundColor: Colors.white,
                              backgroundImage: userImage != null && userImage.isNotEmpty
                                  ? NetworkImage(userImage)
                                  : AssetImage("assets/demo_images/home_demo_image.png") as ImageProvider,
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                Get.to(HelpCenterScreen());
                              },
                              child: Image.asset(
                                "assets/images/help_center_icon.png",
                                height: 25.h,
                              ),
                            ),
                            5.horizontalSpace,
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
                            "${AppStrings.hello.tr}\n${userName}",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w800,
                              fontFamily: AppFonts.jakartaBold,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppStrings.findDoctorSub.tr,
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
                            onChanged: searchController.updateSearchQuery,
                            decoration: InputDecoration(
                              hintText: AppStrings.searchHint.tr,
                              border: InputBorder.none,
                              icon: const Icon(Icons.search, color: Colors.grey),
                              suffixIcon: InkWell(
                                onTap: () {
                                  Get.bottomSheet(
                                    isDismissible: false,
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
                            itemCount: searchController.availableSpecialties.length,
                            itemBuilder: (context, index) {
                              final specialty = searchController.availableSpecialties[index];
                              return Padding(
                                padding: EdgeInsets.only(right: 8.sp),
                                child: Obx(
                                      () => InkWell(
                                    onTap: () {
                                      searchController.selectedCategory.value = specialty;
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(12.sp),
                                      decoration: BoxDecoration(
                                        color: searchController.selectedCategory.value == specialty
                                            ? AppColors.primaryColor
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      child: Text(
                                        specialty,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: searchController.selectedCategory.value == specialty
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
                              "${searchController.filteredDoctorList.length} ${AppStrings.doctorsFound.tr}",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                        10.verticalSpace,
                        Obx(() {
                          var list = searchController.paginatedDoctorList;
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return DoctorWidget(
                                onTap: () {
                                  Get.to(
                                    SearchDoctorDetailScreen(
                                      doctor: list[index],
                                    ),
                                  );
                                },
                                doctor: list[index],
                              );
                            },
                          );
                        }),
                        10.verticalSpace,
                        _buildPagination(),
                        20.verticalSpace,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPagination() {
    return Obx(
          () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _paginationArrow(Icons.arrow_back, () {
            if (searchController.currentPage.value > 1) {
              searchController.currentPage.value--;
              searchController.scrollValue.value = 0.0;
            }
          }),
          15.horizontalSpace,
          ...List.generate(searchController.totalPages, (index) {
            int page = index + 1;
            return GestureDetector(
              onTap: () { searchController.currentPage.value = page; searchController.scrollValue.value = 0.0; },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  "$page",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: AppFonts.jakartaMedium,
                    fontWeight: FontWeight.w600,
                    color: searchController.currentPage.value == page ? AppColors.primaryColor : Colors.grey,
                  ),
                ),
              ),
            );
          }),
          15.horizontalSpace,
          _paginationArrow(Icons.arrow_forward, () {
            if (searchController.currentPage.value < searchController.totalPages) {
              searchController.currentPage.value++;
              searchController.scrollValue.value = 0.0;
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
              offset: const Offset(0, 2),
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
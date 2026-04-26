// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:patient_app/controllers/patient_controllers/payment_controller.dart';
// import 'package:patient_app/screens/patient_screens/main_screen.dart';
// import 'package:patient_app/utils/app_strings.dart';
// import 'package:patient_app/widgets/patient_widgets/search_widgets/appointment_confimation_dialog.dart';
// import '../../../utils/app_colors.dart';
// import '../../../utils/app_fonts.dart';
// import '../../../utils/app_images.dart';
// import '../../../widgets/custom_button.dart';
// import '../../../widgets/progress_stepper.dart';
//
// class PaymentScreen extends StatelessWidget {
//   PaymentScreen({super.key});
//
//   final PaymentController paymentController = Get.put(PaymentController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: 1.sh,
//         width: 1.sw,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [AppColors.onboardingBackground, Colors.white],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w),
//           child: Column(
//             children: [
//               70.verticalSpace,
//               _buildHeader(),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       30.verticalSpace,
//                       _buildProgressStepper(),
//                       30.verticalSpace,
//                       _buildStripePaymentMethods(),
//                       30.verticalSpace,
//                       _buildPaymentStatus(),
//                       20.verticalSpace,
//                       _buildActionButtons(),
//                       30.verticalSpace,
//                       _buildOrderSummary(),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Row(
//       children: [
//         InkWell(
//           onTap: () => Get.back(),
//           child: Image.asset(
//             AppImages.backIcon,
//             height: 33.h,
//             fit: BoxFit.fill,
//           ),
//         ),
//         10.horizontalSpace,
//         Text(
//           AppStrings.payment.tr,
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 23.sp,
//             fontWeight: FontWeight.w800,
//             fontFamily: AppFonts.jakartaBold,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildProgressStepper() {
//     return Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.only(right: 13.sp),
//           child: const ProgressStepper(currentStep: 3, totalSteps: 3),
//         ),
//         5.verticalSpace,
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Text(
//               AppStrings.section.tr,
//               style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.sp),
//             ),
//             100.horizontalSpace,
//             Text(
//               AppStrings.details.tr,
//               style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.sp),
//             ),
//             const Spacer(),
//             Text(
//               AppStrings.confirmation.tr,
//               style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.sp),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStripePaymentMethods() {
//     return Obx(
//           () => Container(
//         width: double.infinity,
//         padding: EdgeInsets.all(16.w),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12.r),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 10,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Payment Methods',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 18.sp,
//                 fontFamily: AppFonts.jakartaBold,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             if (paymentController.isLoadingPaymentIntent.value)
//               Container(
//                 padding: EdgeInsets.all(30.w),
//                 child: Center(
//                   child: Column(
//                     children: [
//                       CircularProgressIndicator(
//                         color: AppColors.primaryColor,
//                       ),
//                       15.verticalSpace,
//                       Text(
//                         'Loading payment methods...',
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           color: Colors.grey[600],
//                           fontFamily: AppFonts.jakartaRegular,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//             else if (paymentController.paymentIntentError.value.isNotEmpty)
//               Container(
//                 padding: EdgeInsets.all(20.w),
//                 decoration: BoxDecoration(
//                   color: Colors.red.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8.r),
//                 ),
//                 child: Column(
//                   children: [
//                     Icon(
//                       Icons.error_outline,
//                       color: Colors.red,
//                       size: 50.sp,
//                     ),
//                     10.verticalSpace,
//                     Text(
//                       paymentController.paymentIntentError.value,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: Colors.red,
//                         fontSize: 14.sp,
//                         fontFamily: AppFonts.jakartaMedium,
//                       ),
//                     ),
//                     15.verticalSpace,
//                     CustomButton(
//                       borderRadius: 8,
//                       text: 'Retry',
//                       onTap: () => paymentController.createPaymentIntent(),
//                       height: 40.h,
//                     ),
//                   ],
//                 ),
//               )
//             else if (paymentController.availablePaymentMethods.isEmpty)
//                 Container(
//                   padding: EdgeInsets.all(20.w),
//                   child: Center(
//                     child: Text(
//                       'No payment methods available',
//                       style: TextStyle(
//                         fontSize: 14.sp,
//                         color: Colors.grey[600],
//                         fontFamily: AppFonts.jakartaRegular,
//                       ),
//                     ),
//                   ),
//                 )
//               else
//                 ListView.builder(
//                   padding: EdgeInsets.only(top: 10.h),
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: paymentController.availablePaymentMethods.length,
//                   itemBuilder: (context, index) {
//                     final method = paymentController.availablePaymentMethods[index];
//                     return Obx(
//                       ()=> _buildPaymentMethodCard(
//                         method: method,
//                         isSelected: paymentController.selectedPaymentMethod.value == method['id'],
//                         onTap: () => paymentController.selectPaymentMethod(method['id']),
//                       ),
//                     );
//                   },
//                 ),
//             15.verticalSpace,
//             if (paymentController.clientSecret.value.isNotEmpty && !paymentController.isLoadingPaymentIntent.value)
//               Container(
//                 padding: EdgeInsets.all(12.w),
//                 decoration: BoxDecoration(
//                   color: AppColors.primaryColor.withOpacity(0.05),
//                   borderRadius: BorderRadius.circular(8.r),
//                   border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.lock_outline, color: AppColors.primaryColor, size: 18.sp),
//                     10.horizontalSpace,
//                     Expanded(
//                       child: Text(
//                         'Secured by Stripe',
//                         style: TextStyle(
//                           fontSize: 12.sp,
//                           color: AppColors.primaryColor,
//                           fontFamily: AppFonts.jakartaMedium,
//                         ),
//                       ),
//                     ),
//                     Image.asset(
//                       "assets/images/stripe_icon.gif",
//                       height: 30.h,
//                       fit: BoxFit.contain,
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPaymentMethodCard({
//     required Map<String, dynamic> method,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     IconData getIconForMethod() {
//       switch (method['type']) {
//         case 'card':
//           return Icons.credit_card;
//         case 'google_pay':
//           return Icons.account_balance_wallet;
//         case 'apple_pay':
//           return Icons.apple;
//         case 'bank_transfer':
//           return Icons.account_balance;
//         case 'ideal':
//           return Icons.euro;
//         default:
//           return Icons.payment;
//       }
//     }
//
//     String getMethodName() {
//       switch (method['type']) {
//         case 'card':
//           return 'Credit / Debit Card';
//         case 'google_pay':
//           return 'Google Pay';
//         case 'apple_pay':
//           return 'Apple Pay';
//         case 'bank_transfer':
//           return 'Bank Transfer';
//         case 'ideal':
//           return 'iDEAL';
//         default:
//           return method['type']?.toString().replaceAll('_', ' ').toUpperCase() ?? 'Payment Method';
//       }
//     }
//
//     String getMethodDescription() {
//       switch (method['type']) {
//         case 'card':
//           return 'Pay with Visa, Mastercard, American Express';
//         case 'google_pay':
//           return 'Fast and secure payment with Google';
//         case 'apple_pay':
//           return 'Pay with Apple Pay';
//         case 'bank_transfer':
//           return 'Pay directly from your bank account';
//         case 'ideal':
//           return 'Pay with your Dutch bank';
//         default:
//           return 'Secure payment via Stripe';
//       }
//     }
//
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12.r),
//       child: Container(
//         margin: EdgeInsets.only(bottom: 10.h),
//         padding: EdgeInsets.all(16.w),
//         decoration: BoxDecoration(
//           color: isSelected ? AppColors.primaryColor.withOpacity(0.05) : Colors.grey[50],
//           borderRadius: BorderRadius.circular(12.r),
//           border: Border.all(
//             color: isSelected ? AppColors.primaryColor : Colors.grey.withOpacity(0.2),
//             width: isSelected ? 2 : 1,
//           ),
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: EdgeInsets.all(10.w),
//               decoration: BoxDecoration(
//                 color: isSelected ? AppColors.primaryColor : Colors.grey[200],
//                 borderRadius: BorderRadius.circular(10.r),
//               ),
//               child: Icon(
//                 getIconForMethod(),
//                 color: isSelected ? Colors.white : Colors.grey[600],
//                 size: 24.sp,
//               ),
//             ),
//             15.horizontalSpace,
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     getMethodName(),
//                     style: TextStyle(
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w600,
//                       fontFamily: AppFonts.jakartaBold,
//                       color: isSelected ? AppColors.primaryColor : Colors.black,
//                     ),
//                   ),
//                   5.verticalSpace,
//                   Text(
//                     getMethodDescription(),
//                     style: TextStyle(
//                       fontSize: 12.sp,
//                       color: Colors.grey[600],
//                       fontFamily: AppFonts.jakartaRegular,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             if (isSelected)
//               Icon(
//                 Icons.check_circle,
//                 color: AppColors.primaryColor,
//                 size: 24.sp,
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPaymentStatus() {
//     return Obx(
//           () => Column(
//         children: [
//           if (paymentController.paymentError.value.isNotEmpty)
//             Container(
//               padding: EdgeInsets.all(12.w),
//               margin: EdgeInsets.only(bottom: 16.h),
//               decoration: BoxDecoration(
//                 color: AppColors.red.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8.r),
//                 border: Border.all(color: AppColors.red.withOpacity(0.3)),
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.error_outline, color: AppColors.red, size: 20.sp),
//                   10.horizontalSpace,
//                   Expanded(
//                     child: Text(
//                       paymentController.paymentError.value,
//                       style: TextStyle(
//                         color: AppColors.red,
//                         fontSize: 14.sp,
//                         fontFamily: AppFonts.jakartaMedium,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           if (paymentController.isProcessingPayment.value)
//             Container(
//               padding: EdgeInsets.all(16.w),
//               margin: EdgeInsets.only(bottom: 16.h),
//               decoration: BoxDecoration(
//                 color: AppColors.primaryColor.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8.r),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     height: 20.w,
//                     width: 20.w,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       valueColor: AlwaysStoppedAnimation<Color>(
//                         AppColors.primaryColor,
//                       ),
//                     ),
//                   ),
//                   10.horizontalSpace,
//                   Text(
//                     "Processing payment...",
//                     style: TextStyle(
//                       color: AppColors.primaryColor,
//                       fontSize: 14.sp,
//                       fontFamily: AppFonts.jakartaMedium,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildOrderSummary() {
//     return Container(
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(12.r),
//         border: Border.all(color: AppColors.lightGrey.withOpacity(0.3)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Order Summary',
//             style: TextStyle(
//               fontSize: 16.sp,
//               fontWeight: FontWeight.w600,
//               fontFamily: AppFonts.jakartaBold,
//             ),
//           ),
//           15.verticalSpace,
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Consultation Fee',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   color: Colors.grey[600],
//                   fontFamily: AppFonts.jakartaRegular,
//                 ),
//               ),
//               Text(
//                 '\$${(paymentController.paymentAmount / 100).toStringAsFixed(2)}',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w600,
//                   fontFamily: AppFonts.jakartaBold,
//                 ),
//               ),
//             ],
//           ),
//           Divider(height: 20.h),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Total',
//                 style: TextStyle(
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.w700,
//                   fontFamily: AppFonts.jakartaBold,
//                 ),
//               ),
//               Text(
//                 '\$${(paymentController.paymentAmount / 100).toStringAsFixed(2)}',
//                 style: TextStyle(
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.primaryColor,
//                   fontFamily: AppFonts.jakartaBold,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildActionButtons() {
//     return Column(
//       children: [
//         Obx(
//               () => CustomButton(
//             borderRadius: 15,
//             text: paymentController.isProcessingPayment.value
//                 ? 'Processing...'
//                 : paymentController.selectedPaymentMethod.value.isEmpty
//                 ? 'Select a Payment Method'
//                 : 'Pay \$${(paymentController.paymentAmount / 100).toStringAsFixed(2)}',
//             onTap: paymentController.isProcessingPayment.value ||
//                 paymentController.selectedPaymentMethod.value.isEmpty
//                 ? () {}
//                 : () {
//               paymentController.processPayment().then((paymentSuccess) {
//                 if (paymentSuccess) {
//                   Get.dialog(
//                     barrierDismissible: false,
//                     AppointmentConfirmationDialog(
//                       doctorName: "Dr. Daniel",
//                       date: "12/02/26",
//                       time: "10:30",
//                       onDone: () {
//                         paymentController.resetPaymentState();
//                         Get.offAll(MainScreen());
//                       },
//                       onViewDetails: () {
//                         Get.back();
//                       },
//                     ),
//                   );
//                 }
//               });
//             },
//           ),
//         ),
//         15.verticalSpace,
//         CustomButton(
//           borderRadius: 15,
//           text: 'Cancel',
//           bgColor: AppColors.inACtiveButtonColor,
//           fontColor: Colors.black,
//           onTap: () {
//             paymentController.resetPaymentState();
//             Get.back();
//           },
//         ),
//       ],
//     );
//   }
// }
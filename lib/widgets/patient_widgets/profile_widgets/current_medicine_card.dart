// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:patient_app/models/medical_history_model.dart';
// import 'package:patient_app/utils/app_colors.dart';
// import 'package:patient_app/utils/app_strings.dart';
//
// class CurrentMedicineCard extends StatelessWidget {
//   final Function onTap;
//   final MedicalHistoryResponse medicalHistoryModel;
//
//   CurrentMedicineCard({required this.medicalHistoryModel, super.key, required this.onTap});
//
//   Color _getStatusColor(String status) {
//     if (status.toLowerCase() == "active") return AppColors.primaryColor;
//     if (status.toLowerCase() == "in progress") return AppColors.orange;
//     if (status.toLowerCase() == "expired") return AppColors.red;
//     if (status.toLowerCase() == "completed") return AppColors.green;
//     return Colors.grey;
//   }
//
//   String _getLocalizedStatus(String status) {
//     switch (status.toLowerCase()) {
//       case "active":
//         return AppStrings.active.tr;
//       case "in progress":
//         return AppStrings.inProgress.tr;
//       case "expired":
//         return AppStrings.expired.tr;
//       case "completed":
//         return AppStrings.completed.tr;
//       default:
//         return status;
//     }
//   }
//
//   Widget _buildStatusChip(String status) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
//       decoration: BoxDecoration(
//         color: _getStatusColor(status),
//         borderRadius: BorderRadius.circular(20.r),
//       ),
//       child: Text(
//         _getLocalizedStatus(status),
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 11.sp,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 8.h),
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       medicalHistoryModel.medicineName ?? 'Unknown Medicine',
//                       style: TextStyle(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.bold,
//                         color: const Color(0xFF333333),
//                       ),
//                     ),
//                     Text(
//                       'Doctor ID: ${medicalHistoryModel.doctorId ?? 'N/A'}',
//                       style: TextStyle(
//                         fontSize: 12.sp,
//                         color: const Color(0xFF666666),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               _buildStatusChip(medicalHistoryModel.status ?? 'Unknown'),
//             ],
//           ),
//           5.verticalSpace,
//           const Divider(),
//           5.verticalSpace,
//           Row(
//             children: [
//               Icon(Icons.medication, size: 16.sp, color: AppColors.primaryColor),
//               8.horizontalSpace,
//               Text(
//                 'Dosage: ${medicalHistoryModel.dosage ?? 'N/A'}',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w500,
//                   color: const Color(0xFF333333),
//                 ),
//               ),
//             ],
//           ),
//           8.verticalSpace,
//           if (medicalHistoryModel.refill != null)
//             Row(
//               children: [
//                 Icon(Icons.refresh, size: 16.sp, color: AppColors.lightGrey),
//                 8.horizontalSpace,
//                 Text(
//                   '${AppStrings.refillsLeft.tr}: ${medicalHistoryModel.refill}',
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w500,
//                     color: AppColors.lightGrey,
//                   ),
//                 ),
//               ],
//             ),
//         ],
//       ),
//     );
//   }
// }
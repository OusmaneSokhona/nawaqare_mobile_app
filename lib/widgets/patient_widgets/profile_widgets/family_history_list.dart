// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import '../../../controllers/patient_controllers/medical_history_controller.dart';
// import '../../../screens/patient_screens/profile_screens/family_history_card.dart';
//
// class FamilyHistoryList extends StatelessWidget {
//   const FamilyHistoryList({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final MedicalHistoryController controller = Get.find<MedicalHistoryController>();
//
//     return Obx(() {
//       if (controller.isLoading.value && controller.apiFamilyHistoryList.isEmpty) {
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       }
//
//       if (controller.apiFamilyHistoryList.isEmpty) {
//         return Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.family_restroom,
//                 size: 64,
//                 color: Colors.grey[400],
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 'No family history records',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey[600],
//                 ),
//               ),
//             ],
//           ),
//         );
//       }
//
//       return ListView.builder(
//         shrinkWrap: true,
//         padding: EdgeInsets.zero,
//         physics: const AlwaysScrollableScrollPhysics(),
//         itemCount: controller.apiFamilyHistoryList.length,
//         itemBuilder: (context, index) {
//           final history = controller.apiFamilyHistoryList[index];
//           return Column(
//             children: [
//               FamilyHistoryCard(familyHistory: history),
//               if (index < controller.apiFamilyHistoryList.length - 1)
//                 5.verticalSpace,
//             ],
//           );
//         },
//       );
//     });
//   }
// }
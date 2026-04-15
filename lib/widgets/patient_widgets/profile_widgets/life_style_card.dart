// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../controllers/patient_controllers/medical_history_controller.dart';
// import '../../../utils/app_strings.dart';
//
// class LifestyleCard extends StatelessWidget {
//   const LifestyleCard({super.key});
//
//   Widget _buildLifestyleItem(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   color: Color(0xFF1F2937),
//                 ),
//               ),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                   color: Color(0xFF1F2937),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           const Divider(height: 1, color: Color(0xFFF3F4F6)),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final MedicalHistoryController controller = Get.find<MedicalHistoryController>();
//
//     return Obx(() {
//       if (controller.isLoading.value && controller.lifestyleData.value == null) {
//         return const Card(
//           elevation: 4,
//           color: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(16.0)),
//           ),
//           child: Padding(
//             padding: EdgeInsets.all(20.0),
//             child: Center(
//               child: CircularProgressIndicator(),
//             ),
//           ),
//         );
//       }
//
//       final lifestyle = controller.lifestyleData.value;
//
//       return Card(
//         elevation: 4,
//         color: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16.0),
//         ),
//         child: Container(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               if (lifestyle != null) ...[
//                 _buildLifestyleItem(
//                     AppStrings.smoking.tr,
//                     lifestyle.capitalizedSmoking.isEmpty ? 'Not specified' : lifestyle.capitalizedSmoking
//                 ),
//                 _buildLifestyleItem(
//                     AppStrings.alcoholUse.tr,
//                     lifestyle.capitalizedAlcohol.isEmpty ? 'Not specified' : lifestyle.capitalizedAlcohol
//                 ),
//                 _buildLifestyleItem(
//                     AppStrings.physicalActivity.tr,
//                     lifestyle.capitalizedPhysicalActivity.isEmpty ? 'Not specified' : lifestyle.capitalizedPhysicalActivity
//                 ),
//                 _buildLifestyleItem(
//                     AppStrings.dietType.tr,
//                     lifestyle.capitalizedDietType.isEmpty ? 'Not specified' : lifestyle.capitalizedDietType
//                 ),
//                 _buildLifestyleItem(
//                     AppStrings.sleepQuality.tr,
//                     lifestyle.capitalizedSleepQuality.isEmpty ? 'Not specified' : lifestyle.capitalizedSleepQuality
//                 ),
//               ] else ...[
//                 _buildLifestyleItem(AppStrings.smoking.tr, 'No data'),
//                 _buildLifestyleItem(AppStrings.alcoholUse.tr, 'No data'),
//                 _buildLifestyleItem(AppStrings.physicalActivity.tr, 'No data'),
//                 _buildLifestyleItem(AppStrings.dietType.tr, 'No data'),
//                 _buildLifestyleItem(AppStrings.sleepQuality.tr, 'No data'),
//               ],
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }
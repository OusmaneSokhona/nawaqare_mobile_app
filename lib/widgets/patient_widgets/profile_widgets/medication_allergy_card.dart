import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:patient_app/controllers/patient_controllers/allergies_controller.dart';
import 'package:patient_app/screens/document_view_screen.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../../models/allergy_model.dart';
import '../../../screens/patient_screens/profile_screens/edit_allergy_screen.dart';

class MedicationAllergyCard extends StatelessWidget {
  final Allergy data;

   MedicationAllergyCard({required this.data, super.key});

  Color _getSeverityColor() {
    switch (data.severity.toLowerCase()) {
      case "severe":
        return AppColors.orange;
      case "moderate":
        return AppColors.orange.withOpacity(0.7);
      case "mild":
        return AppColors.green;
      default:
        return AppColors.red;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
AllergyController controller = Get.find<AllergyController>();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
       print('Tapped on allergy: ${data.allergyType} - ${data.allergenName}   ${data.photo}   ${data.notes}  ${data.reaction}  ${data.severity}  ${data.notes}');
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.allergyType,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data.allergenName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _showDeleteConfirmation(data.id);
                    },
                    child: const Icon(
                      Icons.delete_outline,
                      color: AppColors.red,
                    ),
                  ),
                  3.horizontalSpace,
                  InkWell(
                    onTap: () {
                        Get.to(() => EditAllergyScreen(allergy: data));
                    },
                    child: const Icon(
                      Icons.edit_calendar_outlined,
                      color: Color(0xFF3B82F6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildInfoColumn(
                        AppStrings.reaction.tr,
                        data.reaction,
                      ),
                    ),
                    Expanded(
                      child: _buildInfoColumn(
                        AppStrings.severity.tr,
                        data.severity.capitalizeFirst ?? data.severity,
                      ),
                    ),
                    Expanded(
                      child: _buildInfoColumn(
                        AppStrings.dateIdentified.tr,
                        _formatDate(data.dateIdentified),
                      ),
                    ),
                  ],
                ),
              ),

                const Divider(height: 24, thickness: 1, color: Color(0xFFE5E7EB)),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (data.photo != null && data.photo!.isNotEmpty) ...[
                            InkWell(
                              onTap: () {
                                Get.to(DocumentViewerScreen(documentUrl: data.photo!, fileName: data.allergenName));
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.image,
                                    color: Color(0xFF3B82F6),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      'Attached Image',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF3B82F6),
                                        decoration: TextDecoration.underline,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          (data.notes!=null&&data.notes.isNotEmpty)?Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '${AppStrings.noteLabel.tr}: ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1F2937),
                                    fontSize: 14,
                                  ),
                                ),
                                TextSpan(
                                  text: data.notes,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF1F2937),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ):const SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
  void _showDeleteConfirmation(String id) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Allergy?'),
        content: const Text('Are you sure you want to remove this record? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              controller.deleteItem(id); // Call delete function
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
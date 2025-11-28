import 'package:flutter/material.dart';
import 'package:patient_app/utils/app_colors.dart';

class TemplateCard extends StatelessWidget {
  final String title;
  final String category;
  final String details;
  final String lastUpdate;
  final VoidCallback onEdit;
  final VoidCallback onUse;

  const TemplateCard({
    super.key,
    required this.title,
    required this.category,
    required this.details,
    required this.lastUpdate,
    required this.onEdit,
    required this.onUse,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              details,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              'last update: $lastUpdate',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
              ),
            ),

            const SizedBox(height: 16),

            Divider(color: Colors.grey.shade300, thickness: 1),

            const SizedBox(height: 16),

            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.inACtiveButtonColor,
                      foregroundColor: Colors.black87,
                      side: BorderSide.none,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: onEdit,
                    child: const Text(
                      'Edit Set',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: onUse,
                    child: const Text(
                      'Use Template',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
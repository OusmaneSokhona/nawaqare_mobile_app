import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/profile_controller.dart';
import 'package:patient_app/utils/app_fonts.dart';

class LanguageDialog extends StatelessWidget {
  const LanguageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find();

    const List<String> availableLanguages = ['French', 'English'];

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Title
            const Text(
              'Language Support',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Subtitle
            Text(
              'Ensure accessibility and usability of the application across multiple language',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 14),

           Text("Language",style: TextStyle(fontWeight: FontWeight.w600,fontFamily: AppFonts.jakartaMedium),),
            Obx(
                  () => Column(
                children: availableLanguages.map((language) {
                  return _buildLanguageOption(
                    context,
                    controller: controller,
                    language: language,
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 4),

            // Action Buttons
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back(result: false);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: const Text(
                      'Cancle',
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Pass back the selected language on confirmation
                      Get.back(result: controller.selectedLanguage.value);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(fontWeight: FontWeight.bold),
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

  Widget _buildLanguageOption(
      BuildContext context, {
        required ProfileController controller,
        required String language,
      }) {
    return InkWell(
      onTap: () => controller.setLanguage(language),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        child: Row(
          children: [
            Radio<String>(
              value: language,
              groupValue: controller.selectedLanguage.value,
              onChanged: controller.setLanguage,
              activeColor: Colors.blue[600],
            ),
            Text(
              language,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
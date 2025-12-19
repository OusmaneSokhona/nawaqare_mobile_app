import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/profile_controller.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_strings.dart';

class LanguageDialog extends StatelessWidget {
  LanguageDialog({super.key});
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final List<String> availableLanguages = [AppStrings.french, AppStrings.english];

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
            Text(
              AppStrings.langSupport.tr,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.langDescription.tr,
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 14),
            Text(
              AppStrings.language.tr,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: AppFonts.jakartaMedium,
              ),
            ),
            Obx(
                  () => Column(
                children: availableLanguages.map((language) {
                  return _buildLanguageOption(
                    context,
                    controller: controller,
                    languageKey: language,
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(result: false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      AppStrings.cancel.tr,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (controller.selectedLanguage.value == AppStrings.french) {
                        Get.updateLocale(const Locale('fr', 'FR'));
                      } else {
                        Get.updateLocale(const Locale('en', 'US'));
                      }
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
                    child: Text(
                      AppStrings.confirm.tr,
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
        required String languageKey,
      }) {
    return InkWell(
      onTap: () => controller.setLanguage(languageKey),
      child: Row(
        children: [
          Radio<String>(
            value: languageKey,
            groupValue: controller.selectedLanguage.value,
            onChanged: (val) => controller.setLanguage(val!),
            activeColor: Colors.blue[600],
          ),
          Text(
            languageKey.tr,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
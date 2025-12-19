import 'package:get/get.dart';
import '../utils/app_strings.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      AppStrings.langSupport: "Language Support",
      AppStrings.langDescription: "Ensure accessibility and usability of the application across multiple languages.",
      AppStrings.language: "Language",
      AppStrings.cancel: "Cancel",
      AppStrings.confirm: "Confirm",
      AppStrings.french: "French",
      AppStrings.english: "English",
    },
    'fr_FR': {
      AppStrings.langSupport: "Support Linguistique",
      AppStrings.langDescription: "Assurer l'accessibilité et la convivialité de l'application dans plusieurs langues.",
      AppStrings.language: "Langue",
      AppStrings.cancel: "Annuler",
      AppStrings.confirm: "Confirmer",
      AppStrings.french: "Français",
      AppStrings.english: "Anglais",
    },
  };
}
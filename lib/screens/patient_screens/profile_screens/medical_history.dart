import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/medical_history_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import 'add_edit_medicalentry_Screen.dart';

class MedicalHistory extends StatelessWidget {
  MedicalHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final MedicalHistoryController controller = Get.put(MedicalHistoryController());

    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.onboardingBackground, AppColors.lightWhite],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value && controller.medicalHistoryData.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 60.h, left: 20.w, right: 20.w),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Get.back(),
                      child: Image.asset(
                        AppImages.backIcon,
                        height: 30.h,
                      ),
                    ),
                    10.horizontalSpace,
                    Text(
                      AppStrings.medicalHistory.tr,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                        fontFamily: AppFonts.jakartaBold,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.file_upload_outlined, color: AppColors.primaryColor, size: 24.sp),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionCard(
                        title: "Problem History",
                        type: "addProblem",
                        hasData: controller.medicalHistoryData.containsKey('addProblem') && controller.medicalHistoryData['addProblem'] != null,
                        dataWidget: controller.medicalHistoryData.containsKey('addProblem') && controller.medicalHistoryData['addProblem'] != null
                            ? _buildProblemHistoryCard(
                          controller.medicalHistoryData['addProblem'],
                          controller.medicalHistoryData['_id']?.toString() ?? '',
                          controller,
                        )
                            : null,
                        onAdd: () => _navigateToAddScreen(controller, 'problem'),
                      ),
                      20.verticalSpace,
                      _buildSectionCard(
                        title: "Allergies and intolerances",
                        type: "addAllergical",
                        hasData: controller.medicalHistoryData.containsKey('addAllergical') && controller.medicalHistoryData['addAllergical'] != null,
                        dataWidget: controller.medicalHistoryData.containsKey('addAllergical') && controller.medicalHistoryData['addAllergical'] != null
                            ? _buildAllergiesCard(
                          controller.medicalHistoryData['addAllergical'],
                          controller.medicalHistoryData['_id']?.toString() ?? '',
                          controller,
                        )
                            : null,
                        onAdd: () => _navigateToAddScreen(controller, 'allergy'),
                      ),
                      20.verticalSpace,
                      _buildSectionCard(
                        title: "Current medications",
                        type: "addMedications",
                        hasData: controller.medicalHistoryData.containsKey('addMedications') && controller.medicalHistoryData['addMedications'] != null,
                        dataWidget: controller.medicalHistoryData.containsKey('addMedications') && controller.medicalHistoryData['addMedications'] != null
                            ? _buildCurrentMedicationsCard(
                          controller.medicalHistoryData['addMedications'],
                          controller.medicalHistoryData['_id']?.toString() ?? '',
                          controller,
                        )
                            : null,
                        onAdd: () => _navigateToAddScreen(controller, 'medication'),
                      ),
                      20.verticalSpace,
                      _buildSectionCard(
                        title: "Family history",
                        type: "addFamilyHistory",
                        hasData: controller.medicalHistoryData.containsKey('addFamilyHistory') && controller.medicalHistoryData['addFamilyHistory'] != null,
                        dataWidget: controller.medicalHistoryData.containsKey('addFamilyHistory') && controller.medicalHistoryData['addFamilyHistory'] != null
                            ? _buildFamilyHistoryCard(
                          controller.medicalHistoryData['addFamilyHistory'],
                          controller.medicalHistoryData['_id']?.toString() ?? '',
                          controller,
                        )
                            : null,
                        onAdd: () => _navigateToAddScreen(controller, 'familyHistory'),
                      ),
                      20.verticalSpace,
                      _buildSectionCard(
                        title: "Vaccinations",
                        type: "addVaccinations",
                        hasData: controller.medicalHistoryData.containsKey('addVaccinations') && controller.medicalHistoryData['addVaccinations'] != null,
                        dataWidget: controller.medicalHistoryData.containsKey('addVaccinations') && controller.medicalHistoryData['addVaccinations'] != null
                            ? _buildVaccinationsCard(
                          controller.medicalHistoryData['addVaccinations'],
                          controller.medicalHistoryData['_id']?.toString() ?? '',
                          controller,
                        )
                            : null,
                        onAdd: () => _navigateToAddScreen(controller, 'vaccination'),
                      ),
                      20.verticalSpace,
                      _buildSectionCard(
                        title: "Baseline vitals",
                        type: "addVitals",
                        hasData: controller.medicalHistoryData.containsKey('addVitals') && controller.medicalHistoryData['addVitals'] != null,
                        dataWidget: controller.medicalHistoryData.containsKey('addVitals') && controller.medicalHistoryData['addVitals'] != null
                            ? _buildBaselineVitalsCard(
                          controller.medicalHistoryData['addVitals'],
                          controller.medicalHistoryData['updatedAt']?.toString() ?? '',
                          controller.medicalHistoryData['_id']?.toString() ?? '',
                          controller,
                        )
                            : null,
                        onAdd: () => _navigateToAddScreen(controller, 'vitals'),
                      ),
                      20.verticalSpace,
                      _buildSectionCard(
                        title: "Surgical history",
                        type: "addSurgical",
                        hasData: controller.medicalHistoryData.containsKey('addSurgical') && controller.medicalHistoryData['addSurgical'] != null,
                        dataWidget: controller.medicalHistoryData.containsKey('addSurgical') && controller.medicalHistoryData['addSurgical'] != null
                            ? _buildSurgicalHistoryCard(
                          controller.medicalHistoryData['addSurgical'],
                          controller.medicalHistoryData['_id']?.toString() ?? '',
                          controller,
                        )
                            : null,
                        onAdd: () => _navigateToAddScreen(controller, 'surgical'),
                      ),
                      20.verticalSpace,
                      _buildSectionCard(
                        title: "Infectious history",
                        type: "addInfectional",
                        hasData: controller.medicalHistoryData.containsKey('addInfectional') && controller.medicalHistoryData['addInfectional'] != null,
                        dataWidget: controller.medicalHistoryData.containsKey('addInfectional') && controller.medicalHistoryData['addInfectional'] != null
                            ? _buildInfectiousHistoryCard(
                          controller.medicalHistoryData['addInfectional'],
                          controller.medicalHistoryData['_id']?.toString() ?? '',
                          controller,
                        )
                            : null,
                        onAdd: () => _navigateToAddScreen(controller, 'infection'),
                      ),
                      20.verticalSpace,
                      _buildSectionCard(
                        title: "Lifestyle habits / risk factors",
                        type: "addLifestyle",
                        hasData: controller.medicalHistoryData.containsKey('addLifestyle') && controller.medicalHistoryData['addLifestyle'] != null,
                        dataWidget: controller.medicalHistoryData.containsKey('addLifestyle') && controller.medicalHistoryData['addLifestyle'] != null
                            ? _buildLifestyleCard(
                          controller.medicalHistoryData['addLifestyle'],
                          controller.medicalHistoryData['_id']?.toString() ?? '',
                          controller,
                        )
                            : null,
                        onAdd: () => _navigateToAddScreen(controller, 'lifestyle'),
                      ),
                      40.verticalSpace,
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _navigateToAddScreen(MedicalHistoryController controller, String type) {
    Get.to(() => AddEditMedicalEntryScreen(
      entryType: type,
      existingData: null,
    ));
  }

  Widget _buildSectionCard({
    required String title,
    required String type,
    required bool hasData,
    Widget? dataWidget,
    required VoidCallback onAdd,
  }) {
    if (!hasData) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            InkWell(
              onTap: onAdd,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 16.sp),
                    4.horizontalSpace,
                    Text(
                      "Add",
                      style: TextStyle(color: Colors.white, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    return dataWidget ?? Container();
  }

  Widget _buildProblemHistoryCard(dynamic problemData, String historyId, MedicalHistoryController controller) {
    String verificationStatus = problemData['status']?.toString() ?? 'false';
    bool isVerified = verificationStatus.toLowerCase() == 'verified';

    return _buildMedicalCard(
      title: "Problem History",
      showAddNote: true,
      note: problemData['note'] != null ? "Note: ${problemData['note']}" : null,
      subtitle: problemData['problemName'] ?? 'N/A',
      details: problemData['treatment'] ?? 'No treatment details',
      doctor: problemData['doctorName'] ?? null,
      status: isVerified ? "Verified" : "Unverified",
      statusColor: isVerified ? Colors.green : Colors.orange,
      isVerified: isVerified,
      onMarkVerified: !isVerified ? () => controller.markAsVerified(historyId, "problem") : null,
      historyId: historyId,
      sectionType: "problem",
      controller: controller,
      onEdit: () => _navigateToAddScreen(controller, 'problem'),
    );
  }

  Widget _buildAllergiesCard(dynamic allergyData, String historyId, MedicalHistoryController controller) {
    String verificationStatus = allergyData['status']?.toString() ?? 'false';
    bool isVerified = verificationStatus.toLowerCase() == 'verified';

    return _buildMedicalCard(
      title: "Allergies and intolerances",
      showAddNote: false,
      subtitle: allergyData['allergen'] ?? 'N/A',
      details: "Reaction: ${allergyData['reaction'] ?? 'N/A'}\nSeverity: ${allergyData['severity'] ?? 'Normal'}",
      doctor: allergyData['doctorName'] ?? null,
      status: isVerified ? "Verified" : "Unverified",
      statusColor: isVerified ? Colors.green : Colors.orange,
      isVerified: isVerified,
      onMarkVerified: !isVerified ? () => controller.markAsVerified(historyId, "allergical") : null,
      historyId: historyId,
      sectionType: "allergical",
      controller: controller,
      onEdit: () => _navigateToAddScreen(controller, 'allergy'),
    );
  }

  Widget _buildCurrentMedicationsCard(dynamic medicationData, String historyId, MedicalHistoryController controller) {
    String verificationStatus = medicationData['status']?.toString() ?? 'false';
    bool isVerified = verificationStatus.toLowerCase() == 'verified';

    return _buildMedicalCard(
      title: "Current medications",
      showAddNote: false,
      subtitle: medicationData['medicineName'] ?? 'N/A',
      details: "Dosage: ${medicationData['dosage'] ?? 'N/A'}\nRefill: ${medicationData['refill'] == true ? 'Yes' : 'No'}",
      doctor: "${medicationData['doctorName'] ?? null}",
      status: isVerified ? "Verified" : "Unverified",
      statusColor: isVerified ? Colors.green : Colors.orange,
      isVerified: isVerified,
      onMarkVerified: !isVerified ? () => controller.markAsVerified(historyId, "medications") : null,
      historyId: historyId,
      sectionType: "medications",
      controller: controller,
      onEdit: () => _navigateToAddScreen(controller, 'medication'),
    );
  }

  Widget _buildFamilyHistoryCard(dynamic familyData, String historyId, MedicalHistoryController controller) {
    String verificationStatus = familyData['status']?.toString() ?? 'false';
    bool isVerified = verificationStatus.toLowerCase() == 'verified';

    return _buildMedicalCard(
      title: "Family history",
      showAddNote: false,
      subtitle: "${familyData['relation'] ?? 'Unknown'} - ${familyData['condition'] ?? 'N/A'}",
      details: "Severity: ${familyData['severity'] ?? 'Normal'}\nAge at diagnosis: ${familyData['age'] ?? 'N/A'}",
      doctor: familyData['doctorName'] ?? null,
      status: isVerified ? "Verified" : "Unverified",
      statusColor: isVerified ? Colors.green : Colors.orange,
      isVerified: isVerified,
      onMarkVerified: !isVerified ? () => controller.markAsVerified(historyId, "familyHistory") : null,
      historyId: historyId,
      sectionType: "familyHistory",
      controller: controller,
      onEdit: () => _navigateToAddScreen(controller, 'familyHistory'),
    );
  }

  Widget _buildVaccinationsCard(dynamic vaccinationData, String historyId, MedicalHistoryController controller) {
    String verificationStatus = vaccinationData['status']?.toString() ?? 'false';
    bool isVerified = verificationStatus.toLowerCase() == 'verified';

    return _buildMedicalCard(
      title: "Vaccinations",
      showAddNote: false,
      subtitle: vaccinationData['vaccineName'] ?? 'N/A',
      details: "Date: ${_formatDateFromString(vaccinationData['date'] ?? 'N/A')}\nStatus: ${vaccinationData['status'] ?? 'Unknown'}",
      doctor: vaccinationData['doctorName'] ?? null,
      status: isVerified ? "Verified" : "Unverified",
      statusColor: isVerified ? Colors.green : Colors.orange,
      isVerified: isVerified,
      onMarkVerified: !isVerified ? () => controller.markAsVerified(historyId, "vaccinations") : null,
      historyId: historyId,
      sectionType: "vaccinations",
      controller: controller,
      onEdit: () => _navigateToAddScreen(controller, 'vaccination'),
    );
  }

  Widget _buildBaselineVitalsCard(dynamic vitalsData, String updatedAt, String historyId, MedicalHistoryController controller) {
    String verificationStatus = vitalsData['status']?.toString() ?? 'false';
    bool isVerified = verificationStatus.toLowerCase() == 'verified';

    return _buildMedicalCard(
      title: "Baseline vitals",
      showAddNote: false,
      details: "BP: ${vitalsData['bp'] ?? 'N/A'}\nWeight: ${vitalsData['weight'] ?? 'N/A'}\nHeight: ${vitalsData['height'] ?? 'N/A'}\nBMI: ${vitalsData['bmi'] ?? 'N/A'}",
      doctor: vitalsData['doctorName'] ?? null,
      status: isVerified ? "Verified" : "Unverified",
      statusColor: isVerified ? Colors.green : Colors.orange,
      isVerified: isVerified,
      onMarkVerified: !isVerified ? () => controller.markAsVerified(historyId, "vitals") : null,
      historyId: historyId,
      sectionType: "vitals",
      controller: controller,
      onEdit: () => _navigateToAddScreen(controller, 'vitals'),
    );
  }

  Widget _buildSurgicalHistoryCard(dynamic surgicalData, String historyId, MedicalHistoryController controller) {
    String verificationStatus = surgicalData['status']?.toString() ?? 'false';
    bool isVerified = verificationStatus.toLowerCase() == 'verified';

    return _buildMedicalCard(
      title: "Surgical history",
      showAddNote: false,
      subtitle: "${surgicalData['procedure'] ?? 'N/A'} — ${surgicalData['date'] ?? 'Unknown Year'}",
      details: "Severity: ${surgicalData['severity'] ?? 'Normal'}",
      doctor: surgicalData['doctorName'] ??null,
      status: isVerified ? "Verified" : "Unverified",
      statusColor: isVerified ? Colors.green : Colors.orange,
      isVerified: isVerified,
      onMarkVerified: !isVerified ? () => controller.markAsVerified(historyId, "surgical") : null,
      historyId: historyId,
      sectionType: "surgical",
      controller: controller,
      onEdit: () => _navigateToAddScreen(controller, 'surgical'),
    );
  }

  Widget _buildInfectiousHistoryCard(dynamic infectionData, String historyId, MedicalHistoryController controller) {
    String verificationStatus = infectionData['status']?.toString() ?? 'false';
    bool isVerified = verificationStatus.toLowerCase() == 'verified';

    return _buildMedicalCard(
      title: "Infectious history",
      showAddNote: false,
      subtitle: "${infectionData['infectionType'] ?? 'N/A'} — ${infectionData['date'] ?? 'Unknown Date'}",
      details: infectionData['notes'] ?? 'No additional notes',
      doctor: infectionData['doctorName'] ?? null,
      status: isVerified ? "Verified" : "Unverified",
      statusColor: isVerified ? Colors.green : Colors.orange,
      isVerified: isVerified,
      onMarkVerified: !isVerified ? () => controller.markAsVerified(historyId, "infectional") : null,
      historyId: historyId,
      sectionType: "infectional",
      controller: controller,
      onEdit: () => _navigateToAddScreen(controller, 'infection'),
    );
  }

  Widget _buildLifestyleCard(dynamic lifestyleData, String historyId, MedicalHistoryController controller) {
    String verificationStatus = lifestyleData['status']?.toString() ?? 'false';
    bool isVerified = verificationStatus.toLowerCase() == 'verified';

    return _buildMedicalCard(
      title: "Lifestyle habits / risk factors",
      showAddNote: false,
      details: "Smoking: ${lifestyleData['smoking'] ?? 'N/A'}\nAlcohol: ${lifestyleData['alcohol'] ?? 'N/A'}\nPhysical Activity: ${lifestyleData['physicalActivity'] ?? 'N/A'}\nDiet: ${lifestyleData['dietType'] ?? 'N/A'}\nSleep: ${lifestyleData['sleepQuality'] ?? 'N/A'}",
      doctor: lifestyleData['doctorName'] ?? null,
      status: isVerified ? "Verified" : "Unverified",
      statusColor: isVerified ? Colors.green : Colors.orange,
      isVerified: isVerified,
      onMarkVerified: !isVerified ? () => controller.markAsVerified(historyId, "lifestyle") : null,
      historyId: historyId,
      sectionType: "lifestyle",
      controller: controller,
      onEdit: () => _navigateToAddScreen(controller, 'lifestyle'),
    );
  }

  Widget _buildMedicalCard({
    required String title,
    String? subtitle,
    required String details,
    String? status,
    Color? statusColor,
    String? doctor,
    bool showActionLinks = true,
    bool showAddNote = false,
    String? note,
    Widget? customActions,
    bool isVerified = false,
    VoidCallback? onMarkVerified,
    required String historyId,
    required String sectionType,
    required MedicalHistoryController controller,
    VoidCallback? onEdit,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (subtitle != null) Text(subtitle, style: TextStyle(fontSize: 13.sp, color: Colors.black54)),
                  if (status != null) ...[
                    4.verticalSpace,
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: statusColor?.withOpacity(0.1) ?? Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: statusColor ?? Colors.grey, width: 0.5),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.bold, color: statusColor),
                      ),
                    ),
                  ]
                ],
              ),
            ],
          ),
          8.verticalSpace,
          Text(details, style: TextStyle(fontSize: 11.sp, color: Colors.black87, height: 1.4)),
          if (note != null)
            Text(note, style: TextStyle(fontSize: 11.sp, color: Colors.black87, height: 1.4)),
          if (doctor != null) ...[
            8.verticalSpace,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4.r)),
              child: Text(doctor, style: TextStyle(fontSize: 9.sp, color: AppColors.primaryColor)),
            ),
          ],
          12.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (showActionLinks)
                Row(
                  children: [
                    InkWell(
                      onTap: onEdit,
                      child: Text("Edit", style: TextStyle(color: AppColors.primaryColor, fontSize: 11.sp, decoration: TextDecoration.underline)),
                    ),
                    10.horizontalSpace,
                    if (!isVerified && onMarkVerified != null)
                      InkWell(
                        onTap: onMarkVerified,
                        child: Text(
                          "Mark verified",
                          style: TextStyle(color: Colors.green, fontSize: 11.sp, decoration: TextDecoration.underline),
                        ),
                      ),
                    10.horizontalSpace,
                    if (showAddNote)
                      InkWell(
                        onTap: () => controller.showAddNoteDialog(historyId, sectionType),
                        child: Text(
                          "Add Note",
                          style: TextStyle(color: AppColors.primaryColor, fontSize: 11.sp, decoration: TextDecoration.underline),
                        ),
                      ),
                  ],
                )
              else if (customActions != null)
                customActions,
            ],
          ),
        ],
      ),
    );
  }

  String _formatDateFromString(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
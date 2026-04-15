import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/screens/doctor_screens/statics_screen/report_screen.dart';
import 'package:patient_app/screens/doctor_screens/statics_screen/review_screen.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_fonts.dart';
import 'package:patient_app/utils/app_images.dart';
import 'package:patient_app/widgets/doctor_widgets/statics_widgets/engagement_card.dart';

import '../../../controllers/doctor_controllers/static_controller.dart';

class StaticsScreen extends StatelessWidget {
  const StaticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StaticsController());

    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.onboardingBackground, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              70.verticalSpace,
              _buildHeader(),
              30.verticalSpace,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildClinicalActivityCards(),
                      20.verticalSpace,
                      // _buildLineChartSection(controller),
                      20.verticalSpace,
                      _buildConsultationDonut(controller),
                      20.verticalSpace,
                      _buildOperationalPerformance(),
                      20.verticalSpace,
                      // _buildEvolutionBarChart(controller),
                      20.verticalSpace,
                      _buildPatientEngagement(),
                      20.verticalSpace,
                      _buildComplianceAndPrescriptions(controller),
                      20.verticalSpace,
                      _buildHdsStandardBanner(),
                      20.verticalSpace,
                      CustomButton(
                        borderRadius: 15,
                        text: AppStrings.exportMonthlyReport.tr,
                        onTap: () => Get.to(const ReportScreen()),
                      ),
                      30.verticalSpace,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        InkWell(
          onTap: () => Get.back(),
          child: Image.asset(AppImages.backIcon, height: 33.h, fit: BoxFit.fill),
        ),
        10.horizontalSpace,
        Text(
          AppStrings.statistics.tr,
          style: TextStyle(
            color: Colors.black,
            fontSize: 23.sp,
            fontWeight: FontWeight.w800,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
      ],
    );
  }

  Widget _buildClinicalActivityCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Clinical Activity", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp)),
        15.verticalSpace,
        Row(
          children: [
            _statBox("New patients", "06"),
            15.horizontalSpace,
            _statBox("Follow-ups Rate", "30%"),
          ],
        ),
        10.verticalSpace,
        _statBox("Active patients this week", "42", fullWidth: true),
      ],
    );
  }

  Widget _statBox(String label, String value, {bool fullWidth = false, bool isGridViewItem = false}) {
    if (isGridViewItem) {
      return Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: TextStyle(color: Colors.grey, fontSize: 11.sp)),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
          ],
        ),
      );
    }

    return Expanded(
      flex: fullWidth ? 0 : 1,
      child: Container(
        width: fullWidth ? 1.sw : null,
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Column(
          children: [
            Text(label, style: TextStyle(color: Colors.grey, fontSize: 11.sp)),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChartSection(StaticsController controller) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Analysis period", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
          SizedBox(
            height: 180.h,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: controller.clinicalActivitySpots,
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationDonut(StaticsController controller) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Consultations", style: TextStyle(fontWeight: FontWeight.bold)),
              _buildDropdown("Weekly"),
            ],
          ),
          SizedBox(
            height: 150.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(PieChartData(sections: controller.consultationSections, centerSpaceRadius: 40)),
                Text("56", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _legendItem(Colors.green, "Video"),
              _legendItem(Colors.blue, "Audio"),
              _legendItem(Colors.orange, "in-person"),
            ],
          )
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        5.horizontalSpace,
        Text(label, style: TextStyle(fontSize: 12.sp)),
      ],
    );
  }

  Widget _buildOperationalPerformance() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Operational Performance", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp)),
            _buildDropdown("Weekly"),
          ],
        ),
        5.verticalSpace,
        Text("Engagement & Retention", style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
        15.verticalSpace,
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2,
          children: [
            _statBox("consultation duration", "Average 38 mint", isGridViewItem: true),
            _statBox("Cancellation", "12", isGridViewItem: true),
            _statBox("Scheduled", "30%", isGridViewItem: true),
            _statBox("completed consultations", "30%", isGridViewItem: true),
          ],
        ),
      ],
    );
  }

  Widget _buildEvolutionBarChart(StaticsController controller) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Evolution chart", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
          20.verticalSpace,
          SizedBox(
            height: 150.h,
            child: BarChart(
              BarChartData(
                barGroups: controller.evolutionBarGroups,
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => Text("Week ${value.toInt() + 1}", style: TextStyle(fontSize: 10.sp)),
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientEngagement() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(AppStrings.patientEngagement.tr, style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.bold)),
        ),
        12.verticalSpace,
        EngagementCard(onTap: () {}, icon: Icons.access_time, title: AppStrings.avgResponseTime.tr, value: '2h 14m', showLink: false),
        EngagementCard(
          icon: Icons.star_border,
          title: AppStrings.avgSatisfaction.tr,
          value: '4.7  ★',
          linkText: AppStrings.viewPatientReviews.tr,
          showLink: true,
          onTap: () => Get.to(ReviewScreen()),
        ),
        EngagementCard(onTap: () {}, icon: Icons.message, title: AppStrings.messagesSentReceived.tr, value: '120 / 98', showLink: false),
        EngagementCard(onTap: () {}, icon: Icons.checklist, title: AppStrings.patientsWithoutFollowUp.tr, value: '5', linkText: AppStrings.viewPatientList.tr, showLink: true),
      ],
    );
  }

  Widget _buildComplianceAndPrescriptions(StaticsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.complianceRecords.tr, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        12.verticalSpace,
        Row(
          children: [
            Expanded(child: ComplianceCard(icon: Icons.description, title: AppStrings.dmpDocuments.tr, value: '04')),
            16.horizontalSpace,
            Expanded(child: ComplianceCard(icon: Icons.edit, title: AppStrings.validSignatures.tr, value: '02')),
          ],
        ),
        20.verticalSpace,
        _buildPrescriptionDonut(controller),
      ],
    );
  }

  Widget _buildPrescriptionDonut(StaticsController controller) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.medical_services_outlined, color: Colors.blue, size: 18),
              5.horizontalSpace,
              const Text("Prescriptions", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _legendItem(Colors.green, "signed"),
                    _legendItem(Colors.orange, "pending"),
                    _legendItem(Colors.red, "expired"),
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 100.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(PieChartData(sections: [
                        PieChartSectionData(value: 70, color: Colors.green, radius: 15, showTitle: false),
                        PieChartSectionData(value: 20, color: Colors.orange, radius: 15, showTitle: false),
                        PieChartSectionData(value: 10, color: Colors.red, radius: 15, showTitle: false),
                      ], centerSpaceRadius: 30)),
                      Text("45", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildHdsStandardBanner() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.orange.withOpacity(0.1),
        border: Border.all(color: AppColors.orange.withOpacity(0.3)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.orange),
          10.horizontalSpace,
          Expanded(child: Text(AppStrings.hdsDataStandard.tr, style: TextStyle(fontSize: 14.sp))),
        ],
      ),
    );
  }

  Widget _buildDropdown(String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Text(value, style: TextStyle(fontSize: 12.sp)),
          const Icon(Icons.keyboard_arrow_down, size: 16),
        ],
      ),
    );
  }
}

class ComplianceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ComplianceCard({super.key, required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue),
          5.verticalSpace,
          Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 11.sp, color: Colors.grey)),
          Text(value, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
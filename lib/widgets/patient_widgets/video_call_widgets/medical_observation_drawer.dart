import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/patient_controllers/appointment_controllers/video_call_controller.dart';
import 'package:patient_app/widgets/patient_widgets/video_call_widgets/clinic_note_widget.dart';

class MedicalObservationDrawer extends GetView<VideoCallController> {
  const MedicalObservationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width,
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Stack(
        children: [
          Row(
            children: [
              const Spacer(),
              Container(
                width: 0.85.sw,
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F9FF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(40.w, 10.h, 15.w, 10.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Medical Observation & Care Plan",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      DefaultTabController(
                        length: 3,
                        child: Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TabBar(
                                isScrollable: true,
                                tabAlignment: TabAlignment.start,
                                indicatorColor: const Color(0xFF4A80F0),
                                labelColor: const Color(0xFF4A80F0),
                                unselectedLabelColor: Colors.black54,
                                indicatorSize: TabBarIndicatorSize.label,
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp),
                                tabs: const [
                                  Tab(text: "Clinical Note"),
                                  Tab(text: "Care Plan"),
                                  Tab(text: "Documents"),
                                ],
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    ClinicalNoteWidget(appointmentId:controller.appointmentId.value ),
                                    _buildCarePlanContent(),
                                    _buildDocumentsContent(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: (0.15.sw) - 20,
            top: 55.h,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                height: 40.h,
                width: 40.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF4A80F0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildCarePlanContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Care Plan", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          15.verticalSpace,
          _buildExpansionSection(
            title: "Clinical Context",
            children: [
              _buildSoapField("Reason for visit, current symptoms...", "Minimum 15 characters required.", maxLines: 5),
            ],
          ),
          _buildExpansionSection(
            title: "Diagnosis / Clinical Hypotheses",
            children: [
              _buildSoapField("Main diagnosis", "Primary diagnosis", maxLines: 1),
              _buildSoapField("Secondary diagnosis", "Secondary diagnosis", maxLines: 1),
            ],
          ),
          _buildExpansionSection(
            title: "Care Objectives",
            children: [
              _buildSoapField("Care Objectives", "Define measurable care objectives...", maxLines: 3),
            ],
          ),
          _buildExpansionSection(
            title: "Prescribed Treatment",
            children: [
              _buildSoapField("Medication name", "Metaforming", maxLines: 1),
              _buildSoapField("Dose", "Moring / evening", maxLines: 1),
              _buildSoapField("Frequency", "2 tablets", maxLines: 1),
              _buildSoapField("Duration", "15 days", maxLines: 1),
              _buildSoapField("Instructions", "Metaforming", maxLines: 3),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: TextButton(
                  onPressed: () {},
                  child: const Text("+ Add medication", style: TextStyle(color: Color(0xFF4A80F0))),
                ),
              ),
            ],
          ),
          _buildExpansionSection(
            title: "Tests & Assessments",
            children: [
              _buildSoapField("Tests & Assessments", "No tests required at this time.", maxLines: 1),
            ],
          ),
          _buildToggleSection("Medical Recommendations", "Nor provideded"),
          _buildToggleSection("Follow-Up Plan", "Follow-up required"),
          15.verticalSpace,
          Text("Associated Documents", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          10.verticalSpace,
          _buildCheckboxItem("Generate prescription", "Draft", const Color(0xFFE5A16B)),
          _buildCheckboxItem("Generate consultation report", "Signed", const Color(0xFF4A80F0)),
          _buildCheckboxItem("Generate certificate", "Send", const Color(0xFF5DB37E)),
          25.verticalSpace,
          _buildActionButton("Validate & lock care plan", const Color(0xFF4A80F0), Colors.white),
          30.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildDocumentsContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("All Patient Action In One Place", style: TextStyle(fontSize: 14.sp, color: Colors.black54)),
          5.verticalSpace,
          Text("Recent Document", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
          15.verticalSpace,
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.blue.withOpacity(0.1)),
            ),
            child: Column(
              children: [
                _buildDocumentItem(Icons.science_outlined, "Blood Test", "Lab . New . 23 Jan 2025"),
                const Divider(height: 24),
                _buildDocumentItem(Icons.wb_sunny_outlined, "Chest X-ray", "Patient . Reviewed . 20 Jan 2025"),
                const Divider(height: 24),
                _buildDocumentItem(Icons.description_outlined, "Referral Letter", "Dr. smith . Reviewed . 23 Jan 2025"),
              ],
            ),
          ),
          25.verticalSpace,
          Text("Upload Report", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
          15.verticalSpace,
          Text("Upload Report", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
          10.verticalSpace,
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 30.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FBFF),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Icon(Icons.cloud_upload_outlined, size: 40.sp, color: const Color(0xFF4A80F0)),
                10.verticalSpace,
                Text("Upload Report", style: TextStyle(fontSize: 16.sp, color: Colors.black87, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          25.verticalSpace,
          _buildActionButton("Upload report", const Color(0xFF4A80F0), Colors.white),
          12.verticalSpace,
          _buildActionButton("Cancel", const Color(0xFFEEEEEE), Colors.black87),
          30.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildDocumentItem(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF4A80F0), size: 22.sp),
        12.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  const Icon(Icons.check, color: Colors.green, size: 14),
                  5.horizontalSpace,
                  Text(subtitle, style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
        const Icon(Icons.visibility_outlined, color: Color(0xFF4A80F0), size: 20),
      ],
    );
  }

  Widget _buildExpansionSection({required String title, required List<Widget> children}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(title, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
        childrenPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        children: children,
      ),
    );
  }

  Widget _buildToggleSection(String title, String label) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        childrenPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        title: Text(title, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
        children: [
          ListTile(
            title: Text(label, style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
            trailing: Switch(value: false, onChanged: (v) {}),
          )
        ],
      ),
    );
  }

  Widget _buildCheckboxItem(String label, String status, Color statusColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          SizedBox(width: 24, height: 24, child: Checkbox(value: label.contains("prescription"), onChanged: (v) {})),
          10.horizontalSpace,
          Expanded(child: Text(label, style: TextStyle(fontSize: 13.sp))),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(4)),
            child: Text(status, style: TextStyle(color: Colors.white, fontSize: 10.sp)),
          ),
        ],
      ),
    );
  }

  Widget _buildSoapField(String label, String hint, {int maxLines = 4}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
        5.verticalSpace,
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            maxLines: maxLines,
            style: TextStyle(fontSize: 13.sp),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12.sp),
              contentPadding: const EdgeInsets.all(10),
              border: InputBorder.none,
            ),
          ),
        ),
        10.verticalSpace,
      ],
    );
  }

  Widget _buildActionButton(String text, Color bgColor, Color textColor) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(text, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
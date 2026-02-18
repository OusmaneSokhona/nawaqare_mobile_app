import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_appoinment_controller.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_appointment_detail_controller.dart';
import 'package:patient_app/models/doctor_appointment_model.dart';
import 'package:patient_app/screens/doctor_screens/appointment_screens/doctor_reschedule_appointment_screen.dart';
import 'package:patient_app/screens/doctor_screens/appointment_screens/preview_screen_doctor.dart';
import 'package:patient_app/widgets/appointment_statue_widget.dart';
import 'package:patient_app/widgets/custom_button.dart';
import 'package:patient_app/widgets/doctor_widgets/appointment_widgets/confirmation_dialog.dart';
import 'package:patient_app/widgets/doctor_widgets/appointment_widgets/doctor_appoinment_detail_widget.dart';
import 'package:patient_app/widgets/doctor_widgets/appointment_widgets/doctor_home_visit_status_dialog.dart';
import 'package:patient_app/widgets/doctor_widgets/appointment_widgets/doctor_past_appoinment_widget.dart';
import 'package:patient_app/utils/app_strings.dart';
import 'package:patient_app/widgets/doctor_widgets/appointment_widgets/home_visit_request_detail_screen.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_images.dart';
import '../../../widgets/reschdule_request_widget.dart';

class DoctorAppointmentDetail extends StatelessWidget {
  final bool isCompleted;
  final DoctorAppointment appointmentModel;
  final DoctorAppointmentDetailController controller = Get.put(DoctorAppointmentDetailController());
  final DoctorAppointmentController appointmentController=Get.put(DoctorAppointmentController());

  DoctorAppointmentDetail({
    super.key,
    required this.appointmentModel,
    this.isCompleted = false,
  });
  bool get _hasRescheduleReason {
    return appointmentModel.isReschedule?.reason != null &&
        appointmentModel.isReschedule!.reason!.isNotEmpty&&appointmentModel.isReschedule!.role!="doctor"&&appointmentModel.isReschedule!.isAccept=="pending";
  }
  bool get _hasRescheduleStatus {
    return appointmentModel.isReschedule?.reason != null &&
        appointmentModel.isReschedule!.reason!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
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
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              70.verticalSpace,
              Row(
                children: [
                  InkWell(
                    onTap: () {
appointmentController.fetchDoctorAppointments();
                      Get.back();
                    },
                    child: Image.asset(
                      AppImages.backIcon,
                      height: 33.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    AppStrings.appointmentDetails.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.jakartaBold,
                    ),
                  ),
                ],
              ),
              30.verticalSpace,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      DoctorAppoinmentDetailWidget(
                        appointmentModel: appointmentModel,
                      ),
                      if (isCompleted) ...{
                        DoctorPastAppoinmentWidget(appointmentModel: appointmentModel,),
                      } else ...{
                        if (_hasRescheduleStatus)
                          Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Text(
                              AppStrings.reschedule.tr,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                fontFamily: AppFonts.jakartaBold,
                              ),
                            ),
                          ),
                        if (_hasRescheduleReason)
                          10.verticalSpace,
                        if (_hasRescheduleReason)...{
                          RescheduleRequestWidget(
                            patientName: appointmentModel.patientId.fullName,
                            patientImage: appointmentModel.patientId.profileImage ?? '',
                            rescheduleReason: appointmentModel.isReschedule?.reason,
                            onAccept: () {
                              controller.acceptRescheduleRequest(appointmentModel.id);
                            },
                            onReject: () {
                              controller.rejectRescheduleRequest(appointmentModel.id);
                            },
                          ),} else if(_hasRescheduleStatus)...{
                          Align(alignment: AlignmentGeometry.centerLeft,child:AppointmentStatusWidget(status: appointmentModel.isReschedule!.isAccept),),
                        },
                        10.verticalSpace,
                        Align(
                          alignment: AlignmentDirectional.topStart,
                          child: Text(
                            AppStrings.symptomsHistory.tr,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: AppFonts.jakartaBold,
                            ),
                          ),
                        ),
                        10.verticalSpace,
                        Container(
                          width: 1.sw,
                          padding: EdgeInsets.all(15.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.lightGrey.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.patientSymptoms.tr,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: AppFonts.jakartaBold,
                                ),
                              ),
                              10.verticalSpace,
                              Text(
                                AppStrings.symptomsDescription.tr,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        10.verticalSpace,
                        if(appointmentModel.consultationType=="homevisit")
                          HomeVisitRequestDetailScreen(appointment: appointmentModel,),
                        15.verticalSpace,
                        if (appointmentModel.prescriptionId != null)
                          ...appointmentModel.prescriptionId!.medications.map((medication) =>
                              PrescriptionHistoryCard(
                                medication: medication.name,
                                dosage: "${medication.dosage} - ${medication.frequency} - ${medication.duration}",
                                daysRemaining: _calculateDaysRemaining(appointmentModel.prescriptionId!.validUntil),
                                prescriptionNumber: appointmentModel.prescriptionId!.prescriptionNumber,
                                issueDate: appointmentModel.prescriptionId!.issueDate,
                                validUntil: appointmentModel.prescriptionId!.validUntil,
                              ),
                          ).toList()
                        else
                          const PrescriptionHistoryCard(
                            medication: "No prescription available",
                            dosage: "",
                            daysRemaining: 0,
                            prescriptionNumber: "",
                          ),
                        10.verticalSpace,
                        MedicalReportCard(
                          title: appointmentModel.patientId.reports!,
                          onlyView: true,
                        ),

                        30.verticalSpace,
                        if (appointmentModel.consultationType == "homevisit" && appointmentModel.status == "pending"&&appointmentModel.isReschedule!.isAccept!="pending")
                          ((appointmentModel.homevisitstatus == "Accept" || appointmentModel.homevisitstatus == "accepted") &&
                              (appointmentModel.status == "pending" || appointmentModel.status == "Pending"))
                              ? Column(
                            children: [
                              CustomButton(
                                borderRadius: 15,
                                text: AppStrings.joinConsultation.tr,
                                onTap: () {
                                  Get.to(
                                    PreviewScreenDoctor(appointment: appointmentModel),
                                  );
                                },
                              ),
                              10.verticalSpace,
                              CustomButton(
                                borderRadius: 15,
                                text: AppStrings.reschedule.tr,
                                onTap: () {
                                  Get.to(DoctorRescheduleAppointmentScreen(
                                    appointmentId: appointmentModel.id,
                                  ));
                                },
                                bgColor: AppColors.inACtiveButtonColor,
                                fontColor: Colors.black,
                              ),
                            ],
                          )
                              : Column(
                            children: [
                              CustomButton(
                                borderRadius: 15,
                                text: AppStrings.accept.tr,
                                onTap: () {
                                  Get.dialog(DoctorHomeVisitStatusDialog(
                                    status: true,
                                    appointmentId: appointmentModel.id,
                                  ));
                                },
                              ),
                              10.verticalSpace,
                              CustomButton(
                                borderRadius: 15,
                                text: AppStrings.decline.tr,
                                onTap: () {
                                  Get.dialog(DoctorHomeVisitStatusDialog(
                                    status: false,
                                    appointmentId: appointmentModel.id,
                                  ));
                                },
                                bgColor: AppColors.inACtiveButtonColor,
                                fontColor: Colors.black,
                              ),
                            ],
                          ),
                        if (appointmentModel.consultationType != "homevisit" && appointmentModel.status == "pending"&&appointmentModel.isReschedule!.isAccept!="pending")
                          Column(
                            children: [
                              CustomButton(
                                borderRadius: 15,
                                text: AppStrings.joinConsultation.tr,
                                onTap: () async {
                                  Get.to(PreviewScreenDoctor(appointment: appointmentModel));
                                },
                              ),
                              10.verticalSpace,
                              CustomButton(
                                borderRadius: 15,
                                text: AppStrings.reschedule.tr,
                                onTap: () {
                                  Get.to(DoctorRescheduleAppointmentScreen(appointmentId: appointmentModel.id,));
                                },
                                bgColor: AppColors.inACtiveButtonColor,
                                fontColor: Colors.black,
                              ),
                            ],
                          ),
                        if (appointmentModel.status == "confirmed"&&appointmentModel.isReschedule!.isAccept!="pending"&&appointmentModel.isReschedule!.isAccept!="pending")
                          Column(
                            children: [
                              CustomButton(
                                borderRadius: 15,
                                text: AppStrings.joinConsultation.tr,
                                onTap: ()  {
                                  Get.to(PreviewScreenDoctor(appointment: appointmentModel));
                                },
                              ),
                              10.verticalSpace,
                                CustomButton(
                                  borderRadius: 15,
                                  text: AppStrings.reschedule.tr,
                                  onTap: () {
                                    Get.to(DoctorRescheduleAppointmentScreen(appointmentId: appointmentModel.id,));
                                  },
                                  bgColor: AppColors.inACtiveButtonColor,
                                  fontColor: Colors.black,
                                ),
                            ],
                          ),
                        if (appointmentModel.status == "ongoing"&&appointmentModel.isReschedule!.isAccept!="pending"&&appointmentModel.isReschedule!.isAccept!="pending")
                          CustomButton(
                            borderRadius: 15,
                            text: AppStrings.joinConsultation.tr,
                            onTap: () {
                              Get.to(PreviewScreenDoctor(appointment: appointmentModel));
                            },
                          ),
                        30.verticalSpace,
                      },
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
  int _calculateDaysRemaining(DateTime validUntil) {
    final now = DateTime.now();
    final difference = validUntil.difference(now).inDays;
    return difference > 0 ? difference : 0;
  }
}
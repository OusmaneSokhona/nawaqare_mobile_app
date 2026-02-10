import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/doctor_controllers/doctor_appointment_detail_controller.dart';
import '../../../utils/app_strings.dart';

class DoctorHomeVisitStatusDialog extends StatelessWidget {
  final bool status;
  final String appointmentId;

  const DoctorHomeVisitStatusDialog({
    super.key,
    required this.status,
    required this.appointmentId,
  });

  @override
  Widget build(BuildContext context) {
    final DoctorAppointmentDetailController controller = Get.find<DoctorAppointmentDetailController>();

    return Obx(() {
      final bool isLoading = controller.isLoading.value;

      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                status
                    ? "assets/images/confirmation_tick_icon.png"
                    : "assets/images/home_visit_decline_icon.png",
                height: 110.h,
              ),
              const SizedBox(height: 16),
              Text(
                status ? AppStrings.confirmed.tr : AppStrings.confirmDecline.tr,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                status
                    ? AppStrings.closeConsultationMsg.tr
                    : AppStrings.declineHomeVisitMsg.tr,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 24),
              if (isLoading)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: CircularProgressIndicator(
                    color: Colors.blue[600],
                  ),
                )
              else
                Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                        },
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
                              color: Colors.black54, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (status) {
                            bool success = await controller.acceptAppointment(appointmentId);
                          } else {
                            bool success = await controller.declineAppointment(appointmentId);
                          }
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
                          status ? AppStrings.confirm.tr : AppStrings.decline.tr,
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
    });
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../../models/doctor_model.dart';
import '../../../utils/app_colors.dart';

class DoctorWidget extends StatelessWidget {
  final DoctorModel doctor;
  final Function onTap;
  final bool isCompleted;

  const DoctorWidget({
    Key? key,
    required this.doctor,
    this.isCompleted = false,
    required this.onTap,
  }) : super(key: key);

  String _getSpecialtyAsString(dynamic specialty) {
    if (specialty == null) return 'specialty';
    if (specialty is String) return specialty;
    if (specialty is Map) {
      return specialty['name']?.toString() ?? 'specialty';
    }
    return 'specialty';
  }

  String _getConsultationTypeText() {
    final fee = doctor.fee;
    if (fee == null) return 'Consultation Available';

    bool hasRemote = fee.remoteConsultation != null;
    bool hasInPerson = fee.inPersonConsultation != null;
    bool hasHomeVisit = fee.homeVisitConsultation != null;

    if (hasRemote && hasInPerson && hasHomeVisit) {
      return 'Remote, In-Person & Home Visit';
    } else if (hasRemote && hasInPerson) {
      return 'Both Remote & In-Person';
    } else if (hasRemote && hasHomeVisit) {
      return 'Remote & Home Visit';
    } else if (hasInPerson && hasHomeVisit) {
      return 'In-Person & Home Visit';
    } else if (hasRemote) {
      return 'Remote Consultation';
    } else if (hasInPerson) {
      return 'In-Person Consultation';
    } else if (hasHomeVisit) {
      return 'Home Visit Consultation';
    }
    return 'Consultation Available';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Card(
        color: Colors.white,
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _formatDate(doctor.dateOfRegistration),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "${AppStrings.feeLabel.tr}: ",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      Text(
                        doctor.fee?.displayRemoteFee ?? '\$N/A',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Divider(thickness: 0.3, color: Colors.black45),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 80.w,
                    height: 105.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: doctor.displayImage.startsWith('http')
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Image.network(
                        doctor.displayImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/demo_images/demo_doctor.jpeg',
                            fit: BoxFit.cover,
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                        : Image.asset(
                      doctor.displayImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.displayName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Divider(thickness: 0.3, color: Colors.black45),
                        Text(
                          _getSpecialtyAsString(doctor.medicalSpecialty),
                          style: TextStyle(color: Colors.black, fontSize: 15.sp),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              _getConsultationTypeText().toLowerCase().contains("remote")
                                  ? Icons.add_ic_call
                                  : _getConsultationTypeText().toLowerCase().contains("home")
                                  ? Icons.home
                                  : Icons.meeting_room_outlined,
                              color: Colors.blue,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                _getConsultationTypeText(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.sp,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        5.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.language,
                                  color: AppColors.primaryColor,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  doctor.country ?? AppStrings.notAvailable.tr,
                                  style: TextStyle(fontSize: 11.sp),
                                ),
                              ],
                            ),
                            7.horizontalSpace,
                            Container(
                              height: 15.h,
                              width: 1.w,
                              color: AppColors.primaryColor,
                            ),
                            7.horizontalSpace,
                            Row(
                              children: [
                                Text(
                                  doctor.gender ?? AppStrings.notAvailable.tr,
                                  style: TextStyle(
                                    color: AppColors.darkGrey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        3.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.orange,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  doctor.ratingValue.toStringAsFixed(1),
                                  style: TextStyle(fontSize: 13.sp),
                                ),
                              ],
                            ),
                            7.horizontalSpace,
                            Container(
                              height: 15.h,
                              width: 1.w,
                              color: AppColors.primaryColor,
                            ),
                            7.horizontalSpace,
                            Row(
                              children: [
                                Text(
                                  doctor.availableSlots?.isEmpty == true
                                      ? AppStrings.noSlots.tr
                                      : '${doctor.availableSlots?.length ?? 0} ${AppStrings.slots.tr}',
                                  style: TextStyle(
                                    color: AppColors.darkGrey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
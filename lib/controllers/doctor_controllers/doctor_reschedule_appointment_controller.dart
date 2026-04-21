import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/doctor_controllers/doctor_appoinment_controller.dart';
import '../../../controllers/doctor_controllers/doctor_home_controller.dart';
import '../../../models/time_slot_model.dart';
import '../../../services/api_service.dart';
import '../../../utils/api_urls.dart';

class DoctorRescheduleAppointmentController extends GetxController {
  final ApiService _apiService = ApiService();
  late DoctorHomeController homeController;
  DoctorAppointmentController appointmentController = Get.find();
  String appointmentId = "";

  final selectedDate = Rx<DateTime?>(null);
  final selectedTimeSlot = Rx<TimeSlot?>(null);
  final reasonController = TextEditingController();

  final availableTimeSlots = <TimeSlot>[].obs;
  final isLoadingTimeSlots = false.obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  String doctorId = "";

  @override
  void onInit() {
    super.onInit();
    try {
      homeController = Get.find<DoctorHomeController>();
      doctorId = homeController.currentUser.value?.id ?? "";
    } catch (e) {
      doctorId = "";
    }
  }

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Get.theme.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedDate.value = picked;
      selectedTimeSlot.value = null;
      await fetchTimeSlots();
    }
  }

  Future<void> fetchTimeSlots() async {
    if (selectedDate.value == null || doctorId.isEmpty) {
      return;
    }

    isLoadingTimeSlots.value = true;
    try {
      final response = await _apiService.get(
        '${ApiUrls.getDoctorTimeSlots}$doctorId',  // Note: You might need to add a slash here depending on your API URL
      );

      if (response.statusCode == 200) {
        final timeSlotResponse = TimeSlotResponse.fromJson(response.data);
        print("Fetched ${timeSlotResponse.slots.length} time slots for doctor $doctorId");
        final selectedDateStr = DateFormat('yyyy-MM-dd').format(selectedDate.value!);

        final allSlots = timeSlotResponse.doctor?.allSlots ?? timeSlotResponse.slots;

        final slots = allSlots.where((slot) {
          final isAvailable = slot.status.toLowerCase() == 'available';
          final isConsultation = slot.service?.toLowerCase() == 'consultation';  // ADD THIS LINE
          final slotDate = slot.slotDate ?? DateFormat('yyyy-MM-dd').format(slot.startTime);
          return slotDate == selectedDateStr && isAvailable && isConsultation;  // ADD isConsultation condition
        }).toList();

        slots.sort((a, b) => a.startTime.compareTo(b.startTime));
        availableTimeSlots.assignAll(slots);
      } else {
        availableTimeSlots.clear();
      }
    } catch (e) {
      print('Error fetching time slots: $e');
      availableTimeSlots.clear();
    } finally {
      isLoadingTimeSlots.value = false;
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('EEEE, MMMM d, yyyy').format(date);
  }

  String formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }

  bool validateFields() {
    if (appointmentId.isEmpty) {
      errorMessage.value = 'Appointment not selected';
      return false;
    }

    if (selectedDate.value == null) {
      errorMessage.value = 'Please select a new date';
      return false;
    }

    if (selectedTimeSlot.value == null) {
      errorMessage.value = 'Please select a new time slot';
      return false;
    }

    if (reasonController.text.trim().isEmpty) {
      errorMessage.value = 'Please provide a reason for rescheduling';
      return false;
    }

    errorMessage.value = '';
    return true;
  }

  Future<bool> rescheduleAppointment() async {
    if (!validateFields()) return false;

    isLoading.value = true;
    try {
      final Map<String, dynamic> rescheduleData = {
        'appointmentId': appointmentId,
        'timeslotId': selectedTimeSlot.value!.id,
        'reason': reasonController.text.trim(),
      };

      final response = await _apiService.post(
        ApiUrls.rescheduleAppointment,
        data: rescheduleData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        appointmentController.fetchDoctorAppointments();
        resetForm();
        return true;
      } else {
        errorMessage.value = response.data['message'] ?? 'Failed to reschedule appointment';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void resetForm() {
    appointmentId = "";
    selectedDate.value = null;
    selectedTimeSlot.value = null;
    reasonController.clear();
    availableTimeSlots.clear();
    errorMessage.value = '';
  }
}
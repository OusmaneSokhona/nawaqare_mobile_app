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
  DoctorAppointmentController appointmentController = Get.put(DoctorAppointmentController());
   String appointmentId="";
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
      print("Doctor ID initialized: $doctorId");
    } catch (e) {
      print("Error getting DoctorHomeController: $e");
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
      print("Cannot fetch time slots: date=${selectedDate.value}, doctorId=$doctorId");
      return;
    }

    isLoadingTimeSlots.value = true;
    try {
      print("Fetching time slots for doctor: $doctorId");
      final response = await _apiService.get(
        '${ApiUrls.getDoctorTimeSlots}/$doctorId',
      );

      if (response.statusCode == 200) {
        print("Time slots response received");
        final timeSlotResponse = TimeSlotResponse.fromJson(response.data);
        final selectedDateStr = DateFormat('yyyy-MM-dd').format(selectedDate.value!);

        final slots = timeSlotResponse.slots.where((slot) {
          final isAvailable = slot.status.toLowerCase() == 'available';
          final slotDate = slot.slotDate ?? DateFormat('yyyy-MM-dd').format(slot.startTime);
          return slotDate == selectedDateStr && isAvailable;
        }).toList();

        slots.sort((a, b) => a.startTime.compareTo(b.startTime));
        print("Filtered slots for $selectedDateStr: ${slots.length}");
        availableTimeSlots.assignAll(slots);
      } else {
        print("Failed to fetch time slots: ${response.statusCode}");
        availableTimeSlots.clear();
      }
    } catch (e) {
      print('Fetch time slots error: $e');
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
      errorMessage.value = 'Appointment Id not Selected';
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

    if (reasonController.text.isEmpty) {
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

      print("Rescheduling appointment with data: $rescheduleData");

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
      print('Reschedule appointment error: $e');
      errorMessage.value = 'An error occurred: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void resetForm() {
    appointmentId="";
    selectedDate.value = null;
    selectedTimeSlot.value = null;
    reasonController.clear();
    availableTimeSlots.clear();
    errorMessage.value = '';
  }
}
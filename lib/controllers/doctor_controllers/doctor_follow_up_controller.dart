import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../models/time_slot_model.dart';
import '../../../services/api_service.dart';
import '../../../utils/api_urls.dart';
import 'doctor_appoinment_controller.dart';

class DoctorFollowupController extends GetxController {
  final ApiService _apiService = ApiService();
  final DoctorAppointmentController appointmentController = Get.put(DoctorAppointmentController());

  final selectedDate = Rx<DateTime?>(null);
  final selectedTimeSlot = Rx<TimeSlot?>(null);
  final followupPriceController = TextEditingController();
  final notesController = TextEditingController();

  final availableTimeSlots = <TimeSlot>[].obs;
  final isLoadingTimeSlots = false.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  String doctorId = "";

  @override
  void onInit() {
    super.onInit();
    if (appointmentController.allAppointments.isNotEmpty) {
      doctorId = appointmentController.allAppointments.first.doctorId;
    }
  }

  @override
  void onClose() {
    followupPriceController.dispose();
    notesController.dispose();
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
            colorScheme: ColorScheme.light(primary: Get.theme.primaryColor),
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
        '${ApiUrls.getDoctorTimeSlots}$doctorId',
      );

      if (response.statusCode == 200) {
        final timeSlotResponse = TimeSlotResponse.fromJson(response.data);
        final selectedDateStr = DateFormat('yyyy-MM-dd').format(selectedDate.value!);

        final allSlots = timeSlotResponse.doctor?.allSlots ?? timeSlotResponse.slots;

        final slots = allSlots.where((slot) {
          final isAvailable = slot.status.toLowerCase() == 'available';
          final slotDate = slot.slotDate ?? DateFormat('yyyy-MM-dd').format(slot.startTime);
          return slotDate == selectedDateStr && isAvailable;
        }).toList();

        slots.sort((a, b) => a.startTime.compareTo(b.startTime));
        availableTimeSlots.assignAll(slots);
      } else {
        availableTimeSlots.clear();
      }
    } catch (e) {
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
    if (selectedDate.value == null) {
      errorMessage.value = 'Please select a date';
      return false;
    }

    if (selectedTimeSlot.value == null) {
      errorMessage.value = 'Please select a time slot';
      return false;
    }

    if (followupPriceController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter follow-up price';
      return false;
    }

    if (double.tryParse(followupPriceController.text) == null) {
      errorMessage.value = 'Please enter a valid price';
      return false;
    }

    errorMessage.value = '';
    return true;
  }

  Future<bool> createFollowUp(String appointmentId) async {
    if (!validateFields()) return false;

    isLoading.value = true;
    try {
      final Map<String, dynamic> followupData = {
        'appointmentId': appointmentId,
        'timeSlotId': selectedTimeSlot.value!.id,
        'followupPrice': int.parse(followupPriceController.text),
      };

      if (notesController.text.trim().isNotEmpty) {
        followupData['notes'] = notesController.text.trim();
      }

      final response = await _apiService.post(
        ApiUrls.createFollowUp,
        data: followupData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        appointmentController.fetchDoctorAppointments();
        resetForm();
        return true;
      } else {
        errorMessage.value = response.data['message'] ?? 'Failed to create follow-up';
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
    selectedDate.value = null;
    selectedTimeSlot.value = null;
    followupPriceController.clear();
    notesController.clear();
    availableTimeSlots.clear();
    errorMessage.value = '';
  }
}
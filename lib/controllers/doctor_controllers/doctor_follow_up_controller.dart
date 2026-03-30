import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../models/time_slot_model.dart';
import '../../../models/appointment_model.dart';
import '../../../services/api_service.dart';
import '../../../utils/api_urls.dart';
import 'doctor_appoinment_controller.dart';

class DoctorFollowupController extends GetxController {
  final ApiService _apiService = ApiService();
  final DoctorAppointmentController appointmentController = Get.put(DoctorAppointmentController());
  final isLoadingAppointment = false.obs;
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
      print(
        "Cannot fetch time slots: date=${selectedDate.value}, doctorId=$doctorId",
      );
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
        final selectedDateStr = DateFormat(
          'yyyy-MM-dd',
        ).format(selectedDate.value!);

        final slots =
            timeSlotResponse.slots.where((slot) {
              final isAvailable = slot.status.toLowerCase() == 'available';
              final slotDate =
                  slot.slotDate ??
                  DateFormat('yyyy-MM-dd').format(slot.startTime);
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
    if (selectedDate.value == null) {
      errorMessage.value = 'Please select a date';
      return false;
    }

    if (selectedTimeSlot.value == null) {
      errorMessage.value = 'Please select a time slot';
      return false;
    }

    if (followupPriceController.text.isEmpty) {
      errorMessage.value = 'Please enter follow-up price';
      return false;
    }

    // Validate price is a number
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

      // Add notes if provided
      if (notesController.text.isNotEmpty) {
        followupData['notes'] = notesController.text;
      }

      print("Creating follow-up with data: $followupData");

      final response = await _apiService.post(
        ApiUrls.createFollowUp,
        data: followupData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Follow-up created successfully: ${response.data}");
        Get.back();
        Get.back();


        Get.snackbar(
          "Success",
          "Follow-up appointment scheduled successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        appointmentController.fetchDoctorAppointments();
        return true;
      } else {
        errorMessage.value =
            response.data['message'] ?? 'Failed to create follow-up';
        Get.snackbar(
          "Error",
          errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      print('Create follow-up error: $e');
      errorMessage.value = 'An error occurred: $e';
      Get.snackbar(
        "Error",
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void resetForm() {
    selectedDate.value = null;
    followupPriceController.text="";
    selectedTimeSlot.value = null;
    notesController.clear();
    availableTimeSlots.clear();
    errorMessage.value = '';
  }
}

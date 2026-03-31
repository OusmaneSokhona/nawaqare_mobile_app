import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:patient_app/controllers/doctor_controllers/doctor_appoinment_controller.dart';
import '../../../models/patient_model_doctor.dart' hide TimeSlot;
import '../../../models/time_slot_model.dart';
import '../../../services/api_service.dart';
import '../../../utils/api_urls.dart';
import 'doctor_home_controller.dart';

class DoctorAddAppointmentController extends GetxController {
  final ApiService _apiService = ApiService();
  late DoctorHomeController homeController;
  DoctorAppointmentController appointmentController = Get.find();

  final patients = <Patient>[].obs;
  final isLoadingPatients = false.obs;
  final selectedPatient = Rx<Patient?>(null);

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
      doctorId = homeController.currentUser.value!.id!;
    } catch (e) {
      doctorId = "";
    }
    fetchAllPatients();
  }

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }

  Future<void> fetchAllPatients() async {
    isLoadingPatients.value = true;
    try {
      final response = await _apiService.get(
        ApiUrls.getAllPatients,
      );

      if (response.statusCode == 200) {
        if (response.data['appointments'] != null) {
          final appointmentsResponse = AppointmentsResponse.fromJson(response.data);
          final Map<String, Patient> uniquePatients = {};
          for (final appointment in appointmentsResponse.appointments) {
            if (appointment.patient != null) {
              uniquePatients[appointment.patient!.id] = appointment.patient!;
            }
          }
          patients.assignAll(uniquePatients.values.toList());
        } else if (response.data['patients'] != null) {
          final List<dynamic> patientsData = response.data['patients'];
          patients.assignAll(patientsData.map((json) => Patient.fromJson(json)).toList());
        } else if (response.data is List) {
          patients.assignAll((response.data as List).map((json) => Patient.fromJson(json)).toList());
        } else {
          patients.clear();
        }
      } else {
        patients.clear();
      }
    } catch (e) {
      patients.clear();
    } finally {
      isLoadingPatients.value = false;
    }
  }

  void clearSelectedPatient() {
    selectedPatient.value = null;
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
        '${ApiUrls.getDoctorTimeSlots}/$doctorId',
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
    if (selectedPatient.value == null) {
      errorMessage.value = 'Please select a patient';
      return false;
    }

    if (selectedDate.value == null) {
      errorMessage.value = 'Please select a date';
      return false;
    }

    if (selectedTimeSlot.value == null) {
      errorMessage.value = 'Please select a time slot';
      return false;
    }

    errorMessage.value = '';
    return true;
  }

  Future<bool> createAppointment() async {
    if (!validateFields()) return false;

    isLoading.value = true;
    try {
      final Map<String, dynamic> appointmentData = {
        'patientId': selectedPatient.value!.id,
        'timeslotId': selectedTimeSlot.value!.id,
        'notes': reasonController.text,
      };
print('Creating appointment with data: $appointmentData');
      final response = await _apiService.post(
        ApiUrls.doctorCreateAppointmentEndpoint,
        data: appointmentData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        appointmentController.fetchDoctorAppointments();
        resetForm();
        return true;
      } else {
        errorMessage.value = response.data['message'] ?? 'Failed to create appointment';
        Get.snackbar('Error', errorMessage.value, backgroundColor: Colors.redAccent, colorText: Colors.white);
        return false;
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      Get.snackbar('Error', errorMessage.value, backgroundColor: Colors.redAccent, colorText: Colors.white);
      print('Error creating appointment: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void resetForm() {
    selectedPatient.value = null;
    selectedDate.value = null;
    selectedTimeSlot.value = null;
    reasonController.clear();
    availableTimeSlots.clear();
    errorMessage.value = '';
  }
}
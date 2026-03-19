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
  DoctorAppointmentController appointmentController=Get.find();

  // Patients list for dropdown
  final patients = <Patient>[].obs;
  final isLoadingPatients = false.obs;
  final selectedPatient = Rx<Patient?>(null);

  // Appointment details
  final selectedDate = Rx<DateTime?>(null);
  final selectedTimeSlot = Rx<TimeSlot?>(null);
  final reasonController = TextEditingController();
  final addressController = TextEditingController();
  final feeController = TextEditingController();
  final selectedConsultationType = ''.obs;

  // Time slots
  final availableTimeSlots = <TimeSlot>[].obs;
  final isLoadingTimeSlots = false.obs;

  // Loading state
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  String doctorId = "";

  @override
  void onInit() {
    super.onInit();

    // Initialize home controller and get doctor ID
    try {
      homeController = Get.find<DoctorHomeController>();
      doctorId = homeController.currentUser.value!.id!;
      print("Doctor ID initialized: $doctorId");
    } catch (e) {
      print("Error getting DoctorHomeController: $e");
      doctorId = "";
    }

    // Fetch all patients on init
    fetchAllPatients();
  }

  @override
  void onClose() {
    reasonController.dispose();
    addressController.dispose();
    feeController.dispose();
    super.onClose();
  }

  Future<void> fetchAllPatients() async {
    isLoadingPatients.value = true;

    try {
      print("Fetching all patients");
      final response = await _apiService.get(
        ApiUrls.getAllPatients,
      );

      if (response.statusCode == 200) {
        // Handle different response formats
        if (response.data['appointments'] != null) {
          // Handle AppointmentsResponse format
          final appointmentsResponse = AppointmentsResponse.fromJson(response.data);

          // Extract unique patients from appointments
          final Map<String, Patient> uniquePatients = {};
          for (final appointment in appointmentsResponse.appointments) {
            if (appointment.patient != null) {
              uniquePatients[appointment.patient!.id] = appointment.patient!;
            }
          }
          patients.assignAll(uniquePatients.values.toList());
        } else if (response.data['patients'] != null) {
          // Handle direct patients list in response
          final List<dynamic> patientsData = response.data['patients'];
          patients.assignAll(
              patientsData.map((json) => Patient.fromJson(json)).toList()
          );
        } else if (response.data is List) {
          // Handle direct array response
          patients.assignAll(
              (response.data as List).map((json) => Patient.fromJson(json)).toList()
          );
        } else {
          // Try to parse as single patient object or empty
          patients.clear();
        }

        print("Fetched ${patients.length} patients");
      } else {
        print("Failed to fetch patients: ${response.statusCode}");
        patients.clear();
      }
    } catch (e) {
      print('Fetch patients error: $e');
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

        // Parse using your TimeSlotResponse model
        final timeSlotResponse = TimeSlotResponse.fromJson(response.data);

        // Format selected date for comparison
        final selectedDateStr = DateFormat('yyyy-MM-dd').format(selectedDate.value!);

        // Filter slots by date and availability
        final slots = timeSlotResponse.slots.where((slot) {
          // Check if slot status is available
          final isAvailable = slot.status.toLowerCase() == 'available';

          // Get slot date
          final slotDate = slot.slotDate ?? DateFormat('yyyy-MM-dd').format(slot.startTime);

          return slotDate == selectedDateStr && isAvailable;
        }).toList();

        // Sort slots by start time
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

    if (selectedConsultationType.value.isEmpty) {
      errorMessage.value = 'Please select consultation type';
      return false;
    }

    if (selectedConsultationType.value == 'homevisit' && addressController.text.isEmpty) {
      errorMessage.value = 'Please enter address for home visit';
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
        'consultationType': selectedConsultationType.value,
        'notes': reasonController.text,
        'date': DateFormat('yyyy-MM-dd').format(selectedDate.value!),
      };

      if (selectedConsultationType.value == 'homevisit') {
        appointmentData['visitAddress'] = addressController.text;
      }

      print("Creating appointment with data: $appointmentData");

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
        return false;
      }
    } catch (e) {
      print('Create appointment error: $e');
      errorMessage.value = 'An error occurred: $e';
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
    addressController.clear();
    feeController.clear();
    selectedConsultationType.value = '';
    availableTimeSlots.clear();
    errorMessage.value = '';
  }
}
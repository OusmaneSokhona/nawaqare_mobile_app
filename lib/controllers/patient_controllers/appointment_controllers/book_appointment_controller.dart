import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:patient_app/models/time_slot_model.dart';
import 'package:patient_app/services/api_service.dart';
import 'package:patient_app/utils/api_urls.dart';

class BookAppointmentController extends GetxController {
  RxString appointmentType = "inPerson".obs;
  RxString appointmentId = "".obs;
  final duration = '30 mint'.obs;
  TextEditingController addressController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  final fee = '\$156'.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final selectedTime = ''.obs;
  final Rx<DateTime> _focusedMonth = DateTime.now().obs;
  final RxList<TimeSlot> availableTimeSlots = <TimeSlot>[].obs;
  final RxList<TimeSlot> filteredTimeSlots = <TimeSlot>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  ApiService _apiService = ApiService();

  DateTime get focusedMonth => _focusedMonth.value;

  final appointmentOptions = [
    'inPerson',
    'remote',
    "homeVisit",
  ];

  @override
  void onInit() {
    super.onInit();
    selectDate(DateTime.now());
    ever(appointmentType, (_) {
      _filterTimeSlotsByType();
    });
    ever(selectedDate, (_) {
      _filterTimeSlotsByType();
    });
  }

  void _filterTimeSlotsByType() {
    if (availableTimeSlots.isEmpty) {
      filteredTimeSlots.clear();
      return;
    }

    String apiConsultationType;
    switch (appointmentType.value) {
      case "inPerson":
        apiConsultationType = "inperson";
        break;
      case "homeVisit":
        apiConsultationType = "homevisit";
        break;
      default:
        apiConsultationType = "remote";
    }

    final dateString = selectedDate.value != null
        ? DateFormat('yyyy-MM-dd').format(selectedDate.value!)
        : null;

    filteredTimeSlots.value = availableTimeSlots.where((slot) {
      final matchesType = slot.consultationType.toLowerCase() == apiConsultationType;
      final matchesDate = dateString != null ? slot.slotDate == dateString : true;
      final isAvailable = slot.status == 'available';
      return matchesType && matchesDate && isAvailable;
    }).toList();

    if (filteredTimeSlots.isNotEmpty) {
      selectedTime.value = filteredTimeSlots.first.id;
    } else {
      selectedTime.value = '';
    }
  }

  Future<void> fetchTimeSlots({required String doctorId}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      availableTimeSlots.clear();
      filteredTimeSlots.clear();

      print('Fetching time slots for doctorId: $doctorId');
      final response = await _apiService.get(
        '${ApiUrls.getDoctorTimeSlots}$doctorId',
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data['slots'] != null) {
          final timeSlotResponse = TimeSlotResponse.fromJson(data);

          if (timeSlotResponse.slots.isNotEmpty) {
            print('Sample slot time (local): ${timeSlotResponse.slots.first.startTime}');
            print('Is UTC? ${timeSlotResponse.slots.first.startTime.isUtc}');
          }

          availableTimeSlots.assignAll(timeSlotResponse.slots);
          _filterTimeSlotsByType();
        } else {
          errorMessage.value = 'No slots found in response';
        }
      } else {
        errorMessage.value = 'Failed to load time slots: ${response.statusCode}';
      }
    } catch (e) {
      print('Error fetching time slots: $e');
      errorMessage.value = 'Error: ${e.toString()}';
      availableTimeSlots.clear();
      filteredTimeSlots.clear();
    } finally {
      isLoading.value = false;
    }
  }

  List<TimeSlot> _getTimeSlotsForDate(DateTime date) {
    final dateString = DateFormat('yyyy-MM-dd').format(date);
    return filteredTimeSlots
        .where((slot) => slot.slotDate == dateString && slot.status == 'available')
        .toList();
  }

  void selectAppointmentType(String? newValue) {
    if (newValue != null) {
      appointmentType.value = newValue;
    }
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
    _filterTimeSlotsByType();
  }

  void selectTime(String timeId) {
    selectedTime.value = timeId;
  }

  String get formattedMonthYear {
    return DateFormat('MMMM yyyy').format(_focusedMonth.value);
  }

  void previousMonth() {
    _focusedMonth.value = DateTime(
      _focusedMonth.value.year,
      _focusedMonth.value.month - 1,
      1,
    );
  }

  void nextMonth() {
    _focusedMonth.value = DateTime(
      _focusedMonth.value.year,
      _focusedMonth.value.month + 1,
      1,
    );
  }

  TimeSlot? getSelectedTimeSlot() {
    if (selectedDate.value == null || selectedTime.value.isEmpty) {
      return null;
    }

    return filteredTimeSlots.firstWhere(
          (slot) => slot.id == selectedTime.value,
      orElse: () => TimeSlot(
          id: '',
          startTime: DateTime.now(),
          endTime: DateTime.now(),
          status: '',
          consultationType: "",
          service: ""
      ),
    );
  }

  RxBool isCreatingAppointment = false.obs;
  RxString appointmentError = ''.obs;

  Future<Map<String, dynamic>?> createAppointment({
    required String doctorId,
    required String timeslotId,
    required String consultationType,
  }) async {
    try {
      isCreatingAppointment.value = true;
      appointmentError.value = '';

      final Map<String, dynamic> requestBody = {
        "doctorId": doctorId,
        "timeslotId": timeslotId,
      };

      if (consultationType == "homevisit") {
        requestBody["visitAddress"] = addressController.text;
      }

      if (notesController.text.isNotEmpty) {
        requestBody["notes"] = notesController.text;
      }

      print('Creating appointment with data: $requestBody');

      final response = await _apiService.post(
        ApiUrls.createAppointment,
        data: requestBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Appointment created successfully: ${response.data['appointment']['_id']}');
        appointmentId.value = response.data['appointment']['_id'] ?? '';
        return response.data;
      } else {
        final errorMessage = response.data?["message"] ?? 'Failed to create appointment';
        appointmentError.value = 'Failed to create appointment: $errorMessage';
        print(appointmentError.value);
        return null;
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 400) {
        try {
          final errorData = e.response!.data;
          if (errorData is Map<String, dynamic>) {
            final errorMessage = errorData["message"] ?? 'Bad request';
            appointmentError.value = 'Failed to create appointment: $errorMessage';
          } else if (errorData is String) {
            final parsedError = jsonDecode(errorData);
            appointmentError.value = 'Failed to create appointment: ${parsedError["message"]}';
          } else {
            appointmentError.value = 'Failed to create appointment: Bad request';
          }
        } catch (_) {
          appointmentError.value = 'Failed to create appointment: Bad request';
        }
      } else {
        appointmentError.value = 'Error creating appointment: ${e.message}';
      }
      print(appointmentError.value);
      return null;
    } catch (e) {
      appointmentError.value = 'Error creating appointment: ${e.toString()}';
      print(appointmentError.value);
      return null;
    } finally {
      isCreatingAppointment.value = false;
    }
  }
}
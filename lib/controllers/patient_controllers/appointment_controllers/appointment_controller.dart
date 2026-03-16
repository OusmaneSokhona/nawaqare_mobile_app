import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_app/models/appointment_model.dart';
import 'package:patient_app/services/api_service.dart';
import 'package:patient_app/utils/api_urls.dart';
import 'package:patient_app/utils/app_strings.dart';

class AppointmentController extends GetxController {
  RxString appointmentType = "upcoming".obs;
  RxInt currentPage = 1.obs;
  RxBool isLoading = false.obs;
  final int itemsPerPage = 4;

  Rx<AppointmentResponse?> appointmentResponse = Rx<AppointmentResponse?>(null);
  RxList<Appointment> allAppointments = <Appointment>[].obs;
  RxList<Appointment> upcomingAppointments = <Appointment>[].obs;
  RxList<Appointment> pastAppointments = <Appointment>[].obs;
  RxList<Appointment> currentList = <Appointment>[].obs;

  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    ever(appointmentType, (_) {
      currentPage.value = 1;
      _updateCurrentList();
    });
  }

  Future<void> fetchAppointments() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(
        ApiUrls.getAppointments,
      );

      if (response.statusCode == 200) {
        final jsonResponse = response.data is String
            ? json.decode(response.data)
            : response.data;

        appointmentResponse.value = AppointmentResponse.fromJson(jsonResponse);

        allAppointments.value = appointmentResponse.value?.appointments ?? [];
        upcomingAppointments.value = appointmentResponse.value?.upcomingAppointments ?? [];
        pastAppointments.value = appointmentResponse.value?.pastAppointments ?? [];

        _updateCurrentList();

      } else {
        throw Exception('Failed to load appointments. Status: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.warning.tr,
        'Failed to fetch appointments: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _updateCurrentList() {
    currentList.value = appointmentType.value == "past"
        ? pastAppointments
        : upcomingAppointments;
    update();
  }

  List<Appointment> get paginatedList {
    final sortedList = currentList.toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    int start = (currentPage.value - 1) * itemsPerPage;
    if (start >= sortedList.length) return [];

    int end = start + itemsPerPage;
    end = end > sortedList.length ? sortedList.length : end;

    return sortedList.sublist(start, end);
  }

  int get totalPages {
    if (currentList.isEmpty) return 1;
    return (currentList.length / itemsPerPage).ceil();
  }

  int get totalCount => currentList.length;

  Map<String, int> get stats {
    return {
      'total': allAppointments.length,
      'upcoming': upcomingAppointments.length,
      'past': pastAppointments.length,
    };
  }

  bool isUpcoming(Appointment appointment) {
    return appointment.date.isAfter(DateTime.now());
  }


  String _getFormattedDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final appointmentDay = DateTime(date.year, date.month, date.day);

    if (appointmentDay == today) {
      return "Today";
    } else if (appointmentDay == today.add(Duration(days: 1))) {
      return "Tomorrow";
    } else {
      final weekdayMap = {
        1: 'Mon',
        2: 'Tue',
        3: 'Wed',
        4: 'Thu',
        5: 'Fri',
        6: 'Sat',
        7: 'Sun',
      };

      final monthMap = {
        1: 'Jan',
        2: 'Feb',
        3: 'Mar',
        4: 'Apr',
        5: 'May',
        6: 'Jun',
        7: 'Jul',
        8: 'Aug',
        9: 'Sep',
        10: 'Oct',
        11: 'Nov',
        12: 'Dec',
      };

      final weekday = weekdayMap[date.weekday] ?? 'Day';
      final month = monthMap[date.month] ?? 'Month';

      return '$weekday, ${date.day} $month';
    }
  }

  String _getFormattedTime(DateTime startTime, DateTime endTime) {
    String formatTime(DateTime time) {
      final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = time.hour < 12 ? 'AM' : 'PM';
      return '$hour:$minute $period';
    }

    return '${formatTime(startTime)} - ${formatTime(endTime)}';
  }

  String getConsultationTypeDisplay(ConsultationType type) {
    return type.displayName;
  }

  Map<String, dynamic> getStatusDisplay(AppointmentStatus status) {
    Color statusColor;
    String statusText;

    switch (status) {
      case AppointmentStatus.pending:
        statusColor = Colors.orange;
        statusText = 'Pending';
        break;
      case AppointmentStatus.confirmed:
        statusColor = Colors.green;
        statusText = 'Confirmed';
        break;
      case AppointmentStatus.completed:
        statusColor = Colors.blue;
        statusText = 'Completed';
        break;
      case AppointmentStatus.cancelled:
        statusColor = Colors.red;
        statusText = 'Cancelled';
        break;
      case AppointmentStatus.ongoing:
        statusColor = Colors.purple;
        statusText = 'Ongoing';
        break;
      case AppointmentStatus.rescheduled:
        statusColor = Colors.amber;
        statusText = 'Rescheduled';
        break;
    }

    return {
      'color': statusColor,
      'text': statusText,
    };
  }

  String getDoctorSpecialty(Appointment appointment) {
    return "General Practitioner";
  }

  String getDoctorImage(Appointment appointment) {
    return "assets/demo_images/doctor_1.png";
  }

  Future<void> refreshAppointments() async {
    await fetchAppointments();
  }

  Future<void> cancelAppointment(String appointmentId, String reason) async {
    try {
      isLoading.value = true;

      final response = await _apiService.post(
        'appointments/cancel',
        data: {
          'appointmentId': appointmentId,
          'reason': reason,
        },
      );

      if (response.statusCode == 200) {
        allAppointments.removeWhere((app) => app.id == appointmentId);
        upcomingAppointments.removeWhere((app) => app.id == appointmentId);
        pastAppointments.removeWhere((app) => app.id == appointmentId);

        _updateCurrentList();

        Get.snackbar(
          "Success",
          'Appointment cancelled successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        throw Exception('Failed to cancel appointment');
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.warning.tr,
        'Failed to cancel appointment',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> rescheduleAppointment(
      String appointmentId,
      DateTime newDate,
      String newTimeslotId,
      String reason,
      ) async {
    try {
      isLoading.value = true;

      final response = await _apiService.post(
        'appointments/reschedule',
        data: {
          'appointmentId': appointmentId,
          'newDate': newDate.toIso8601String(),
          'newTimeslotId': newTimeslotId,
          'reason': reason,
        },
      );

      if (response.statusCode == 200) {
        await fetchAppointments();

        Get.snackbar(
          "Success",
          'Appointment rescheduled successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        throw Exception('Failed to reschedule appointment');
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.warning.tr,
        'Failed to reschedule appointment',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> acceptRescheduleRequest(String appointmentId) async {
    try {
      isLoading.value = true;

      final Map<String, dynamic> requestData = {
        'appointmentId': appointmentId,
      };


      final response = await _apiService.post(
        ApiUrls.acceptRescheduleRequest,
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        await fetchAppointments(); // Refresh appointments list

        Get.snackbar(
          "Success",
          'Reschedule request accepted successfully',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
        return true;
      } else {
        String errorMsg = response.data['message'] ?? 'Failed to accept reschedule request';
        Get.snackbar(
          AppStrings.warning.tr,
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.warning.tr,
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> rejectRescheduleRequest(String appointmentId) async {
    try {
      isLoading.value = true;

      final Map<String, dynamic> requestData = {
        'appointmentId': appointmentId,
      };


      final response = await _apiService.post(
        ApiUrls.rejectRescheduleRequest,
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        await fetchAppointments(); // Refresh appointments list

        Get.snackbar(
          "Success",
          'Reschedule request rejected successfully',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
        return true;
      } else {
        String errorMsg = response.data['message'] ?? 'Failed to reject reschedule request';
        Get.snackbar(
          AppStrings.warning.tr,
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.warning.tr,
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  final RxString selectedTab = "Diagnosis".obs;

  final List<String> tabs = [
    "Diagnosis",
    "Ordonnance",
    "Medical Report",
    "Reviews"
  ];
}
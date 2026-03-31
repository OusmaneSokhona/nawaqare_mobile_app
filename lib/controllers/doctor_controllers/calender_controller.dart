import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';
import '../../utils/api_urls.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_strings.dart';
import '../../models/time_slot_model_doctor.dart';
import '../../utils/app_colors.dart';

class CalenderController extends GetxController {
  final ApiService _apiService = ApiService();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final selectedDate = DateTime.now().obs;
  final initialDate = DateTime.now().obs;
  final selectedDuration = 'daily'.obs;
  final selectedConsultationType = 'all'.obs;
  final selectedTime = "".obs;
  final deletingSlotId = "".obs;

  final allSlots = <TimeSlotModelDoctor>[].obs;
  final filteredSlots = <TimeSlotModelDoctor>[].obs;
  final isLoading = false.obs;
  final isCreating = false.obs;
  final isDeleting = false.obs;

  final availableTimes = <String>[].obs;
  final bookedTimes = <String>[].obs;
  final cancelledTimes = <String>[].obs;

  final slotIdMap = <String, String>{}.obs;
  final slotConsultationTypeMap = <String, String>{}.obs;

  final startTime = TimeOfDay.now().obs;
  final endTime = TimeOfDay.now().obs;
  final breakStartTime = const TimeOfDay(hour: 13, minute: 0).obs;
  final breakEndTime = const TimeOfDay(hour: 14, minute: 0).obs;
  final bufferTime = 15.obs;

  final consultationType = 'inperson'.obs;

  final consultation = false.obs;
  final followUp = false.obs;
  final physiotherapy = false.obs;

  @override
  void onInit() {
    super.onInit();
    endTime.value = _addMinutesToTimeOfDay(startTime.value, 30);
    fetchSlotsForDate(selectedDate.value);
  }

  void setConsultationType(String type) {
    consultationType.value = type;
  }

  TimeOfDay _addMinutesToTimeOfDay(TimeOfDay time, int minutes) {
    final totalMinutes = time.hour * 60 + time.minute + minutes;
    final newHour = totalMinutes ~/ 60;
    final newMinute = totalMinutes % 60;
    return TimeOfDay(hour: newHour % 24, minute: newMinute);
  }

  String formatTimeOfDayForDisplay(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  void selectNewDate(DateTime date) {
    selectedDate.value = date;
    filterSlotsByDuration();
  }

  void selectNewTime(String time) {
    selectedTime.value = time;
  }

  String getSlotIdByTime(String timeString) {
    return slotIdMap[timeString] ?? '';
  }

  String getConsultationTypeByTime(String timeString) {
    return slotConsultationTypeMap[timeString] ?? 'inperson';
  }

  void updateSlotIdMap() {
    slotIdMap.clear();
    slotConsultationTypeMap.clear();
    for (var slot in filteredSlots) {
      final timeString = DateFormat('hh:mm a').format(slot.startTime.toLocal());
      slotIdMap[timeString] = slot.id;
      slotConsultationTypeMap[timeString] = slot.consultationType;
    }
  }

  void categorizeSlots() {
    availableTimes.clear();
    bookedTimes.clear();
    cancelledTimes.clear();

    for (var slot in filteredSlots) {
      final timeString = DateFormat('hh:mm a').format(slot.startTime.toLocal());

      if (slot.status == 'available') {
        availableTimes.add(timeString);
      } else if (slot.status == 'booked') {
        bookedTimes.add(timeString);
      } else if (slot.status == 'cancelled') {
        cancelledTimes.add(timeString);
      }
    }

    availableTimes.sort();
    bookedTimes.sort();
    cancelledTimes.sort();
  }

  void filterSlotsByDuration() {
    final now = selectedDate.value;
    DateTime startDate;
    DateTime endDate;

    switch (selectedDuration.value) {
      case 'daily':
        startDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
        endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case 'weekly':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        startDate = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day, 0, 0, 0);
        endDate = startDate.add(Duration(days: 7));
        break;
      case 'monthly':
        startDate = DateTime(now.year, now.month, 1, 0, 0, 0);
        endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        break;
      default:
        startDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
        endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    }

    DateTime startDateLocal = startDate;
    DateTime endDateLocal = endDate;

    var durationFiltered = allSlots.where((slot) {
      return slot.startTime.isAfter(startDateLocal) && slot.startTime.isBefore(endDateLocal);
    }).toList();

    if (selectedConsultationType.value != 'all') {
      durationFiltered = durationFiltered.where((slot) {
        return slot.consultationType == selectedConsultationType.value;
      }).toList();
    }

    filteredSlots.value = durationFiltered;
    updateSlotIdMap();
    categorizeSlots();
  }

  Future<void> fetchSlotsForDate(DateTime date) async {
    try {
      isLoading.value = true;
      allSlots.clear();
      filteredSlots.clear();

      final response = await _apiService.get(ApiUrls.doctorSlotsApi);

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['doctor'] != null && data['doctor']['allSlots'] != null) {
          final slotsList = data['doctor']['allSlots'] as List;

          allSlots.value = slotsList.map((slotData) {
            return TimeSlotModelDoctor(
              id: slotData['_id'],
              startTime: DateTime.parse(slotData['startTime']).toLocal(),
              endTime: DateTime.parse(slotData['endTime']).toLocal(),
              consultationType: slotData['consultationType'] ?? 'inperson',
              status: slotData['status'] ?? 'available',
            );
          }).toList();

          filterSlotsByDuration();
        }
      }
    } catch (e) {
      print('Error fetching slots: $e');
      Get.snackbar(
        AppStrings.warning.tr,
        AppStrings.failedToLoadSlots.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createTimeSlotsForDay() async {
    try {
      isCreating.value = true;

      if (consultationType.value.isEmpty) {
        Get.snackbar(
          AppStrings.warning.tr,
          'Please select a consultation type',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isCreating.value = false;
        return;
      }

      if (endTime.value.hour < startTime.value.hour ||
          (endTime.value.hour == startTime.value.hour &&
              endTime.value.minute <= startTime.value.minute)) {
        Get.snackbar(
          AppStrings.warning.tr,
          AppStrings.endTimeMustBeAfterStartTime.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isCreating.value = false;
        return;
      }

      final timeSlots = <Map<String, dynamic>>[];

      DateTime currentSlotTime = DateTime(
        selectedDate.value.year,
        selectedDate.value.month,
        selectedDate.value.day,
        startTime.value.hour,
        startTime.value.minute,
      );

      DateTime endDateTime = DateTime(
        selectedDate.value.year,
        selectedDate.value.month,
        selectedDate.value.day,
        endTime.value.hour,
        endTime.value.minute,
      );

      DateTime breakStartDateTime = DateTime(
        selectedDate.value.year,
        selectedDate.value.month,
        selectedDate.value.day,
        breakStartTime.value.hour,
        breakStartTime.value.minute,
      );

      DateTime breakEndDateTime = DateTime(
        selectedDate.value.year,
        selectedDate.value.month,
        selectedDate.value.day,
        breakEndTime.value.hour,
        breakEndTime.value.minute,
      );

      while (currentSlotTime.isBefore(endDateTime)) {
        final slotEndTime = currentSlotTime.add(const Duration(minutes: 30));

        if (!currentSlotTime.isBefore(breakStartDateTime) &&
            currentSlotTime.isBefore(breakEndDateTime)) {
          currentSlotTime = breakEndDateTime;
          continue;
        }

        final actualEndTime = slotEndTime.isAfter(endDateTime)
            ? endDateTime
            : slotEndTime;

        if (actualEndTime.isAfter(currentSlotTime)) {
          final startTimeUtc = currentSlotTime.toUtc();
          final endTimeUtc = actualEndTime.toUtc();

          timeSlots.add({
            'startTime': startTimeUtc.toIso8601String(),
            'endTime': endTimeUtc.toIso8601String(),
            'consultationType': consultationType.value,
          });
        }

        currentSlotTime = slotEndTime;
      }

      if (timeSlots.isEmpty) {
        Get.snackbar(
          AppStrings.warning.tr,
          'No time slots to create',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        isCreating.value = false;
        return;
      }

      final requestBody = {
        'slots': timeSlots,
      };

      print('Creating slots: ${jsonEncode(requestBody)}');

      final response = await _apiService.post(
        ApiUrls.createSlotApi,
        data: requestBody,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.back();
        await fetchSlotsForDate(selectedDate.value);

        Get.snackbar(
          "Success",
          '${timeSlots.length} Time Slots Created',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        clearForm();
      } else {
        Get.snackbar(
          AppStrings.warning.tr,
          AppStrings.failedToCreateSlot.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        await fetchSlotsForDate(selectedDate.value);
      }
    } catch (e) {
      print('Error creating slots: $e');
      Get.snackbar(
        AppStrings.warning.tr,
        AppStrings.failedToCreateSlot.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> deleteTimeSlot(String slotId) async {
    if (slotId.isEmpty) {
      Get.snackbar(
        AppStrings.warning.tr,
        'Invalid slot ID',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final result = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        title: Text(
          AppStrings.deleteSlot.tr,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            fontFamily: AppFonts.jakartaBold,
          ),
        ),
        content: Text(
          AppStrings.areYouSureDeleteSlot.tr,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16.sp,
            fontFamily: AppFonts.jakartaRegular,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              AppStrings.cancel.tr,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16.sp,
                fontFamily: AppFonts.jakartaMedium,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              AppStrings.delete.tr,
              style: TextStyle(
                color: Colors.red,
                fontSize: 16.sp,
                fontFamily: AppFonts.jakartaMedium,
              ),
            ),
          ),
        ],
      ),
    );

    if (result != true) {
      return;
    }

    try {
      isDeleting.value = true;
      deletingSlotId.value = slotId;

      final slotToDelete = filteredSlots.firstWhereOrNull((slot) => slot.id == slotId);
      if (slotToDelete == null) {
        Get.snackbar(
          AppStrings.warning.tr,
          'Slot not found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      allSlots.removeWhere((slot) => slot.id == slotId);
      filterSlotsByDuration();

      final deleteUrl = '${ApiUrls.deleteSlotApi}$slotId';
      final response = await _apiService.delete(deleteUrl);

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          AppStrings.slotDeleted.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
        await fetchSlotsForDate(selectedDate.value);
      } else {
        await fetchSlotsForDate(selectedDate.value);
        Get.snackbar(
          AppStrings.warning.tr,
          'Failed to delete slot. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on DioException catch (e) {
      await fetchSlotsForDate(selectedDate.value);
      String errorMessage = AppStrings.failedToDeleteSlot.tr;
      if (e.response != null) {
        if (e.response?.data is Map && e.response?.data['message'] != null) {
          errorMessage = e.response?.data['message'];
        }
      }
      Get.snackbar(
        AppStrings.warning.tr,
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      await fetchSlotsForDate(selectedDate.value);
      Get.snackbar(
        AppStrings.warning.tr,
        AppStrings.failedToDeleteSlot.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isDeleting.value = false;
      deletingSlotId.value = '';
    }
  }

  int get availableSlotsCount {
    return filteredSlots.where((slot) => slot.status == 'available').length;
  }

  int get bookedSlotsCount {
    return filteredSlots.where((slot) => slot.status == 'booked').length;
  }

  int get cancelledSlotsCount {
    return filteredSlots.where((slot) => slot.status == 'cancelled').length;
  }

  Future<void> showTimePickerCustom(bool isStartTime) async {
    final BuildContext context = Get.context!;
    if (context == null) return;

    final TimeOfDay currentTime = isStartTime ? startTime.value : endTime.value;

    final TimeOfDay? selectedTimeOfDay = await showTimePicker(
      context: context,
      initialTime: currentTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.primaryColor,
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              dialBackgroundColor: Colors.grey[50],
              hourMinuteTextColor: Colors.black,
              dayPeriodTextColor: Colors.black,
              dayPeriodColor: AppColors.primaryColor.withOpacity(0.5),
              dialHandColor: AppColors.primaryColor,
              dialTextColor: Colors.black,
              entryModeIconColor: AppColors.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTimeOfDay != null) {
      if (isStartTime) {
        startTime.value = selectedTimeOfDay;
        if (endTime.value.hour < startTime.value.hour ||
            (endTime.value.hour == startTime.value.hour &&
                endTime.value.minute <= startTime.value.minute)) {
          endTime.value = _addMinutesToTimeOfDay(startTime.value, 30);
        }
      } else {
        endTime.value = selectedTimeOfDay;
      }
    }
  }

  Future<void> showBreakTimePicker(bool isStartBreak) async {
    final BuildContext context = Get.context!;
    if (context == null) return;

    final TimeOfDay currentTime = isStartBreak ? breakStartTime.value : breakEndTime.value;

    final TimeOfDay? selectedTimeOfDay = await showTimePicker(
      context: context,
      initialTime: currentTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.primaryColor,
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              dialBackgroundColor: Colors.grey[50],
              hourMinuteTextColor: Colors.black,
              dayPeriodTextColor: Colors.black,
              dayPeriodColor: AppColors.primaryColor.withOpacity(0.5),
              dialHandColor: AppColors.primaryColor,
              dialTextColor: Colors.black,
              entryModeIconColor: AppColors.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTimeOfDay != null) {
      if (isStartBreak) {
        breakStartTime.value = selectedTimeOfDay;
        if (breakEndTime.value.hour < breakStartTime.value.hour ||
            (breakEndTime.value.hour == breakStartTime.value.hour &&
                breakEndTime.value.minute <= breakStartTime.value.minute)) {
          breakEndTime.value = _addMinutesToTimeOfDay(breakStartTime.value, 60);
        }
      } else {
        breakEndTime.value = selectedTimeOfDay;
      }
    }
  }

  void clearForm() {
    startTime.value = TimeOfDay.now();
    endTime.value = _addMinutesToTimeOfDay(TimeOfDay.now(), 30);
    breakStartTime.value = const TimeOfDay(hour: 13, minute: 0);
    breakEndTime.value = const TimeOfDay(hour: 14, minute: 0);
    bufferTime.value = 15;
    consultationType.value = 'inperson';
    consultation.value = false;
    followUp.value = false;
    physiotherapy.value = false;
  }

  @override
  void onClose() {
    super.onClose();
  }
}

extension TimeOfDayExtension on TimeOfDay {
  int get hourOfPeriod {
    if (hour == 0) return 12;
    if (hour > 12) return hour - 12;
    return hour;
  }
}
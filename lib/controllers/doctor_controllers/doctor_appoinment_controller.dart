import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:patient_app/utils/appointment_status.dart';
import 'dart:convert';
import '../../models/clinical_notes.dart';
import '../../models/doctor_appointment_model.dart';
import '../../services/api_service.dart';
import '../../utils/api_urls.dart';
import '../../utils/app_strings.dart';

class DoctorAppointmentController extends GetxController {
  RxBool isLoading = false.obs;
  final selectedDateIndex = 2.obs;
  RxString appointmentType = "upcoming".obs;
  RxInt currentPage = 1.obs;
  final int itemsPerPage = 4;
  RxList<DoctorAppointment> allAppointments = <DoctorAppointment>[].obs;
  RxList<DoctorAppointment> upcomingAppointments = <DoctorAppointment>[].obs;
  RxList<DoctorAppointment> pastAppointments = <DoctorAppointment>[].obs;
  RxList<DoctorAppointment> currentList = <DoctorAppointment>[].obs;
  RxList<DoctorAppointment> filteredList = <DoctorAppointment>[].obs;
  Rx<ClinicalNotes> clinicalNote = ClinicalNotes.empty().obs;

  @override
  void onInit() {
    super.onInit();
    ever(appointmentType, (_) {
      currentPage.value = 1;
      _updateCurrentList();
    });
  }

  Future<void> fetchDoctorAppointments() async {
    try {
      isLoading.value = true;

      final response = await ApiService().get(
        ApiUrls.getAppointments,
      );

      if (response.statusCode == 200) {
        final jsonResponse = response.data is String
            ? json.decode(response.data)
            : response.data;

        if (jsonResponse.containsKey('appointements') || jsonResponse.containsKey('appointments')) {
          List<dynamic> appointmentsJson = jsonResponse['appointements'] ?? jsonResponse['appointments'] ?? [];

          List<DoctorAppointment> appointments = [];

          for (var json in appointmentsJson) {
            try {
              final appointment = DoctorAppointment.fromJson(json);
              appointments.add(appointment);
            } catch (e) {
            }
          }

          allAppointments.value = appointments;

          DateTime now = DateTime.now();

          upcomingAppointments.value = appointments
              .where((appointment) {
            try {
              final date = appointment.date is String
                  ? DateTime.parse(appointment.date.toString())
                  : DateTime.tryParse(appointment.date.toString());
              return date != null && date.isAfter(now);
            } catch (e) {
              return false;
            }
          })
              .toList();

          pastAppointments.value = appointments
              .where((appointment) {
            try {
              final date = appointment.date is String
                  ? DateTime.parse(appointment.date.toString())
                  : DateTime.tryParse(appointment.date.toString());
              return date != null && date.isBefore(now);
            } catch (e) {
              return false;
            }
          })
              .toList();

          _updateCurrentList();

        } else {
          allAppointments.value = [];
          upcomingAppointments.value = [];
          pastAppointments.value = [];
          _updateCurrentList();

          Get.snackbar(
            "Info",
            'No appointments found',
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
          );
        }
      } else {
        throw Exception('Failed to load appointments. Status: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.warning.tr,
        'Failed to fetch appointments: ${e.toString()}',
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
    filteredList.value = currentList;
    update();
  }

  void searchPatients(String query) {
    if (query.isEmpty) {
      filteredList.value = currentList;
    } else {
      filteredList.value = currentList.where((appointment) {
        return appointment.patientId.fullName.toLowerCase().contains(query.toLowerCase()) ||
            appointment.patientId.email.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    currentPage.value = 1;
  }

  void searchUpcomingPatients(String query) {
    if (query.isEmpty) {
      filteredList.value = upcomingAppointments;
    } else {
      filteredList.value = upcomingAppointments.where((appointment) {
        return appointment.patientId.fullName.toLowerCase().contains(query.toLowerCase()) ||
            appointment.patientId.email.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    currentPage.value = 1;
  }

  List<DoctorAppointment> get paginatedList {
    final sortedList = filteredList.toList()
      ..sort((a, b) => DateTime.parse(a.date.toString()).compareTo(DateTime.parse(b.date.toString())));

    int start = (currentPage.value - 1) * itemsPerPage;
    if (start >= sortedList.length) return [];

    int end = start + itemsPerPage;
    end = end > sortedList.length ? sortedList.length : end;

    return sortedList.sublist(start, end);
  }

  int get totalPages {
    if (filteredList.isEmpty) return 1;
    return (filteredList.length / itemsPerPage).ceil();
  }

  int get totalCount => currentList.length;

  Future<void> refreshAppointments() async {
    await fetchDoctorAppointments();
  }

  void showFilterBottomSheet() {
    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Filter",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            20.verticalSpace,
            Obx(() => Column(
              children: [
                _buildFilterOption(
                  AppStrings.consultationType.tr,
                  selectedConsultationType,
                  consultationTypes,
                      (value) => updateConsultationType(value),
                ),
                20.verticalSpace,
                _buildFilterOption(
                  AppStrings.status.tr,
                  selectedStatus,
                  statuses,
                      (value) => updateStatus(value),
                ),
                20.verticalSpace,
                _buildFilterOption(
                  AppStrings.period.tr,
                  selectedPeriod,
                  periods,
                      (value) => updatePeriod(value),
                ),
              ],
            )),
            30.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: resetFilters,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      AppStrings.reset.tr,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: ElevatedButton(
                    onPressed: applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      AppStrings.apply.tr,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String title, String currentValue, List<String> options, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        10.verticalSpace,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentValue,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down),
              items: options.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  void selectDate(int index) {
    selectedDateIndex.value = index;
  }

  final List<String> consultationTypes = [
    "All",
    'homevisit',
    'inperson',
    'remote',
  ];
  final List<String> statuses = ['All',AppointmentStatus.CONFIRMED,AppointmentStatus.PENDING, AppointmentStatus.ONGOING,AppointmentStatus.MISSED,AppointmentStatus.COMPLETED,AppointmentStatus.CANCELLED];
  final List<String> periods = [
    'All',
    'This week',
    'Last week',
    'This month',
    'Last month'
  ];

  final RxString _selectedConsultationType = 'All'.obs;
  final RxString _selectedStatus = 'All'.obs;
  final RxString _selectedPeriod = 'All'.obs;

  String get selectedConsultationType => _selectedConsultationType.value;
  String get selectedStatus => _selectedStatus.value;
  String get selectedPeriod => _selectedPeriod.value;

  void updateConsultationType(String? newValue) {
    if (newValue != null) {
      _selectedConsultationType.value = newValue;
    }
  }

  void updateStatus(String? newValue) {
    if (newValue != null) {
      _selectedStatus.value = newValue;
    }
  }

  void updatePeriod(String? newValue) {
    if (newValue != null) {
      _selectedPeriod.value = newValue;
    }
  }

  void resetFilters() {
    _selectedConsultationType.value = 'All';
    _selectedStatus.value = 'All';
    _selectedPeriod.value = 'All';
    filteredList.value = currentList;
    Get.back();
  }

  void applyFilters() {
    List<DoctorAppointment> filtered = currentList;

    if (_selectedConsultationType.value != 'All') {
      filtered = filtered.where((appointment) =>
      appointment.consultationType == _selectedConsultationType.value).toList();
    }

    if (_selectedStatus.value != 'All') {
      filtered = filtered.where((appointment) =>
      appointment.status == _selectedStatus.value).toList();
    }

    if (_selectedPeriod.value != 'All') {
      filtered = _filterByPeriod(filtered, _selectedPeriod.value);
    }

    filteredList.value = filtered;
    currentPage.value = 1;
    Get.back();
  }

  List<DoctorAppointment> _filterByPeriod(List<DoctorAppointment> appointments, String period) {
    DateTime now = DateTime.now();

    switch (period) {
      case 'This week':
        DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        return appointments.where((app) {
          DateTime appDate = DateTime.parse(app.date.toString());
          return appDate.isAfter(startOfWeek) && appDate.isBefore(now.add(Duration(days: 1)));
        }).toList();

      case 'Last week':
        DateTime startOfLastWeek = now.subtract(Duration(days: now.weekday + 6));
        DateTime endOfLastWeek = now.subtract(Duration(days: now.weekday));
        return appointments.where((app) {
          DateTime appDate = DateTime.parse(app.date.toString());
          return appDate.isAfter(startOfLastWeek) && appDate.isBefore(endOfLastWeek);
        }).toList();

      case 'This month':
        DateTime startOfMonth = DateTime(now.year, now.month, 1);
        return appointments.where((app) {
          DateTime appDate = DateTime.parse(app.date.toString());
          return appDate.isAfter(startOfMonth) && appDate.isBefore(now.add(Duration(days: 1)));
        }).toList();

      case 'Last month':
        DateTime startOfLastMonth = now.month == 1
            ? DateTime(now.year - 1, 12, 1)
            : DateTime(now.year, now.month - 1, 1);
        DateTime endOfLastMonth = DateTime(now.year, now.month, 0);
        return appointments.where((app) {
          DateTime appDate = DateTime.parse(app.date.toString());
          return appDate.isAfter(startOfLastMonth) && appDate.isBefore(endOfLastMonth.add(Duration(days: 1)));
        }).toList();

      default:
        return appointments;
    }
  }

  RxString notesText = "No Notes Available".obs;
  TextEditingController notesController = TextEditingController();

  void saveNotes() {
    notesText.value = notesController.text;
  }

  List<String> reportTypes = [
    "Blood Test Report",
    "X-Ray Report",
    "MRI Scan Report",
    "CT Scan Report",
    "Ultrasound Report",
  ];
  RxString selectedReportType = "Blood Test Report".obs;
  final selectedFileName = Rx<String?>('No file selected');

  void pickFile(Rx<String?> file) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpeg', 'jpg', 'png'],
    );

    if (result != null && result.files.single.name != null) {
      file.value = result.files.single.name!;

      if (result.files.single.path != null) {
        String filePath = result.files.single.path!;
        String fileName = result.files.single.name!;

        Get.snackbar(
          "File Selected",
          "Selected file: $fileName",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      file.value = 'File selection cancelled';
    }
  }

  Future<void> updateAppointmentStatus(String appointmentId, String status, bool isBackTrue) async {
    try {
      isLoading.value = true;

      final response = await ApiService().patch(
        '${ApiUrls.updateAppointmentStatus}$appointmentId',
        data: {'status': status},
      );

      if (response.statusCode == 200) {
        if(isBackTrue) Get.back();
        Get.snackbar(
          "Success",
          "Appointment status updated successfully",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
        await fetchDoctorAppointments();
      } else {
        throw Exception('Failed to update appointment status');
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        'Failed to update status: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> referPatient(String appointmentId, String comment) async {
    try {
      isLoading.value = true;

      final response = await ApiService().patch(
        '${ApiUrls.referPatient}$appointmentId',
        data: {'comment': comment},
      );

      if (response.statusCode == 200) {
        Get.back();
        Get.snackbar(
          "Success",
          "Patient referred successfully",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
        await fetchDoctorAppointments();
      } else {
        throw Exception('Failed to refer patient');
      }

    } catch (e) {
      Get.snackbar(
        "Error",
        'Failed to refer: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addClinicalNotes(String appointmentId, String drNotes) async {
    try {
      isLoading.value = true;

      final response = await ApiService().post(
        ApiUrls.doctorNotes,
        data: {
          'appointmentId': appointmentId,
          'drNotes': drNotes,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        Get.snackbar(
          "Success",
          "Clinical notes added successfully",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
        await getClinicalNotes(appointmentId);
      } else {
        throw Exception('Failed to add clinical notes');
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        'Failed to add clinical notes: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getClinicalNotes(String appointmentId) async {
    try {
      final response = await ApiService().get(
        '${ApiUrls.getDoctorNotes}$appointmentId',
      );

      if (response.statusCode == 200) {
        final jsonResponse = response.data is String
            ? json.decode(response.data)
            : response.data;

        if (jsonResponse.containsKey('data')) {
          clinicalNote.value = ClinicalNotes.fromJson(jsonResponse['data']);
        } else if (jsonResponse.containsKey('success') && jsonResponse['success'] == true) {
          clinicalNote.value = ClinicalNotes.fromJson(jsonResponse['data'] ?? {});
        } else {
          clinicalNote.value = ClinicalNotes.fromJson(jsonResponse);
        }
      } else if (response.statusCode == 404) {
        clinicalNote.value = ClinicalNotes.empty();
      } else {
        throw Exception('Failed to fetch clinical notes');
      }
    } catch (e) {
      clinicalNote.value = ClinicalNotes.empty();
      Get.snackbar(
        "Info",
        'No clinical notes found for this appointment',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    }
  }

  Future<void> updateClinicalNotes(String appointmentId, String drNotes) async {
    try {
      isLoading.value = true;

      final response = await ApiService().put(
        '${ApiUrls.doctorNotes}/$appointmentId',
        data: {
          'appointmentId': appointmentId,
          'drNotes': drNotes,
        },
      );

      if (response.statusCode == 200) {
        Get.back();
        Get.snackbar(
          "Success",
          "Clinical notes updated successfully",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
        await getClinicalNotes(appointmentId);
      } else {
        throw Exception('Failed to update clinical notes');
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        'Failed to update clinical notes: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
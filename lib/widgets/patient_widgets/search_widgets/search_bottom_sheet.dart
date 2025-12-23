import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:patient_app/utils/app_colors.dart';
import 'package:patient_app/utils/app_strings.dart';
import '../../../controllers/patient_controllers/search_controller.dart';

class SearchBottomSheet extends StatelessWidget {
  SearchBottomSheet({super.key});

  final SearchControllerCustom searchController = Get.find<SearchControllerCustom>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.8.sh,
      width: 1.sw,
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateField(context),
                  const SizedBox(height: 20),
                  _buildReligionDropdown(),
                  const SizedBox(height: 20),
                  _buildLocationDropdown(),
                  const SizedBox(height: 20),
                  _buildConsultationMode(),
                  const SizedBox(height: 20),
                  _buildDistanceSlider(),
                  const SizedBox(height: 20),
                  _buildGenderRadio(),
                  const SizedBox(height: 20),
                  _buildPriceSlider(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          _buildActionButtons(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () => Get.back(),
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(7.r),
            ),
            child: const Icon(Icons.close, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.date.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => searchController.pickDate(context),
          child: Obx(
                () => Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: AppColors.primaryColor, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    searchController.selectedDate.value != null
                        ? DateFormat('dd/MMM/yyyy').format(searchController.selectedDate.value!)
                        : AppStrings.selectDate.tr,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReligionDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.religion.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Obx(
              () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: searchController.selectedReligion.value,
                icon: const Icon(Icons.keyboard_arrow_down),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    searchController.selectedReligion.value = newValue;
                  }
                },
                items: searchController.religions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(fontSize: 16)),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.location.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Obx(
              () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: searchController.selectedLocation.value,
                icon: const Icon(Icons.keyboard_arrow_down),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    searchController.selectedLocation.value = newValue;
                  }
                },
                items: searchController.locations.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16)),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConsultationMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.consultationMode.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Obx(
              () => Row(
            children: [
              Radio<ConsultationMode>(
                activeColor: AppColors.primaryColor,
                value: ConsultationMode.inPerson,
                groupValue: searchController.consultationMode.value,
                onChanged: (ConsultationMode? value) {
                  if (value != null) searchController.consultationMode.value = value;
                },
              ),
              Text(AppStrings.inPerson.tr),
              const SizedBox(width: 20),
              Radio<ConsultationMode>(
                activeColor: AppColors.primaryColor,
                value: ConsultationMode.remote,
                groupValue: searchController.consultationMode.value,
                onChanged: (ConsultationMode? value) {
                  if (value != null) searchController.consultationMode.value = value;
                },
              ),
              Text(AppStrings.teleconsultation.tr),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDistanceSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.distance.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Obx(
              () => Slider(
            activeColor: AppColors.primaryColor,
            value: searchController.distanceRange.value,
            min: 0,
            max: 5,
            label: '${searchController.distanceRange.value.toStringAsFixed(1)}km',
            onChanged: (double value) {
              searchController.distanceRange.value = value;
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0km'),
              Text('5km'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGenderRadio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.gender.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Obx(
              () => Row(
            children: [
              Radio<Gender>(
                activeColor: AppColors.primaryColor,
                value: Gender.male,
                groupValue: searchController.selectedGender.value,
                onChanged: (Gender? value) {
                  if (value != null) searchController.selectedGender.value = value;
                },
              ),
              Text(AppStrings.male.tr),
              const SizedBox(width: 20),
              Radio<Gender>(
                activeColor: AppColors.primaryColor,
                value: Gender.female,
                groupValue: searchController.selectedGender.value,
                onChanged: (Gender? value) {
                  if (value != null) searchController.selectedGender.value = value;
                },
              ),
              Text(AppStrings.female.tr),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.price.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Obx(
              () => Slider(
            activeColor: AppColors.primaryColor,
            value: searchController.priceRange.value,
            min: 0,
            max: 50,
            label: '\$${searchController.priceRange.value.toStringAsFixed(0)}',
            onChanged: (double value) {
              searchController.priceRange.value = value;
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$0'),
              Text('\$50'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: searchController.resetFilters,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                side: BorderSide(color: Colors.grey.shade400),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(AppStrings.reset.tr, style: const TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: ElevatedButton(
              onPressed: searchController.applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(AppStrings.apply.tr, style: const TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
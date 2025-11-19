import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:patient_app/utils/app_colors.dart';
import '../../controllers/search_controller.dart';

class SearchBottomSheet extends GetView<SearchController> {
   SearchBottomSheet({super.key});
SearchControllerCustom searchController=Get.find();
  @override
  Widget build(BuildContext context) {
    Get.put(SearchController());

    return Container(
      height: 0.8.sh,
      width: 1.sw,
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
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
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateField(context),
                  SizedBox(height: 20),
                  _buildReligionDropdown(),
                  SizedBox(height: 20),
                  _buildLocationDropdown(),
                  SizedBox(height: 20),
                  _buildConsultationMode(),
                  SizedBox(height: 20),
                  _buildDistanceSlider(),
                  SizedBox(height: 20),
                  _buildGenderRadio(),
                  SizedBox(height: 20),
                  _buildPriceSlider(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          _buildActionButtons(),
          SizedBox(height: 10),
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
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(7.r),
            ),
            child: Icon(Icons.close, color:Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () => searchController.pickDate(context),
          child: Obx(
                () => Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: AppColors.primaryColor, size: 20),
                  SizedBox(width: 10),
                  Text(
                    searchController.selectedDate.value != null
                        ? DateFormat('dd/MMM/yyyy').format(searchController.selectedDate.value!)
                        : 'Select Date',
                    style: TextStyle(fontSize: 16),
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
        Text('Religion', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 8),
        Obx(
              () => Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: searchController.selectedReligion.value,
                icon: Icon(Icons.keyboard_arrow_down),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    searchController.selectedReligion.value = newValue;
                  }
                },
                items: searchController.religions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(fontSize: 16)),
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
        Text('Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 8),
        Obx(
              () => Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: searchController.selectedLocation.value,
                icon: Icon(Icons.keyboard_arrow_down),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    searchController.selectedLocation.value = newValue;
                  }
                },
                items: searchController.locations.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16)),
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
        Text('Consultation Mode', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
              Text('In-Person'),
              SizedBox(width: 20),
              Radio<ConsultationMode>(
                activeColor: AppColors.primaryColor,
                value: ConsultationMode.remote,
                groupValue: searchController.consultationMode.value,
                onChanged: (ConsultationMode? value) {
                  if (value != null) searchController.consultationMode.value = value;
                },
              ),
              Text('Teleconsultation'),
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
        Text('Distance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
        Padding(
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
        Text('Gender', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
              Text('Male'),
              SizedBox(width: 20),
              Radio<Gender>(
                activeColor: AppColors.primaryColor,
                value: Gender.female,
                groupValue: searchController.selectedGender.value,
                onChanged: (Gender? value) {
                  if (value != null) searchController.selectedGender.value = value;
                },
              ),
              Text('Female'),
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
        Text('Price', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
        Padding(
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
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: searchController.resetFilters,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                side: BorderSide(color: Colors.grey.shade400),
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Reset', style: TextStyle(fontSize: 16)),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: ElevatedButton(
              onPressed: searchController.applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Apply', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
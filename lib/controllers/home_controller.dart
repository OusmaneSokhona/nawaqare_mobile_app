import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../models/appointment_model.dart';

class HomeController extends GetxController{
  RxString appointmentType="upcoming".obs;
  ScrollController scrollController=ScrollController();
  RxDouble scrollValue=0.0.obs;
  void scrollChange(){
    scrollController.addListener((){
      scrollValue.value=scrollController.offset;
      print(scrollValue);
    });
  }
  List<AppointmentModel> doctorList = [
    AppointmentModel(
      name: "Dr. Daniel Lee",
      specialty: "Cardiologist",
      consultationType: "Remote Consultation",
      rating: 5.0,
      fee: 10,
      date: "Sunday, 12 June",
      time: "11:00-12:00 AM",
      status: "Follow Up",
      imageUrl: "assets/demo_images/doctor_1.png",
    ),
    AppointmentModel(
      name: "Dr. Jessica Turner",
      specialty: "Gynecologist",
      consultationType: "Remote Consultation",
      rating: 5.0,
      fee: 10,
      date: "Sunday, 12 June",
      time: "11:00-12:00 AM",
      status: "Renewal",
      imageUrl: "assets/demo_images/doctor_2.png",
    ),
    AppointmentModel(
      name: "Dr. Michael Johnson",
      specialty: "Orthopedic Surgery",
      consultationType: "In person Consultation",
      rating: 5.0,
      fee: 10,
      date: "Sunday, 12 June",
      time: "11:00-12:00 AM",
      status: "Exam Review",
      imageUrl: "assets/demo_images/doctor_3.png",
    ),
    AppointmentModel(
      name: "Dr. Michael Johnson",
      specialty: "Orthopedic Surgery",
      consultationType: "In person Consultation",
      rating: 5.0,
      fee: 10,
      date: "Sunday, 12 June",
      time: "11:00-12:00 AM",
      status: "Initial",
      imageUrl: "assets/demo_images/doctor_4.png",
    ),
  ];
}
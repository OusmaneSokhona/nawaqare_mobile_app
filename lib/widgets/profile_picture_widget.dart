import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

class ProfilePictureWidget extends StatelessWidget {
  GestureTapCallback onTap;
  Rxn<File> pickedImage = Rxn<File>();
  ProfilePictureWidget({super.key,required this.onTap,required this.pickedImage});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Obx(
              () {
            return Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: ClipOval(
                child: pickedImage.value != null
                    ? Image.file(
                  pickedImage.value!,
                  fit: BoxFit.cover,
                  width: 120,
                  height: 120,
                )
                    : Icon(
                  Icons.person_outline_outlined,
                  size: 80,
                  color: Colors.blue.shade700,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

class ProfilePictureWidget extends StatelessWidget {
  GestureTapCallback onTap;
  Rxn<File> pickedImage = Rxn<File>();
  RxString? imageUrl = RxString('');
  ProfilePictureWidget({super.key,required this.onTap,required this.pickedImage,this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: (){
          imageUrl!.value='';
          onTap();
        },
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
              child: (imageUrl!.value==null||imageUrl!.value.isNotEmpty)?Image.network(imageUrl!.value):pickedImage.value != null
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
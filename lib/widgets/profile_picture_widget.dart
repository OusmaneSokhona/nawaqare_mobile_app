import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

class ProfilePictureWidget extends StatelessWidget {
  final GestureTapCallback onTap;
  final Rxn<File> pickedImage;
  final RxString? imageUrl;

  ProfilePictureWidget({
    super.key,
    required this.onTap,
    required this.pickedImage,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          imageUrl?.value = '';
          onTap();
        },
        child: Obx(() {
          return Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: ClipOval(
              child: _buildImage(),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildImage() {
    if (imageUrl != null && imageUrl!.value.isNotEmpty) {
      return Image.network(
        imageUrl!.value,
        fit: BoxFit.cover,
        width: 120,
        height: 120,
        errorBuilder: (context, error, stackTrace) {
          return _buildPickedImageOrIcon();
        },
      );
    }

    return _buildPickedImageOrIcon();
  }

  Widget _buildPickedImageOrIcon() {
    if (pickedImage.value != null) {
      return Image.file(
        pickedImage.value!,
        fit: BoxFit.cover,
        width: 120,
        height: 120,
      );
    }

    return Icon(
      Icons.person_outline_outlined,
      size: 80,
      color: Colors.blue.shade700,
    );
  }
}
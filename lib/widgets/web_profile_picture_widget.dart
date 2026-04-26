import 'package:flutter/foundation.dart'; // Required for Uint8List
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebProfilePictureWidget extends StatelessWidget {
  final VoidCallback onTap;
  final Rxn<Uint8List> pickedImageBytes;

  WebProfilePictureWidget({
    super.key,
    required this.onTap,
    required this.pickedImageBytes,
  });

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
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [BoxShadow(blurRadius: 2, color: Colors.black12)],
              ),
              child: ClipOval(
                child: pickedImageBytes.value != null
                    ? Image.memory(
                  pickedImageBytes.value!,
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
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient_app/utils/app_colors.dart';

import '../utils/app_fonts.dart';

class OrderTrackingCard extends StatelessWidget {
  final int currentStep;

  const OrderTrackingCard({required this.currentStep, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(alignment:Alignment.centerLeft,child: Text("Current Order",style: TextStyle(fontSize:18.sp,fontFamily:AppFonts.jakartaMedium,fontWeight: FontWeight.w700,color: Colors.black),)),
        5.verticalSpace,
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                   Text(
                    'Track Order',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 0,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Detail', style: TextStyle(fontSize: 14)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Package ID:1234566',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'From: Pharmacie Centrale de paris',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 24),
              OrderProgressStepper(currentStep: currentStep),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Estimated: 45 mint',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OrderProgressStepper extends StatelessWidget {
  final int currentStep;

  const OrderProgressStepper({required this.currentStep, super.key});

  static const List<String> stepTitles = ['Order', 'Preparing', 'In Delivery', 'Delivered'];
  static const Color activeColor = Color(0xFF4C86F7);
  static const Color completedColor = Color(0xFF10B981);
  static const Color inactiveColor = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(stepTitles.length, (index) {
        final int step = index + 1;
        final bool isCompleted = step < currentStep;
        final bool isActive = step == currentStep;

        return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildStepCircle(step, isCompleted, isActive),
                  if (index < stepTitles.length - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: isCompleted ? completedColor : inactiveColor,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                stepTitles[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isCompleted || isActive ? FontWeight.w600 : FontWeight.normal,
                  color: isCompleted || isActive ? Color(0xFF1F2937) : Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStepCircle(int step, bool isCompleted, bool isActive) {
    Color circleColor;
    Widget child;

    if (isCompleted) {
      circleColor = completedColor;
      child = const Icon(Icons.check, color: Colors.white, size: 16);
    } else if (isActive) {
      circleColor = activeColor;
      child = Text(
        '$step',
        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
      );
    } else {
      circleColor = inactiveColor;
      child = Text(
        '$step',
        style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13, fontWeight: FontWeight.w500),
      );
    }

    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: circleColor,
        shape: BoxShape.circle,
        border: isActive || isCompleted ? null : Border.all(color: inactiveColor, width: 1.5),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
import 'package:flutter/material.dart';

class ProgressStepper extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProgressStepper({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  })  : assert(currentStep >= 1),
        assert(totalSteps >= 1);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(totalSteps * 2 - 1, (index) {
        final stepIndex = (index ~/ 2) + 1; // 1-based step index

        if (index.isOdd) {
          final isCompleted = stepIndex <= currentStep - 1;
          return Expanded(
            child: Container(
              height: 2.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: isCompleted ? Colors.green.shade600 : Colors.grey.shade300,
              ),
            ),
          );
        } else {
          // Step Indicator (Circle)
          return _buildStepIndicator(stepIndex);
        }
      }),
    );
  }

  Widget _buildStepIndicator(int stepIndex) {
    final isCompleted = stepIndex < currentStep;
    final isActive = stepIndex == currentStep;
    final isInactive = stepIndex > currentStep;

    Color backgroundColor;
    Color borderColor;
    Widget content;

    if (isCompleted) {
      backgroundColor = Colors.green.shade600;
      borderColor = Colors.green.shade600;
      content = const Icon(
        Icons.check,
        color: Colors.white,
        size: 16.0,
      );
    } else if (isActive) {
      backgroundColor = Colors.blue.shade600;
      borderColor = Colors.blue.shade600;
      content = Text(
        '$stepIndex',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14.0,
        ),
      );
    } else {
      backgroundColor = Colors.white;
      borderColor = Colors.grey.shade300;
      content = Text(
        '$stepIndex',
        style: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.bold,
          fontSize: 14.0,
        ),
      );
    }

    return Container(
      width: 36.0,
      height: 36.0,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2.0,
        ),
      ),
      alignment: Alignment.center,
      child: content,
    );
  }
}



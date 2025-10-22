import 'package:flutter/material.dart';
import 'package:plan_z/features/on_boarding/ui/widgets/text_with_button_and_indicator/custom_circular_progress.dart';
import 'package:plan_z/features/on_boarding/ui/widgets/text_with_button_and_indicator/indicator.dart';
import 'insider_circular.dart';

class BottomWidgets extends StatelessWidget {
  const BottomWidgets({
    super.key,
    required this.currentIndex,
    required this.controller,
  });

  final int currentIndex;
  final PageController controller;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Indicator(
          currentIndex: currentIndex,
        ),
        Stack(
          children: [
            OuterCircular(
              currentIndex: currentIndex,
            ),
            InsiderCircular(
              currentIndex: currentIndex,
              controller: controller,
            ),
          ],
        ),
      ],
    );
  }
}

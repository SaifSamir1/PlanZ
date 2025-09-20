import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../../data/model/page_model.dart';

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.currentIndex,
  });

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return SlideInLeft(
      duration: const Duration(milliseconds: 800),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: AnimatedContainer(
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 300),
              width: index == currentIndex ? 28 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: index == currentIndex
                    ? PageModel.pagesDetails[currentIndex].color
                    : PageModel.pagesDetails[currentIndex].color.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

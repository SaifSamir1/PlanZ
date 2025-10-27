import 'package:flutter/material.dart';
import 'package:plan_z/features/on_boarding/ui/widgets/welcome_slide.dart';

class PageViewBuilder extends StatelessWidget {
  const PageViewBuilder({
    required this.controller,
    super.key,
  });

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      children: const [
        WelcomeSlide(
          path: "assets/images/owner.jpg",
        ),
        WelcomeSlide(
          path: "assets/images/vendor.jpg",
        ),
        WelcomeSlide(
          path: "assets/images/attandee.jpg",
        ),
      ],
    );
  }
}

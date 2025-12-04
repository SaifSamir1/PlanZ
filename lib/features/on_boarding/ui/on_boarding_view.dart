import 'package:flutter/material.dart';
import 'package:plan_z/features/on_boarding/ui/widgets/language_selector_button.dart';
import 'package:plan_z/features/on_boarding/ui/widgets/onboarding_screen_body.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [LanguageSelectorButton()],
      ),
      body: const OnBoardingScreenBody(),
    );
  }
}

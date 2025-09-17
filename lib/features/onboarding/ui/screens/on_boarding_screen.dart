import 'package:flutter/material.dart';
import 'package:flutter_carousel_intro/flutter_carousel_intro.dart';
import 'package:flutter_carousel_intro/slider_item_model.dart';
import 'package:plan_z/core/theming/text_stayls.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/onboarding/ui/screens/stakeholders_selection_screen.dart';

class OnBoardingScreen extends StatelessWidget {
  OnBoardingScreen({super.key});

  final List<SliderItem> slides = [
    SliderItem(
      title: 'Create Your Event in Minutes',
      titleTextAlign: TextAlign.center,
      titleTextStyle: AppTextStyles.title,
      subtitle: Text(
        "Pick your event type, set a budget, explore vendors, and preview your event before booking.",
        textAlign: TextAlign.center,
        style: AppTextStyles.subtitle,
      ),
      widget: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.asset('assets/images/owner.jpg'),
      ),
    ),
    SliderItem(
      title: 'Grow Your Business',
      titleTextAlign: TextAlign.center,
      titleTextStyle: AppTextStyles.title,
      subtitle: Text(
        "Add packages, set prices, and get discovered by event organizers looking for your services.",
        textAlign: TextAlign.center,
        style: AppTextStyles.subtitle,
      ),
      widget: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.asset('assets/images/vendor.jpg'),
      ),
    ),
    SliderItem(
      title: 'Stay Connected',
      titleTextAlign: TextAlign.center,
      titleTextStyle: AppTextStyles.title,
      subtitle: Text(
        "Receive invitations, RSVP instantly, and get reminders — never miss an event.",
        textAlign: TextAlign.center,
        style: AppTextStyles.subtitle,
      ),
      widget: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.asset('assets/images/attandee.jpg'),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            FlutterCarouselIntro(
              animatedOpacity: true,
              animatedRotateX: true,
              autoPlay: true,
              autoPlaySlideDuration: Duration(seconds: 5),
              slides: slides,
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => StakeholdersSelectionScreen(),

                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Skip',
                        style: AppTextStyles.subtitle.copyWith(
                          color: AppColors.primaryGold,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.arrow_forward, color: AppColors.primaryGold),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

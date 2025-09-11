import 'package:flutter/material.dart';
import 'package:flutter_carousel_intro/flutter_carousel_intro.dart';
import 'package:flutter_carousel_intro/slider_item_model.dart';
import 'package:plan_z/core/theming/text_stayls.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/onboarding/ui/screens/stakeholders_selection_screen.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterCarouselIntro(
        animatedOpacity: true,
        animatedRotateX: true,
        autoPlay: true,
        autoPlaySlideDuration: Duration(seconds: 5),
        slides: [
          SliderItem(
            title: 'Welcome to Plan Z',
            titleTextAlign: TextAlign.center,
            titleTextStyle: AppTextStyles.title,
            subtitle: Text(
              'Your Vision, Our Mission',
              textAlign: TextAlign.center,
              style: AppTextStyles.subtitle,
            ),
            widget: Image.asset('assets/images/Frame_3.png'),
          ),
          SliderItem(
            title: 'Create Your Event in Minutes',
            titleTextAlign: TextAlign.center,
            titleTextStyle: AppTextStyles.title,
            subtitle: Text(
              "Pick your event type, set a budget, explore vendors, and preview your event before booking.",
              textAlign: TextAlign.center,
              style: AppTextStyles.subtitle,
            ),
            widget: Image.asset('assets/images/owner.jpg'),
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
            widget: Image.asset('assets/images/vendor.jpg'),
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
            widget: Image.asset('assets/images/attandee.jpg'),
          ),
          SliderItem(
            widget: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/event.jpg',
                    fit: BoxFit.cover,
                    height: 450,
                  ),
                  SizedBox(height: 50),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGold,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StakeholdersSelectionScreen(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Get Started", style: AppTextStyles.button),
                          SizedBox(width: 40),
                          Icon(
                            size: 20,
                            Icons.arrow_forward,
                            color: AppColors.primaryDark,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

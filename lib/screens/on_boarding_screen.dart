import 'package:flutter/material.dart';
import 'package:flutter_carousel_intro/flutter_carousel_intro.dart';
import 'package:flutter_carousel_intro/slider_item_model.dart';

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
            titleTextStyle: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xFF21225B),
            ),
            subtitle: Text(
              'Your Vision, Our Mission',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Color(0xFF21225B),
              ),
            ),
            widget: Image.asset('assets/images/Frame_3.png'),
          ),
          SliderItem(
            title: 'Create Your Event in Minutes',
            titleTextAlign: TextAlign.center,
            titleTextStyle: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xFF21225B),
            ),
            subtitle: Text(
              "Pick your event type, set a budget, explore vendors, and preview your event before booking.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Color(0xFF21225B),
              ),
            ),
            widget: Image.asset('assets/images/owner.jpg'),
          ),
          SliderItem(
            title: 'Grow Your Business',
            titleTextAlign: TextAlign.center,
            titleTextStyle: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xFF21225B),
            ),
            subtitle: Text(
              "Add packages, set prices, and get discovered by event organizers looking for your services.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Color(0xFF21225B),
              ),
            ),
            widget: Image.asset('assets/images/vendor.jpg'),
          ),
          SliderItem(
            title: 'Stay Connected',
            titleTextAlign: TextAlign.center,
            titleTextStyle: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xFF21225B),
            ),
            subtitle: Text(
              "Receive invitations, RSVP instantly, and get reminders — never miss an event.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Color(0xFF21225B),
              ),
            ),
            widget: Image.asset('assets/images/attandee.jpg'),
          ),
          SliderItem(
            widget: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/event.jpg',
                  fit: BoxFit.cover,
                  height: 450,
                ),
                 SizedBox(height: 120),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE3C100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                    ),
                    onPressed: () {
                      // Navigate to the next screen 
                    },
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Get Started",
                          style: TextStyle(fontSize: 23, color: Color(0xFF21225B)),
                        ),
                        SizedBox(width: 45),
                        Icon(
                          size: 30,
                          Icons.arrow_forward,
                          color: Color(0xFF21225B),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

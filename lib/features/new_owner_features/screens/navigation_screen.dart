
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';
import 'owner_home_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final _pageController = PageController();
  final NotchBottomBarController _controller = NotchBottomBarController(index: 0);

  final List<Widget> _screens =  [
    OwnerHomeScreen(),
    Screen(title: "Chat 💬"),
    Screen(title: "Add "),
    Screen(title: "Event 👤"),
    Screen(title: "Profile 👤"),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // disable swipe
        children: _screens,
      ),

      // ✅ Only Animated Notch Bottom Bar
      bottomNavigationBar: AnimatedNotchBottomBar(

        kBottomRadius:5,
        kIconSize :20,
        notchBottomBarController: _controller,
        color: Colors.white,
        notchColor: AppColors.primaryDark,
        showLabel: true,
        durationInMilliSeconds: 300,
        removeMargins: false,
        bottomBarItems: const [
          BottomBarItem(
            inActiveItem: Icon(Icons.home_outlined, color: AppColors.primaryDark),
            activeItem: Icon(Icons.home, color: Colors.white),
            itemLabelWidget: Text('Home',style: TextStyle(color: AppColors.primaryDark),),

          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.chat_bubble_outline, color: AppColors.primaryDark),
            activeItem: Icon(Icons.chat, color: Colors.white),
            itemLabelWidget: Text('Chat',style: TextStyle(color: AppColors.primaryDark),),
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.add_box_outlined, color: AppColors.primaryDark),
            activeItem: Icon(Icons.add_box_rounded, color: Colors.white),
            itemLabelWidget: Text('Add',style: TextStyle(color: AppColors.primaryDark),),
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.calendar_today_outlined, color: AppColors.primaryDark),
            activeItem: Icon(Icons.calendar_today_rounded, color: Colors.white),
            itemLabelWidget: Text('Event',style: TextStyle(color: AppColors.primaryDark),),
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.person_outline, color: AppColors.primaryDark),
            activeItem: Icon(Icons.person, color: Colors.white),
            itemLabelWidget: Text('Profile',style: TextStyle(color: AppColors.primaryDark),),
          ),
        ],
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
      ),
    );
  }
}

//
// 🔹 Simple Screen Widget
class Screen extends StatelessWidget {
  final String title;
  const Screen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
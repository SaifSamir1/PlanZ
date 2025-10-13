import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/features/new_owner_features/event_owner_home/ui/screens/payment_history.dart';
import 'package:plan_z/features/new_owner_features/user_info/ui/screens/profile_screen.dart';
import 'package:plan_z/features/new_owner_features/chat_bot/cubits/chat_cubit.dart';
import 'package:plan_z/features/new_owner_features/chat_bot/ui/chat_bot_screen.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/ui/screens/create_event_screen.dart';
import '../../../../../../../core/utils/app_colors.dart';
import 'owner_home_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final _pageController = PageController();
  final NotchBottomBarController _controller = NotchBottomBarController(
    index: 0,
  );

  final List<Widget> _screens = [
    const OwnerHomeScreen(),
    BlocProvider(create: (context) => ChatCubit(), child: const ChatScreen()),
    const CreateEventScreen(),
    const ProfileScreen(),
    const PaymentHistory(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: AnimatedNotchBottomBar(
          kBottomRadius: 12,
          kIconSize: 22,
          notchBottomBarController: _controller,
          color: Colors.white,
          notchColor: AppColors.primaryGold,
          showLabel: true,
          durationInMilliSeconds: 400,
          removeMargins: false,
          bottomBarItems: [
            BottomBarItem(
              inActiveItem: const Icon(
                Icons.home_outlined,
                color: AppColors.primaryDark,
              ),
              activeItem: const Icon(Icons.home_rounded, color: Colors.white),
              itemLabelWidget: Text(
                'Home',
                style: TextStyle(
                  color: AppColors.primaryDark.withOpacity(0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            BottomBarItem(
              inActiveItem: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: AppColors.primaryDark,
              ),
              activeItem: const Icon(
                Icons.chat_bubble_rounded,
                color: Colors.white,
              ),
              itemLabelWidget: Text(
                'Chat',
                style: TextStyle(
                  color: AppColors.primaryDark.withOpacity(0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            BottomBarItem(
              inActiveItem: Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: AppColors.primaryGold,
                  size: 24,
                ),
              ),
              activeItem: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 26,
              ),
              itemLabelWidget: Text(
                'Create',
                style: TextStyle(
                  color: AppColors.primaryGold,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            BottomBarItem(
              inActiveItem: const Icon(
                Icons.person_outline_rounded,
                color: AppColors.primaryDark,
              ),
              activeItem: const Icon(Icons.person_rounded, color: Colors.white),
              itemLabelWidget: Text(
                'Profile',
                style: TextStyle(
                  color: AppColors.primaryDark.withOpacity(0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            BottomBarItem(
              inActiveItem: const Icon(
                Icons.history_rounded,
                color: AppColors.primaryDark,
              ),
              activeItem: const Icon(
                Icons.history_rounded,
                color: Colors.white,
              ),
              itemLabelWidget: Text(
                'Payment',
                style: TextStyle(
                  color: AppColors.primaryDark.withOpacity(0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          onTap: (index) {
            _controller.index = index; 
            _pageController.jumpToPage(index); 
          },
        ),
      ),
    );
  }
}

class Screen extends StatelessWidget {
  final String title;
  const Screen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeIn(
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

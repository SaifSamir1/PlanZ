import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/features/event_owners/create_event_screen/ui/screens/select_event_type_screen.dart';
import 'package:plan_z/features/event_owners/event_owner_home/ui/screens/payment_history.dart';
import 'package:plan_z/features/event_owners/user_info/ui/screens/profile_screen.dart';
import 'package:plan_z/features/event_owners/chat_bot/cubits/chat_cubit.dart';
import 'package:plan_z/features/event_owners/chat_bot/ui/chat_bot_screen.dart';
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
    const SelectEventTypeScreen(),
    const PaymentHistory(),
    const ProfileScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // هام: يخلي الـ body يمتد تحت الـ BottomBar
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      floatingActionButton: _buildChatFAB(),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withOpacity(0.15),
              blurRadius: 25,
              offset: const Offset(0, -8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: AppColors.primaryGold.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, -4),
              spreadRadius: -2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: AnimatedNotchBottomBar(
            notchBottomBarController: _controller,

            // Colors & Style
            color: Colors.white,
            notchColor: AppColors.primaryGold,
            showBlurBottomBar: false,
            showShadow: false, // نستخدم shadow مخصص
            // Spacing & Sizing
            kBottomRadius: 24,
            kIconSize: 24,
            bottomBarHeight: 20,
            removeMargins: true,

            // Animation
            durationInMilliSeconds: 350,
            showLabel: true,

            // Items
            bottomBarItems: [
              // 1. Home
              BottomBarItem(
                inActiveItem: Icon(
                  Icons.home_outlined,
                  color: AppColors.primaryDark.withOpacity(0.6),
                ),
                activeItem: const Icon(
                  Icons.home_rounded,
                  color: Colors.white,
                  size: 26,
                ),
                itemLabelWidget: _buildLabel('navigation.home'.tr(), false),
              ),

              // 2. Create (Center - Special)
              BottomBarItem(
                inActiveItem: Icon(
                  Icons.add_rounded,
                  color: AppColors.primaryDark.withOpacity(0.6),
                  size: 28,
                ),
                activeItem: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                itemLabelWidget: _buildLabel('navigation.create'.tr(), false),
              ),

              // 3. Payment
              BottomBarItem(
                inActiveItem: Icon(
                  Icons.account_balance_wallet_outlined,
                  color: AppColors.primaryDark.withOpacity(0.6),
                ),
                activeItem: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                  size: 26,
                ),
                itemLabelWidget: _buildLabel('navigation.wallet'.tr(), false),
              ),

              // 4. Profile
              BottomBarItem(
                inActiveItem: Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.primaryDark.withOpacity(0.6),
                ),
                activeItem: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 26,
                ),
                itemLabelWidget: _buildLabel('navigation.profile'.tr(), false),
              ),
            ],

            onTap: (index) {
              setState(() {
                _controller.index = index;
                _pageController.jumpToPage(index);
              });
            },
          ),
        ),
      ),
    );
  }

  /// ============================================
  /// Chat Floating Action Button
  /// ============================================
  Widget _buildChatFAB() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => ChatCubit(),
              child: const ChatScreen(),
            ),
          ),
        );
      },
      backgroundColor: AppColors.primaryGold,
      foregroundColor: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      tooltip: 'attendee.chat_tooltip'.tr(),
      child: const Icon(Icons.chat_bubble_rounded, size: 26),
    );
  }

  Widget _buildLabel(String text, bool isActive, {bool isSpecial = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text,
        style: TextStyle(
          color: isSpecial
              ? AppColors.primaryGold
              : isActive
              ? AppColors.primaryDark
              : AppColors.primaryDark.withOpacity(0.5),
          fontSize: isSpecial ? 12 : 10,
          fontWeight: isSpecial ? FontWeight.w700 : FontWeight.w600,
          letterSpacing: 0.3,
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
          duration: const Duration(milliseconds: 600),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryGold.withOpacity(0.1),
                  AppColors.primaryGold.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primaryGold.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

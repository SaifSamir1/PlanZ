// lib/features/attendee/presentation/screens/attendee_home_screen.dart

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/attandee/cubit/attendee_cubit.dart';
import 'package:plan_z/features/attandee/ui/home/ui/screens/attandee_notification.dart';
import 'package:plan_z/features/attandee/ui/home/ui/widgets/attendee_stats_card.dart';
import 'package:plan_z/features/attandee/ui/home/ui/widgets/quick_actions_section.dart';
import 'package:plan_z/features/attandee/ui/home/ui/widgets/upcoming_events_section.dart';
import 'package:plan_z/features/auth/data/models/user_manager.dart';

class AttendeeHomeScreen extends StatefulWidget {
  const AttendeeHomeScreen({super.key});

  @override
  State<AttendeeHomeScreen> createState() => _AttendeeHomeScreenState();
}

class _AttendeeHomeScreenState extends State<AttendeeHomeScreen> {
  UserManager userManager = UserManager();

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  void _loadData() {
    final cubit = context.read<AttendeeCubit>();
    cubit.getAttendeeStats(userManager.currentUser!.id);
    cubit.getUpcomingEvents(userManager.currentUser!.id);
  }

  Future<void> _onRefresh() async {
    _loadData();
    // Wait for both states to complete
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: "EventFlow",
        actions: [
          // Notification Icon
          SlideInRight(
            duration: const Duration(milliseconds: 700),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                );
              },

              icon: Icon(
                Icons.notifications_outlined,
                color: AppColors.buttonPrimary,
              ),
            ),
          ),
          // User Avatar
          SlideInRight(
            duration: const Duration(milliseconds: 800),
            delay: const Duration(milliseconds: 100),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: const Color(0xfff8f9fa),
                radius: 19,
                child: Icon(
                  Icons.person_outline,
                  color: AppColors.buttonPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.buttonPrimary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Card
              FadeInUp(
                duration: const Duration(milliseconds: 500),
                child: AttendeeStatsCard(
                  attendeeId: userManager.currentUser!.id,
                ),
              ),

              const SizedBox(height: 24),

              // Quick Actions
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 100),
                child: const QuickActionsSection(),
              ),

              const SizedBox(height: 24),

              // Upcoming Events
              FadeInUp(
                duration: const Duration(milliseconds: 700),
                delay: const Duration(milliseconds: 200),
                child: UpcomingEventsSection(
                  attendeeId: userManager.currentUser!.id,
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

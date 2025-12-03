// lib/features/attendee/presentation/screens/my_events_screen.dart

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/attandee/cubit/attendee_cubit.dart';
import 'package:plan_z/features/attandee/cubit/attendee_state.dart';
import 'package:plan_z/features/attandee/ui/home/ui/widgets/attendee1_event_card.dart';
import 'package:plan_z/features/attandee/ui/home/ui/widgets/empty1_events_widget.dart';
import 'package:plan_z/features/attandee/ui/home/ui/widgets/event_filter_tabs.dart';
import 'package:plan_z/features/attandee/ui/home/ui/widgets/my_events_loading_shimmer.dart';
import 'package:plan_z/features/auth/data/models/user_manager.dart';
import 'package:plan_z/features/event_owners/create_event_screen/data/models/event_model.dart';

enum EventFilter { all, upcoming, past }

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  UserManager userManager = UserManager();

  EventFilter selectedFilter = EventFilter.upcoming;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);

    _loadEvents();

    // Listen to tab changes
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          selectedFilter = EventFilter.values[_tabController.index];
        });
        _loadEvents();
      }
    });
  }

  void _loadEvents() {
    debugPrint('📥 Loading attendee events with filter: $selectedFilter');
    final userId = userManager.currentUser?.id;

    if (userId == null) {
      debugPrint('❌ User ID is null');
      return;
    }

    switch (selectedFilter) {
      case EventFilter.all:
        context.read<AttendeeCubit>().getMyAcceptedEvents(userId);
        break;
      case EventFilter.upcoming:
        context.read<AttendeeCubit>().getUpcomingEvents(userId);
        break;
      case EventFilter.past:
        context.read<AttendeeCubit>().getPastEvents(userId);
        break;
    }
  }

  Future<void> _onRefresh() async {
    _loadEvents();
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'attendee.my_events_title'.tr()),
      body: Column(
        children: [
          // Filter Tabs
          FadeInDown(
            duration: const Duration(milliseconds: 500),
            child: EventFilterTabs(
              controller: _tabController,
              selectedFilter: selectedFilter,
            ),
          ),

          // Events List
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColors.buttonPrimary,
              child: _buildEventsList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList() {
    return BlocBuilder<AttendeeCubit, AttendeeState>(
      builder: (context, state) {
        // Loading States
        if (state is GetMyAcceptedEventsLoading ||
            state is GetUpcomingEventsLoading ||
            state is GetPastEventsLoading) {
          return const MyEventsLoadingShimmer();
        }

        // Error States
        if (state is GetMyAcceptedEventsError) {
          return _buildErrorWidget(state.message);
        }
        if (state is GetUpcomingEventsError) {
          return _buildErrorWidget(state.message);
        }
        if (state is GetPastEventsError) {
          return _buildErrorWidget(state.message);
        }

        // Success States
        List<EventModel> events = [];

        if (state is GetMyAcceptedEventsSuccess) {
          events = state.events;
        } else if (state is GetUpcomingEventsSuccess) {
          events = state.events;
        } else if (state is GetPastEventsSuccess) {
          events = state.events;
        }

        // Empty State
        if (events.isEmpty) {
          return Empty1EventsWidget(filterType: selectedFilter);
        }

        // Display Events
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: events.length,
          itemBuilder: (context, index) {
            return FadeInUp(
              duration: const Duration(milliseconds: 400),
              delay: Duration(milliseconds: 50 * index),
              child: Attendee1EventCard(
                event: events[index],
                onTap: () {
                  // Navigate to Event Details
                  // Navigator.pushNamed(
                  //   context,
                  //   '/event-details',
                  //   arguments: events[index].eventId,
                  // );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'attendee.upcoming_events_failed'.tr(),
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadEvents,
              icon: const Icon(Icons.refresh),
              label: Text('attendee.retry'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

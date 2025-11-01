// lib/features/event_owner/presentation/screens/owner_home_screen.dart

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/auth/data/models/user_manager.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/cubits/create_event_cubit/create_event_cubit.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/cubits/create_event_cubit/create_event_state.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/data/models/event_model.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/ui/screens/my_events_list_screen.dart';
import 'package:plan_z/features/new_owner_features/event_owner_home/ui/screens/services_screen.dart';
import 'owner_notification_screen.dart';

class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  late GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    _loadOwnerEvents();
  }

  /// ✅ تحميل الـ Events
  void _loadOwnerEvents() {
    debugPrint('🔄 Loading owner events...');
    final ownerId = UserManager().userId;
    if (ownerId != null) {
      context.read<EventOwnerCubit>().getEventOwnerEvents(ownerId);
    } else {
      debugPrint('❌ User ID is null');
    }
  }

  /// ✅ Refresh the events list
  Future<void> _onRefresh() async {
    debugPrint('🔃 User initiated refresh');
    setState(() {
      _isRefreshing = true;
    });

    _loadOwnerEvents();

    // انتظر 2 ثانية لتأكد من انتهاء الـ Loading
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Home',
        actions: [
          // Notification Icon
          SlideInRight(
            duration: const Duration(milliseconds: 700),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
                size: 24,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OwnerNotificationScreen(),
                  ),
                );
              },
            ),
          ),
          // Profile Avatar
          SlideInRight(
            duration: const Duration(milliseconds: 800),
            delay: const Duration(milliseconds: 100),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300, width: 1.5),
              ),
              child: CircleAvatar(
                radius: 18,
                child: Text(
                  UserManager().getUserInitials(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _onRefresh,
        color: AppColors.primaryGold,
        backgroundColor: Colors.white,
        strokeWidth: 2.5,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(),
              const SizedBox(height: 28),
              _buildQuickActionsSection(context),
              _buildUpcomingEventsSection(),
              const SizedBox(height: 150),
            ],
          ),
        ),
      ),
    );
  }

  /// ============================================
  /// Welcome Card Section
  /// ============================================
  Widget _buildWelcomeCard() {
    final userName = UserManager().userName ?? 'User';

    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $userName! 👋',
                    style: AppTextStyles.headline3,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Welcome back to PlanZ.',
                    style: TextStyle(
                      color: AppColors.primaryDark.withOpacity(0.6),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade300, width: 1.5),
              ),
              child: CircleAvatar(
                radius: 22,
                child: Text(
                  UserManager().getUserInitials(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ============================================
  /// Quick Actions Section
  /// ============================================
  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInUp(
          duration: const Duration(milliseconds: 600),
          child: Text("Quick Actions", style: AppTextStyles.headline3),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.3,
          children: [
            // My Events Action
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyEventsListScreen(),
                  ),
                );
              },
              child: SlideInLeft(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 100),
                child: _quickAction(
                  Icons.calendar_month_outlined,
                  "My Events",
                ),
              ),
            ),
            // Services Action
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ServicesScreen(),
                  ),
                );
              },
              child: SlideInRight(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 100),
                child: _quickAction(
                  Icons.miscellaneous_services_outlined,
                  "Services",
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// ============================================
  /// Upcoming Events Section ✅ معدّل
  /// ============================================
  Widget _buildUpcomingEventsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 28),
        FadeInUp(
          duration: const Duration(milliseconds: 600),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Upcoming Events",
                style: AppTextStyles.headline3,
              ),
              // ✅ Refresh Button
              if (!_isRefreshing)
                GestureDetector(
                  onTap: () {
                    _refreshIndicatorKey.currentState?.show();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.refresh_rounded,
                      size: 20,
                      color: AppColors.primaryDark.withOpacity(0.7),
                    ),
                  ),
                )
              else
                // ✅ Loading Indicator أثناء الـ Refresh
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryGold,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        BlocBuilder<EventOwnerCubit, EventOwnerState>(
          builder: (context, state) {
            debugPrint('📊 State: ${state.runtimeType}');

            // ============================================
            // Loading State
            // ============================================
            if (state is GetEventOwnerEventsLoading) {
              return SizedBox(
                height: 285,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index == 0 ? 16 : 0,
                      ),
                      child: _buildLoadingCard(),
                    );
                  },
                ),
              );
            }

            // ============================================
            // Error State
            // ============================================
            if (state is GetEventOwnerEventsError) {
              return _buildErrorWidget(state.message);
            }

            // ============================================
            // Success State ✅
            // ============================================
            if (state is GetEventOwnerEventsSuccess) {
              debugPrint('✅ Events loaded: ${state.events.length}');

              // فلتر الـ Upcoming Events و ترتيبها
              final upcomingEvents = state.events
                  .where((event) => event.eventDate.isAfter(DateTime.now()))
                  .toList()
                ..sort((a, b) => a.eventDate.compareTo(b.eventDate));

              if (upcomingEvents.isEmpty) {
                return _buildEmptyState();
              }

              return SizedBox(
                height: 285,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: upcomingEvents.length,
                  itemBuilder: (context, index) {
                    final event = upcomingEvents[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index < upcomingEvents.length - 1 ? 16 : 0,
                      ),
                      child: SlideInLeft(
                        duration: const Duration(milliseconds: 700),
                        delay: Duration(milliseconds: 100 * index),
                        child: _eventCard(event),
                      ),
                    );
                  },
                ),
              );
            }

            // ============================================
            // Default State
            // ============================================
            return _buildEmptyState();
          },
        ),
      ],
    );
  }

  /// ============================================
  /// Quick Action Card Widget
  /// ============================================
  Widget _quickAction(IconData icon, String label) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryDark.withOpacity(0.7),
                size: 26,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.primaryDark,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// ============================================
  /// Event Card Widget
  /// ============================================
  Widget _eventCard(EventModel event) {
    final formattedDate = DateFormat('MMM d, yyyy').format(event.eventDate);

    return SizedBox(
      width: 280,
      child: InkWell(
        onTap: () {
          // TODO: Navigate to Event Details
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => EventDetailsScreen(eventId: event.eventId),
          //   ),
          // );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Image or Placeholder
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: _buildEventPlaceholder(),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.eventName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: AppColors.primaryDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          size: 16,
                          color: AppColors.primaryDark.withOpacity(0.6),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.primaryDark.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.place_outlined,
                          size: 16,
                          color: AppColors.primaryDark.withOpacity(0.6),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            event.location,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.primaryDark.withOpacity(0.6),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "View Details",
                          style: TextStyle(
                            color: AppColors.primaryGold,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: AppColors.primaryDark.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ============================================
  /// Event Placeholder (Loading or No Image)
  /// ============================================
  Widget _buildEventPlaceholder() {
    return Container(
      height: 140,
      width: double.infinity,
      color: Colors.grey[200],
      child: Icon(
        Icons.event_rounded,
        size: 48,
        color: Colors.grey[400],
      ),
    );
  }

  /// ============================================
  /// Loading Card (Shimmer Effect Alternative)
  /// ============================================
  Widget _buildLoadingCard() {
    return SizedBox(
      width: 280,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[200],
        ),
        child: Column(
          children: [
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 16,
                    child: null, // Placeholder for shimmer
                  ),
                  SizedBox(height: 12),
                  SizedBox(height: 14),
                  SizedBox(height: 12),
                  SizedBox(height: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ============================================
  /// Error Widget
  /// ============================================
  Widget _buildErrorWidget(String message) {
    return Container(
      height: 285,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red[200]!, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red[300],
          ),
          const SizedBox(height: 12),
          const Text(
            'Failed to load events',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadOwnerEvents,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// ============================================
  /// Empty State Widget
  /// ============================================
  Widget _buildEmptyState() {
    return Container(
      height: 285,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy_rounded,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          const Text(
            'No Upcoming Events',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first event to get started!',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

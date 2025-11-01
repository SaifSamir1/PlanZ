// lib/features/new_owner_features/invitations/ui/screens/my_events_list_screen.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // ✅ إضافة هذا
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/cubits/create_event_cubit/create_event_cubit.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/cubits/create_event_cubit/create_event_state.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/data/models/event_model.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/data/models/event_model_enum.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/ui/screens/event_details_screen.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/ui/screens/event_tracking_screen.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/ui/screens/payment_screen.dart';

class MyEventsListScreen extends StatefulWidget {
  const MyEventsListScreen({super.key});

  @override
  State<MyEventsListScreen> createState() => _MyEventsListScreenState();
}

class _MyEventsListScreenState extends State<MyEventsListScreen> {
  String _selectedFilter = 'All';
  bool _isLocaleInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeLocale(); // ✅ تهيئة الـ Locale
    _loadEvents();
  }

  /// ✅ Initialize Locale for DateFormat
  Future<void> _initializeLocale() async {
    try {
      // ✅ Initialize the local for English (default)
      await initializeDateFormatting('en', null);
      debugPrint('✅ Date formatting initialized');
      setState(() => _isLocaleInitialized = true);
    } catch (e) {
      debugPrint('⚠️ Error initializing date format: $e');
      // Continue anyway - use simple format
      setState(() => _isLocaleInitialized = true);
    }
  }

  /// ✅ Load Events
  void _loadEvents() {
    debugPrint('🔄 Loading events...');
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      context.read<EventOwnerCubit>().getEventOwnerEvents(currentUser.uid);
    }
  }

  /// ✅ Filter Events based on Status
  List<EventModel> _filterEvents(List<EventModel> events) {
    if (_selectedFilter == 'All') return events;

    return events.where((event) {
      final statusLabel = _getStatusLabel(event.status);
      return statusLabel == _selectedFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Show loading until locale is initialized
    if (!_isLocaleInitialized) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(title: 'My Events'),
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.primaryGold,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'My Events',
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: () {
              // Navigate to create new event
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigate to Create Event')),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<EventOwnerCubit, EventOwnerState>(
        builder: (context, state) {
          debugPrint('📊 State: ${state.runtimeType}');

          // ============================================
          // Loading State
          // ============================================
          if (state is GetEventOwnerEventsLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryGold,
                ),
              ),
            );
          }

          // ============================================
          // Error State
          // ============================================
          if (state is GetEventOwnerEventsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  const Text(
                    'Failed to load events',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(state.message),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _loadEvents,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            );
          }

          // ============================================
          // Success State ✅
          // ============================================
          if (state is GetEventOwnerEventsSuccess) {
            final allEvents = state.events;
            final filteredEvents = _filterEvents(allEvents);

            if (filteredEvents.isEmpty) {
              return _buildEmptyState();
            }

            return Column(
              children: [
                // ✅ Filter Tabs
                _buildFilterTabs(),

                // ✅ Events List
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      _loadEvents();
                      await Future.delayed(const Duration(seconds: 1));
                    },
                    color: AppColors.primaryGold,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        final event = filteredEvents[index];
                        return _buildEventCard(event);
                      },
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// ============================================
  /// Filter Tabs Widget
  /// ============================================
  Widget _buildFilterTabs() {
    final filters = ['All', 'Draft', 'Pending', 'Approved', 'Confirmed'];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            final isSelected = _selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: FilterChip(
                label: Text(filter),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
                selectedColor: AppColors.primaryGold,
                backgroundColor: Colors.grey[200],
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppColors.primaryDark,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// ============================================
  /// Event Card Widget
  /// ============================================
  Widget _buildEventCard(EventModel event) {
    // ✅ Safe DateFormat using try-catch
    String formattedDate;
    try {
      formattedDate = DateFormat('MMM d, yyyy').format(event.eventDate);
    } catch (e) {
      // Fallback format
      formattedDate = '${event.eventDate.month}/${event.eventDate.day}/${event.eventDate.year}';
    }

    final statusColor = _getStatusColor(event.status);
    final statusLabel = _getStatusLabel(event.status);
    final daysUntil = event.eventDate.difference(DateTime.now()).inDays;

    return GestureDetector(
      onTap: () => _navigateToEventScreen(event),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // ✅ Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.eventName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          event.eventTypeName,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ✅ Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      border: Border.all(color: statusColor, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ✅ Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date & Location
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          event.location,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Budget & Guests
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Budget',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'EGP ${(event.totalBudget).toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryGold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Guests',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${event.expectedGuestCount} people',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                      if (daysUntil >= 0)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Days Left',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              daysUntil == 0 ? 'Today!' : '$daysUntil days',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: daysUntil <= 3
                                    ? Colors.red
                                    : Colors.blue,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ============================================
  /// Empty State Widget
  /// ============================================
  Widget _buildEmptyState() {
    return Center(
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
            'No Events',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedFilter == 'All'
                ? 'Create your first event'
                : 'No events with status: $_selectedFilter',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  /// ============================================
  /// Navigation Handler ✅
  /// ============================================
  void _navigateToEventScreen(EventModel event) {
    debugPrint('📍 Navigating: ${event.eventName} (${event.status})');

    // ✅ Load event details first
    context.read<EventOwnerCubit>().getEventById(event.eventId);

    Widget destinationScreen;

    // ✅ Navigate based on Status
    switch (event.status) {
      case EventStatus.draft:
        destinationScreen = EventDetailsScreen(eventId: event.eventId);
        break;

      case EventStatus.pending:
        destinationScreen = EventTrackingScreen(eventId: event.eventId);
        break;

      case EventStatus.approved:
      case EventStatus.partiallyPaid:
        destinationScreen = PaymentScreen(
          eventId: event.eventId,
          totalAmount: event.allocatedBudget,
        );
        break;

      case EventStatus.confirmed:
        destinationScreen = EventDetailsScreen(eventId: event.eventId);
        break;

      default:
        destinationScreen = EventDetailsScreen(eventId: event.eventId);
    }

    // ✅ Navigate & Refresh on Return
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destinationScreen),
    ).then((_) {
      debugPrint('↩️ Returned, refreshing...');
      _loadEvents();
    });
  }

  /// ============================================
  /// Helper Methods
  /// ============================================
  Color _getStatusColor(EventStatus status) {
    switch (status) {
      case EventStatus.draft:
        return Colors.grey;
      case EventStatus.pending:
        return Colors.orange;
      case EventStatus.approved:
        return Colors.blue;
      case EventStatus.partiallyPaid:
        return Colors.amber;
      case EventStatus.confirmed:
        return Colors.green;
      case EventStatus.cancelled:
        return Colors.red;
      case EventStatus.completed:
        return Colors.purple;
    }
  }

  String _getStatusLabel(EventStatus status) {
    switch (status) {
      case EventStatus.draft:
        return 'Draft';
      case EventStatus.pending:
        return 'Pending';
      case EventStatus.approved:
        return 'Approved';
      case EventStatus.partiallyPaid:
        return 'Partial';
      case EventStatus.confirmed:
        return 'Confirmed';
      case EventStatus.cancelled:
        return 'Cancelled';
      case EventStatus.completed:
        return 'Completed';
    }
  }
}

// lib/features/new_owner_features/invitations/ui/screens/my_events_list_screen.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // ✅ إضافة هذا
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/event_owners/create_event_screen/cubits/create_event_cubit/create_event_cubit.dart';
import 'package:plan_z/features/event_owners/create_event_screen/cubits/create_event_cubit/create_event_state.dart';
import 'package:plan_z/features/event_owners/create_event_screen/data/models/event_model.dart';
import 'package:plan_z/features/event_owners/create_event_screen/data/models/event_model_enum.dart';
import 'package:plan_z/features/event_owners/create_event_screen/ui/screens/event_details_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class MyEventsListScreen extends StatefulWidget {
  const MyEventsListScreen({super.key});

  @override
  State<MyEventsListScreen> createState() => _MyEventsListScreenState();
}

class _MyEventsListScreenState extends State<MyEventsListScreen> {
  String _selectedFilter = 'event_owner.my_events_screen.filter.all'.tr();
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
    if (_selectedFilter == 'event_owner.my_events_screen.filter.all'.tr())
      return events;

    // ✅ Check for Active filter
    if (_selectedFilter == 'event_owner.my_events_screen.filter.active'.tr()) {
      return events.where((event) {
        final isPaid = event.paymentStatus.name == 'paid';
        final allApproved = event.allVendorsApproved;
        return isPaid && allApproved;
      }).toList();
    }

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
        appBar: CustomAppBar(title: 'event_owner.my_events_screen.title'.tr()),
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGold),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'event_owner.my_events_screen.title'.tr(),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: () {
              // Navigate to create new event
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'event_owner.my_events_screen.navigate_create'.tr(),
                  ),
                ),
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
                  Text(
                    'event_owner.my_events_screen.failed_load'.tr(),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(state.message),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _loadEvents,
                    icon: const Icon(Icons.refresh),
                    label: Text('event_owner.my_events_screen.retry'.tr()),
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

            return Column(
              children: [
                // ✅ Filter Tabs (Always visible)
                _buildFilterTabs(),

                // ✅ Events List or Empty State
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      _loadEvents();
                      await Future.delayed(const Duration(seconds: 1));
                    },
                    color: AppColors.primaryGold,
                    child: filteredEvents.isEmpty
                        ? _buildEmptyStateContent()
                        : ListView.builder(
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
    final filters = [
      'event_owner.my_events_screen.filter.all'.tr(),
      'event_owner.my_events_screen.filter.active'.tr(),
      'event_owner.my_events_screen.filter.draft'.tr(),
      'event_owner.my_events_screen.filter.pending'.tr(),
      'event_owner.my_events_screen.filter.approved'.tr(),
      'event_owner.my_events_screen.filter.confirmed'.tr(),
    ];

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
      formattedDate =
          '${event.eventDate.month}/${event.eventDate.day}/${event.eventDate.year}';
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
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
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

                  // ✅ Vendor Approval Status (if not all approved)
                  if (!event.allVendorsApproved)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'event_owner.my_events_screen.vendor_approvals'
                                  .tr(),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${event.approvedVendorsCount}/${event.totalVendorsCount}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: event.totalVendorsCount > 0
                                ? event.approvedVendorsCount /
                                      event.totalVendorsCount
                                : 0,
                            minHeight: 4,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.orange,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              size: 14,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'event_owner.my_events_screen.all_vendors_approved'
                                  .tr(),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),

                  // Budget & Guests
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'event_owner.my_events_screen.budget'.tr(),
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
                            'event_owner.my_events_screen.guests'.tr(),
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
                              'event_owner.my_events_screen.days_left'.tr(),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              daysUntil == 0
                                  ? 'event_owner.my_events_screen.today'.tr()
                                  : '$daysUntil ${'event_owner.my_events_screen.days'.tr()}',
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
  /// Empty State Content Widget
  /// ============================================
  Widget _buildEmptyStateContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy_rounded, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'event_owner.my_events_screen.no_events'.tr(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedFilter == 'event_owner.my_events_screen.filter.all'.tr()
                ? 'event_owner.my_events_screen.create_first'.tr()
                : 'event_owner.my_events_screen.no_events_status'.tr(
                    args: [_selectedFilter],
                  ),
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

    // ✅ All events go to EventDetailsScreen first
    // From there, user can navigate to:
    // - EventTrackingScreen (to track vendor approvals)
    // - EventPackagesScreen (to manage/change packages)
    // - PaymentScreen (when all packages are approved)
    final destinationScreen = EventDetailsScreen(eventId: event.eventId);

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
        return 'event_owner.my_events_screen.status.draft'.tr();
      case EventStatus.pending:
        return 'event_owner.my_events_screen.status.pending'.tr();
      case EventStatus.approved:
        return 'event_owner.my_events_screen.status.approved'.tr();
      case EventStatus.partiallyPaid:
        return 'event_owner.my_events_screen.status.partial'.tr();
      case EventStatus.confirmed:
        return 'event_owner.my_events_screen.status.confirmed'.tr();
      case EventStatus.cancelled:
        return 'event_owner.my_events_screen.status.cancelled'.tr();
      case EventStatus.completed:
        return 'event_owner.my_events_screen.status.completed'.tr();
    }
  }
}

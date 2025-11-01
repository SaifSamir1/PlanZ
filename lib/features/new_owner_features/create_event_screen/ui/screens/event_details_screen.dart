// lib/features/new_owner_features/create_event_screen/ui/screens/event_details_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/cubits/create_event_cubit/create_event_cubit.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/cubits/create_event_cubit/create_event_state.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/data/models/event_model.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/data/models/event_model_enum.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/ui/screens/event_packages_screen.dart';

class EventDetailsScreen extends StatefulWidget {
  final String eventId;

  const EventDetailsScreen({
    super.key,
    required this.eventId,
  });

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isInitializing = true;
  
  // ✅ IMPORTANT: Cache event data to persist across state changes
  EventModel? _cachedEvent;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // ✅ Load data after frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadEventDataAsync();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// ✅ Async method for proper sequential loading
  Future<void> _loadEventDataAsync() async {
    try {
      debugPrint('📥 Step 1: Loading event by ID...');
      
      // ✅ Call 1: Get Event
      await context.read<EventOwnerCubit>().getEventById(widget.eventId);
      
      if (!mounted) return;
      debugPrint('✅ Step 1 Complete: Event loaded');
      
      // ✅ Small delay to ensure state update
      await Future.delayed(const Duration(milliseconds: 200));
      
      if (!mounted) return;
      debugPrint('📥 Step 2: Loading package requests...');
      
      // ✅ Call 2: Get Packages
      await context.read<EventOwnerCubit>().getEventPackageRequests(widget.eventId);
      
      if (!mounted) return;
      debugPrint('✅ Step 2 Complete: Packages loaded');
      
      // ✅ Stop loading
      if (mounted) {
        setState(() => _isInitializing = false);
      }
    } catch (e) {
      debugPrint('❌ Error in _loadEventDataAsync: $e');
      if (mounted) {
        setState(() => _isInitializing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Event Details',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() => _isInitializing = true);
              _loadEventDataAsync();
            },
          ),
        ],
      ),
      body: BlocBuilder<EventOwnerCubit, EventOwnerState>(
        builder: (context, state) {
          debugPrint('📊 EventDetails State: ${state.runtimeType}');

          // ✅ Cache event from any Success state
          if (state is GetEventByIdSuccess) {
            _cachedEvent = state.event;
            debugPrint('✅ Event cached: ${state.event.eventName}');
          }

          // ============================================
          // Loading State
          // ============================================
          if (state is GetEventByIdLoading || _isInitializing) {
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
          if (state is GetEventByIdError) {
            return _buildErrorWidget(state.message);
          }

          if (state is GetEventPackageRequestsError) {
            if (_cachedEvent != null) {
              return _buildEventDetailsView(_cachedEvent!);
            }
            return _buildErrorWidget(state.message);
          }

          // ============================================
          // Success State ✅
          // ============================================
          if (_cachedEvent != null) {
            debugPrint('📊 Rendering with cached event: ${_cachedEvent!.eventName}');
            return _buildEventDetailsView(_cachedEvent!);
          }

          // ============================================
          // Fallback
          // ============================================
          if (state is GetEventPackageRequestsLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryGold,
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// ============================================
  /// Event Details View with TabBar
  /// ============================================
  Widget _buildEventDetailsView(EventModel event) {
    return Column(
      children: [
        // ✅ TabBar
        Container(
          color: AppColors.primaryDark,
          child: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primaryGold,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(text: 'Overview', icon: Icon(Icons.info)),
              Tab(text: 'Services', icon: Icon(Icons.business_center)),
              Tab(text: 'Budget', icon: Icon(Icons.attach_money)),
            ],
          ),
        ),

        // ✅ TabBarView
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(event),
              _buildServicesTab(event),
              _buildBudgetTab(event),
            ],
          ),
        ),
      ],
    );
  }

  /// ============================================
  /// Overview Tab
  /// ============================================
  Widget _buildOverviewTab(EventModel event) {
    return RefreshIndicator(
      onRefresh: () async {
        _loadEventDataAsync();
        await Future.delayed(const Duration(seconds: 1));
      },
      color: AppColors.primaryGold,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ✅ Header Card
          _buildHeaderCard(event),
          const SizedBox(height: 20),

          // ✅ Status Card
          _buildStatusCard(event.status),
          const SizedBox(height: 20),

          // ✅ Event Info
          _buildEventInfoCard(event),
          const SizedBox(height: 20),

          // ✅ Quick Stats
          _buildQuickStats(event),
          const SizedBox(height: 20),

          // ✅ Action Buttons
          _buildActionButtons(event),
        ],
      ),
    );
  }

  /// ============================================
  /// Services Tab
  /// ============================================
  Widget _buildServicesTab(EventModel event) {
    if (event.services.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text('No Services Selected'),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Selected Services (${event.services.length})',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 16),
        ...event.services.map((service) => _buildServiceCard(service)),
      ],
    );
  }

  /// ============================================
  /// Budget Tab
  /// ============================================
  Widget _buildBudgetTab(EventModel event) {
    final percentage = event.totalBudget > 0
        ? ((event.allocatedBudget / event.totalBudget) * 100).toInt()
        : 0;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ✅ Budget Summary
        _buildBudgetSummaryCard(event, percentage),
        const SizedBox(height: 20),

        // ✅ Breakdown
        Text(
          'Budget Breakdown',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 16),
        if (event.services.isEmpty)
          const Center(child: Text('No services to show breakdown'))
        else
          ...event.services.map(
            (service) => _buildBudgetBreakdownItem(service, event.totalBudget),
          ),
      ],
    );
  }

  /// ============================================
  /// Header Card
  /// ============================================
  Widget _buildHeaderCard(EventModel event) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primaryDark.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            _getEventTypeIcon(event.eventTypeName),
            style: const TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 12),
          Text(
            event.eventName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            event.eventTypeName,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.white70),
              const SizedBox(width: 8),
              Text(
                DateFormat('MMM d, yyyy').format(event.eventDate),
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ============================================
  /// Status Card
  /// ============================================
  Widget _buildStatusCard(EventStatus status) {
    final statusInfo = _getStatusInfo(status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusInfo['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusInfo['color'] as Color, width: 2),
      ),
      child: Row(
        children: [
          Icon(
            statusInfo['icon'] as IconData,
            color: statusInfo['color'] as Color,
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusInfo['title'] as String,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: statusInfo['color'] as Color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusInfo['description'] as String,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ============================================
  /// Event Info Card
  /// ============================================
  Widget _buildEventInfoCard(EventModel event) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Event Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          const Divider(height: 20),
          _buildInfoRow(Icons.location_on, 'Location', event.location),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.location_city,
            'City',
            event.city ?? 'N/A',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.home,
            'Address',
            event.address ?? 'N/A',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.people,
            'Expected Guests',
            '${event.expectedGuestCount} people',
          ),
          if (event.description != null && event.description!.isNotEmpty) ...{
            const Divider(height: 20),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              event.description!,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          },
        ],
      ),
    );
  }

  /// ============================================
  /// Quick Stats
  /// ============================================
  Widget _buildQuickStats(EventModel event) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Services',
            event.services.length.toString(),
            Icons.business_center,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Budget',
            'EGP ${_formatNumber(event.totalBudget.toInt())}',
            Icons.attach_money,
            Colors.green,
          ),
        ),
      ],
    );
  }

  /// ============================================
  /// Stat Card
  /// ============================================
  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// ============================================
  /// Service Card
  /// ============================================
  Widget _buildServiceCard(dynamic service) {
    // Assuming service has these properties
    final statusColor = Colors.green;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryGold.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.business_center,
                  color: AppColors.primaryGold,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Service',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    Text(
                      'Package Name',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Approved',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ============================================
  /// Budget Summary Card
  /// ============================================
  Widget _buildBudgetSummaryCard(EventModel event, int percentage) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green, Colors.green.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '💰 Budget Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBudgetItem('Total', event.totalBudget),
              _buildBudgetItem('Allocated', event.allocatedBudget),
              _buildBudgetItem('Remaining', event.remainingBudget),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: event.allocatedBudget / (event.totalBudget > 0 ? event.totalBudget : 1),
              minHeight: 12,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$percentage% of budget allocated',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// ============================================
  /// Budget Item
  /// ============================================
  Widget _buildBudgetItem(String label, double amount) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.white70),
        ),
        const SizedBox(height: 4),
        Text(
          'EGP ${_formatNumber(amount.toInt())}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  /// ============================================
  /// Budget Breakdown Item
  /// ============================================
  Widget _buildBudgetBreakdownItem(
    dynamic service,
    double totalBudget,
  ) {
    double amount = 0;
    final percentage = totalBudget > 0 ? ((amount / totalBudget) * 100) : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Service Name',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
              Text(
                'EGP ${_formatNumber(amount.toInt())}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: amount / (totalBudget > 0 ? totalBudget : 1),
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation(AppColors.primaryGold),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${percentage.toStringAsFixed(1)}% of total budget',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// ============================================
  /// Action Buttons
  /// ============================================
  Widget _buildActionButtons(EventModel event) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EventPackagesScreen(eventId: event.eventId),
                ),
              ).then((_) => _loadEventDataAsync());
            },
            icon: const Icon(Icons.shopping_bag),
            label: const Text('Manage Packages'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGold,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  /// ============================================
  /// Error Widget
  /// ============================================
  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          const Text(
            'Failed to load event',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(message),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() => _isInitializing = true);
              _loadEventDataAsync();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  /// ============================================
  /// Helper Methods
  /// ============================================
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primaryGold),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12, color: AppColors.primaryDark),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Map<String, dynamic> _getStatusInfo(EventStatus status) {
    switch (status) {
      case EventStatus.draft:
        return {
          'title': 'Draft',
          'description': 'Event is still in draft mode',
          'icon': Icons.edit,
          'color': Colors.grey,
        };
      case EventStatus.pending:
        return {
          'title': 'Pending Approval',
          'description': 'Waiting for vendor responses',
          'icon': Icons.hourglass_empty,
          'color': Colors.orange,
        };
      case EventStatus.approved:
        return {
          'title': 'Approved',
          'description': 'All vendors approved',
          'icon': Icons.check_circle,
          'color': Colors.green,
        };
      case EventStatus.partiallyPaid:
        return {
          'title': 'Partially Paid',
          'description': 'Partial payment received',
          'icon': Icons.payment,
          'color': Colors.amber,
        };
      case EventStatus.confirmed:
        return {
          'title': 'Confirmed',
          'description': 'Event confirmed and ready',
          'icon': Icons.verified,
          'color': Colors.green,
        };
      case EventStatus.cancelled:
        return {
          'title': 'Cancelled',
          'description': 'Event has been cancelled',
          'icon': Icons.cancel,
          'color': Colors.red,
        };
      case EventStatus.completed:
        return {
          'title': 'Completed',
          'description': 'Event completed successfully',
          'icon': Icons.check_circle_outline,
          'color': Colors.blue,
        };
    }
  }

  String _getEventTypeIcon(String eventType) {
    const icons = {
      'Wedding': '💍',
      'Birthday': '🎂',
      'Conference': '🎤',
      'Corporate': '🏢',
      'Party': '🎉',
      'Engagement': '💝',
      'Graduation': '🎓',
      'Baby Shower': '👶',
    };
    return icons[eventType] ?? '🎉';
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

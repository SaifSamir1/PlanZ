// lib/features/new_owner_features/create_event_screen/ui/screens/event_details_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/event_owners/create_event_screen/cubits/create_event_cubit/create_event_cubit.dart';
import 'package:plan_z/features/event_owners/create_event_screen/cubits/create_event_cubit/create_event_state.dart';
import 'package:plan_z/features/event_owners/create_event_screen/data/models/event_model.dart';
import 'package:plan_z/features/event_owners/create_event_screen/data/models/event_model_enum.dart';
import 'package:plan_z/features/event_owners/create_event_screen/ui/screens/event_packages_screen.dart';
import 'package:plan_z/features/event_owners/create_event_screen/ui/screens/event_tracking_screen.dart';
import 'package:plan_z/features/event_owners/create_event_screen/ui/screens/payment_screen.dart';
import 'package:plan_z/features/event_owners/create_event_screen/ui/screens/select_guests_screen.dart';

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
      _loadEventData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// ✅ Load event data
  void _loadEventData() {
    debugPrint('📥 Loading event data...');
    context.read<EventOwnerCubit>().getEventById(widget.eventId);
    context.read<EventOwnerCubit>().getEventPackageRequests(widget.eventId);
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
              _loadEventData();
            },
          ),
        ],
      ),
      body: BlocConsumer<EventOwnerCubit, EventOwnerState>(
        listener: (context, state) {
          // ✅ Cache event from Success state
          if (state is GetEventByIdSuccess) {
            setState(() {
              _cachedEvent = state.event;
              _isInitializing = false;
            });
            debugPrint('✅ Event cached: ${state.event.eventName}');
          }
        },
        builder: (context, state) {
          debugPrint('📊 EventDetails State: ${state.runtimeType}');

          // ============================================
          // Loading State
          // ============================================
          if (state is GetEventByIdLoading || (_isInitializing && _cachedEvent == null)) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryGold,
                ),
              ),
            );
          }

          // ============================================
          // Error State (only if no cached data)
          // ============================================
          if (state is GetEventByIdError && _cachedEvent == null) {
            return _buildErrorWidget(state.message);
          }

          // ============================================
          // Show Content (if we have cached event)
          // ============================================
          if (_cachedEvent != null) {
            debugPrint('📊 Rendering event: ${_cachedEvent!.eventName}');
            return _buildEventDetailsView(_cachedEvent!);
          }

          // ============================================
          // Fallback
          // ============================================
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primaryGold,
              ),
            ),
          );
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
        _loadEventData();
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
  Widget _buildServiceCard(EventService service) {
    // ✅ Determine status color based on vendor approval
    final statusColor = service.vendorApproved ? Colors.green : Colors.orange;
    final statusLabel = service.vendorApproved ? 'Approved' : 'Pending';

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
                      service.serviceName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    Text(
                      service.packageName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Vendor: ${service.vendorName}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
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
                  statusLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price: EGP ${_formatNumber(service.packagePrice.toInt())}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryGold,
                ),
              ),
              if (service.isRequired)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Required',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
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
    EventService service,
    double totalBudget,
  ) {
    // ✅ Use actual service price
    final amount = service.packagePrice;
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.serviceName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      service.packageName,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
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
    // ✅ Check event status
    final allApproved = event.allVendorsApproved;
    final isPaid = event.paymentStatus == PaymentStatus.paid;
    final isActive = _isEventActive(event);
    final isEventPending = _isEventPending(event);

    debugPrint('');
    debugPrint('🔍 [_buildActionButtons] Event Status Check:');
    debugPrint('   Event Name: ${event.eventName}');
    debugPrint('   Status: ${event.status}');
    debugPrint('   Payment Status: ${event.paymentStatus}');
    debugPrint('   All Vendors Approved: $allApproved');
    debugPrint('   Pending Vendors: ${event.pendingVendorsCount}');
    debugPrint('   Is Active: $isActive');
    debugPrint('   Is Pending: $isEventPending');

    return Column(
      children: [
        // ✅ Vendor Approval Status Card
        _buildVendorApprovalCard(event),
        const SizedBox(height: 16),

        // ✅ Track Package Approvals Button
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EventTrackingScreen(eventId: event.eventId),
                  ),
                ).then((_) => _loadEventData());
              },
              icon: const Icon(Icons.track_changes),
              label: const Text('Track Package Approvals'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),

        // ✅ Manage Packages Button
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EventPackagesScreen(eventId: event.eventId),
                  ),
                ).then((_) => _loadEventData());
              },
              icon: const Icon(Icons.shopping_bag),
              label: const Text('Manage Packages'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGold,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),

        // ✅ Proceed to Payment Button (when all approved)
        if (allApproved && isEventPending)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(
                        eventId: event.eventId,
                        totalAmount: event.allocatedBudget,
                      ),
                    ),
                  ).then((_) => _loadEventData());
                },
                icon: const Icon(Icons.payment),
                label: const Text('Proceed to Payment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

        // ✅ Invite Guests Button (after payment)
        if (isPaid || isActive)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectGuestsScreen(
                        eventId: event.eventId,
                        eventName: event.eventName,
                        eventType: event.eventTypeName,
                        eventDate: event.eventDate,
                        fromCreateEvent: false,
                      ),
                    ),
                  ).then((_) => _loadEventData());
                },
                icon: const Icon(Icons.people_alt),
                label: const Text('Invite Guests'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// ============================================
  /// Vendor Approval Status Card
  /// ============================================
  Widget _buildVendorApprovalCard(EventModel event) {
    final approvalPercentage = event.totalVendorsCount > 0
        ? ((event.approvedVendorsCount / event.totalVendorsCount) * 100).toInt()
        : 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[300]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Vendor Approvals',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: event.allVendorsApproved ? Colors.green : Colors.orange,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  event.allVendorsApproved ? 'All Approved ✓' : 'Pending',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: approvalPercentage / 100,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                event.allVendorsApproved ? Colors.green : Colors.orange,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Approved: ${event.approvedVendorsCount}/${event.totalVendorsCount}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                'Pending: ${event.pendingVendorsCount}',
                style: const TextStyle(fontSize: 12, color: Colors.orange),
              ),
              if (event.rejectedVendorsCount > 0)
                Text(
                  'Rejected: ${event.rejectedVendorsCount}',
                  style: const TextStyle(fontSize: 12, color: Colors.red),
                ),
            ],
          ),
        ],
      ),
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
              _loadEventData();
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

  /// ============================================
  /// Event Status Check Methods
  /// ============================================
  /// ✅ Check if event is ACTIVE (paid + all vendors approved)
  bool _isEventActive(EventModel event) {
    final isPaid = event.paymentStatus == PaymentStatus.paid;
    final allApproved = event.allVendorsApproved;
    return isPaid && allApproved;
  }

  /// ✅ Check if event is PENDING (waiting for vendor approvals or payment)
  bool _isEventPending(EventModel event) {
    return event.status == EventStatus.pending ||
        event.status == EventStatus.approved;
  }
}

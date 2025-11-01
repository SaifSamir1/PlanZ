// lib/features/new_owner_features/create_event_screen/ui/screens/event_tracking_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/cubits/create_event_cubit/create_event_cubit.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/cubits/create_event_cubit/create_event_state.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/data/models/event_model.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/data/models/event_model_enum.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/ui/screens/payment_screen.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_request_model.dart';

class EventTrackingScreen extends StatefulWidget {
  final String eventId;

  const EventTrackingScreen({
    super.key,
    required this.eventId,
  });

  @override
  State<EventTrackingScreen> createState() => _EventTrackingScreenState();
}

class _EventTrackingScreenState extends State<EventTrackingScreen> {
  late Timer _refreshTimer;
  bool _isAutoRefreshing = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }

  /// ✅ Load Data
  void _loadData() {
    debugPrint('📊 Loading tracking data for: ${widget.eventId}');
    context.read<EventOwnerCubit>().getEventById(widget.eventId);
    context.read<EventOwnerCubit>().getEventPackageRequests(widget.eventId);
  }

  /// ✅ Auto Refresh every 10 seconds
  void _startAutoRefresh() {
    debugPrint('🔄 Starting auto refresh (10s interval)');
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_isAutoRefreshing && mounted) {
        debugPrint('🔁 Auto refreshing...');
        _loadData();
      }
    });
  }

  /// ✅ Manual Refresh
  Future<void> _manualRefresh() async {
    debugPrint('👆 Manual refresh');
    _loadData();
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Event Tracking',
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: _manualRefresh,
          ),
          IconButton(
            icon: Icon(
              _isAutoRefreshing ? Icons.notifications_active : Icons.notifications_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isAutoRefreshing = !_isAutoRefreshing;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isAutoRefreshing
                        ? '🔄 Auto-refresh enabled'
                        : '🔇 Auto-refresh disabled',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<EventOwnerCubit, EventOwnerState>(
        builder: (context, state) {
          debugPrint('📊 Tracking State: ${state.runtimeType}');

          // ============================================
          // Loading State
          // ============================================
          if (state is GetEventByIdLoading || state is GetEventPackageRequestsLoading) {
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
          if (state is GetEventByIdError || state is GetEventPackageRequestsError) {
            String errorMsg = 'Failed to load data';
            if (state is GetEventByIdError) errorMsg = state.message;
            if (state is GetEventPackageRequestsError) errorMsg = state.message;

            return _buildErrorWidget(errorMsg);
          }

          // ============================================
          // Success State ✅
          // ============================================
          if (state is GetEventByIdSuccess && state is GetEventPackageRequestsSuccess) {
            final event = state.event;
            final requests = (state as GetEventPackageRequestsSuccess).requests;

            // ✅ Check if all packages are accepted
            final allAccepted = requests.isNotEmpty &&
                requests.every((r) => r.status == RequestStatus.accepted);

            return _buildTrackingContent(event, requests, allAccepted);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// ============================================
  /// Tracking Content
  /// ============================================
  Widget _buildTrackingContent(
    EventModel event,
    List<PackageRequestModel> requests,
    bool allAccepted,
  ) {
    return RefreshIndicator(
      onRefresh: _manualRefresh,
      color: AppColors.primaryGold,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ✅ Event Summary
          _buildEventSummary(event),
          const SizedBox(height: 20),

          // ✅ Progress Card
          _buildProgressCard(requests),
          const SizedBox(height: 20),

          // ✅ Request Status Section
          if (requests.isEmpty)
            _buildEmptyState()
          else
            _buildRequestsSection(requests),

          const SizedBox(height: 20),

          // ✅ Action Button
          if (allAccepted && requests.isNotEmpty)
            _buildProceedButton(event, requests),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  /// ============================================
  /// Event Summary Card
  /// ============================================
  Widget _buildEventSummary(EventModel event) {
    final daysUntilEvent = event.eventDate.difference(DateTime.now()).inDays;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryGold, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _getEventTypeIcon(event.eventTypeName),
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.eventName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      event.eventTypeName,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: daysUntilEvent <= 3
                      ? Colors.red.withOpacity(0.2)
                      : Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  daysUntilEvent == 0
                      ? 'Today! 🚨'
                      : '$daysUntilEvent days',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: daysUntilEvent <= 3 ? Colors.red : Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(Icons.calendar_month, DateFormat('MMM d').format(event.eventDate)),
              _buildSummaryItem(Icons.location_on, event.city ?? 'N/A'),
              _buildSummaryItem(Icons.people, '${event.expectedGuestCount}'),
            ],
          ),
        ],
      ),
    );
  }

  /// ============================================
  /// Summary Item
  /// ============================================
  Widget _buildSummaryItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
      ],
    );
  }

  /// ============================================
  /// Progress Card
  /// ============================================
  Widget _buildProgressCard(List<PackageRequestModel> requests) {
    if (requests.isEmpty) return const SizedBox.shrink();

    final accepted = requests.where((r) => r.status == RequestStatus.accepted).length;
    final pending = requests.where((r) => r.status == RequestStatus.pending).length;
    final rejected = requests.where((r) => r.status == RequestStatus.rejected).length;
    final total = requests.length;
    final progressPercent = (accepted / total) * 100;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primaryDark.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '📊 Overall Progress',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '${progressPercent.toInt()}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: accepted / total,
              minHeight: 10,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(AppColors.primaryGold),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildProgressStat('Accepted', '$accepted/$total', Colors.green),
              _buildProgressStat('Pending', pending.toString(), Colors.orange),
              _buildProgressStat('Rejected', rejected.toString(), Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  /// ============================================
  /// Progress Stat
  /// ============================================
  Widget _buildProgressStat(String label, String count, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  /// ============================================
  /// Requests Section
  /// ============================================
  Widget _buildRequestsSection(List<PackageRequestModel> requests) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.assignment, color: AppColors.primaryGold),
            const SizedBox(width: 8),
            Text(
              'Package Requests (${requests.length})',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...requests.asMap().entries.map((entry) {
          final index = entry.key;
          final request = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: index < requests.length - 1 ? 12 : 0),
            child: _buildRequestCard(request),
          );
        }),
      ],
    );
  }

  /// ============================================
  /// Request Card
  /// ============================================
  Widget _buildRequestCard(PackageRequestModel request) {
    final statusInfo = _getRequestStatusInfo(request.status);
    final hoursSinceRequest = DateTime.now().difference(request.requestedAt).inHours;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusInfo['color'].withOpacity(0.3), width: 1.5),
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusInfo['color'].withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: statusInfo['color'].withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    statusInfo['icon'],
                    size: 16,
                    color: statusInfo['color'],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.serviceName,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        request.packageName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusInfo['color'].withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    statusInfo['label'],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: statusInfo['color'],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ✅ Details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Vendor', request.vendorName),
                const SizedBox(height: 8),
                _buildDetailRow(
                  'Price',
                  'EGP ${_formatNumber(request.packagePrice?.toInt() ?? 0)}',
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  'Requested',
                  _formatDateTime(request.requestedAt),
                ),
                if (request.acceptedAt != null) ...[
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    'Accepted',
                    _formatDateTime(request.acceptedAt!),
                  ),
                ],

                // ✅ Timeline
                const SizedBox(height: 12),
                _buildTimeline(request),

                // ✅ Message if available
                if (request.message != null && request.message!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '💬 Vendor Message',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          request.message!,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.blue[900],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ============================================
  /// Timeline Widget
  /// ============================================
  Widget _buildTimeline(PackageRequestModel request) {
    final isAccepted = request.status == RequestStatus.accepted;
    const dotSize = 8.0;

    return Row(
      children: [
        // Requested
        Column(
          children: [
            Container(
              width: dotSize,
              height: dotSize,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            Text(
              'Sent',
              style: TextStyle(fontSize: 9, color: Colors.grey[600]),
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              height: 1,
              color: isAccepted ? Colors.green : Colors.orange,
            ),
          ),
        ),
        // Accepted/Pending
        Column(
          children: [
            Container(
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                color: isAccepted ? Colors.green : Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
            Text(
              isAccepted ? 'Approved' : 'Waiting',
              style: TextStyle(
                fontSize: 9,
                color: isAccepted ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// ============================================
  /// Detail Row
  /// ============================================
  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryDark,
          ),
        ),
      ],
    );
  }

  /// ============================================
  /// Empty State
  /// ============================================
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(Icons.assignment_outlined, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text(
              'No Requests Found',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Add packages to see requests here',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          const Text(
            'Failed to load tracking',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadData,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  /// ============================================
  /// Proceed Button
  /// ============================================
  Widget _buildProceedButton(EventModel event, List<PackageRequestModel> requests) {
    final totalPrice = requests.fold<double>(
      0,
      (sum, r) => sum + (r.packagePrice ?? 0),
    );

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green, width: 1),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '✅ All Packages Approved!',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      'Ready to proceed to payment',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentScreen(
                    eventId: event.eventId,
                    totalAmount: totalPrice,
                  ),
                ),
              ).then((_) => _loadData());
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
      ],
    );
  }

  /// ============================================
  /// Helper Methods
  /// ============================================
  Map<String, dynamic> _getRequestStatusInfo(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return {
          'label': 'Pending',
          'color': Colors.orange,
          'icon': Icons.hourglass_empty,
        };
      case RequestStatus.accepted:
        return {
          'label': 'Accepted',
          'color': Colors.green,
          'icon': Icons.check_circle,
        };
      case RequestStatus.rejected:
        return {
          'label': 'Rejected',
          'color': Colors.red,
          'icon': Icons.cancel,
        };
      case RequestStatus.expired:
        return {
          'label': 'Expired',
          'color': Colors.grey,
          'icon': Icons.schedule,
        };
      case RequestStatus.cancelled:
        return {
          'label': 'Cancelled',
          'color': Colors.red,
          'icon': Icons.close,
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

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d, hh:mm a').format(dateTime);
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

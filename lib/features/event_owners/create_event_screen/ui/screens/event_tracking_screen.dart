// lib/features/new_owner_features/create_event_screen/ui/screens/event_tracking_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/event_owners/create_event_screen/cubits/create_event_cubit/create_event_cubit.dart';
import 'package:plan_z/features/event_owners/create_event_screen/cubits/create_event_cubit/create_event_state.dart';
import 'package:plan_z/features/event_owners/create_event_screen/data/models/event_model.dart';
import 'package:plan_z/features/event_owners/create_event_screen/ui/screens/payment_screen.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_request_model.dart';

// ============================================
// Main Screen
// ============================================

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
  EventModel? _cachedEvent;
  List<PackageRequestModel>? _cachedRequests;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// ✅ Load Data (Manual only - no auto-refresh)
  void _loadData() {
    debugPrint('📊 Loading tracking data for: ${widget.eventId}');
    context.read<EventOwnerCubit>().getEventById(widget.eventId);
    context.read<EventOwnerCubit>().getEventPackageRequests(widget.eventId);
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
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _manualRefresh,
          ),
        ],
      ),
      body: BlocConsumer<EventOwnerCubit, EventOwnerState>(
        listener: (context, state) {
          // ✅ Cache event and requests from Success states
          if (state is GetEventByIdSuccess) {
            setState(() {
              _cachedEvent = state.event;
            });
            debugPrint('✅ Event cached: ${state.event.eventName}');
          }
          
          if (state is GetEventPackageRequestsSuccess) {
            setState(() {
              _cachedRequests = state.requests;
            });
            debugPrint('✅ Requests cached: ${state.requests.length} requests');
          }
        },
        builder: (context, state) {
          debugPrint('📊 Tracking State: ${state.runtimeType}');

          // ============================================
          // Loading State (initial load only)
          // ============================================
          if (state is GetEventByIdLoading && _cachedEvent == null) {
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
          if (state is GetEventByIdError && _cachedEvent == null) {
            return _buildErrorWidget(state.message);
          }

          // ============================================
          // Success State ✅ - Show content if we have cached event
          // ============================================
          if (_cachedEvent != null) {
            final requests = _cachedRequests ?? [];
            final allAccepted = requests.isNotEmpty &&
                requests.every((r) => r.status == RequestStatus.accepted);

            debugPrint('📊 Rendering tracking content: ${_cachedEvent!.eventName}');
            return _buildTrackingContent(_cachedEvent!, requests, allAccepted);
          }

          // Fallback loading
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
          EventSummaryCard(event: event),
          const SizedBox(height: 20),

          // ✅ Progress Card
          ProgressCard(requests: requests),
          const SizedBox(height: 20),

          // ✅ Request Status Section
          if (requests.isEmpty)
            const EmptyState()
          else
            RequestsSection(requests: requests),

          const SizedBox(height: 20),

          // ✅ Action Button
          if (allAccepted && requests.isNotEmpty)
            ProceedButton(
              event: event,
              requests: requests,
              onRefresh: _loadData,
            ),

          const SizedBox(height: 30),
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

}

// ============================================
// Stateless Widgets
// ============================================

/// Event Summary Card Widget
class EventSummaryCard extends StatelessWidget {
  final EventModel event;

  const EventSummaryCard({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
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
              SummaryItem(
                icon: Icons.calendar_month,
                text: DateFormat('MMM d').format(event.eventDate),
              ),
              SummaryItem(
                icon: Icons.location_on,
                text: event.city ?? 'N/A',
              ),
              SummaryItem(
                icon: Icons.people,
                text: '${event.expectedGuestCount}',
              ),
            ],
          ),
        ],
      ),
    );
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
}

/// Summary Item Widget
class SummaryItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const SummaryItem({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
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
}

/// Progress Card Widget
class ProgressCard extends StatelessWidget {
  final List<PackageRequestModel> requests;

  const ProgressCard({
    super.key,
    required this.requests,
  });

  @override
  Widget build(BuildContext context) {
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
              ProgressStat(label: 'Accepted', count: '$accepted/$total', color: Colors.green),
              ProgressStat(label: 'Pending', count: pending.toString(), color: Colors.orange),
              ProgressStat(label: 'Rejected', count: rejected.toString(), color: Colors.red),
            ],
          ),
        ],
      ),
    );
  }
}

/// Progress Stat Widget
class ProgressStat extends StatelessWidget {
  final String label;
  final String count;
  final Color color;

  const ProgressStat({
    super.key,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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
}

/// Requests Section Widget
class RequestsSection extends StatelessWidget {
  final List<PackageRequestModel> requests;

  const RequestsSection({
    super.key,
    required this.requests,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.assignment, color: AppColors.primaryGold),
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
            child: RequestCard(request: request),
          );
        }),
      ],
    );
  }
}

/// Request Card Widget
class RequestCard extends StatelessWidget {
  final PackageRequestModel request;

  const RequestCard({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getRequestStatusInfo(request.status);

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
          // Header
          RequestCardHeader(request: request, statusInfo: statusInfo),

          // Details
          RequestCardDetails(request: request),
        ],
      ),
    );
  }

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
}

/// Request Card Header Widget
class RequestCardHeader extends StatelessWidget {
  final PackageRequestModel request;
  final Map<String, dynamic> statusInfo;

  const RequestCardHeader({
    super.key,
    required this.request,
    required this.statusInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

/// Request Card Details Widget
class RequestCardDetails extends StatelessWidget {
  final PackageRequestModel request;

  const RequestCardDetails({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailRow(label: 'Vendor', value: request.vendorName),
          const SizedBox(height: 8),
          DetailRow(
            label: 'Price',
            value: 'EGP ${_formatNumber(request.packagePrice?.toInt() ?? 0)}',
          ),
          const SizedBox(height: 8),
          DetailRow(
            label: 'Requested',
            value: _formatDateTime(request.requestedAt),
          ),
          if (request.acceptedAt != null) ...[
            const SizedBox(height: 8),
            DetailRow(
              label: 'Accepted',
              value: _formatDateTime(request.acceptedAt!),
            ),
          ],
          const SizedBox(height: 12),
          RequestTimeline(request: request),
          if (request.message != null && request.message!.isNotEmpty) ...[
            const SizedBox(height: 12),
            VendorMessageBox(message: request.message!),
          ],
        ],
      ),
    );
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

/// Detail Row Widget
class DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const DetailRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
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
}

/// Request Timeline Widget
class RequestTimeline extends StatelessWidget {
  final PackageRequestModel request;

  const RequestTimeline({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    final isAccepted = request.status == RequestStatus.accepted;
    const dotSize = 8.0;

    return Row(
      children: [
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
}

/// Vendor Message Box Widget
class VendorMessageBox extends StatelessWidget {
  final String message;

  const VendorMessageBox({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            message,
            style: TextStyle(
              fontSize: 11,
              color: Colors.blue[900],
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty State Widget
class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
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
}

/// Proceed Button Widget
class ProceedButton extends StatelessWidget {
  final EventModel event;
  final List<PackageRequestModel> requests;
  final VoidCallback onRefresh;

  const ProceedButton({
    super.key,
    required this.event,
    required this.requests,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final totalPrice = requests.fold<double>(
      0,
      (sum, r) => sum + (r.packagePrice ?? 0),
    );
    
    debugPrint('💰 [ProceedButton] Calculating total price:');
    debugPrint('   Requests count: ${requests.length}');
    for (var i = 0; i < requests.length; i++) {
      debugPrint('   Request $i: packagePrice = ${requests[i].packagePrice}');
    }
    debugPrint('   Total Price: $totalPrice');
    debugPrint('   Event allocatedBudget: ${event.allocatedBudget}');

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
              // ✅ Use event.allocatedBudget instead of totalPrice from requests
              final paymentAmount = event.allocatedBudget > 0 ? event.allocatedBudget : totalPrice;
              debugPrint('💳 [ProceedButton] Navigating to Payment:');
              debugPrint('   event.allocatedBudget: ${event.allocatedBudget}');
              debugPrint('   totalPrice from requests: $totalPrice');
              debugPrint('   paymentAmount: $paymentAmount');
              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentScreen(
                    eventId: event.eventId,
                    totalAmount: paymentAmount,
                  ),
                ),
              ).then((_) => onRefresh());
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
}

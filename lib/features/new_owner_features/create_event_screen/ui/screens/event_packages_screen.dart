// lib/features/new_owner_features/create_event_screen/ui/screens/event_packages_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/cubits/create_event_cubit/create_event_cubit.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/cubits/create_event_cubit/create_event_state.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/data/models/event_model.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/ui/screens/browse_packages_screen.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_request_model.dart';

class EventPackagesScreen extends StatefulWidget {
  final String eventId;

  const EventPackagesScreen({
    super.key,
    required this.eventId,
  });

  @override
  State<EventPackagesScreen> createState() => _EventPackagesScreenState();
}

class _EventPackagesScreenState extends State<EventPackagesScreen> {
  bool _isInitializing = true;
  
  // ✅ IMPORTANT: Cache event and packages data
  EventModel? _cachedEvent;
  List<PackageRequestModel>? _cachedPackages;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDataAsync();
    });
  }

  /// ✅ IMPORTANT: استخدم async/await بشكل صحيح
  Future<void> _loadDataAsync() async {
    try {
      if (!mounted) return;
      debugPrint('📦 Step 1: Loading event...');

      // ✅ Step 1: تحميل الـ Event
      await context.read<EventOwnerCubit>().getEventById(widget.eventId);

      if (!mounted) return;
      debugPrint('✅ Event loaded');

      // ✅ Small delay to ensure state propagation
      await Future.delayed(const Duration(milliseconds: 200));

      if (!mounted) return;
      debugPrint('📦 Step 2: Loading package requests...');

      // ✅ Step 2: بعد ما الـ Event توصل، احمل الـ Packages
      await context
          .read<EventOwnerCubit>()
          .getEventPackageRequests(widget.eventId);

      if (!mounted) return;
      debugPrint('✅ Packages loaded');

      // ✅ إنهاء الـ Loading
      setState(() => _isInitializing = false);
    } catch (e) {
      debugPrint('❌ Error in _loadDataAsync: $e');
      if (mounted) {
        setState(() => _isInitializing = false);
      }
    }
  }
// event_packages_screen.dart - Modified

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: CustomAppBar(
      title: 'Manage Packages',
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: () {
            setState(() => _isInitializing = true);
            _loadDataAsync();
          },
        ),
        IconButton(
          icon: const Icon(Icons.info_outline, color: Colors.white),
          onPressed: _showInfoDialog,
        ),
      ],
    ),
    body: BlocBuilder<EventOwnerCubit, EventOwnerState>(
      builder: (context, state) {
        debugPrint('📊 EventPackages State: ${state.runtimeType}');

        // ✅ Cache event from any Success state
        if (state is GetEventByIdSuccess) {
          _cachedEvent = state.event;
          debugPrint('✅ Event cached with ${state.event.services.length} services');
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
          return _buildErrorWidget('Failed to load event: ${state.message}');
        }

        // ============================================
        // Success State ✅ - Render with Event Services
        // ============================================
        if (_cachedEvent != null) {
          debugPrint(
              '📊 Rendering event with ${_cachedEvent!.services.length} packages');
          
          // ✅ استخدم الـ services من Event، مش PackageRequests!
          return _buildPackagesContent(
            _cachedEvent!,
            _cachedEvent!.services, // ✅ الخدمات المحفوظة
          );
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

// في _buildPackagesContent()

Widget _buildPackagesContent(
  EventModel event,
  List<dynamic> services, // ✅ غيّر من List إلى List<dynamic>
) {
  debugPrint('✅ Building packages content with ${services.length} items');

  return RefreshIndicator(
    onRefresh: () async {
      _loadDataAsync();
      await Future.delayed(const Duration(seconds: 1));
    },
    color: AppColors.primaryGold,
    child: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildEventSummaryCard(event),
        const SizedBox(height: 20),
        _buildWarningCard(event),
        const SizedBox(height: 20),
        
        if (services.isEmpty)
          _buildEmptyState()
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.shopping_bag, color: AppColors.primaryGold),
                  const SizedBox(width: 8),
                  Text(
                    'Your Packages (${services.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...services.map((service) {
                // ✅ Cast to EventService
                if (service is EventService) {
                  return _buildEventServiceCard(event, service);
                } else if (service is Map) {
                  // ✅ If it's still a Map, convert it
                  final eventService = EventService.fromJson(service as Map<String, dynamic>);
                  return _buildEventServiceCard(event, eventService);
                }
                return const SizedBox.shrink();
              }).toList(),
            ],
          ),

        const SizedBox(height: 30),
      ],
    ),
  );
}


/// ============================================
/// Event Service Card - Modified
/// ============================================
Widget _buildEventServiceCard(
  EventModel event,
  EventService service, // ✅ EventService بدل PackageRequestModel
) {
  final isApproved = service.vendorApproved; // ✅ استخدم vendorApproved
  final statusColor = isApproved ? Colors.green : Colors.orange;
  final daysUntilEvent =
      event.eventDate.difference(DateTime.now()).inDays;
  final canModify = daysUntilEvent >= 1;

  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: statusColor.withOpacity(0.3), width: 1.5),
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
            color: statusColor.withOpacity(0.1),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Row(
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
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.serviceName, // ✅ من EventService
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      service.packageName, // ✅ من EventService
                      style: const TextStyle(
                        fontSize: 14,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor, width: 1),
                ),
                child: Text(
                  isApproved ? 'Approved' : 'Pending', // ✅ استخدم vendorApproved
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDetailItem('Vendor', service.vendorName), // ✅
                  _buildDetailItem(
                    'Price',
                    'EGP ${_formatNumber(service.packagePrice.toInt())}', // ✅
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildDetailItem(
                'Service Type',
                service.isRequired ? 'Required' : 'Optional',
              ),
              const SizedBox(height: 12),

              // ✅ Action Buttons - Simplified
              if (canModify && isApproved) ...{
                const Divider(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            _editPackage(event, service),
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Edit'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          side: const BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            _removePackage(event, service),
                        icon: const Icon(Icons.delete, size: 16),
                        label: const Text('Remove'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              } else if (!canModify) ...{
                const Divider(),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lock, size: 16, color: Colors.red),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Locked (event within 24 hours)',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              },
            ],
          ),
        ),
      ],
    ),
  );
}

/// ============================================
/// Remove/Edit Methods
/// ============================================
void _editPackage(EventModel event, EventService service) {
  _showError('Feature coming soon');
}

void _removePackage(EventModel event, EventService service) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Remove Package?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Service: ${service.serviceName}'),
          Text('Package: ${service.packageName}'),
          const SizedBox(height: 12),
          const Text(
            'This will remove the package from the event.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            context.read<EventOwnerCubit>().removePackageFromEvent(
              eventId: event.eventId,
              serviceId: service.serviceId,
            );
            _loadDataAsync();
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Remove'),
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
            'Failed to load',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() => _isInitializing = true);
              _loadDataAsync();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Retry'),
          ),
        ],
      ),
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
            Icon(Icons.shopping_bag_outlined,
                size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text(
              'No Packages Found',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Add packages from event details',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  /// ============================================
  /// Event Summary Card
  /// ============================================
  Widget _buildEventSummaryCard(EventModel event) {
    final daysUntilEvent =
        event.eventDate.difference(DateTime.now()).inDays;

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
                  color: daysUntilEvent <= 1
                      ? Colors.red.withOpacity(0.2)
                      : Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  daysUntilEvent == 0
                      ? 'Today!'
                      : daysUntilEvent == 1
                          ? 'Tomorrow'
                          : '$daysUntilEvent days',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: daysUntilEvent <= 1 ? Colors.red : Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(
                Icons.calendar_month,
                DateFormat('MMM d').format(event.eventDate),
              ),
              _buildSummaryItem(
                Icons.location_on,
                event.city ?? 'N/A',
              ),
              _buildSummaryItem(
                Icons.people,
                '${event.expectedGuestCount}',
              ),
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
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  /// ============================================
  /// Warning Card
  /// ============================================
  Widget _buildWarningCard(EventModel event) {
    final daysUntilEvent =
        event.eventDate.difference(DateTime.now()).inDays;
    final isWithin24Hours = daysUntilEvent < 1;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isWithin24Hours
            ? Colors.red.withOpacity(0.1)
            : Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isWithin24Hours ? Colors.red : Colors.blue,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isWithin24Hours ? Icons.warning : Icons.info,
            color: isWithin24Hours ? Colors.red : Colors.blue,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isWithin24Hours
                      ? '⚠️ Changes Not Allowed'
                      : 'ℹ️ Package Rules',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color:
                        isWithin24Hours ? Colors.red : Colors.blue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isWithin24Hours
                      ? 'Event within 24 hours. Package changes are locked.'
                      : 'Replace packages 24h+ after request. Event 24h+ away.',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ============================================
  /// Package Card
  /// ============================================
  Widget _buildPackageCard(
    EventModel event,
    PackageRequestModel request,
  ) {
    final isAccepted = request.status == RequestStatus.accepted;
    final statusColor = isAccepted ? Colors.green : Colors.orange;
    final daysUntilEvent =
        event.eventDate.difference(DateTime.now()).inDays;
    final canModify = daysUntilEvent >= 1;
    final hoursSinceRequest =
        DateTime.now().difference(request.requestedAt).inHours;
    final canReplace = hoursSinceRequest >= 24;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3), width: 1.5),
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
              color: statusColor.withOpacity(0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
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
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
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
                      const SizedBox(height: 2),
                      Text(
                        request.packageName,
                        style: const TextStyle(
                          fontSize: 14,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor, width: 1),
                  ),
                  child: Text(
                    isAccepted ? 'Confirmed' : 'Pending',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetailItem('Vendor', request.vendorName),
                    _buildDetailItem(
                      'Price',
                      'EGP ${_formatNumber(request.packagePrice?.toInt() ?? 0)}',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildDetailItem(
                  'Requested',
                  _formatDateTime(request.requestedAt),
                ),
                if (request.acceptedAt != null) ...{
                  const SizedBox(height: 8),
                  _buildDetailItem(
                    'Approved',
                    _formatDateTime(request.acceptedAt!),
                  ),
                },
                const SizedBox(height: 12),

                // ✅ Action Buttons
                if (canModify && isAccepted) ...{
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (canReplace)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                _replacePackage(event, request),
                            icon: const Icon(Icons.sync, size: 16),
                            label: const Text('Replace'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.orange,
                              side: const BorderSide(
                                  color: Colors.orange),
                            ),
                          ),
                        ),
                      if (canReplace) const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              _cancelPackage(event, request),
                          icon: const Icon(Icons.cancel, size: 16),
                          label: const Text('Cancel'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(
                                color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                } else if (!canModify) ...{
                  const Divider(),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lock,
                            size: 16, color: Colors.red),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Changes locked (event within 24 hours)',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                },
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ============================================
  /// Detail Item
  /// ============================================
  Widget _buildDetailItem(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryDark,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// ============================================
  /// Action Methods
  /// ============================================
  void _replacePackage(EventModel event, PackageRequestModel request) {
    final daysUntilEvent =
        event.eventDate.difference(DateTime.now()).inDays;
    final hoursSinceRequest =
        DateTime.now().difference(request.requestedAt).inHours;

    if (daysUntilEvent < 1) {
      _showError('Cannot replace package within 24 hours of event');
      return;
    }

    if (hoursSinceRequest < 24) {
      _showError('Please wait 24 hours after request before replacing');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Replace Package?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Service: ${request.serviceName}'),
            Text('Current: ${request.packageName}'),
            const SizedBox(height: 12),
            const Text(
              'You will select a new package and wait for approval.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToReplacePackage(event, request);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange),
            child: const Text('Replace'),
          ),
        ],
      ),
    );
  }

  void _cancelPackage(EventModel event, PackageRequestModel request) {
    final daysUntilEvent =
        event.eventDate.difference(DateTime.now()).inDays;

    if (daysUntilEvent < 1) {
      _showError('Cannot cancel package within 24 hours of event');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Package?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Service: ${request.serviceName}'),
            Text('Package: ${request.packageName}'),
            const SizedBox(height: 12),
            const Text(
              'This cannot be undone. Vendor will be notified.',
              style: TextStyle(fontSize: 12, color: Colors.red),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Go Back'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<EventOwnerCubit>().removePackageFromEvent(
                    eventId: event.eventId,
                    serviceId: request.serviceId,
                  );
              _loadDataAsync();
            },
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cancel Package'),
          ),
        ],
      ),
    );
  }

  void _navigateToReplacePackage(
      EventModel event, PackageRequestModel request) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BrowsePackagesScreen(
          eventInfo: {
            'eventId': event.eventId,
            'eventName': event.eventName,
            'eventType': event.eventTypeName,
          },
          budgetData: {
            'totalBudget': event.totalBudget,
            'remainingBudget': event.remainingBudget,
            'currency': 'EGP',
          },
          servicesData: {
            'selectedServices': [
              {
                'serviceId': request.serviceId,
                'serviceName': request.serviceName,
                'isReplacement': true,
              },
            ],
          },
        ),
      ),
    ).then((_) => _loadDataAsync());
  }

  /// ============================================
  /// Helper Methods
  /// ============================================
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Package Management Rules'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('📋 Replace Package:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('• Available 24h after request'),
              Text('• At least 24h before event'),
              Text('• Requires new vendor approval'),
              SizedBox(height: 16),
              Text('❌ Cancel Package:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('• At least 24h before event'),
              Text('• Vendor will be notified'),
              Text('• Cannot be undone'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got It'),
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

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d, yyyy - hh:mm a').format(dateTime);
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}

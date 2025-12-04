import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_request_model.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/cubit/vendor_cubit.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/cubit/vendor_state.dart';
import 'package:easy_localization/easy_localization.dart';

class RequestDetailsScreen extends StatefulWidget {
  final PackageRequestModel request;

  const RequestDetailsScreen({super.key, required this.request});

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'vendor.requests.title'.tr(),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: BlocListener<VendorCubit, VendorState>(
        listener: (context, state) {
          if (state is AcceptRequestLoading || state is RejectRequestLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryGold,
                  ),
                ),
              ),
            );
          } else if (state is AcceptRequestSuccess ||
              state is RejectRequestSuccess) {
            Navigator.pop(context); // Close loading dialog
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('vendor.requests.request_updated'.tr()),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) Navigator.pop(context); // Go back to dashboard
            });
          } else if (state is AcceptRequestError ||
              state is RejectRequestError) {
            Navigator.pop(context); // Close loading dialog
            final message = state is AcceptRequestError
                ? state.message
                : (state as RejectRequestError).message;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${'vendor.requests.update_error'.tr()} $message',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Status Card
              _buildStatusCard(),
              const SizedBox(height: 20),

              // ✅ Event Information
              _buildSectionTitle('vendor.requests.event_information'.tr()),
              _buildInfoCard(
                icon: Icons.event,
                title: widget.request.eventName,
                subtitle: widget.request.eventType,
                details: [
                  '${'vendor.requests.date'.tr()}: ${_formatDate(widget.request.eventDate)}',
                  '${'vendor.requests.guest_count'.tr()}: ${widget.request.guestCount}',
                ],
              ),
              const SizedBox(height: 16),

              // ✅ Event Owner Information
              _buildSectionTitle('vendor.requests.event_owner'.tr()),
              _buildInfoCard(
                icon: Icons.person,
                title: widget.request.eventOwnerName,
                subtitle: widget.request.eventOwnerEmail,
                details: [
                  '${'auth.phone_number'.tr()}: ${widget.request.eventOwnerPhone?.toString() ?? 'N/A'}',
                ],
              ),
              const SizedBox(height: 16),

              // ✅ Location Information
              _buildSectionTitle('vendor.requests.location_details'.tr()),
              _buildLocationCard(),
              const SizedBox(height: 16),

              // ✅ Package Information
              _buildSectionTitle('vendor.requests.package_details'.tr()),
              _buildPackageCard(),
              const SizedBox(height: 16),

              // ✅ Budget Information
              _buildSectionTitle('vendor.requests.budget_information'.tr()),
              _buildBudgetCard(),
              const SizedBox(height: 16),

              // ✅ Additional Details
              if (widget.request.customRequirements != null &&
                  (widget.request.customRequirements!['description'] ?? '')
                      .isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(
                      'vendor.requests.event_description'.tr(),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        widget.request.customRequirements!['description'] ??
                            'vendor.requests.no_description'.tr(),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),

              // ✅ Action Buttons
              if (widget.request.status == RequestStatus.pending)
                _buildActionButtons()
              else
                _buildStatusBadge(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ Status Card
  Widget _buildStatusCard() {
    final statusColor = _getStatusColor(widget.request.status);
    final statusText = _getStatusText(widget.request.status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor, width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getStatusIcon(widget.request.status),
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'vendor.requests.request_status'.tr(),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Info Card
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<String> details,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryGold, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...details.map(
            (detail) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                detail,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Location Card
  Widget _buildLocationCard() {
    final customReq = widget.request.customRequirements ?? {};
    final city = customReq['city']?.toString() ?? 'N/A';
    final address = customReq['address']?.toString() ?? 'N/A';
    final location = widget.request.eventLocation ?? 'N/A';

    debugPrint('🔍 Location Card Debug:');
    debugPrint('   customReq: $customReq');
    debugPrint('   city: $city');
    debugPrint('   address: $address');
    debugPrint('   location: $location');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Text(
                'vendor.requests.event_location'.tr(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildDetailRow('vendor.requests.location'.tr(), location),
          _buildDetailRow('vendor.requests.city'.tr(), city),
          _buildDetailRow('vendor.requests.address'.tr(), address),
        ],
      ),
    );
  }

  /// ✅ Package Card
  Widget _buildPackageCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shopping_bag, color: Colors.amber[700], size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.request.packageName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.request.serviceName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            'vendor.requests.service_id'.tr(),
            widget.request.serviceId,
          ),
          _buildDetailRow(
            'vendor.requests.package_id'.tr(),
            widget.request.packageId,
          ),
        ],
      ),
    );
  }

  /// ✅ Budget Card
  Widget _buildBudgetCard() {
    final customReq = widget.request.customRequirements ?? {};
    final totalBudget = (customReq['totalBudget'] as num?)?.toDouble() ?? 0.0;
    final price =
        widget.request.packagePrice ??
        (customReq['packagePrice'] as num?)?.toDouble() ??
        0.0;

    debugPrint('🔍 Budget Card Debug:');
    debugPrint('   customReq: $customReq');
    debugPrint('   totalBudget: $totalBudget');
    debugPrint('   packagePrice from request: ${widget.request.packagePrice}');
    debugPrint('   packagePrice from customReq: ${customReq['packagePrice']}');
    debugPrint('   final price: $price');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.money, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              Text(
                'vendor.requests.budget_information'.tr(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            'vendor.requests.package_price'.tr(),
            'EGP ${_formatNumber(price.toInt())}',
          ),
          _buildDetailRow(
            'vendor.requests.total_event_budget'.tr(),
            'EGP ${_formatNumber(totalBudget.toInt())}',
          ),
        ],
      ),
    );
  }

  /// ✅ Detail Row
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Section Title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  /// ✅ Action Buttons
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _rejectRequest,
            icon: const Icon(Icons.close, size: 18),
            label: Text('vendor.requests.reject'.tr()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _acceptRequest,
            icon: const Icon(Icons.check, size: 18),
            label: Text('vendor.requests.accept'.tr()),
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

  /// ✅ Status Badge (for non-pending requests)
  Widget _buildStatusBadge() {
    final statusColor = _getStatusColor(widget.request.status);
    final statusText = _getStatusText(widget.request.status);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor),
      ),
      child: Center(
        child: Text(
          '${'vendor.requests.status_label'.tr()}: $statusText',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: statusColor,
          ),
        ),
      ),
    );
  }

  /// ✅ Accept Request
  void _acceptRequest() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('vendor.requests.accept_request'.tr()),
        content: Text('vendor.requests.accept_message'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('vendor.requests.cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<VendorCubit>().acceptRequest(
                requestId: widget.request.requestId,
                vendorResponse: 'Accepted',
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text('vendor.requests.accept'.tr()),
          ),
        ],
      ),
    );
  }

  /// ✅ Reject Request
  void _rejectRequest() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('vendor.requests.reject_request'.tr()),
        content: Text('vendor.requests.reject_message'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('vendor.requests.cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<VendorCubit>().rejectRequest(
                requestId: widget.request.requestId,
                rejectionReason: 'Not available',
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('vendor.requests.reject'.tr()),
          ),
        ],
      ),
    );
  }

  /// ✅ Show Info Dialog
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('vendor.requests.request_information'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${'vendor.requests.request_id'.tr()}: ${widget.request.requestId}',
            ),
            const SizedBox(height: 8),
            Text(
              '${'vendor.requests.created'.tr()}: ${_formatDate(widget.request.requestedAt)}',
            ),
            const SizedBox(height: 8),
            Text(
              '${'vendor.requests.expires'.tr()}: ${_formatDate(widget.request.expiresAt)}',
            ),
            const SizedBox(height: 8),
            Text(
              '${'vendor.requests.is_expired'.tr()}: ${widget.request.isExpired ? "vendor.requests.yes".tr() : "vendor.requests.no".tr()}',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('vendor.requests.close'.tr()),
          ),
        ],
      ),
    );
  }

  /// ✅ Helper Methods
  String _formatDate(DateTime date) {
    try {
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    } catch (e) {
      debugPrint('⚠️ Error formatting date: $e');
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    }
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  Color _getStatusColor(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return Colors.orange;
      case RequestStatus.accepted:
        return Colors.green;
      case RequestStatus.rejected:
        return Colors.red;
      case RequestStatus.expired:
        return Colors.grey;
      case RequestStatus.cancelled:
        return Colors.red[900]!;
    }
  }

  String _getStatusText(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return 'vendor.requests.pending'.tr();
      case RequestStatus.accepted:
        return 'vendor.requests.accepted'.tr();
      case RequestStatus.rejected:
        return 'vendor.requests.rejected'.tr();
      case RequestStatus.expired:
        return 'vendor.requests.expired'.tr();
      case RequestStatus.cancelled:
        return 'vendor.requests.cancelled'.tr();
    }
  }

  IconData _getStatusIcon(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return Icons.schedule;
      case RequestStatus.accepted:
        return Icons.check_circle;
      case RequestStatus.rejected:
        return Icons.cancel;
      case RequestStatus.expired:
        return Icons.history;
      case RequestStatus.cancelled:
        return Icons.block;
    }
  }
}

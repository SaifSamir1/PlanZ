// lib/features/new_owner_features/create_event_screen/ui/screens/event_review_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/services/notification_service.dart';
import 'package:plan_z/features/auth/data/models/user_manager.dart';
import 'package:plan_z/features/event_owners/create_event_screen/cubits/create_event_cubit/create_event_cubit.dart';
import 'package:plan_z/features/event_owners/create_event_screen/cubits/create_event_cubit/create_event_state.dart';
import 'package:plan_z/features/event_owners/event_owner_home/ui/screens/navigation_screen.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_model.dart';
import 'package:easy_localization/easy_localization.dart';

class EventReviewScreen extends StatefulWidget {
  final Map<String, dynamic> eventInfo;
  final Map<String, dynamic> budgetData;
  final Map<String, dynamic> servicesData;
  final Map<String, PackageModel>
  selectedPackages; // ✅ معدّل - PackageModel Objects

  const EventReviewScreen({
    super.key,
    required this.eventInfo,
    required this.budgetData,
    required this.servicesData,
    required this.selectedPackages,
  });

  @override
  State<EventReviewScreen> createState() => _EventReviewScreenState();
}

class _EventReviewScreenState extends State<EventReviewScreen> {
  late double _totalServicePrice;

  @override
  void initState() {
    super.initState();
    _calculateTotalPrice();
  }

  /// ✅ معدّل - الآن العملية سهلة جداً
  void _calculateTotalPrice() {
    _totalServicePrice = 0.0;
    debugPrint('🔍 Calculating price from packages:');
    debugPrint('Selected packages count: ${widget.selectedPackages.length}');

    // ✅ الآن ببساطة - المفتاح = serviceId, القيمة = PackageModel كاملة
    for (var entry in widget.selectedPackages.entries) {
      final serviceId = entry.key;
      final package = entry.value; // ✅ عندك البيانات كاملة مباشرة!

      debugPrint(
        '✅ Service: $serviceId, Package: ${package.packageName}, Price: ${package.price}',
      );
      _totalServicePrice += package.price ?? 0.0;
    }

    debugPrint('💰 Total service price: $_totalServicePrice');
  }

  /// ✅ Helper to extract string from any value
  String _getString(dynamic value) {
    if (value == null) return 'N/A';
    if (value is String) return value;
    if (value is Map) {
      return (value['name'] ?? value['id'] ?? value['title'] ?? 'Unknown')
          .toString();
    }
    return value.toString();
  }

  /// ✅ Format number
  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'event_review.title'.tr(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocListener<EventOwnerCubit, EventOwnerState>(
        listener: (context, state) {
          if (state is CreateEventSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('event_review.success_message'.tr()),
                backgroundColor: Colors.green,
              ),
            );

            // ✅ حدّث الـ Events قبل ما تروح
            final ownerId = UserManager().userId;
            if (ownerId != null) {
              context.read<EventOwnerCubit>().getEventOwnerEvents(ownerId);
            }

            // ✅ بعدها روح للـ Home Screen (مش Pop)
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NavigationScreen(),
                  ),
                  (route) => false,
                );
              }
            });
          }

          if (state is CreateEventError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'event_review.error_prefix'.tr(args: [state.message]),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state is CreateEventLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) =>
                  const Center(child: CircularProgressIndicator()),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEventInfoSection(),
              const SizedBox(height: 20),
              _buildBudgetSection(),
              const SizedBox(height: 20),
              _buildSelectedPackagesSection(),
              const SizedBox(height: 20),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  /// ============================================
  /// Event Info Section
  /// ============================================
  Widget _buildEventInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryGold, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event, color: AppColors.primaryGold, size: 24),
              const SizedBox(width: 12),
              Text(
                'event_review.event_info_title'.tr(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            'event_review.event_name'.tr(),
            _getString(widget.eventInfo['eventName']),
          ),
          _buildInfoRow(
            'event_review.event_type'.tr(),
            _getString(widget.eventInfo['eventType']),
          ),
          _buildInfoRow(
            'event_review.date'.tr(),
            _getString(widget.eventInfo['eventDate']),
          ),
          _buildInfoRow(
            'event_review.location'.tr(),
            _getString(widget.eventInfo['location']),
          ),
          _buildInfoRow(
            'event_review.city'.tr(),
            _getString(widget.eventInfo['city']),
          ),
          _buildInfoRow(
            'event_review.guest_count'.tr(),
            '${widget.eventInfo['guestCount'] ?? 0} ${'event_review.guests_suffix'.tr()}',
          ),
          if ((widget.eventInfo['additionalNotes'] as String?)?.isNotEmpty ??
              false)
            _buildInfoRow(
              'event_review.notes'.tr(),
              _getString(widget.eventInfo['additionalNotes']),
            ),
        ],
      ),
    );
  }

  /// ============================================
  /// Budget Section
  /// ============================================
  Widget _buildBudgetSection() {
    final totalBudget =
        (widget.budgetData['totalBudget'] as num?)?.toDouble() ?? 0.0;
    final remaining = totalBudget - _totalServicePrice;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.5), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.money, color: Colors.blue, size: 24),
              const SizedBox(width: 12),
              Text(
                'event_review.budget_overview'.tr(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildBudgetRow('event_review.total_budget'.tr(), totalBudget),
          _buildBudgetRow(
            'event_review.services_cost'.tr(),
            _totalServicePrice,
            Colors.orange,
          ),
          _buildBudgetRow(
            'event_review.remaining'.tr(),
            remaining,
            remaining >= 0 ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }

  /// ============================================
  /// Selected Packages Section ✅ معدّل كاملاً
  /// ============================================
  Widget _buildSelectedPackagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.shopping_bag, color: AppColors.primaryGold, size: 24),
            const SizedBox(width: 12),
            Text(
              'event_review.selected_services'.tr(
                args: [widget.selectedPackages.length.toString()],
              ),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // ✅ الآن حلقة بسيطة جداً
        ...widget.selectedPackages.entries.map((entry) {
          final serviceId = entry.key;
          final package = entry.value; // ✅ عندك البيانات كاملة

          // البحث عن معلومات الخدمة
          Map<String, dynamic>? serviceInfo;
          try {
            final selectedServices =
                widget.servicesData['selectedServices'] as List? ?? [];
            final service = selectedServices.firstWhere(
              (s) => s['serviceId'] == serviceId,
              orElse: () => <String, dynamic>{},
            );
            serviceInfo = service is Map<String, dynamic> ? service : null;
          } catch (e) {
            debugPrint('⚠️ Service not found: $serviceId - $e');
          }

          final serviceName = _getString(
            serviceInfo?['serviceName'] ?? 'Unknown Service',
          );

          return _buildPackageCard(serviceName, package);
        }).toList(),

        if (widget.selectedPackages.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'event_review.no_packages_selected'.tr(),
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ),
          ),
      ],
    );
  }

  /// ============================================
  /// Package Card ✅ معدّل
  /// ============================================
  Widget _buildPackageCard(String serviceName, PackageModel package) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryGold.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service Label (صغيرة)
          Text(
            serviceName,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),

          // Package Name (العنوان الرئيسي)
          Text(
            package.packageName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),

          // Vendor Name
          Row(
            children: [
              Icon(Icons.store, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  package.vendorName,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Description
          if (package.description.isNotEmpty) ...[
            Text(
              package.description,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
          ],

          // Features (إن وُجدت)
          if (package.features.isNotEmpty) ...[
            Text(
              'event_review.features'.tr(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            ...package.features
                .take(2)
                .map(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 14,
                          color: Colors.green.withOpacity(0.7),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            feature,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            const SizedBox(height: 12),
          ],

          // Price Section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primaryGold.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'event_review.price'.tr(),
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.budgetData['currency'] ?? 'SAR'} ${(package.price ?? 0).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'event_review.unit'.tr(),
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      package.priceUnit,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Rating
          if (package.rating != null && package.rating! > 0) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 6),
                Text(
                  '${package.rating} ⭐ (${package.reviewCount} ${'event_review.reviews_suffix'.tr()})',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${package.bookingCount} ${'event_review.bookings_suffix'.tr()}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// ============================================
  /// Action Buttons
  /// ============================================
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: AppColors.primaryGold),
            ),
            child: Text('event_review.back'.tr()),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _submitEvent,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: AppColors.primaryGold,
            ),
            child: Text(
              'event_review.create_event'.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// ============================================
  /// Helper Widgets
  /// ============================================
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetRow(String label, double value, [Color? color]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          Text(
            '${widget.budgetData['currency'] ?? 'SAR'} ${_formatNumber(value.toInt())}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color ?? AppColors.primaryGold,
            ),
          ),
        ],
      ),
    );
  }

  /// ============================================
  /// Send Vendor Notifications ✅ جديد
  /// ============================================
  Future<void> _sendVendorNotifications() async {
    debugPrint('📢 [EventReviewScreen._sendVendorNotifications] Starting...');
    debugPrint('   Total packages: ${widget.selectedPackages.length}');

    for (var entry in widget.selectedPackages.entries) {
      final package = entry.value; // PackageModel

      debugPrint(
        '📤 [EventReviewScreen] Sending to vendor: ${package.vendorName}',
      );
      debugPrint('   Vendor ID: ${package.vendorId}');
      debugPrint('   FCM Token: ${package.vendorFcmToken}');
      debugPrint('   Package: ${package.packageName}');

      // إرسال الـ notification فقط إذا كان هناك FCM token
      if (package.vendorFcmToken != null &&
          package.vendorFcmToken!.isNotEmpty) {
        try {
          await NotificationService.sendNotification(
            receiverId: package.vendorId,
            receiverRole: 'vendor',
            title: 'event_review.notification_title'.tr(),
            body: 'event_review.notification_body'.tr(
              args: [package.packageName],
            ),
            type: 'package_request',
            data: {
              'packageId': package.packageId,
              'packageName': package.packageName,
              'eventName': widget.eventInfo['eventName'] ?? 'Unknown Event',
              'eventDate': widget.eventInfo['eventDate']?.toString() ?? '',
              'vendorId': package.vendorId,
            },
            fcmToken: package.vendorFcmToken,
          );

          // عرض local notification فوراً
          await NotificationService.showLocalNotification(
            title: 'event_review.notification_title'.tr(),
            body: 'event_review.notification_body'.tr(
              args: [package.packageName],
            ),
          );

          debugPrint(
            '✅ [EventReviewScreen] Notification sent to ${package.vendorName}',
          );
        } catch (e) {
          debugPrint('❌ [EventReviewScreen] Error sending notification: $e');
        }
      } else {
        debugPrint(
          '⚠️ [EventReviewScreen] No FCM token for vendor: ${package.vendorName}',
        );
      }
    }

    debugPrint('✅ [EventReviewScreen._sendVendorNotifications] Completed!');
  }

  /// ============================================
  /// Submit Event ✅ معدّل
  /// ============================================
  void _submitEvent() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('event_review.user_not_authenticated'.tr())),
        );
        return;
      }

      final eventOwnerId = user.uid;
      final eventOwnerName = user.displayName ?? 'Unknown';
      final eventOwnerEmail = user.email ?? '';

      // ✅ Get date and combine with time FIRST
      DateTime eventDate = widget.eventInfo['eventDate'] ?? DateTime.now();
      final eventTime = widget.eventInfo['eventTime'] as TimeOfDay?;
      if (eventTime != null) {
        eventDate = eventDate.copyWith(
          hour: eventTime.hour,
          minute: eventTime.minute,
        );
      }
      debugPrint(' [EventReviewScreen] Combined eventDate: $eventDate');

      // Debug: Print entire eventInfo to see what's being passed
      debugPrint('🔍 [EventReviewScreen] FULL eventInfo:');
      widget.eventInfo.forEach((key, value) {
        if (value is Map) {
          debugPrint('   $key: [Map with ${value.length} keys]');
        } else if (value is List) {
          debugPrint('   $key: [List with ${value.length} items]');
        } else {
          debugPrint('   $key: $value');
        }
      });

      // Get all data WITHOUT using _getString (to preserve null/empty values)
      debugPrint(
        ' [EventReviewScreen] eventType: ${widget.eventInfo['eventType']}',
      );

      final eventTypeId =
          widget.eventInfo['eventType']?['eventTypeId'] ??
          widget.eventInfo['eventTypeId'] ??
          '';
      final eventTypeName =
          widget.eventInfo['eventType']?['eventTypeName'] ??
          widget.eventInfo['eventTypeName'] ??
          'Unknown';
      final eventName = widget.eventInfo['eventName'] ?? '';
      final description = widget.eventInfo['description'] ?? '';

      // Location, Address, Phone - get directly without _getString
      final location = widget.eventInfo['location']?.toString().trim() ?? '';
      final city = widget.eventInfo['city']?.toString().trim() ?? '';
      final address = widget.eventInfo['address']?.toString().trim() ?? '';
      final eventOwnerPhone =
          widget.eventInfo['phone']?.toString().trim() ?? '';
      final guestCount = widget.eventInfo['guestCount'];

      final totalBudget =
          (widget.budgetData['totalBudget'] as num?)?.toDouble() ?? 0.0;
      final expectedGuestCount = int.tryParse('${guestCount ?? 0}') ?? 0;

      debugPrint(' [EventReviewScreen] Data extracted:');
      debugPrint(
        '   location: $location (type: ${widget.eventInfo['location'].runtimeType})',
      );
      debugPrint('   city: $city');
      debugPrint('   address: $address');
      debugPrint('   phone: $eventOwnerPhone');
      debugPrint('   guestCount: $guestCount');
      debugPrint('   eventDate: $eventDate');

      // معدّل - حفظ بيانات الـ Packages كاملة مع معلومات الخدمة
      debugPrint(' [EventReviewScreen] Preparing customRequirements');
      debugPrint(
        '   selectedPackages count: ${widget.selectedPackages.length}',
      );

      final selectedServicesFromWidget =
          widget.servicesData['selectedServices'] as List?;
      debugPrint(
        '   selectedServices type: ${selectedServicesFromWidget.runtimeType}',
      );
      debugPrint(
        '   selectedServices count: ${selectedServicesFromWidget?.length}',
      );
      debugPrint('   selectedServices: $selectedServicesFromWidget');

      final customRequirements = {
        'selectedServices': widget.servicesData['selectedServices'],
        'selectedPackagesIds': widget.selectedPackages.entries
            .map((e) => {'serviceId': e.key, 'packageId': e.value.packageId})
            .toList(),
        'selectedPackagesData': widget.selectedPackages.entries.map((e) {
          try {
            debugPrint('   🔎 Processing package for serviceId: ${e.key}');

            // Get service info from selectedServices
            final selectedServices =
                widget.servicesData['selectedServices'] as List?;

            Map<String, dynamic>? serviceInfo;
            if (selectedServices != null) {
              try {
                final service = selectedServices.firstWhere(
                  (s) => s['serviceId'] == e.key,
                  orElse: () => <String, dynamic>{},
                );
                serviceInfo = service is Map<String, dynamic> ? service : null;
              } catch (err) {
                debugPrint('      ⚠️ Error finding service: $err');
              }
            }

            final packageData = {
              'serviceId': e.key,
              'serviceName': serviceInfo?['serviceName'] ?? '',
              'serviceNameAr': serviceInfo?['serviceNameAr'],
              'isRequired': serviceInfo?['required'] ?? true,
              'packageId': e.value.packageId,
              'packageName': e.value.packageName,
              'vendorId': e.value.vendorId,
              'vendorName': e.value.vendorName,
              'price': e.value.price,
            };

            debugPrint(
              '      ✅ Created packageData: ${packageData['serviceName']} -> ${packageData['packageName']}',
            );
            return packageData;
          } catch (error) {
            debugPrint('      ❌ Error processing package ${e.key}: $error');
            rethrow;
          }
        }).toList(),
        'totalServicePrice': _totalServicePrice,
      };

      debugPrint(
        '✅ [EventReviewScreen] customRequirements ready: ${customRequirements['selectedPackagesData']?.length} packages',
      );

      if (!mounted) return;

      // ✅ إرسال notifications للـ vendors قبل إنشاء الـ event
      debugPrint(
        '📢 [EventReviewScreen._submitEvent] Sending vendor notifications...',
      );
      await _sendVendorNotifications();

      context.read<EventOwnerCubit>().createEvent(
        eventOwnerId: eventOwnerId,
        eventOwnerName: eventOwnerName,
        eventOwnerEmail: eventOwnerEmail,
        eventOwnerPhone: eventOwnerPhone,
        eventTypeId: eventTypeId,
        eventTypeName: eventTypeName,
        eventName: eventName,
        description: description,
        eventDate: eventDate,
        location: location,
        city: city,
        address: address,
        coordinates: widget.eventInfo['coordinates'],
        totalBudget: totalBudget,
        expectedGuestCount: expectedGuestCount,
        customRequirements: customRequirements,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Error: ${e.toString()}')));
    }
  }
}

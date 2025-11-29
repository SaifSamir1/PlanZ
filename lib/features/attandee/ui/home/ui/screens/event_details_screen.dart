// lib/features/attendee/presentation/screens/event_details_screen.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/event_owners/create_event_screen/data/models/event_model.dart';

class EventDetailsScreen extends StatefulWidget {
  final EventModel event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool isInterested = false;

  @override
  void initState() {
    super.initState();
    // Initialize date formatting for locale support
    initializeDateFormatting('en_US', null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'attendee.event_details_title'.tr(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {
                setState(() => isInterested = !isInterested);
              },
              icon: Icon(
                isInterested ? Icons.favorite : Icons.favorite_border,
                color: isInterested ? Colors.red : AppColors.buttonPrimary,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Event Image
            _buildEventImage(),

            // ✅ Event Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Name
                  FadeInUp(
                    duration: const Duration(milliseconds: 400),
                    child: Text(
                      widget.event.eventName,
                      style: AppTextStyles.title.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Event Type Badge
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 50),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.buttonPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.event.eventTypeName,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.buttonPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ✅ Key Information Section
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 100),
                    child: _buildInfoSection(),
                  ),

                  const SizedBox(height: 24),

                  // ✅ Description
                  if (widget.event.description != null &&
                      widget.event.description!.isNotEmpty)
                    FadeInUp(
                      duration: const Duration(milliseconds: 700),
                      delay: const Duration(milliseconds: 150),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'attendee.about_event'.tr(),
                            style: AppTextStyles.headline3,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.event.description!,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),

                  // ✅ Guest Count
                  FadeInUp(
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 200),
                    child: _buildGuestCountSection(),
                  ),

                  const SizedBox(height: 24),

                  // ✅ Budget Information
                  FadeInUp(
                    duration: const Duration(milliseconds: 900),
                    delay: const Duration(milliseconds: 250),
                    child: _buildBudgetSection(),
                  ),

                  const SizedBox(height: 32),

                  // ✅ Action Buttons
                  FadeInUp(
                    duration: const Duration(milliseconds: 1000),
                    delay: const Duration(milliseconds: 300),
                    child: _buildActionButtons(context),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Event Image
  Widget _buildEventImage() {
    return Container(
      height: 250,
      width: double.infinity,
      color: AppColors.buttonPrimary.withOpacity(0.1),
      child: Stack(
        children: [
          Image.network(
            "https://cdn-cjhkj.nitrocdn.com/krXSsXVqwzhduXLVuGLToUwHLNnSxUxO/assets/images/optimized/rev-ff94111/spotme.com/wp-content/uploads/2020/07/Hero-1.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Icon(
                  Icons.event_rounded,
                  size: 80,
                  color: AppColors.buttonPrimary.withOpacity(0.3),
                ),
              );
            },
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Info Section (Date, Location, Organizer)
  Widget _buildInfoSection() {
    return Column(
      children: [
        _buildInfoItem(
          icon: Icons.calendar_today_rounded,
          title: 'attendee.date_time'.tr(),
          value: _formatDateTime(widget.event.eventDate),
        ),
        const SizedBox(height: 16),
        _buildInfoItem(
          icon: Icons.location_on_rounded,
          title: 'attendee.location'.tr(),
          value: widget.event.location,
        ),
        const SizedBox(height: 16),
        _buildInfoItem(
          icon: Icons.person_rounded,
          title: 'attendee.organizer'.tr(),
          value: widget.event.eventOwnerName,
        ),
      ],
    );
  }

  /// Info Item Widget
  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.buttonPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.buttonPrimary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.grey[600],
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Guest Count Section
  Widget _buildGuestCountSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.buttonPrimary.withOpacity(0.08),
            AppColors.buttonPrimary.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.buttonPrimary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'attendee.guest_info'.tr(),
            style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  label: 'attendee.expected_guests'.tr(),
                  value: widget.event.expectedGuestCount.toString(),
                  icon: Icons.people_outline,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  label: 'attendee.confirmed'.tr(),
                  value: (widget.event.confirmedGuestCount ?? 0).toString(),
                  icon: Icons.check_circle_outline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Stat Item Widget
  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.buttonPrimary, size: 24),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.title.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: Colors.grey[600],
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Budget Section
  Widget _buildBudgetSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'attendee.budget_info'.tr(),
            style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _buildBudgetItem(
            label: 'attendee.total_budget'.tr(),
            amount: widget.event.totalBudget,
            color: AppColors.buttonPrimary,
          ),
          const SizedBox(height: 8),
          _buildBudgetItem(
            label: 'attendee.allocated_budget'.tr(),
            amount: widget.event.allocatedBudget,
            color: Colors.orange,
          ),
          const SizedBox(height: 8),
          _buildBudgetItem(
            label: 'attendee.remaining_budget'.tr(),
            amount: widget.event.remainingBudget,
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  /// Budget Item Widget
  Widget _buildBudgetItem({
    required String label,
    required double amount,
    required Color color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.body.copyWith(color: Colors.grey[600]),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'attendee.egp'.tr(args: [amount.toStringAsFixed(2)]),
            style: AppTextStyles.body.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  /// Action Buttons
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // ✅ RSVP Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('attendee.interested_snackbar'.tr()),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.check_circle),
            label: Text('attendee.mark_interested'.tr()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // ✅ Share Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('attendee.shared_snackbar'.tr()),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.share),
            label: Text('attendee.share_event'.tr()),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.buttonPrimary,
              side: BorderSide(color: AppColors.buttonPrimary, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Format date and time
  String _formatDateTime(DateTime date) {
    return DateFormat('EEE, MMM d, yyyy • h:mm a').format(date);
  }
}

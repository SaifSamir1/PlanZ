// lib/features/attendee/presentation/widgets/home/attendee_event_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/data/models/event_model.dart';

class AttendeeEventCard extends StatelessWidget {
  final EventModel event;

  const AttendeeEventCard({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 1,
        color: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Navigate to Event Details Screen
            // Navigator.pushNamed(
            //   context,
            //   '/event-details',
            //   arguments: event.eventId,
            // );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Event Image
                _buildEventImage(),

                const SizedBox(width: 12),

                // Event Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Event Name
                      Text(
                        event.eventName,
                        style: AppTextStyles.subtitle.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 6),

                      // Event Date
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _formatEventDate(event.eventDate),
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // Event Location
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              event.location,
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Countdown Badge (if event is soon)
                      if (_isEventSoon(event.eventDate))
                        _buildCountdownBadge(event.eventDate),
                    ],
                  ),
                ),

                // Arrow Icon
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 100,
        width: 100,
        color: AppColors.buttonPrimary.withOpacity(0.1),
        child: Image.network(
                "https://cdn-cjhkj.nitrocdn.com/krXSsXVqwzhduXLVuGLToUwHLNnSxUxO/assets/images/optimized/rev-ff94111/spotme.com/wp-content/uploads/2020/07/Hero-1.jpg",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderImage();
                },
              )
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Icon(
      Icons.event_rounded,
      size: 40,
      color: AppColors.buttonPrimary.withOpacity(0.5),
    );
  }

  Widget _buildCountdownBadge(DateTime eventDate) {
    final daysUntil = eventDate.difference(DateTime.now()).inDays;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.buttonPrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time_rounded,
            size: 12,
            color: AppColors.buttonPrimary,
          ),
          const SizedBox(width: 4),
          Text(
            "$daysUntil ${daysUntil == 1 ? 'day' : 'days'} left",
            style: AppTextStyles.caption.copyWith(
              color: AppColors.buttonPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatEventDate(DateTime date) {
    return DateFormat('EEE, MMM d, y • h:mm a').format(date);
  }

  bool _isEventSoon(DateTime eventDate) {
    final daysUntil = eventDate.difference(DateTime.now()).inDays;
    return daysUntil >= 0 && daysUntil <= 7; // Within 7 days
  }
}

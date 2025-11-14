// lib/features/attendee/presentation/widgets/my_events/attendee_event_card.dart

import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/attandee/ui/home/ui/widgets/event_date_badge.dart';
import 'package:plan_z/features/event_owners/create_event_screen/data/models/event_model.dart';

class Attendee1EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;

  const Attendee1EventCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPastEvent = event.eventDate.isBefore(DateTime.now());

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        color: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isPastEvent ? Colors.grey[300]! : AppColors.buttonPrimary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Badge
                EventDateBadge(
                  date: event.eventDate,
                  isPast: isPastEvent,
                ),

                const SizedBox(width: 16),

                // Event Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event Name
                      Text(
                        event.eventName,
                        style: AppTextStyles.subtitle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isPastEvent ? Colors.grey[600] : Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 8),

                      // Event Type
                      Row(
                        children: [
                          Icon(
                            Icons.celebration_rounded,
                            size: 16,
                            color: isPastEvent ? Colors.grey[500] : AppColors.buttonPrimary,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              event.eventTypeName,
                              style: AppTextStyles.caption.copyWith(
                                color: isPastEvent ? Colors.grey[600] : Colors.grey[700],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // Location
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 16,
                            color: isPastEvent ? Colors.grey[500] : Colors.red,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              event.location,
                              style: AppTextStyles.caption.copyWith(
                                color: isPastEvent ? Colors.grey[600] : Colors.grey[700],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // Host Info
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline_rounded,
                            size: 16,
                            color: isPastEvent ? Colors.grey[500] : Colors.blue,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              "Hosted by ${event.eventOwnerName}",
                              style: AppTextStyles.caption.copyWith(
                                color: isPastEvent ? Colors.grey[600] : Colors.grey[700],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      // Past Event Badge
                      if (isPastEvent) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.history_rounded,
                                size: 12,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Past Event",
                                style: AppTextStyles.caption.copyWith(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Arrow Icon
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: isPastEvent ? Colors.grey[400] : Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_stayls.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/auth/data/models/event_model.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Card(
        elevation: 0.3,
        color: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey[200]!, width: 0.5),
        ),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Container(
                height: 90,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(event.imageURL),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      event.title,
                      style: AppTextStyles.headline3.copyWith(fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          color: AppColors.buttonPrimary,
                        ),

                        Expanded(
                          child: Text(
                            event.date.toString(),
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.primaryDark,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: AppColors.buttonPrimary),
                        Expanded(
                          child: Text(
                            event.location,
                            style: AppTextStyles.body.copyWith(
                              fontSize: 12,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 5),
              Container(
                height: 25,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Center(
                  child: Text(
                    event.status,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.background,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.buttonPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

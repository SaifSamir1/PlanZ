import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_stayls.dart';
import 'package:plan_z/features/auth/data/models/event_model.dart';
import 'package:plan_z/features/attandee_features/attendee_home/ui/attende_home_widgets/event_card.dart';

class UpComingEventsWidget extends StatelessWidget {
  UpComingEventsWidget({super.key});

  final List<EventModel> events = [
    EventModel(
      title: "Annual Tech Summit 2024",
      date: "Fri, Oct 27, 9:00 AM",
      location: "Convention Center Hall A",
      status: "active",
      imageURL: "assets/images/ConferencesTransformyournextconference.jpg",
    ),
    EventModel(
      title: "Charity Gala Dinner",
      date: "Sat, Nov 11, 6:00 PM",
      location: "Downtown Amphitheater",
      status: "Upcoming",
      imageURL: "assets/images/9bab5601-4438-49db-8a10-d88b94ad178f.jpg",
    ),
    EventModel(
      title: "Charity Gala Dinner",
      date: "Thu, Dec 14, 7:00 PM",
      location: "Grand Ballroom Hotel",
      status: "Upcoming",
      imageURL: "assets/images/ConferencesTransformyournextconference.jpg",
    ),
    EventModel(
      title: "Wedding",
      date: "Sat, Nov 11, 6:00 PM",
      location: "Downtown Amphitheater",
      status: "active",
      imageURL: "assets/images/9bab5601-4438-49db-8a10-d88b94ad178f.jpg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInUp(
          duration: const Duration(milliseconds: 600),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text("Upcoming Events", style: AppTextStyles.headline3),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: events.length,
          itemBuilder: (context, index) {
            return SlideInUp(
              duration: Duration(milliseconds: 600 + (index * 100)),
              delay: Duration(milliseconds: index * 100),
              child: EventCard(event: events[index]),
            );
          },
        ),
      ],
    );
  }
}



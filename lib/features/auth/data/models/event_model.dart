class EventModel {
  String title;
  String location;
  String status;
  String date;
  String imageURL;
  EventModel({
    required this.title,
    required this.date,
    required this.location,
    required this.status,
    required this.imageURL,
  });
}


// lib/models/event_models.dart
class EventType {
  final String id;
  final String title;
  final String description;
  final String imagePath;
  final String? icon;

  EventType({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    this.icon,
  });
}

class EventData {
  final String? selectedEventTypeId;
  final double? budget;

  EventData({
    this.selectedEventTypeId,
    this.budget,
  });

  EventData copyWith({
    String? selectedEventTypeId,
    double? budget,
  }) {
    return EventData(
      selectedEventTypeId: selectedEventTypeId ?? this.selectedEventTypeId,
      budget: budget ?? this.budget,
    );
  }
}



class EventTypesData {
  static List<EventType> getEventTypes() {
    return [
      EventType(
        id: 'wedding',
        title: 'Wedding',
        description: 'Celebrate your special day with elegance and joy.',
        imagePath: 'assets/images/widding_place.jpg',
      ),
      EventType(
        id: 'conference',
        title: 'Conference',
        description: 'Organize impactful and productive professional gatherings.',
        imagePath: 'assets/images/conferance_placess.jpg',
      ),
      EventType(
        id: 'birthday',
        title: 'Birthday Party',
        description: 'Plan a memorable and fun celebration for any age.',
        imagePath: 'assets/images/birth_day.jpg',
      ),
      EventType(
        id: 'other',
        title: 'Other Event',
        description: 'Customize for unique events not listed above.',
        imagePath: 'assets/images/other_eventes.png',
      ),
    ];
  }
}

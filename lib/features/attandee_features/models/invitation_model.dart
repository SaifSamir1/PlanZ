class Invitation {
  final String id;
  final String eventId;
  final String eventName;
  final String eventType;
  final String eventDate;
  final String eventLocation;
  String status;
  String? rsvpMessage;
  String? qrCode;

  Invitation({
    required this.id,
    required this.eventId,
    required this.eventName,
    required this.eventType,
    required this.eventDate,
    required this.eventLocation,
    this.status = 'pending',
    this.rsvpMessage,
    this.qrCode,
  });

  factory Invitation.fromJson(Map<String, dynamic> json) {
    return Invitation(
      id: json['id'],
      eventId: json['eventId'],
      eventName: json['eventName'],
      eventType: json['eventType'],
      eventDate: json['eventDate'],
      eventLocation: json['eventLocation'],
      status: json['status'],
      rsvpMessage: json['rsvpMessage'],
      qrCode: json['qrCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'eventName': eventName,
      'eventType': eventType,
      'eventDate': eventDate,
      'eventLocation': eventLocation,
      'status': status,
      'rsvpMessage': rsvpMessage,
      'qrCode': qrCode,
    };
  }

  Invitation copyWith({
    String? status,
    String? rsvpMessage,
    String? qrCode,
  }) {
    return Invitation(
      id: id,
      eventId: eventId,
      eventName: eventName,
      eventType: eventType,
      eventDate: eventDate,
      eventLocation: eventLocation,
      status: status ?? this.status,
      rsvpMessage: rsvpMessage ?? this.rsvpMessage,
      qrCode: qrCode ?? this.qrCode,
    );
  }
}
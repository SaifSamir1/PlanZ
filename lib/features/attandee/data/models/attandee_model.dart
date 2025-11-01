class AttendeeModel {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final bool isActive;
  final List<String> invitations;
  final List<String> acceptedInvitations;
  final List<String> declinedInvitations;
  final List<String> attendedEvents;
  final String? profileImageUrl;
  final DateTime createdAt;

  AttendeeModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.isActive,
    required this.invitations,
    required this.acceptedInvitations,
    required this.declinedInvitations,
    required this.attendedEvents,
    this.profileImageUrl,
    required this.createdAt,
  });

  factory AttendeeModel.fromJson(Map<String, dynamic> json) {
    return AttendeeModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'] ?? '',
      isActive: json['isActive'] ?? true,
      invitations: List<String>.from(json['invitations'] ?? []),
      acceptedInvitations: List<String>.from(json['acceptedInvitations'] ?? []),
      declinedInvitations: List<String>.from(json['declinedInvitations'] ?? []),
      attendedEvents: List<String>.from(json['attendedEvents'] ?? []),
      profileImageUrl: json['profileImageUrl'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'isActive': isActive,
      'invitations': invitations,
      'acceptedInvitations': acceptedInvitations,
      'declinedInvitations': declinedInvitations,
      'attendedEvents': attendedEvents,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  AttendeeModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    bool? isActive,
    List<String>? invitations,
    List<String>? acceptedInvitations,
    List<String>? declinedInvitations,
    List<String>? attendedEvents,
    String? profileImageUrl,
    DateTime? createdAt,
  }) {
    return AttendeeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isActive: isActive ?? this.isActive,
      invitations: invitations ?? this.invitations,
      acceptedInvitations: acceptedInvitations ?? this.acceptedInvitations,
      declinedInvitations: declinedInvitations ?? this.declinedInvitations,
      attendedEvents: attendedEvents ?? this.attendedEvents,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
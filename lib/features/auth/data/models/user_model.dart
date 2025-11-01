// lib/features/auth/data/models/user_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

enum UserType { vendor, eventOwner, attendee, admin }

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserType userType;
  final String? phoneNumber;
  final bool isActive;
  final Map<String, dynamic>? additionalInfo;
  
  // ✅ FCM Token for Push Notifications
  final String? fcmToken;
  final List<String>? fcmTokens; // Support multiple devices
  
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    this.phoneNumber,
    this.isActive = true,
    this.additionalInfo,
    this.fcmToken,
    this.fcmTokens,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      userType: UserType.values.firstWhere(
        (type) => type.name == json['userType'],
        orElse: () => UserType.attendee,
      ),
      phoneNumber: json['phoneNumber'],
      isActive: json['isActive'] ?? true,
      additionalInfo: json['additionalInfo'] != null
          ? Map<String, dynamic>.from(json['additionalInfo'])
          : null,
      fcmToken: json['fcmToken'],
      fcmTokens: json['fcmTokens'] != null
          ? List<String>.from(json['fcmTokens'])
          : null,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] is Timestamp
              ? (json['createdAt'] as Timestamp).toDate()
              : DateTime.parse(json['createdAt']))
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] is Timestamp
              ? (json['updatedAt'] as Timestamp).toDate()
              : DateTime.parse(json['updatedAt']))
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'userType': userType.name,
      'phoneNumber': phoneNumber,
      'isActive': isActive,
      'additionalInfo': additionalInfo,
      'fcmToken': fcmToken,
      'fcmTokens': fcmTokens,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    UserType? userType,
    String? phoneNumber,
    bool? isActive,
    Map<String, dynamic>? additionalInfo,
    String? fcmToken,
    List<String>? fcmTokens,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isActive: isActive ?? this.isActive,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      fcmToken: fcmToken ?? this.fcmToken,
      fcmTokens: fcmTokens ?? this.fcmTokens,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, userType: ${userType.name}, fcmToken: ${fcmToken != null ? 'Set' : 'Not Set'})';
  }
}

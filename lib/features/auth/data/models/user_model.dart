// lib/features/auth/data/models/user_model.dart

enum UserType { vendor, eventOwner, attendee, admin } // ✅ Add admin

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserType userType;
  final String? phoneNumber;
  final bool isActive;
  final Map<String, dynamic>? additionalInfo;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    this.phoneNumber,
    this.isActive = true,
    this.additionalInfo,
  });

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
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
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
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isActive: isActive ?? this.isActive,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, userType: ${userType.name})';
  }
}

// lib/features/auth/data/models/user_model.dart

// أنواع المستخدمين المحتملة
enum UserType { vendor, eventOwner, attendee }

// نموذج المستخدم
class UserModel {
  final String id;
  final String name;
  final String email;
  final UserType userType;
  final String? phoneNumber; // اختياري
  final bool isActive; // لتحديد ما إذا كان المستخدم نشطًا أم لا

  // معلومات إضافية حسب نوع المستخدم
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

  // إنشاء نموذج من JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      userType: UserType.values.firstWhere(
        (type) => type.name == json['userType'],
        orElse: () => UserType.attendee, // القيمة الافتراضية
      ),
      phoneNumber: json['phoneNumber'],
      isActive: json['isActive'] ?? true,
      additionalInfo: json['additionalInfo'] != null
          ? Map<String, dynamic>.from(json['additionalInfo'])
          : null,
    );
  }

  // تحويل النموذج إلى JSON
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

  // دالة مساعدة لإنشاء نسخة محدثة من النموذج
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

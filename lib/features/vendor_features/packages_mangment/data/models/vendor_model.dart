class VendorModel {
  final String vendorId;
  final String name;
  final String serviceType;
  final List<String> packages; // IDs of packages
  final bool verified;
  final double walletBalance;
  final List<String> notifications; // IDs of notifications

  VendorModel({
    required this.vendorId,
    required this.name,
    required this.serviceType,
    required this.packages,
    required this.verified,
    required this.walletBalance,
    required this.notifications,
  });

  factory VendorModel.fromMap(Map<String, dynamic> map, String documentId) {
    return VendorModel(
      vendorId: documentId,
      name: map['name'] ?? '',
      serviceType: map['serviceType'] ?? '',
      packages: List<String>.from(map['packages'] ?? []),
      verified: map['verified'] ?? false,
      walletBalance: (map['walletBalance'] ?? 0).toDouble(),
      notifications: List<String>.from(map['notifications'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'serviceType': serviceType,
      'packages': packages,
      'verified': verified,
      'walletBalance': walletBalance,
      'notifications': notifications,
    };
  }
}

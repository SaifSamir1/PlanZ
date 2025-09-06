class PackageModel {
  final String id;
  final String name;
  final String status;
  final String description;
  final String price;
  final String type;

  PackageModel({
    required this.name,
    required this.status,
    required this.description,
    required this.price,
    required this.id,
    required this.type,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      name: json['name'],
      status: json['status'],
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      id: json['id'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'status': status,
      'description': description,
      'price': price,
      'id': id,
      'type': type,
    };
  }
}

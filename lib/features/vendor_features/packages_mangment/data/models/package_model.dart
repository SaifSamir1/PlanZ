class PackageModel {
  final String packageId;
  //final String vendorId;
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
    required this.packageId,
   // required this.vendorId,
    required this.type,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      name: json['name'],
      status: json['status'],
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      packageId: json['id']??"",
     // vendorId: json['vendorId']??"",
      type: json['type']??"",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'status': status,
      'description': description,
      'price': price,
      'id': packageId,
      //'vendorId': vendorId,
      'type': type,
    };
  }
}

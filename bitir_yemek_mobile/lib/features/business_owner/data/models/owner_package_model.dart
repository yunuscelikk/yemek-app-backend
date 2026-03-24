class OwnerPackageModel {
  final String id;
  final String title;
  final String? description;
  final double originalPrice;
  final double discountedPrice;
  final int quantity;
  final int remainingQuantity;
  final String pickupStart;
  final String pickupEnd;
  final String pickupDate;
  final String? imageUrl;
  final bool isActive;
  final int soldQuantity;
  final double totalRevenue;

  const OwnerPackageModel({
    required this.id,
    required this.title,
    this.description,
    required this.originalPrice,
    required this.discountedPrice,
    required this.quantity,
    required this.remainingQuantity,
    required this.pickupStart,
    required this.pickupEnd,
    required this.pickupDate,
    this.imageUrl,
    required this.isActive,
    required this.soldQuantity,
    required this.totalRevenue,
  });

  factory OwnerPackageModel.fromJson(Map<String, dynamic> json) {
    return OwnerPackageModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      originalPrice: double.parse(json['originalPrice'].toString()),
      discountedPrice: double.parse(json['discountedPrice'].toString()),
      quantity: (json['quantity'] as num).toInt(),
      remainingQuantity: (json['remainingQuantity'] as num).toInt(),
      pickupStart: json['pickupStart'] as String,
      pickupEnd: json['pickupEnd'] as String,
      pickupDate: json['pickupDate'] as String,
      imageUrl: json['imageUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      soldQuantity: (json['soldQuantity'] as num?)?.toInt() ?? 0,
      totalRevenue: json['totalRevenue'] != null
          ? double.parse(json['totalRevenue'].toString())
          : 0.0,
    );
  }

  int get discountPercent {
    if (originalPrice <= 0) return 0;
    return ((1 - discountedPrice / originalPrice) * 100).round();
  }
}

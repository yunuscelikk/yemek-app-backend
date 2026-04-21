import 'package:equatable/equatable.dart';

class OwnerCategoryModel extends Equatable {
  final int id;
  final String name;
  final String slug;

  const OwnerCategoryModel({
    required this.id,
    required this.name,
    required this.slug,
  });

  @override
  List<Object?> get props => [id, name, slug];

  factory OwnerCategoryModel.fromJson(Map<String, dynamic> json) {
    return OwnerCategoryModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      slug: json['slug'] as String,
    );
  }
}

class OwnerBusinessModel extends Equatable {
  final String id;
  final String name;
  final String address;
  final String city;
  final String district;
  final String? imageUrl;
  final bool isApproved;
  final String approvalStatus;
  final bool isActive;
  final double rating;
  final int activePackages;
  final int pendingOrders;
  final OwnerCategoryModel? category;

  const OwnerBusinessModel({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.district,
    this.imageUrl,
    required this.isApproved,
    required this.approvalStatus,
    required this.isActive,
    required this.rating,
    required this.activePackages,
    required this.pendingOrders,
    this.category,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    address,
    city,
    district,
    imageUrl,
    isApproved,
    approvalStatus,
    isActive,
    rating,
    activePackages,
    pendingOrders,
    category,
  ];

  factory OwnerBusinessModel.fromJson(Map<String, dynamic> json) {
    return OwnerBusinessModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      district: json['district'] as String,
      imageUrl: json['imageUrl'] as String?,
      isApproved: json['isApproved'] as bool? ?? false,
      approvalStatus: json['approvalStatus'] as String? ?? 'pending',
      isActive: json['isActive'] as bool? ?? true,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      activePackages: (json['activePackages'] as num?)?.toInt() ?? 0,
      pendingOrders: (json['pendingOrders'] as num?)?.toInt() ?? 0,
      category: json['category'] != null
          ? OwnerCategoryModel.fromJson(
              json['category'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  String get approvalLabel {
    switch (approvalStatus) {
      case 'approved':
        return 'Onaylı';
      case 'rejected':
        return 'Reddedildi';
      default:
        return 'Onay Bekliyor';
    }
  }
}

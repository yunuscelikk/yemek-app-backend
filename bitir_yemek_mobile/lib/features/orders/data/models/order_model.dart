class OrderModel {
  final String id;
  final String packageId;
  final int quantity;
  final double totalPrice;
  final double discountAmount;
  final double finalPrice;
  final String pickupCode;
  final String status;
  final String? couponId;
  final DateTime createdAt;
  final OrderPackageModel? package;

  OrderModel({
    required this.id,
    required this.packageId,
    required this.quantity,
    required this.totalPrice,
    required this.discountAmount,
    required this.finalPrice,
    required this.pickupCode,
    required this.status,
    this.couponId,
    required this.createdAt,
    this.package,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String? ?? '',
      packageId: json['packageId'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 1,
      totalPrice: _parseDouble(json['totalPrice']),
      discountAmount: _parseDouble(json['discountAmount']),
      finalPrice: _parseDouble(json['finalPrice']),
      pickupCode: json['pickupCode'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      couponId: json['couponId'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      package: json['package'] != null
          ? OrderPackageModel.fromJson(json['package'] as Map<String, dynamic>)
          : null,
    );
  }

  bool get isActive => status == 'pending' || status == 'confirmed';
  bool get isCompleted => status == 'picked_up';
  bool get isCancelled => status == 'cancelled';
  bool get canCancel => isActive;

  String get statusText {
    switch (status) {
      case 'pending':
        return 'Onay Bekliyor';
      case 'confirmed':
        return 'Onaylandi';
      case 'picked_up':
        return 'Teslim Alindi';
      case 'cancelled':
        return 'Iptal Edildi';
      default:
        return status;
    }
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

class OrderPackageModel {
  final String id;
  final String title;
  final double discountedPrice;
  final String? imageUrl;
  final OrderBusinessModel? business;

  OrderPackageModel({
    required this.id,
    required this.title,
    required this.discountedPrice,
    this.imageUrl,
    this.business,
  });

  factory OrderPackageModel.fromJson(Map<String, dynamic> json) {
    return OrderPackageModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      discountedPrice: OrderModel._parseDouble(json['discountedPrice']),
      imageUrl: json['imageUrl'] as String?,
      business: json['business'] != null
          ? OrderBusinessModel.fromJson(
              json['business'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class OrderBusinessModel {
  final String id;
  final String name;
  final String address;
  final String? phone;

  OrderBusinessModel({
    required this.id,
    required this.name,
    required this.address,
    this.phone,
  });

  factory OrderBusinessModel.fromJson(Map<String, dynamic> json) {
    return OrderBusinessModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      phone: json['phone'] as String?,
    );
  }
}

class OrdersResponse {
  final List<OrderModel> orders;
  final int total;
  final int page;
  final int totalPages;

  OrdersResponse({
    required this.orders,
    required this.total,
    required this.page,
    required this.totalPages,
  });

  factory OrdersResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ?? [];
    final pagination = json['pagination'] as Map<String, dynamic>? ?? {};

    return OrdersResponse(
      orders: data
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: pagination['total'] as int? ?? 0,
      page: pagination['page'] as int? ?? 1,
      totalPages: pagination['totalPages'] as int? ?? 1,
    );
  }
}

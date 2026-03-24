class OrderPackageRef {
  final String id;
  final String title;
  final String pickupDate;
  final String pickupStart;
  final String pickupEnd;

  const OrderPackageRef({
    required this.id,
    required this.title,
    required this.pickupDate,
    required this.pickupStart,
    required this.pickupEnd,
  });

  factory OrderPackageRef.fromJson(Map<String, dynamic> json) {
    return OrderPackageRef(
      id: json['id'] as String,
      title: json['title'] as String,
      pickupDate: json['pickupDate'] as String,
      pickupStart: json['pickupStart'] as String,
      pickupEnd: json['pickupEnd'] as String,
    );
  }
}

class OrderUserRef {
  final String id;
  final String name;
  final String? phone;

  const OrderUserRef({required this.id, required this.name, this.phone});

  factory OrderUserRef.fromJson(Map<String, dynamic> json) {
    return OrderUserRef(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
    );
  }
}

class OwnerOrderModel {
  final String id;
  final String status;
  final double totalPrice;
  final String pickupCode;
  final int quantity;
  final DateTime createdAt;
  final OrderPackageRef? package;
  final OrderUserRef? user;

  const OwnerOrderModel({
    required this.id,
    required this.status,
    required this.totalPrice,
    required this.pickupCode,
    required this.quantity,
    required this.createdAt,
    this.package,
    this.user,
  });

  factory OwnerOrderModel.fromJson(Map<String, dynamic> json) {
    return OwnerOrderModel(
      id: json['id'] as String,
      status: json['status'] as String,
      totalPrice: double.parse(json['totalPrice'].toString()),
      pickupCode: json['pickupCode'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      createdAt: DateTime.parse(json['createdAt'] as String),
      package: json['package'] != null
          ? OrderPackageRef.fromJson(json['package'] as Map<String, dynamic>)
          : null,
      user: json['user'] != null
          ? OrderUserRef.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  String get statusLabel {
    switch (status) {
      case 'confirmed':
        return 'Onaylı';
      case 'picked_up':
        return 'Teslim Alındı';
      case 'cancelled':
        return 'İptal';
      default:
        return 'Bekliyor';
    }
  }

  bool get canVerify => status == 'pending' || status == 'confirmed';
}

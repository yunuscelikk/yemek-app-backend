part of 'owner_orders_bloc.dart';

abstract class OwnerOrdersEvent extends Equatable {
  const OwnerOrdersEvent();

  @override
  List<Object?> get props => [];
}

class LoadBusinessOrders extends OwnerOrdersEvent {
  final String businessId;
  final String? status;
  final int page;
  final int limit;

  const LoadBusinessOrders({
    required this.businessId,
    this.status,
    this.page = 1,
    this.limit = 50,
  });

  @override
  List<Object?> get props => [businessId, status, page, limit];
}

class RefreshOrders extends OwnerOrdersEvent {
  const RefreshOrders();
}

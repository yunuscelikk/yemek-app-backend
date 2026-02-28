part of 'orders_bloc.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrders extends OrdersEvent {
  const LoadOrders();
}

class LoadMoreOrders extends OrdersEvent {
  const LoadMoreOrders();
}

class RefreshOrders extends OrdersEvent {
  const RefreshOrders();
}

class CancelOrder extends OrdersEvent {
  final String orderId;

  const CancelOrder({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class ChangeOrderFilter extends OrdersEvent {
  final OrderFilter filter;

  const ChangeOrderFilter({required this.filter});

  @override
  List<Object?> get props => [filter];
}

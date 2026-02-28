part of 'orders_bloc.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object?> get props => [];
}

class OrdersInitial extends OrdersState {
  const OrdersInitial();
}

class OrdersLoading extends OrdersState {
  const OrdersLoading();
}

class OrdersLoaded extends OrdersState {
  final List<OrderModel> orders;
  final bool hasReachedMax;
  final OrderFilter filter;

  const OrdersLoaded({
    required this.orders,
    required this.hasReachedMax,
    required this.filter,
  });

  List<OrderModel> get filteredOrders {
    switch (filter) {
      case OrderFilter.active:
        return orders.where((o) => o.isActive).toList();
      case OrderFilter.completed:
        return orders.where((o) => o.isCompleted).toList();
      case OrderFilter.cancelled:
        return orders.where((o) => o.isCancelled).toList();
    }
  }

  @override
  List<Object?> get props => [orders, hasReachedMax, filter];
}

class OrdersLoadingMore extends OrdersState {
  final List<OrderModel> orders;
  final OrderFilter filter;

  const OrdersLoadingMore({required this.orders, required this.filter});

  List<OrderModel> get filteredOrders {
    switch (filter) {
      case OrderFilter.active:
        return orders.where((o) => o.isActive).toList();
      case OrderFilter.completed:
        return orders.where((o) => o.isCompleted).toList();
      case OrderFilter.cancelled:
        return orders.where((o) => o.isCancelled).toList();
    }
  }

  @override
  List<Object?> get props => [orders, filter];
}

class OrdersError extends OrdersState {
  final String message;

  const OrdersError({required this.message});

  @override
  List<Object?> get props => [message];
}

class OrderCancelSuccess extends OrdersState {
  final String orderId;

  const OrderCancelSuccess({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class OrderCancelError extends OrdersState {
  final String message;

  const OrderCancelError({required this.message});

  @override
  List<Object?> get props => [message];
}

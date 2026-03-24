part of 'owner_orders_bloc.dart';

abstract class OwnerOrdersState extends Equatable {
  const OwnerOrdersState();

  @override
  List<Object?> get props => [];
}

class OwnerOrdersInitial extends OwnerOrdersState {
  const OwnerOrdersInitial();
}

class OwnerOrdersLoading extends OwnerOrdersState {
  const OwnerOrdersLoading();
}

class OwnerOrdersLoaded extends OwnerOrdersState {
  final List<OwnerOrderModel> orders;
  final String? status;

  const OwnerOrdersLoaded({required this.orders, this.status});

  @override
  List<Object?> get props => [orders, status];
}

class OwnerOrdersError extends OwnerOrdersState {
  final String message;

  const OwnerOrdersError({required this.message});

  @override
  List<Object?> get props => [message];
}

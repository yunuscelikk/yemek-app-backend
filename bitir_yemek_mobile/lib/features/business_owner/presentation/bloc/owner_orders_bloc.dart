import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/owner_order_model.dart';
import '../../domain/repositories/business_owner_repository.dart';

part 'owner_orders_event.dart';
part 'owner_orders_state.dart';

class OwnerOrdersBloc extends Bloc<OwnerOrdersEvent, OwnerOrdersState> {
  final BusinessOwnerRepository _repository;
  String? _currentBusinessId;
  String? _currentStatus;

  OwnerOrdersBloc({required BusinessOwnerRepository repository})
    : _repository = repository,
      super(OwnerOrdersInitial()) {
    on<LoadBusinessOrders>(_onLoadBusinessOrders);
    on<RefreshOrders>(_onRefreshOrders);
  }

  Future<void> _onLoadBusinessOrders(
    LoadBusinessOrders event,
    Emitter<OwnerOrdersState> emit,
  ) async {
    _currentBusinessId = event.businessId;
    _currentStatus = event.status;
    emit(OwnerOrdersLoading());
    try {
      final orders = await _repository.getBusinessOrders(
        event.businessId,
        status: event.status,
        page: event.page,
        limit: event.limit,
      );
      emit(OwnerOrdersLoaded(orders: orders, status: event.status));
    } catch (e) {
      emit(OwnerOrdersError(message: e.toString()));
    }
  }

  Future<void> _onRefreshOrders(
    RefreshOrders event,
    Emitter<OwnerOrdersState> emit,
  ) async {
    if (_currentBusinessId == null) return;
    emit(OwnerOrdersLoading());
    try {
      final orders = await _repository.getBusinessOrders(
        _currentBusinessId!,
        status: _currentStatus,
      );
      emit(OwnerOrdersLoaded(orders: orders, status: _currentStatus));
    } catch (e) {
      emit(OwnerOrdersError(message: e.toString()));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/business_model.dart';
import '../../domain/repositories/businesses_repository.dart';

part 'businesses_event.dart';
part 'businesses_state.dart';

class BusinessesBloc extends Bloc<BusinessesEvent, BusinessesState> {
  final BusinessesRepository _repository;

  BusinessesBloc({required BusinessesRepository repository})
    : _repository = repository,
      super(BusinessesInitial()) {
    on<LoadNearbyBusinesses>(_onLoadNearbyBusinesses);
    on<LoadMoreBusinesses>(_onLoadMoreBusinesses);
  }

  Future<void> _onLoadNearbyBusinesses(
    LoadNearbyBusinesses event,
    Emitter<BusinessesState> emit,
  ) async {
    emit(BusinessesLoading());

    final result = await _repository.getNearbyBusinesses(
      latitude: event.latitude,
      longitude: event.longitude,
      radius: event.radius,
      page: 1,
      limit: 10,
    );

    if (result.isSuccess) {
      emit(
        BusinessesLoaded(
          businesses: result.businesses!,
          pagination: result.pagination!,
          hasReachedMax:
              result.pagination!.page >= result.pagination!.totalPages,
        ),
      );
    } else {
      emit(BusinessesError(message: result.error!));
    }
  }

  Future<void> _onLoadMoreBusinesses(
    LoadMoreBusinesses event,
    Emitter<BusinessesState> emit,
  ) async {
    if (state is! BusinessesLoaded) return;

    final currentState = state as BusinessesLoaded;

    if (currentState.hasReachedMax) return;

    emit(
      BusinessesLoadingMore(
        businesses: currentState.businesses,
        pagination: currentState.pagination,
      ),
    );

    final result = await _repository.getNearbyBusinesses(
      latitude: event.latitude,
      longitude: event.longitude,
      radius: event.radius,
      page: currentState.pagination.page + 1,
      limit: 10,
    );

    if (result.isSuccess) {
      final allBusinesses = [...currentState.businesses, ...result.businesses!];
      emit(
        BusinessesLoaded(
          businesses: allBusinesses,
          pagination: result.pagination!,
          hasReachedMax:
              result.pagination!.page >= result.pagination!.totalPages,
        ),
      );
    } else {
      emit(
        BusinessesError(
          message: result.error!,
          businesses: currentState.businesses,
        ),
      );
    }
  }
}

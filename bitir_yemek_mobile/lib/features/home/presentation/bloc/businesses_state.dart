part of 'businesses_bloc.dart';

abstract class BusinessesState extends Equatable {
  const BusinessesState();

  @override
  List<Object?> get props => [];
}

class BusinessesInitial extends BusinessesState {
  const BusinessesInitial();
}

class BusinessesLoading extends BusinessesState {
  const BusinessesLoading();
}

class BusinessesLoadingMore extends BusinessesState {
  final List<BusinessModel> businesses;
  final PaginationModel pagination;

  const BusinessesLoadingMore({
    required this.businesses,
    required this.pagination,
  });

  @override
  List<Object?> get props => [businesses, pagination];
}

class BusinessesLoaded extends BusinessesState {
  final List<BusinessModel> businesses;
  final PaginationModel pagination;
  final bool hasReachedMax;

  const BusinessesLoaded({
    required this.businesses,
    required this.pagination,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [businesses, pagination, hasReachedMax];
}

class BusinessesError extends BusinessesState {
  final String message;
  final List<BusinessModel>? businesses;

  const BusinessesError({required this.message, this.businesses});

  @override
  List<Object?> get props => [message, businesses];
}

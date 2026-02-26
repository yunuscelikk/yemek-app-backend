part of 'packages_bloc.dart';

abstract class PackagesState extends Equatable {
  const PackagesState();

  @override
  List<Object?> get props => [];
}

class PackagesInitial extends PackagesState {
  const PackagesInitial();
}

class PackagesLoading extends PackagesState {
  const PackagesLoading();
}

class PackagesLoadingMore extends PackagesState {
  final List<PackageModel> packages;
  final PaginationModel pagination;

  const PackagesLoadingMore({required this.packages, required this.pagination});

  @override
  List<Object?> get props => [packages, pagination];
}

class PackagesLoaded extends PackagesState {
  final List<PackageModel> packages;
  final PaginationModel pagination;
  final bool hasReachedMax;

  const PackagesLoaded({
    required this.packages,
    required this.pagination,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [packages, pagination, hasReachedMax];
}

class PackagesError extends PackagesState {
  final String message;
  final List<PackageModel>? packages;

  const PackagesError({required this.message, this.packages});

  @override
  List<Object?> get props => [message, packages];
}

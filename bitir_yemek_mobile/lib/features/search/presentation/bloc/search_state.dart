part of 'search_bloc.dart';

enum SortOrder {
  priceAsc('Azalan Fiyat'),
  priceDesc('Artan Fiyat'),
  distance('Mesafe'),
  rating('Puan'),
  discount('İndirim');

  final String label;
  const SortOrder(this.label);
}

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchLoaded extends SearchState {
  final List<PackageModel> packages;
  final SortOrder sortOrder;
  final bool hasReachedMax;
  final int currentPage;

  const SearchLoaded({
    required this.packages,
    required this.sortOrder,
    this.hasReachedMax = false,
    this.currentPage = 1,
  });

  SearchLoaded copyWith({
    List<PackageModel>? packages,
    SortOrder? sortOrder,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return SearchLoaded(
      packages: packages ?? this.packages,
      sortOrder: sortOrder ?? this.sortOrder,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [packages, sortOrder, hasReachedMax, currentPage];
}

class SearchLoadingMore extends SearchState {
  final List<PackageModel> packages;
  final SortOrder sortOrder;

  const SearchLoadingMore({required this.packages, required this.sortOrder});

  @override
  List<Object?> get props => [packages, sortOrder];
}

class SearchError extends SearchState {
  final String message;

  const SearchError({required this.message});

  @override
  List<Object?> get props => [message];
}

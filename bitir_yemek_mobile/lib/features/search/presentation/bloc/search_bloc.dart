import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../home/data/models/package_model.dart';
import '../../../home/data/repositories/businesses_repository_impl.dart';
import '../../../home/domain/repositories/businesses_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final BusinessesRepository _repository;

  SearchBloc({required BusinessesRepository repository})
    : _repository = repository,
      super(SearchInitial()) {
    on<SearchPackages>(_onSearchPackages);
    on<LoadMoreSearchResults>(_onLoadMoreSearchResults);
    on<UpdateSortOrder>(_onUpdateSortOrder);
    on<UpdateSearchFilters>(_onUpdateSearchFilters);
  }

  Future<void> _onSearchPackages(
    SearchPackages event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());

    try {
      final result = await _repository.getNearbyPackages(
        latitude: event.latitude,
        longitude: event.longitude,
        radius: 50.0, // Daha geniş arama
        page: 1,
        limit: 20,
      );

      if (result.isSuccess) {
        final sortedPackages = _sortPackages(result.packages!, event.sortOrder);
        emit(
          SearchLoaded(
            packages: sortedPackages,
            sortOrder: event.sortOrder,
            hasReachedMax:
                result.pagination!.page >= result.pagination!.totalPages,
            currentPage: 1,
          ),
        );
      } else {
        emit(SearchError(message: result.error!));
      }
    } catch (e) {
      emit(SearchError(message: 'Arama yapılırken hata oluştu: $e'));
    }
  }

  Future<void> _onLoadMoreSearchResults(
    LoadMoreSearchResults event,
    Emitter<SearchState> emit,
  ) async {
    final currentState = state;
    if (currentState is! SearchLoaded || currentState.hasReachedMax) return;

    emit(
      SearchLoadingMore(
        packages: currentState.packages,
        sortOrder: currentState.sortOrder,
      ),
    );

    try {
      final result = await _repository.getNearbyPackages(
        latitude: event.latitude,
        longitude: event.longitude,
        radius: 50.0,
        page: currentState.currentPage + 1,
        limit: 20,
      );

      if (result.isSuccess) {
        final allPackages = [...currentState.packages, ...result.packages!];
        final sortedPackages = _sortPackages(
          allPackages,
          currentState.sortOrder,
        );

        emit(
          SearchLoaded(
            packages: sortedPackages,
            sortOrder: currentState.sortOrder,
            hasReachedMax:
                result.pagination!.page >= result.pagination!.totalPages,
            currentPage: currentState.currentPage + 1,
          ),
        );
      }
    } catch (e) {
      emit(SearchError(message: 'Daha fazla yüklenirken hata oluştu: $e'));
    }
  }

  void _onUpdateSortOrder(UpdateSortOrder event, Emitter<SearchState> emit) {
    final currentState = state;
    if (currentState is! SearchLoaded) return;

    final sortedPackages = _sortPackages(
      currentState.packages,
      event.sortOrder,
    );
    emit(
      currentState.copyWith(
        packages: sortedPackages,
        sortOrder: event.sortOrder,
      ),
    );
  }

  void _onUpdateSearchFilters(
    UpdateSearchFilters event,
    Emitter<SearchState> emit,
  ) {
    // Filtreleme mantığı buraya eklenecek
  }

  List<PackageModel> _sortPackages(
    List<PackageModel> packages,
    SortOrder sortOrder,
  ) {
    final sorted = List<PackageModel>.from(packages);

    switch (sortOrder) {
      case SortOrder.priceAsc:
        sorted.sort((a, b) => a.discountedPrice.compareTo(b.discountedPrice));
        break;
      case SortOrder.priceDesc:
        sorted.sort((a, b) => b.discountedPrice.compareTo(a.discountedPrice));
        break;
      case SortOrder.distance:
        sorted.sort((a, b) {
          final distA = a.business.distance ?? double.infinity;
          final distB = b.business.distance ?? double.infinity;
          return distA.compareTo(distB);
        });
        break;
      case SortOrder.rating:
        sorted.sort((a, b) => b.business.rating.compareTo(a.business.rating));
        break;
      case SortOrder.discount:
        sorted.sort(
          (a, b) => b.discountPercentage.compareTo(a.discountPercentage),
        );
        break;
    }

    return sorted;
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/businesses_repository_impl.dart';
import '../../domain/repositories/businesses_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final BusinessesRepository _repository;

  HomeBloc({required BusinessesRepository repository})
    : _repository = repository,
      super(HomeInitial()) {
    on<LoadCategories>(_onLoadCategories);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    try {
      final result = await _repository.getCategories();

      print('Categories Result: isSuccess=${result.isSuccess}');
      print('Categories Result: error=${result.error}');
      print('Categories Result: categories count=${result.categories?.length}');

      if (result.isSuccess &&
          result.categories != null &&
          result.categories!.isNotEmpty) {
        // Add "Hepsi" (All) category at the beginning
        final allCategory = CategoryModel(id: 0, name: 'Hepsi', slug: 'all');
        final categories = [allCategory, ...result.categories!];

        print('Categories loaded: ${categories.map((c) => c.name).toList()}');
        emit(HomeLoaded(categories: categories));
      } else {
        print('Categories failed or empty: ${result.error}');
        emit(HomeError(message: result.error ?? 'Kategoriler yüklenemedi'));
      }
    } catch (e) {
      print('Categories exception: $e');
      emit(HomeError(message: 'Kategoriler yüklenirken hata: $e'));
    }
  }
}

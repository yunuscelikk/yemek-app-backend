import '../../data/models/favorite_model.dart';

abstract class FavoritesRepository {
  Future<FavoritesResponse> getFavorites({int page = 1, int limit = 10});
  Future<void> addFavorite(String businessId);
  Future<void> removeFavorite(String businessId);
  Future<bool> checkFavorite(String businessId);
}

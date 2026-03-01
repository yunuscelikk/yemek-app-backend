import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_remote_datasource.dart';
import '../models/favorite_model.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource _remoteDataSource;

  FavoritesRepositoryImpl({required FavoritesRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<FavoritesResponse> getFavorites({int page = 1, int limit = 10}) async {
    final data = await _remoteDataSource.getFavorites(page: page, limit: limit);
    return FavoritesResponse.fromJson(data);
  }

  @override
  Future<void> addFavorite(String businessId) async {
    await _remoteDataSource.addFavorite(businessId);
  }

  @override
  Future<void> removeFavorite(String businessId) async {
    await _remoteDataSource.removeFavorite(businessId);
  }

  @override
  Future<bool> checkFavorite(String businessId) async {
    final data = await _remoteDataSource.checkFavorite(businessId);
    return data['isFavorite'] as bool? ?? false;
  }
}

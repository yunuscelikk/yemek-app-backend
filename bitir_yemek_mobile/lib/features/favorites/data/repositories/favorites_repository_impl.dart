import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_remote_datasource.dart';
import '../models/favorite_model.dart';
import '../../../../core/services/cache_service.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource _remoteDataSource;
  final CacheService _cache;

  FavoritesRepositoryImpl({
    required FavoritesRemoteDataSource remoteDataSource,
    CacheService? cacheService,
  }) : _remoteDataSource = remoteDataSource,
       _cache = cacheService ?? CacheService();

  @override
  Future<FavoritesResponse> getFavorites({int page = 1, int limit = 10}) async {
    final cacheKey = 'favorites:list:p$page:l$limit';

    final cached = _cache.get<Map<String, dynamic>>(cacheKey);
    if (cached != null) {
      return FavoritesResponse.fromJson(cached);
    }

    final data = await _remoteDataSource.getFavorites(page: page, limit: limit);
    _cache.set(cacheKey, data);
    return FavoritesResponse.fromJson(data);
  }

  @override
  Future<void> addFavorite(String businessId) async {
    await _remoteDataSource.addFavorite(businessId);
    // Evict the favorites list cache so the next fetch reflects the new entry.
    _cache.invalidatePattern('favorites:');
  }

  @override
  Future<void> removeFavorite(String businessId) async {
    await _remoteDataSource.removeFavorite(businessId);
    // Evict the favorites list cache so the removed entry is not shown.
    _cache.invalidatePattern('favorites:');
  }

  @override
  Future<bool> checkFavorite(String businessId) async {
    final cacheKey = 'favorites:check:$businessId';

    final cached = _cache.get<bool>(cacheKey);
    if (cached != null) return cached;

    final data = await _remoteDataSource.checkFavorite(businessId);
    final isFavorite = data['isFavorite'] as bool? ?? false;
    // Short TTL for check — list mutations already evict these keys.
    _cache.set(cacheKey, isFavorite, ttl: const Duration(minutes: 2));
    return isFavorite;
  }
}

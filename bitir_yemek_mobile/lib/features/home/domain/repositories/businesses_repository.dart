import '../../data/models/business_model.dart';
import '../../data/models/package_model.dart';
import '../../data/repositories/businesses_repository_impl.dart';

abstract class BusinessesRepository {
  Future<BusinessesResult> getNearbyBusinesses({
    required double latitude,
    required double longitude,
    double radius = 5.0,
    int page = 1,
    int limit = 10,
  });

  Future<BusinessesResult> getBusinesses({
    String? city,
    String? district,
    int page = 1,
    int limit = 10,
  });

  Future<PackagesResult> getPackages({
    String? categoryId,
    int page = 1,
    int limit = 10,
  });

  Future<PackagesResult> getNearbyPackages({
    required double latitude,
    required double longitude,
    double radius = 5.0,
    int page = 1,
    int limit = 10,
  });

  Future<CategoriesResult> getCategories();
}

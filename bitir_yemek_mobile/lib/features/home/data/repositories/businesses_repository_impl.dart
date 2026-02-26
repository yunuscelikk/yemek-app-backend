import '../datasources/businesses_remote_datasource.dart';
import '../models/business_model.dart';
import '../models/category_model.dart';
import '../models/package_model.dart';
import '../../domain/repositories/businesses_repository.dart';

class BusinessesRepositoryImpl implements BusinessesRepository {
  final BusinessesRemoteDataSource _remoteDataSource;

  BusinessesRepositoryImpl({
    required BusinessesRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<BusinessesResult> getNearbyBusinesses({
    required double latitude,
    required double longitude,
    double radius = 5.0,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _remoteDataSource.getNearbyBusinesses(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        page: page,
        limit: limit,
      );

      final businessesResponse = BusinessesResponse.fromJson(response);

      return BusinessesResult.success(
        businesses: businessesResponse.data,
        pagination: businessesResponse.pagination,
      );
    } on BusinessesException catch (e) {
      return BusinessesResult.failure(e.message);
    } catch (e) {
      return BusinessesResult.failure('Bir hata oluştu: $e');
    }
  }

  @override
  Future<BusinessesResult> getBusinesses({
    String? city,
    String? district,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _remoteDataSource.getBusinesses(
        city: city,
        district: district,
        page: page,
        limit: limit,
      );

      final businessesResponse = BusinessesResponse.fromJson(response);

      return BusinessesResult.success(
        businesses: businessesResponse.data,
        pagination: businessesResponse.pagination,
      );
    } on BusinessesException catch (e) {
      return BusinessesResult.failure(e.message);
    } catch (e) {
      return BusinessesResult.failure('Bir hata oluştu: $e');
    }
  }

  @override
  Future<PackagesResult> getPackages({
    String? categoryId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _remoteDataSource.getPackages(
        categoryId: categoryId,
        page: page,
        limit: limit,
      );

      final packagesResponse = PackagesResponse.fromJson(response);

      return PackagesResult.success(
        packages: packagesResponse.data,
        pagination: packagesResponse.pagination,
      );
    } on BusinessesException catch (e) {
      return PackagesResult.failure(e.message);
    } catch (e) {
      return PackagesResult.failure('Bir hata oluştu: $e');
    }
  }

  @override
  Future<PackagesResult> getNearbyPackages({
    required double latitude,
    required double longitude,
    double radius = 5.0,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _remoteDataSource.getNearbyPackages(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        page: page,
        limit: limit,
      );

      // Debug logging
      print('Packages API Response: $response');
      print('Data: ${response['data']}');
      print('Pagination: ${response['pagination']}');

      final packagesResponse = PackagesResponse.fromJson(response);

      return PackagesResult.success(
        packages: packagesResponse.data,
        pagination: packagesResponse.pagination,
      );
    } on BusinessesException catch (e) {
      print('BusinessesException: ${e.message}');
      return PackagesResult.failure(e.message);
    } catch (e) {
      print('Error: $e');
      return PackagesResult.failure('Bir hata oluştu: $e');
    }
  }

  @override
  Future<CategoriesResult> getCategories() async {
    try {
      print('Repository: Fetching categories...');
      final response = await _remoteDataSource.getCategories();
      print('Repository: Categories response: $response');

      // Backend returns 'categories' key, not 'data'
      final categoriesData = response['categories'] ?? response['data'];
      if (categoriesData == null) {
        print('Repository: No categories or data in response');
        return CategoriesResult.failure('Kategori verisi bulunamadı');
      }

      final categories = (categoriesData as List<dynamic>)
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();

      print('Repository: Parsed ${categories.length} categories');
      return CategoriesResult.success(categories: categories);
    } on BusinessesException catch (e) {
      print('Repository: BusinessesException: ${e.message}');
      return CategoriesResult.failure(e.message);
    } catch (e) {
      print('Repository: Error: $e');
      return CategoriesResult.failure('Bir hata oluştu: $e');
    }
  }
}

class CategoriesResult {
  final bool isSuccess;
  final List<CategoryModel>? categories;
  final String? error;

  CategoriesResult._({required this.isSuccess, this.categories, this.error});

  factory CategoriesResult.success({required List<CategoryModel> categories}) {
    return CategoriesResult._(isSuccess: true, categories: categories);
  }

  factory CategoriesResult.failure(String error) {
    return CategoriesResult._(isSuccess: false, error: error);
  }
}

class PackagesResult {
  final bool isSuccess;
  final List<PackageModel>? packages;
  final PaginationModel? pagination;
  final String? error;

  PackagesResult._({
    required this.isSuccess,
    this.packages,
    this.pagination,
    this.error,
  });

  factory PackagesResult.success({
    required List<PackageModel> packages,
    required PaginationModel pagination,
  }) {
    return PackagesResult._(
      isSuccess: true,
      packages: packages,
      pagination: pagination,
    );
  }

  factory PackagesResult.failure(String error) {
    return PackagesResult._(isSuccess: false, error: error);
  }
}

class BusinessesResult {
  final bool isSuccess;
  final List<BusinessModel>? businesses;
  final PaginationModel? pagination;
  final String? error;

  BusinessesResult._({
    required this.isSuccess,
    this.businesses,
    this.pagination,
    this.error,
  });

  factory BusinessesResult.success({
    required List<BusinessModel> businesses,
    required PaginationModel pagination,
  }) {
    return BusinessesResult._(
      isSuccess: true,
      businesses: businesses,
      pagination: pagination,
    );
  }

  factory BusinessesResult.failure(String error) {
    return BusinessesResult._(isSuccess: false, error: error);
  }
}

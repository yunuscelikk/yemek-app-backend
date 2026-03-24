import '../../domain/repositories/business_owner_repository.dart';
import '../datasources/business_owner_remote_datasource.dart';
import '../models/dashboard_stats_model.dart';
import '../models/owner_business_model.dart';
import '../models/owner_order_model.dart';
import '../models/owner_package_model.dart';

class BusinessOwnerRepositoryImpl implements BusinessOwnerRepository {
  final BusinessOwnerRemoteDataSource _remoteDataSource;

  BusinessOwnerRepositoryImpl({
    required BusinessOwnerRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<List<OwnerBusinessModel>> getMyBusinesses() =>
      _remoteDataSource.getMyBusinesses();

  @override
  Future<DashboardStatsModel> getDashboardStats(String businessId) =>
      _remoteDataSource.getDashboardStats(businessId);

  @override
  Future<List<OwnerOrderModel>> getBusinessOrders(
    String businessId, {
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    final data = await _remoteDataSource.getBusinessOrders(
      businessId,
      status: status,
      page: page,
      limit: limit,
    );
    final List<dynamic> rawList = data['data'] as List<dynamic>? ?? [];
    return rawList
        .map((e) => OwnerOrderModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<OwnerPackageModel>> getBusinessPackages(String businessId) =>
      _remoteDataSource.getBusinessPackages(businessId);

  @override
  Future<Map<String, dynamic>> verifyOrder(
    String businessId,
    String pickupCode,
  ) => _remoteDataSource.verifyOrder(businessId, pickupCode);

  @override
  Future<OwnerPackageModel> createPackage({
    required String businessId,
    required String title,
    String? description,
    required double originalPrice,
    required double discountedPrice,
    required int quantity,
    required String pickupStart,
    required String pickupEnd,
    required String pickupDate,
  }) => _remoteDataSource.createPackage(
    businessId: businessId,
    title: title,
    description: description,
    originalPrice: originalPrice,
    discountedPrice: discountedPrice,
    quantity: quantity,
    pickupStart: pickupStart,
    pickupEnd: pickupEnd,
    pickupDate: pickupDate,
  );

  @override
  Future<OwnerPackageModel> updatePackage(
    String packageId, {
    String? title,
    String? description,
    double? originalPrice,
    double? discountedPrice,
    int? quantity,
    String? pickupStart,
    String? pickupEnd,
    String? pickupDate,
    bool? isActive,
  }) => _remoteDataSource.updatePackage(
    packageId,
    title: title,
    description: description,
    originalPrice: originalPrice,
    discountedPrice: discountedPrice,
    quantity: quantity,
    pickupStart: pickupStart,
    pickupEnd: pickupEnd,
    pickupDate: pickupDate,
    isActive: isActive,
  );

  @override
  Future<void> deletePackage(String packageId) =>
      _remoteDataSource.deletePackage(packageId);

  @override
  Future<OwnerBusinessModel> createBusiness({
    required String name,
    String? description,
    required String address,
    required String city,
    required String district,
    required double latitude,
    required double longitude,
    String? phone,
    required int categoryId,
  }) => _remoteDataSource.createBusiness(
    name: name,
    description: description,
    address: address,
    city: city,
    district: district,
    latitude: latitude,
    longitude: longitude,
    phone: phone,
    categoryId: categoryId,
  );

  @override
  Future<List<OwnerCategoryModel>> getCategories() =>
      _remoteDataSource.getCategories();
}

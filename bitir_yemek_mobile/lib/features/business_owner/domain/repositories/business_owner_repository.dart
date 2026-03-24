import '../../data/models/dashboard_stats_model.dart';
import '../../data/models/owner_business_model.dart';
import '../../data/models/owner_order_model.dart';
import '../../data/models/owner_package_model.dart';

abstract class BusinessOwnerRepository {
  Future<List<OwnerBusinessModel>> getMyBusinesses();

  Future<DashboardStatsModel> getDashboardStats(String businessId);

  Future<List<OwnerOrderModel>> getBusinessOrders(
    String businessId, {
    String? status,
    int page,
    int limit,
  });

  Future<List<OwnerPackageModel>> getBusinessPackages(String businessId);

  Future<Map<String, dynamic>> verifyOrder(
    String businessId,
    String pickupCode,
  );

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
  });

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
  });

  Future<void> deletePackage(String packageId);

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
  });

  Future<List<OwnerCategoryModel>> getCategories();
}

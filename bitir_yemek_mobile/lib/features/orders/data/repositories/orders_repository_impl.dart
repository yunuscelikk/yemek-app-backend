import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_remote_datasource.dart';
import '../models/order_model.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource _remoteDataSource;

  OrdersRepositoryImpl({required OrdersRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<OrdersResponse> getMyOrders({int page = 1, int limit = 10}) async {
    final data = await _remoteDataSource.getMyOrders(page: page, limit: limit);
    return OrdersResponse.fromJson(data);
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    await _remoteDataSource.cancelOrder(orderId);
  }
}

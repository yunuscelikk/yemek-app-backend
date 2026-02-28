import '../../data/models/order_model.dart';

abstract class OrdersRepository {
  Future<OrdersResponse> getMyOrders({int page = 1, int limit = 10});
  Future<void> cancelOrder(String orderId);
}

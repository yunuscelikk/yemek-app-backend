import 'package:equatable/equatable.dart';

class DailyStatModel extends Equatable {
  final String date;
  final int orders;
  final double revenue;

  const DailyStatModel({
    required this.date,
    required this.orders,
    required this.revenue,
  });

  @override
  List<Object?> get props => [date, orders, revenue];

  factory DailyStatModel.fromJson(Map<String, dynamic> json) {
    return DailyStatModel(
      date: json['date'] as String,
      orders: (json['orders'] as num).toInt(),
      revenue: json['revenue'] != null
          ? double.parse(json['revenue'].toString())
          : 0.0,
    );
  }
}

class DashboardStatsModel extends Equatable {
  final int totalPackages;
  final int activePackages;
  final int todayOrders;
  final double todayRevenue;
  final int pendingOrders;
  final int totalOrders;
  final double totalRevenue;
  final double averageRating;
  final double weeklyRevenue;
  final double monthlyRevenue;
  final List<DailyStatModel> dailyStats;

  const DashboardStatsModel({
    required this.totalPackages,
    required this.activePackages,
    required this.todayOrders,
    required this.todayRevenue,
    required this.pendingOrders,
    required this.totalOrders,
    required this.totalRevenue,
    required this.averageRating,
    required this.weeklyRevenue,
    required this.monthlyRevenue,
    required this.dailyStats,
  });

  @override
  List<Object?> get props => [
    totalPackages,
    activePackages,
    todayOrders,
    todayRevenue,
    pendingOrders,
    totalOrders,
    totalRevenue,
    averageRating,
    weeklyRevenue,
    monthlyRevenue,
    dailyStats,
  ];

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    final stats = json['stats'] as Map<String, dynamic>;
    final rawDailyStats = json['dailyStats'] as List<dynamic>? ?? [];

    return DashboardStatsModel(
      totalPackages: (stats['totalPackages'] as num?)?.toInt() ?? 0,
      activePackages: (stats['activePackages'] as num?)?.toInt() ?? 0,
      todayOrders: (stats['todayOrders'] as num?)?.toInt() ?? 0,
      todayRevenue: stats['todayRevenue'] != null
          ? double.parse(stats['todayRevenue'].toString())
          : 0.0,
      pendingOrders: (stats['pendingOrders'] as num?)?.toInt() ?? 0,
      totalOrders: (stats['totalOrders'] as num?)?.toInt() ?? 0,
      totalRevenue: stats['totalRevenue'] != null
          ? double.parse(stats['totalRevenue'].toString())
          : 0.0,
      averageRating: stats['averageRating'] != null
          ? double.parse(stats['averageRating'].toString())
          : 0.0,
      weeklyRevenue: stats['weeklyRevenue'] != null
          ? double.parse(stats['weeklyRevenue'].toString())
          : 0.0,
      monthlyRevenue: stats['monthlyRevenue'] != null
          ? double.parse(stats['monthlyRevenue'].toString())
          : 0.0,
      dailyStats: rawDailyStats
          .map((e) => DailyStatModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

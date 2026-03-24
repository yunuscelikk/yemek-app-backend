part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboard extends DashboardEvent {
  final String businessId;

  const LoadDashboard({required this.businessId});

  @override
  List<Object?> get props => [businessId];
}

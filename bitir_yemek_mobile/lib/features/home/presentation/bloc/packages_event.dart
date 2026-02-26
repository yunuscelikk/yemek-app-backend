part of 'packages_bloc.dart';

abstract class PackagesEvent extends Equatable {
  const PackagesEvent();

  @override
  List<Object?> get props => [];
}

class LoadNearbyPackages extends PackagesEvent {
  final double latitude;
  final double longitude;
  final double radius;

  const LoadNearbyPackages({
    required this.latitude,
    required this.longitude,
    this.radius = 5.0,
  });

  @override
  List<Object?> get props => [latitude, longitude, radius];
}

class LoadPackagesByCategory extends PackagesEvent {
  final String categoryId;
  final double latitude;
  final double longitude;

  const LoadPackagesByCategory({
    required this.categoryId,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [categoryId, latitude, longitude];
}

class LoadMorePackages extends PackagesEvent {
  final double latitude;
  final double longitude;
  final double radius;

  const LoadMorePackages({
    required this.latitude,
    required this.longitude,
    this.radius = 5.0,
  });

  @override
  List<Object?> get props => [latitude, longitude, radius];
}

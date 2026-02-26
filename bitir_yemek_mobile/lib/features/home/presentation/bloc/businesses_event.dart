part of 'businesses_bloc.dart';

abstract class BusinessesEvent extends Equatable {
  const BusinessesEvent();

  @override
  List<Object?> get props => [];
}

class LoadNearbyBusinesses extends BusinessesEvent {
  final double latitude;
  final double longitude;
  final double radius;

  const LoadNearbyBusinesses({
    required this.latitude,
    required this.longitude,
    this.radius = 5.0,
  });

  @override
  List<Object?> get props => [latitude, longitude, radius];
}

class LoadMoreBusinesses extends BusinessesEvent {
  final double latitude;
  final double longitude;
  final double radius;

  const LoadMoreBusinesses({
    required this.latitude,
    required this.longitude,
    this.radius = 5.0,
  });

  @override
  List<Object?> get props => [latitude, longitude, radius];
}

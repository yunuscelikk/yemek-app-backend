part of 'owner_packages_bloc.dart';

abstract class OwnerPackagesEvent extends Equatable {
  const OwnerPackagesEvent();

  @override
  List<Object?> get props => [];
}

class LoadBusinessPackages extends OwnerPackagesEvent {
  final String businessId;

  const LoadBusinessPackages({required this.businessId});

  @override
  List<Object?> get props => [businessId];
}

class DeletePackage extends OwnerPackagesEvent {
  final String packageId;

  const DeletePackage({required this.packageId});

  @override
  List<Object?> get props => [packageId];
}

class RefreshPackages extends OwnerPackagesEvent {
  const RefreshPackages();
}

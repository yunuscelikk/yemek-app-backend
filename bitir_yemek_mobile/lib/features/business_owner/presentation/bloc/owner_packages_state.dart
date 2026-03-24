part of 'owner_packages_bloc.dart';

abstract class OwnerPackagesState extends Equatable {
  const OwnerPackagesState();

  @override
  List<Object?> get props => [];
}

class OwnerPackagesInitial extends OwnerPackagesState {
  const OwnerPackagesInitial();
}

class OwnerPackagesLoading extends OwnerPackagesState {
  const OwnerPackagesLoading();
}

class OwnerPackagesLoaded extends OwnerPackagesState {
  final List<OwnerPackageModel> packages;

  const OwnerPackagesLoaded({required this.packages});

  @override
  List<Object?> get props => [packages];
}

class OwnerPackagesError extends OwnerPackagesState {
  final String message;

  const OwnerPackagesError({required this.message});

  @override
  List<Object?> get props => [message];
}

class PackageDeleted extends OwnerPackagesState {
  const PackageDeleted();
}

class PackageDeleteError extends OwnerPackagesState {
  final String message;

  const PackageDeleteError({required this.message});

  @override
  List<Object?> get props => [message];
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/owner_package_model.dart';
import '../../domain/repositories/business_owner_repository.dart';

part 'owner_packages_event.dart';
part 'owner_packages_state.dart';

class OwnerPackagesBloc extends Bloc<OwnerPackagesEvent, OwnerPackagesState> {
  final BusinessOwnerRepository _repository;
  String? _currentBusinessId;

  OwnerPackagesBloc({required BusinessOwnerRepository repository})
    : _repository = repository,
      super(OwnerPackagesInitial()) {
    on<LoadBusinessPackages>(_onLoadBusinessPackages);
    on<DeletePackage>(_onDeletePackage);
    on<RefreshPackages>(_onRefreshPackages);
  }

  Future<void> _onLoadBusinessPackages(
    LoadBusinessPackages event,
    Emitter<OwnerPackagesState> emit,
  ) async {
    _currentBusinessId = event.businessId;
    emit(OwnerPackagesLoading());
    try {
      final packages = await _repository.getBusinessPackages(event.businessId);
      emit(OwnerPackagesLoaded(packages: packages));
    } catch (e) {
      emit(OwnerPackagesError(message: e.toString()));
    }
  }

  Future<void> _onDeletePackage(
    DeletePackage event,
    Emitter<OwnerPackagesState> emit,
  ) async {
    try {
      await _repository.deletePackage(event.packageId);
      emit(PackageDeleted());
      // Reload packages after deletion
      if (_currentBusinessId != null) {
        final packages = await _repository.getBusinessPackages(
          _currentBusinessId!,
        );
        emit(OwnerPackagesLoaded(packages: packages));
      }
    } catch (e) {
      emit(PackageDeleteError(message: e.toString()));
      // Restore loaded state if we had one
      if (_currentBusinessId != null) {
        try {
          final packages = await _repository.getBusinessPackages(
            _currentBusinessId!,
          );
          emit(OwnerPackagesLoaded(packages: packages));
        } catch (_) {}
      }
    }
  }

  Future<void> _onRefreshPackages(
    RefreshPackages event,
    Emitter<OwnerPackagesState> emit,
  ) async {
    if (_currentBusinessId == null) return;
    emit(OwnerPackagesLoading());
    try {
      final packages = await _repository.getBusinessPackages(
        _currentBusinessId!,
      );
      emit(OwnerPackagesLoaded(packages: packages));
    } catch (e) {
      emit(OwnerPackagesError(message: e.toString()));
    }
  }
}

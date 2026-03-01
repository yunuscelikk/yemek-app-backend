part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoritesEvent {
  const LoadFavorites();
}

class LoadMoreFavorites extends FavoritesEvent {
  const LoadMoreFavorites();
}

class RefreshFavorites extends FavoritesEvent {
  const RefreshFavorites();
}

class RemoveFavorite extends FavoritesEvent {
  final String businessId;

  const RemoveFavorite({required this.businessId});

  @override
  List<Object?> get props => [businessId];
}

class ToggleFavorite extends FavoritesEvent {
  final String businessId;

  const ToggleFavorite({required this.businessId});

  @override
  List<Object?> get props => [businessId];
}

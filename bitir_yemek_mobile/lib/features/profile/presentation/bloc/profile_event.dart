part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String? name;
  final String? phone;

  const UpdateProfile({this.name, this.phone});

  @override
  List<Object?> get props => [name, phone];
}

class ProfileLogoutRequested extends ProfileEvent {}

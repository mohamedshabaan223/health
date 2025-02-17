import 'package:health_app/models/user_profile.dart';

abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileSuccess extends UserProfileState {
  final UserProfile userProfile;

  UserProfileSuccess(this.userProfile);
}

class UserProfileFailure extends UserProfileState {
  final String error;

  UserProfileFailure(this.error);
}

class UpdateProfileLoading extends UserProfileState {}

class UpdateProfileSuccess extends UserProfileState {}

class UpdateProfileFailure extends UserProfileState {
  final String errorMessage;

  UpdateProfileFailure({required this.errorMessage});
}

class ChangePasswordLoading extends UserProfileState {}

class ChangePasswordSuccess extends UserProfileState {}

class ChangePasswordFailure extends UserProfileState {
  final String errorMessage;

  ChangePasswordFailure({required this.errorMessage});
}

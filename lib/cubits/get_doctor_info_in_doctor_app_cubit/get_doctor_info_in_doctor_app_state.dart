part of 'get_doctor_info_in_doctor_app_cubit.dart';

@immutable
sealed class GetDoctorInfoInDoctorAppState {}

final class GetDoctorInfoInDoctorAppInitial
    extends GetDoctorInfoInDoctorAppState {}

final class GetDoctorInfoInDoctorAppLoading
    extends GetDoctorInfoInDoctorAppState {}

final class GetDoctorInfoInDoctorAppSuccess
    extends GetDoctorInfoInDoctorAppState {
  final GetDoctorInfoById getInfo;
  GetDoctorInfoInDoctorAppSuccess(this.getInfo);
}

final class GetDoctorInfoInDoctorAppFailuer
    extends GetDoctorInfoInDoctorAppState {
  final String errorMessage;

  GetDoctorInfoInDoctorAppFailuer({required this.errorMessage});
}

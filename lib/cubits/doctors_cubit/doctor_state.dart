part of 'doctor_cubit.dart';

@immutable
sealed class DoctorState {}

final class DoctorInitial extends DoctorState {}

final class DoctorLoading extends DoctorState {}

final class DoctorSuccess extends DoctorState {
  final List<DoctorModel> doctorsList;

  DoctorSuccess(this.doctorsList);
}

final class DoctorFailure extends DoctorState {
  final String errorMessage;

  DoctorFailure({required this.errorMessage});
}

final class GetDoctorInfoSuccess extends DoctorState {
  final GetDoctorInfoById doctorInfo;

  GetDoctorInfoSuccess(this.doctorInfo);
}

final class GetDoctorInfoFailure extends DoctorState {
  final String errorMessage;

  GetDoctorInfoFailure({required this.errorMessage});
}

final class GetDoctorInfoLoading extends DoctorState {}

final class GetDoctorBySpecializationLoading extends DoctorState {}

final class GetDoctorBySpecializationSuccess extends DoctorState {
  final List<GetDoctorBySpecialization> doctorsList;

  GetDoctorBySpecializationSuccess(this.doctorsList);
}

final class GetDoctorBySpecializationFailure extends DoctorState {
  final String errorMessage;

  GetDoctorBySpecializationFailure({required this.errorMessage});
}

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

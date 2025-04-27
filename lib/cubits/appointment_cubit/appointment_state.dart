part of 'appointment_cubit.dart';

@immutable
abstract class AppointmentState {}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {}

class AppointmentSuccess extends AppointmentState {
  final String message;
  AppointmentSuccess(this.message);
}

class AppointmentFailure extends AppointmentState {
  final String errorMessage;
  AppointmentFailure(this.errorMessage);
}

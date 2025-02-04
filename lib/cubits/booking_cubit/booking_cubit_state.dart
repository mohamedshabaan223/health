part of 'booking_cubit_cubit.dart';

@immutable
sealed class BookingCubitState {}

final class BookingCubitInitial extends BookingCubitState {}

final class BookingCubitLoading extends BookingCubitState {}

final class BookingCubitSuccess extends BookingCubitState {
  final List<AppointmentDisplayDoctorData> timeslots;

  BookingCubitSuccess(this.timeslots);
}

final class BookingCubitError extends BookingCubitState {
  final String errormessage;

  BookingCubitError(this.errormessage);
}

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

class BookingCubitDataLoading extends BookingCubitState {}

class BookingCubitDataSuccess extends BookingCubitState {
  final BookingResponse bookingResponse;
  BookingCubitDataSuccess(this.bookingResponse);
}

class BookingCubitDataError extends BookingCubitState {
  final String message;
  BookingCubitDataError(this.message);
}

final class BookingCubitGetAllLoading extends BookingCubitState {}

final class BookingCubitGetAllSuccess extends BookingCubitState {
  final List<GetAllBooking> bookings;

  BookingCubitGetAllSuccess(this.bookings);
}

final class BookingCubitGetAllAppointmentSuccess extends BookingCubitState {
  final List<AllAppoinementModel> bookings;

  BookingCubitGetAllAppointmentSuccess(this.bookings);
}

final class BookingCubitGetAllError extends BookingCubitState {
  final String errormessage;

  BookingCubitGetAllError(this.errormessage);
}

class BookingCubitSuccessUpdate extends BookingCubitState {
  final String message;

  BookingCubitSuccessUpdate(this.message);
}

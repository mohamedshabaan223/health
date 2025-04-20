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

final class BookingCubitDataLoading extends BookingCubitState {}

class BookingCubitDataSuccess extends BookingCubitState {
  final BookingResponse bookingResponse;
  BookingCubitDataSuccess(this.bookingResponse);
}

class BookingCubitDataError extends BookingCubitState {
  final String message;
  BookingCubitDataError(this.message);
}

final class BookingCubitGetAllSuccess extends BookingCubitState {
  final List<GetAllBooking> bookings;

  BookingCubitGetAllSuccess(this.bookings);
}

final class BookingCubitGetAllError extends BookingCubitState {
  final String errormessage;

  BookingCubitGetAllError(this.errormessage);
}

class BookingCubitSuccessUpdate extends BookingCubitState {
  final String message;

  BookingCubitSuccessUpdate(this.message);
}

class BookingDoctorCompletedLoading extends BookingCubitState {}

class BookingDoctorCompletedSuccess extends BookingCubitState {
  final List<AllAppointmentsPatientForDoctor> bookings;

  BookingDoctorCompletedSuccess(this.bookings);
}

class BookingDoctorCompletedError extends BookingCubitState {
  final String message;

  BookingDoctorCompletedError(this.message);
}

class BookingCubitBookingDetailsSuccess extends BookingCubitState {
  final BookingDetailsModel bookingDetails;
  BookingCubitBookingDetailsSuccess(this.bookingDetails);
}

class BookingCubitCancelSuccess extends BookingCubitState {
  final String message;
  BookingCubitCancelSuccess(this.message);
}

class BookingCubitAllCanceledSuccess extends BookingCubitState {
  final List<CanceledBookingModel> canceledBookings;
  BookingCubitAllCanceledSuccess(this.canceledBookings);
}

class BookingCubitAllCanceledEmpty extends BookingCubitState {
  final String message;
  BookingCubitAllCanceledEmpty(this.message);
}

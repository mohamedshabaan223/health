part of 'location_cubit.dart';

abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationSuccess extends LocationState {}

class LocationError extends LocationState {
  final String message;
  LocationError(this.message);
}

class NearbyDoctorsLoaded extends LocationState {
  final List<DoctorModelForNearByDoctor> doctors;
  NearbyDoctorsLoaded(this.doctors);
}

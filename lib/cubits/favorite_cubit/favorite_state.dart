abstract class FavoriteDoctorState {}

class FavoriteDoctorInitial extends FavoriteDoctorState {}

class FavoriteDoctorLoading extends FavoriteDoctorState {}

class FavoriteDoctorSuccess extends FavoriteDoctorState {
  final String message;
  int doctorid;
  FavoriteDoctorSuccess({required this.doctorid, required this.message});
}

class FavoriteDoctorAlreadyExists extends FavoriteDoctorState {
  final String message;
  int doctorid;
  FavoriteDoctorAlreadyExists({required this.doctorid, required this.message});
}

class FavoriteDoctorFailure extends FavoriteDoctorState {
  final String errorMessage;
  FavoriteDoctorFailure({required this.errorMessage});
}

class FavoriteDoctorRemoved extends FavoriteDoctorState {
  final String message;
  int doctorid;
  FavoriteDoctorRemoved({required this.doctorid, required this.message});
}

class FavoriteDoctorLoaded extends FavoriteDoctorState {
  final Map<int, bool> favoriteDoctors;

  FavoriteDoctorLoaded(this.favoriteDoctors);
}

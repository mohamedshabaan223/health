import 'package:health_app/models/specializations_model.dart';

abstract class SpecialityState {}

class SpecialityInitial extends SpecialityState {}

class SpecialityLoading extends SpecialityState {}

class SpecialitySuccess extends SpecialityState {
  final List<SpecializationModel> specializations;

  SpecialitySuccess(this.specializations);
}

class SpecialityFailure extends SpecialityState {
  final String errorMessage;

  SpecialityFailure({required this.errorMessage});
}

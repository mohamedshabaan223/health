import 'package:bloc/bloc.dart';
import 'package:health_app/core/api/api_consumer.dart';
import 'package:health_app/core/api/end_points.dart';
import 'package:health_app/core/errors/exceptions.dart';
import 'package:health_app/cubits/specializations_cubit/specializations_state.dart';
import 'package:health_app/models/specializations_model.dart';

class SpecializationsCubit extends Cubit<SpecialityState> {
  final ApiConsumer api;

  SpecializationsCubit(this.api) : super(SpecialityInitial());
  Future<void> getAllSpecializations() async {
    try {
      emit(SpecialityLoading());
      final response = await api.get(EndPoints.allSpecialities);

      final List<dynamic> data = response;
      final List<SpecializationModel> specializations =
          data.map((json) => SpecializationModel.fromJson(json)).toList();

      emit(SpecialitySuccess(specializations));
    } on ServerException catch (e) {
      emit(SpecialityFailure(errorMessage: e.errorModel.errorMessage));
    } catch (e) {
      emit(SpecialityFailure(errorMessage: "Unexpected error occurred: $e"));
    }
  }
}

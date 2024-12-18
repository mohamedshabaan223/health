import 'package:bloc/bloc.dart';
import 'package:health_app/core/api/api_consumer.dart';
import 'package:health_app/core/api/end_points.dart';
import 'package:health_app/core/errors/exceptions.dart';
import 'package:health_app/models/doctor_model.dart';
import 'package:meta/meta.dart';

part 'doctor_state.dart';

class DoctorCubit extends Cubit<DoctorState> {
  final ApiConsumer api;
  DoctorCubit(this.api) : super(DoctorInitial());

  Future<void> getAllDoctorsByOrderType({String orderType = "ASC"}) async {
    try {
      emit(DoctorLoading());
      final response = await api.get(
        EndPoints.getAllDoctors,
        queryParameters: {"OrderType": orderType},
      );

      final List<dynamic> data = response;
      final doctors = data.map((json) => DoctorModel.fromJson(json)).toList();

      emit(DoctorSuccess(doctors));
    } on ServerException catch (e) {
      print(
          "Error caught in getAllDoctorsByOrderType: ${e.errorModel.errorMessage}");
      emit(DoctorFailure(errorMessage: e.errorModel.errorMessage));
    } catch (e) {
      print("Unexpected error in getAllDoctorsByOrderType: $e");
      emit(DoctorFailure(errorMessage: "Unexpected error occurred: $e"));
    }
  }

  Future<void> getDoctorsByGender({required String gender}) async {
    try {
      emit(DoctorLoading());
      final response = await api.get(
        EndPoints.getAllDoctors,
        queryParameters: {
          'Gender': gender,
        },
      );
      final List<DoctorModel> doctors = List<DoctorModel>.from(
        response.map((doctor) => DoctorModel.fromJson(doctor)),
      );
      emit(DoctorSuccess(doctors));
    } on ServerException catch (e) {
      print("Error caught in getDoctorsByGender: ${e.errorModel.errorMessage}");
      emit(DoctorFailure(
        errorMessage: e.errorModel.errorMessage,
      ));
    } catch (e) {
      print("Unexpected error in getDoctorsByGender: $e");
      emit(DoctorFailure(errorMessage: "Unexpected error occurred: $e"));
    }
  }
}

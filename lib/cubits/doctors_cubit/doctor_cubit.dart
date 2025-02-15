import 'package:bloc/bloc.dart';
import 'package:health_app/core/api/api_consumer.dart';
import 'package:health_app/core/api/end_points.dart';
import 'package:health_app/core/errors/exceptions.dart';
import 'package:health_app/models/doctor_model.dart';
import 'package:health_app/models/get_doctor_based_on_specialization.dart';
import 'package:health_app/models/get_doctor_info_by_id.dart';
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
      emit(DoctorFailure(errorMessage: e.errorModel.errorMessage));
    } catch (e) {
      emit(DoctorFailure(errorMessage: "Unexpected error occurred: $e"));
    }
  }

  Future<void> getDoctorsByGender({required String gender}) async {
    try {
      emit(DoctorLoading());
      final response = await api.get(
        EndPoints.getAllDoctors,
        queryParameters: {'Gender': gender},
      );
      final List<DoctorModel> doctors = List<DoctorModel>.from(
        response.map((doctor) => DoctorModel.fromJson(doctor)),
      );
      emit(DoctorSuccess(doctors));
    } on ServerException catch (e) {
      emit(DoctorFailure(errorMessage: e.errorModel.errorMessage));
    } catch (e) {
      emit(DoctorFailure(errorMessage: "Unexpected error occurred: $e"));
    }
  }

  Future<void> getDoctorById({required int doctorId}) async {
    try {
      emit(GetDoctorInfoLoading());

      final response =
          await api.get("http://10.0.2.2:5282/GetDoctorDetails/$doctorId");

      final doctorInfo = GetDoctorInfoById.fromJson(response);

      emit(GetDoctorInfoSuccess(doctorInfo));
    } on ServerException catch (e) {
      emit(GetDoctorInfoFailure(errorMessage: e.errorModel.errorMessage));
    } catch (e) {
      emit(GetDoctorInfoFailure(errorMessage: "Unexpected error occurred: $e"));
    }
  }

  void searchDoctorByName(String query) {
    final filteredDoctors = (state as DoctorSuccess)
        .doctorsList
        .where((doctor) =>
            doctor.doctorName!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    emit(DoctorSuccess(filteredDoctors));
  }

  Future<void> getDoctorsBySpecialization(
      {required int specializationId}) async {
    try {
      emit(GetDoctorBySpecializationLoading());

      final response = await api.get(
        "http://10.0.2.2:5282/Api/V1/Specialization/GetDoctorsBySpecializationID",
        queryParameters: {"specializationId": specializationId},
      );

      final List<GetDoctorBySpecialization> doctors =
          List<GetDoctorBySpecialization>.from(
        response.map((doctor) => GetDoctorBySpecialization.fromJson(doctor)),
      );

      emit(GetDoctorBySpecializationSuccess(doctors));
    } on ServerException catch (e) {
      emit(GetDoctorBySpecializationFailure(
          errorMessage: e.errorModel.errorMessage));
    } catch (e) {
      emit(GetDoctorBySpecializationFailure(
          errorMessage: "Unexpected error occurred: $e"));
    }
  }

  Future<void> addDoctorToFavorites({
    required int doctorId,
    required int patientId,
  }) async {
    try {
      emit(AddFavoriteDoctorLoading());

      final response = await api.post(
        "http://10.0.2.2:5282/Api/V1/Doctors/AddFavoriteDR",
        data: {
          'doctorId': doctorId,
          'patientId': patientId,
        },
      );

      if (response.statusCode == 200 &&
          response.data == "Doctor added to favorites.") {
        emit(AddFavoriteDoctorSuccess());
      } else if (response.statusCode == 400 ||
          response.data == "Doctor already added to favorites") {
        emit(AddFavoriteDoctorFailure(
            errorMessage: "هذا الطبيب موجود بالفعل في المفضلة ⭐"));
      } else {
        emit(AddFavoriteDoctorFailure(
            errorMessage: "فشل في إضافة الطبيب إلى المفضلة ❌"));
      }
    } on ServerException catch (e) {
      emit(AddFavoriteDoctorFailure(errorMessage: e.errorModel.errorMessage));
    } catch (e) {
      emit(AddFavoriteDoctorFailure(errorMessage: "حدث خطأ غير متوقع: $e"));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/core/api/api_consumer.dart';
import 'package:health_app/core/api/end_points.dart';
import 'package:health_app/cubits/favorite_cubit/favorite_state.dart';
import 'package:health_app/models/doctor_model.dart';

class FavoriteDoctorCubit extends Cubit<FavoriteDoctorState> {
  FavoriteDoctorCubit(this.api) : super(FavoriteDoctorInitial());

  final ApiConsumer api;
  final Map<int, bool> favoriteDoctors = {};

  Future<void> getAllDoctorsInFavorites({required int patientId}) async {
    try {
      emit(FavoriteDoctorLoading());

      final response = await api.get(
        "http://10.0.2.2:5282/Api/V1/Doctors/GetAllDoctors",
        queryParameters: {"PatientId": patientId},
      );

      final List<dynamic> data = response;
      final List<DoctorModel> doctors =
          data.map((json) => DoctorModel.fromJson(json)).toList();

      final newFavorites = {for (var doctor in doctors) doctor.id ?? 0: true};

      if (favoriteDoctors != newFavorites) {
        favoriteDoctors.clear();
        favoriteDoctors.addAll(newFavorites);
        emit(GetAllDoctorsFavoriteSuccess(doctors: doctors));
      }
    } catch (e) {
      emit(FavoriteDoctorFailure(errorMessage: "Unexpected error: $e"));
    }
  }

  Future<void> addFavoriteDoctor({
    required int patientId,
    required int doctorId,
  }) async {
    try {
      emit(FavoriteDoctorLoading());

      final response = await api.post(
        EndPoints.addFavoriteDoctor,
        data: {"patientId": patientId, "doctorId": doctorId},
      );

      if (response == "Doctor added to favorites.") {
        favoriteDoctors[doctorId] = true;

        List<int> favoriteList =
            CacheHelper().getList(key: "favoriteDoctors") ?? [];
        if (!favoriteList.contains(doctorId)) {
          favoriteList.add(doctorId);
          await CacheHelper()
              .saveList(key: "favoriteDoctors", value: favoriteList);
        }

        emit(FavoriteDoctorLoaded(Map.from(favoriteDoctors)));
      } else {
        emit(FavoriteDoctorFailure(errorMessage: "Unexpected response"));
      }
    } catch (e) {
      emit(FavoriteDoctorFailure(errorMessage: "Unexpected error: $e"));
    }
  }

  Future<void> removeFavoriteDoctor({
    required int patientId,
    required int doctorId,
  }) async {
    try {
      emit(FavoriteDoctorLoading());

      final response = await api.delete(
        EndPoints.removeFavoriteDoctor,
        data: {"patientId": patientId, "doctorId": doctorId},
      );

      if (response == true) {
        favoriteDoctors.remove(doctorId);

        List<int> favoriteList =
            CacheHelper().getList(key: "favoriteDoctors") ?? [];
        if (favoriteList.contains(doctorId)) {
          favoriteList.remove(doctorId);
          await CacheHelper()
              .saveList(key: "favoriteDoctors", value: favoriteList);
        }

        emit(FavoriteDoctorLoaded(Map.from(favoriteDoctors)));
      } else {
        emit(FavoriteDoctorFailure(
            errorMessage: "تعذر إزالة الطبيب من المفضلة."));
      }
    } catch (e) {
      emit(FavoriteDoctorFailure(errorMessage: "Unexpected error: $e"));
    }
  }

  bool isDoctorFavorite(int doctorId) {
    return favoriteDoctors[doctorId] ?? false;
  }

  void resetState() {
    emit(FavoriteDoctorInitial());
  }
}

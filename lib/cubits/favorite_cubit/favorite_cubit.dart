import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/core/api/api_consumer.dart';
import 'package:health_app/core/api/end_points.dart';
import 'package:health_app/cubits/favorite_cubit/favorite_state.dart';

class FavoriteDoctorCubit extends Cubit<FavoriteDoctorState> {
  FavoriteDoctorCubit(this.api) : super(FavoriteDoctorInitial()) {
    loadFavorites();
  }

  final ApiConsumer api;
  final Map<int, bool> favoriteDoctors = {};

  void loadFavorites() {
    final List<int> favoriteList =
        CacheHelper().getList(key: "favoriteDoctors");
    debugPrint("Loaded favorites from cache before processing: $favoriteList");
    favoriteDoctors.clear();
    for (var id in favoriteList) {
      favoriteDoctors[id] = true;
    }
    debugPrint("Final favoriteDoctors Map: $favoriteDoctors");
    emit(FavoriteDoctorLoaded(Map.from(favoriteDoctors)));
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
        List<int> favoriteList = CacheHelper().getList(key: "favoriteDoctors");
        if (!favoriteList.contains(doctorId)) {
          favoriteList.add(doctorId);
          await CacheHelper()
              .saveList(key: "favoriteDoctors", value: favoriteList);
        }
        debugPrint(
            "Saved favorites in cache: ${CacheHelper().getList(key: "favoriteDoctors")}");
        emit(FavoriteDoctorLoaded(Map.from(favoriteDoctors)));
      } else {
        emit(FavoriteDoctorFailure(errorMessage: "Unexpected response"));
      }
    } catch (e) {
      emit(FavoriteDoctorFailure(errorMessage: "Unexpected error: $e"));
    }
  }

  void testCacheHelper() {
    final storedFavorites = CacheHelper().getList(key: "favoriteDoctors");
    debugPrint("Directly fetching from CacheHelper: $storedFavorites");
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
        List<int> favoriteList = CacheHelper().getList(key: "favoriteDoctors");
        favoriteList.remove(doctorId);
        await CacheHelper()
            .saveList(key: "favoriteDoctors", value: favoriteList);
        debugPrint(
            "Favorites after remove operation: ${CacheHelper().getList(key: "favoriteDoctors")}");
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
    return favoriteDoctors.containsKey(doctorId) &&
        favoriteDoctors[doctorId] == true;
  }
}

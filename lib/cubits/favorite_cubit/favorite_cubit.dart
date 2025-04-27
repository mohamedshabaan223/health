import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/core/api/api_consumer.dart';
import 'package:health_app/core/api/end_points.dart';
import 'package:health_app/cubits/favorite_cubit/favorite_state.dart';
import 'package:health_app/models/doctor_model.dart';
import 'package:path_provider/path_provider.dart';

class FavoriteDoctorCubit extends Cubit<FavoriteDoctorState> {
  FavoriteDoctorCubit(this.api) : super(FavoriteDoctorInitial());

  final ApiConsumer api;
  final Map<int, bool> favoriteDoctors = {};
  String doctorfavoriteimagepath = "";

  // تعديل دالة حفظ الصورة لتقبل doctorId
  Future<File> saveDoctorProfileImage(String base64String, int doctorId) async {
    try {
      final String base64Data = base64String.split(',').last;
      Uint8List bytes = base64Decode(base64Data);

      final directory = await getApplicationDocumentsDirectory();
      final String filePath =
          '${directory.path}/doctor_favorite_image_$doctorId.png';

      final File file = File(filePath);
      await file.writeAsBytes(bytes);

      print("Doctor Image saved at: $filePath");
      return file;
    } catch (e) {
      print("Failed to save doctor image: $e");
      rethrow;
    }
  }

  // تعديل دالة getAllDoctorsInFavorites لحفظ الصور
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

      // هنا هنتأكد نحفظ الصورة لو موجودة
      for (var doctor in doctors) {
        if (doctor.photo != null && doctor.photo!.isNotEmpty) {
          try {
            File savedFile =
                await saveDoctorProfileImage(doctor.photo!, doctor.id ?? 0);
            doctor.localImagePath = savedFile.path;
          } catch (e) {
            print("Failed to process doctor image: $e");
          }
        }
      }

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
            errorMessage: "Failed to remove favorite doctor"));
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

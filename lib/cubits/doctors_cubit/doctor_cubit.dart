import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:health_app/core/api/api_consumer.dart';
import 'package:health_app/core/api/end_points.dart';
import 'package:health_app/core/errors/exceptions.dart';
import 'package:health_app/models/doctor_model.dart';
import 'package:health_app/models/get_doctor_based_on_specialization.dart';
import 'package:health_app/models/get_doctor_info_by_id.dart';
import 'package:path_provider/path_provider.dart';
part 'doctor_state.dart';

class DoctorCubit extends Cubit<DoctorState> {
  final ApiConsumer api;
  bool _isRequestInProgress = false;

  DoctorCubit(this.api) : super(DoctorInitial());

  Future<File> saveDoctorProfileImage(
      String base64String, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/$fileName.png';
      final File file = File(filePath);
      final String metaPath = '${directory.path}/$fileName.txt';

      final String base64Data = base64String.split(',').last;
      String cleanedBase64 =
          base64Data.replaceAll(RegExp(r'[^A-Za-z0-9+/=]'), '');
      String paddedBase64 = cleanedBase64;
      while (paddedBase64.length % 4 != 0) {
        paddedBase64 += "=";
      }
      if (await file.exists() && await File(metaPath).exists()) {
        final oldBase64 = await File(metaPath).readAsString();
        if (oldBase64 == paddedBase64) {
          log("Image already exists and is the same. Skipping save.");
          return file;
        }
      }

      Uint8List bytes = base64Decode(paddedBase64);
      await file.writeAsBytes(bytes);
      await File(metaPath).writeAsString(paddedBase64);
      log("Image saved at: $filePath");
      return file;
    } catch (e) {
      log("Failed to save image: $e");
      rethrow;
    }
  }

  Future<void> getDoctorById({required int doctorId}) async {
    if (_isRequestInProgress) return;

    _isRequestInProgress = true;

    if (state is GetDoctorInfoLoading) {
      return;
    }

    emit(GetDoctorInfoLoading());
    log('State changed: $state');

    try {
      final response = await api.get(
          "http://medicalservicesproject.runasp.net/GetDoctorDetails/$doctorId");
      final doctorInfo = GetDoctorInfoById.fromJson(response);
      if (doctorInfo.profileImage != null &&
          doctorInfo.profileImage!.isNotEmpty) {
        try {
          File savedFile = await saveDoctorProfileImage(
              doctorInfo.profileImage!, 'doctor_$doctorId');
          doctorInfo.localImagePath = savedFile.path;
        } catch (e) {
          log("Failed to process doctor image: $e");
          emit(GetDoctorInfoFailure(errorMessage: "Failed to process image"));
          log('State changed: $state');

          return;
        }
      }
      emit(GetDoctorInfoSuccess(doctorInfo));
      log('State changed: $state');
    } on ServerException catch (e) {
      emit(GetDoctorInfoFailure(errorMessage: e.errorModel.errorMessage));
      log('State changed: $state');
    } catch (e) {
      emit(GetDoctorInfoFailure(errorMessage: "Unexpected error occurred: $e"));
      log('State changed: $state');
    } finally {
      _isRequestInProgress = false;
    }
  }

  Future<void> getAllDoctorsByOrderType({String orderType = "ASC"}) async {
    try {
      emit(DoctorLoading());

      final response = await api.get(
        EndPoints.getAllDoctors,
        queryParameters: {"OrderType": orderType},
      );

      final List<dynamic> data = response;
      log("Response Data: $data");

      final doctors = data.map((json) {
        log("Doctor JSON: $json");
        return DoctorModel.fromJson(json);
      }).toList();
      for (var doctor in doctors) {
        if (doctor.photo != null && (doctor.phone?.isNotEmpty ?? false)) {
          try {
            File savedFile = await saveDoctorProfileImage(
                doctor.photo!, 'doctor_${doctor.id}');
            doctor.localImagePath = savedFile.path;
          } catch (e) {
            log("Failed to process doctor image: $e");
          }
        }
      }

      emit(DoctorSuccess(doctors));
    } on ServerException catch (e) {
      emit(DoctorFailure(errorMessage: e.errorModel.errorMessage));
    } catch (e) {
      emit(DoctorFailure(errorMessage: "Unexpected error occurred: $e"));
    }
  }

  Future<void> getAllDoctorsByTopRating() async {
    try {
      emit(DoctorLoading());

      final response = await api.get(EndPoints.getAllDoctors);
      final List<dynamic> data = response;
      final doctors = data.map((json) => DoctorModel.fromJson(json)).toList();
      final filteredDoctors =
          doctors.where((doc) => doc.rating >= 3 && doc.rating <= 5).toList();

      for (var doctor in filteredDoctors) {
        if (doctor.photo != null && doctor.photo!.isNotEmpty) {
          try {
            File savedFile = await saveDoctorProfileImage(
                doctor.photo!, 'doctor_${doctor.id}');
            doctor.localImagePath = savedFile.path;
          } catch (e) {
            log("Failed to process doctor image: $e");
          }
        }
      }

      emit(DoctorSuccess(filteredDoctors));
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
      for (var doctor in doctors) {
        if (doctor.photo != null && doctor.photo!.isNotEmpty) {
          try {
            File savedFile = await saveDoctorProfileImage(
                doctor.photo!, 'doctor_${doctor.id}');
            doctor.localImagePath = savedFile.path;
          } catch (e) {
            log("Failed to process doctor image: $e");
          }
        }
      }

      emit(DoctorSuccess(doctors));
    } on ServerException catch (e) {
      emit(DoctorFailure(errorMessage: e.errorModel.errorMessage));
    } catch (e) {
      emit(DoctorFailure(errorMessage: "Unexpected error occurred: $e"));
    }
  }

  Future<void> getDoctorsBySpecialization(
      {required int specializationId}) async {
    try {
      emit(GetDoctorBySpecializationLoading());
      log('State changed: $state');

      final response = await api.get(
        "http://medicalservicesproject.runasp.net/Api/V1/Specialization/GetDoctorsBySpecializationID",
        queryParameters: {"specializationId": specializationId},
      );
      final List<GetDoctorBySpecialization> doctors =
          List<GetDoctorBySpecialization>.from(
        response.map((doctor) => GetDoctorBySpecialization.fromJson(doctor)),
      );
      for (var doctor in doctors) {
        if (doctor.photo != null && doctor.photo!.isNotEmpty) {
          try {
            File savedFile = await saveDoctorProfileImage(
                doctor.photo!, 'doctor_${doctor.id}');
            doctor.localImagePath = savedFile.path;
          } catch (e) {
            log("Failed to process doctor image: $e");
          }
        }
      }
      emit(GetDoctorBySpecializationSuccess(doctors, specializationId));
      log('State changed: $state');
    } on ServerException catch (e) {
      emit(GetDoctorBySpecializationFailure(
          errorMessage: e.errorModel.errorMessage));
      log('State changed: $state');
    } catch (e) {
      emit(GetDoctorBySpecializationFailure(
          errorMessage: "Unexpected error occurred: $e"));
      log('State changed: $state');
    }
  }

  void resetState() {
    emit(DoctorInitial());
  }
}

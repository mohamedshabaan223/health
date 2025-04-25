import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
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
  DoctorCubit(this.api) : super(DoctorInitial());

  // حفظ مسار الصورة للطبيب
  String doctorProfilePhotoPath = "";

  // طريقة لحفظ الصورة بعد فك تشفير base64
  Future<File> saveDoctorProfileImage(String base64String) async {
    try {
      final String base64Data = base64String.split(',').last;
      Uint8List bytes = base64Decode(base64Data);

      final directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/doctor_profile_image.png';

      final File file = File(filePath);
      await file.writeAsBytes(bytes);

      print("Doctor Image saved at: $filePath");
      return file;
    } catch (e) {
      print("Failed to save doctor image: $e");
      rethrow;
    }
  }

  // الحصول على تفاصيل الطبيب بواسطة المعرف
  Future<void> getDoctorById({required int doctorId}) async {
    try {
      emit(GetDoctorInfoLoading());

      final response =
          await api.get("http://10.0.2.2:5282/GetDoctorDetails/$doctorId");

      final doctorInfo = GetDoctorInfoById.fromJson(response);

      if (doctorInfo.profileImage != null &&
          doctorInfo.profileImage!.isNotEmpty) {
        try {
          // حفظ الصورة من Base64
          File savedFile =
              await saveDoctorProfileImage(doctorInfo.profileImage!);
          doctorProfilePhotoPath = savedFile.path;
          emit(GetDoctorInfoSuccess(doctorInfo));
        } catch (e) {
          print("Failed to process doctor image: $e");
          emit(GetDoctorInfoFailure(errorMessage: "Failed to process image"));
        }
      } else {
        emit(GetDoctorInfoSuccess(doctorInfo)); // إذا لا توجد صورة
      }
    } on ServerException catch (e) {
      emit(GetDoctorInfoFailure(errorMessage: e.errorModel.errorMessage));
    } catch (e) {
      emit(GetDoctorInfoFailure(errorMessage: "Unexpected error occurred: $e"));
    }
  }

  // الحصول على جميع الأطباء بالترتيب
  Future<void> getAllDoctorsByOrderType({String orderType = "ASC"}) async {
    try {
      emit(DoctorLoading());

      final response = await api.get(
        EndPoints.getAllDoctors,
        queryParameters: {"OrderType": orderType},
      );

      final List<dynamic> data = response;
      print("Response Data: $data");

      final doctors = data.map((json) {
        print("Doctor JSON: $json");
        return DoctorModel.fromJson(json);
      }).toList();

      // التعامل مع صورة الطبيب هنا (إذا كانت موجودة)
      for (var doctor in doctors) {
        if (doctor.photo != null && doctor.phone!.isNotEmpty) {
          try {
            File savedFile = await saveDoctorProfileImage(doctor.photo!);
            doctorProfilePhotoPath = savedFile.path;
          } catch (e) {
            print("Failed to process doctor image: $e");
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

  // الحصول على الأطباء بأعلى تقييم
  Future<void> getAllDoctorsByTopRating() async {
    try {
      emit(DoctorLoading());

      final response = await api.get(EndPoints.getAllDoctors);

      final List<dynamic> data = response;
      final doctors = data.map((json) => DoctorModel.fromJson(json)).toList();

      final filteredDoctors = doctors.where((doc) => doc.rating >= 4).toList();

      // التعامل مع الصورة
      for (var doctor in filteredDoctors) {
        if (doctor.photo != null && doctor.photo!.isNotEmpty) {
          try {
            File savedFile = await saveDoctorProfileImage(doctor.photo!);
            doctorProfilePhotoPath = savedFile.path;
          } catch (e) {
            print("Failed to process doctor image: $e");
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

  // البحث عن طبيب حسب الجنس
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

      // التعامل مع الصورة
      for (var doctor in doctors) {
        if (doctor.photo != null && doctor.photo!.isNotEmpty) {
          try {
            File savedFile = await saveDoctorProfileImage(doctor.photo!);
            doctorProfilePhotoPath = savedFile.path;
          } catch (e) {
            print("Failed to process doctor image: $e");
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

  // الحصول على الأطباء حسب التخصص
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

      // التعامل مع الصور هنا
      for (var doctor in doctors) {
        if (doctor.photo != null && doctor.photo!.isNotEmpty) {
          try {
            File savedFile = await saveDoctorProfileImage(doctor.photo!);
            doctorProfilePhotoPath = savedFile.path;
          } catch (e) {
            print("Failed to process doctor image: $e");
          }
        }
      }

      emit(GetDoctorBySpecializationSuccess(doctors));
    } on ServerException catch (e) {
      emit(GetDoctorBySpecializationFailure(
          errorMessage: e.errorModel.errorMessage));
    } catch (e) {
      emit(GetDoctorBySpecializationFailure(
          errorMessage: "Unexpected error occurred: $e"));
    }
  }

  // إعادة تعيين الحالة
  void resetState() {
    emit(DoctorInitial());
  }
}

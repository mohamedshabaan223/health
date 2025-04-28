import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:health_app/core/api/api_consumer.dart';
import 'package:health_app/core/errors/exceptions.dart';
import 'package:health_app/models/get_doctor_info_by_id.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
part 'get_doctor_info_in_doctor_app_state.dart';

class GetDoctorInfoInDoctorAppCubit
    extends Cubit<GetDoctorInfoInDoctorAppState> {
  final ApiConsumer api;

  GetDoctorInfoInDoctorAppCubit(this.api)
      : super(GetDoctorInfoInDoctorAppInitial());
  String doctorProfilePhotoPath = "";
  Future<File> saveDoctorProfileImage(String base64String) async {
    try {
      final String base64Data = base64String.split(',').last;
      String cleanedBase64 =
          base64Data.replaceAll(RegExp(r'[^A-Za-z0-9+/=]'), '');
      String paddedBase64 = cleanedBase64;
      while (paddedBase64.length % 4 != 0) {
        paddedBase64 += "=";
      }
      Uint8List bytes = base64Decode(paddedBase64);
      final directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/doctor_profile_image.png';
      final File file = File(filePath);
      await file.writeAsBytes(bytes);

      log("Profile Image saved at: $filePath");
      return file;
    } catch (e) {
      log("Failed to save image: $e");
      rethrow;
    }
  }

  Future<void> getDoctorByIdInDoctorApp({required int doctorId}) async {
    try {
      emit(GetDoctorInfoInDoctorAppLoading());

      final response =
          await api.get("http://10.0.2.2:5282/GetDoctorDetails/$doctorId");

      final doctorInfo = GetDoctorInfoById.fromJson(response);

      if (doctorInfo.profileImage != null &&
          doctorInfo.profileImage!.isNotEmpty) {
        try {
          File savedFile =
              await saveDoctorProfileImage(doctorInfo.profileImage!);
          doctorProfilePhotoPath = savedFile.path;
          emit(GetDoctorInfoInDoctorAppSuccess(doctorInfo));
        } catch (e) {
          log("Failed to process doctor image: $e");
          emit(GetDoctorInfoInDoctorAppFailuer(
              errorMessage: "Failed to process image"));
        }
      } else {
        emit(GetDoctorInfoInDoctorAppSuccess(doctorInfo));
      }
    } on ServerException catch (e) {
      emit(GetDoctorInfoInDoctorAppFailuer(
          errorMessage: e.errorModel.errorMessage));
    } catch (e) {
      emit(GetDoctorInfoInDoctorAppFailuer(
          errorMessage: "Unexpected error occurred: $e"));
    }
  }
}

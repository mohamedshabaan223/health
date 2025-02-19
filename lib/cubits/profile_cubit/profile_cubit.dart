import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health_app/core/api/api_consumer.dart';
import 'package:health_app/core/api/end_points.dart';
import 'package:health_app/cubits/profile_cubit/profile_state.dart';
import 'package:health_app/models/user_profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final ApiConsumer api;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  UserProfileCubit(this.api) : super(UserProfileInitial());

  String profilePhotoPath = "";

  Future<void> fetchUserProfile(int patientId) async {
    try {
      emit(UserProfileLoading());
      final response = await api.get(
        EndPoints.getUserProfile,
        queryParameters: {"id": patientId},
      );

      final UserProfile userProfile = UserProfile.fromJson(response);

      if (userProfile.photoData != null && userProfile.photoData!.isNotEmpty) {
        try {
          File savedFile = await saveBase64Image(userProfile.photoData!);
          profilePhotoPath = savedFile.path;
          emit(UserProfileSuccess(userProfile));
        } catch (e) {
          print("Failed to process image: $e");
        }
      } else {
        emit(UserProfileSuccess(userProfile));
      }
    } catch (e) {
      print("Unexpected error in getUserProfile: $e");
      emit(UserProfileFailure("Unexpected error occurred: $e"));
    }
  }

  Future<File> saveBase64Image(String base64String) async {
    try {
      final String base64Data = base64String.split(',').last;
      Uint8List bytes = base64Decode(base64Data);

      final directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/profile_image.png';

      final File file = File(filePath);
      await file.writeAsBytes(bytes);

      print("Image saved at: $filePath");
      return file;
    } catch (e) {
      print("Failed to save image: $e");
      rethrow;
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profilePhotoPath = pickedFile.path;
      print("New Image Path: $profilePhotoPath");
      emit(ProfilePhotoUpdated(profilePhotoPath: profilePhotoPath));
    }
  }

  Future<void> updateProfile(int userId) async {
    try {
      emit(UpdateProfileLoading());
      FormData formData = FormData.fromMap({
        "name": nameController.text,
        "email": emailController.text,
        "password": passwordController.text,
        "phone": phoneController.text,
        if (profilePhotoPath.isNotEmpty)
          "photo": await MultipartFile.fromFile(profilePhotoPath,
              filename: "profile.jpg"),
      });

      final response = await api.put(
        '${EndPoints.updateUserProfile}?id=$userId',
        data: formData,
      );

      emit(UpdateProfileSuccess());
    } on DioException catch (e) {
      print("Error in updateProfile: ${e.response?.data}");
      emit(UpdateProfileFailure(
          errorMessage: e.response?.data ?? "An error occurred"));
    } catch (e) {
      print("Unexpected error in updateProfile: $e");
      emit(UpdateProfileFailure(errorMessage: "Unexpected error occurred: $e"));
    }
  }

  Future<void> changePassword(int userId) async {
    if (currentPasswordController.text.isEmpty) {
      emit(ChangePasswordFailure(
          errorMessage: "يرجى إدخال كلمة المرور الحالية"));
      return;
    }

    if (newPasswordController.text != confirmNewPasswordController.text) {
      emit(ChangePasswordFailure(
          errorMessage: "كلمة المرور الجديدة غير متطابقة"));
      return;
    }

    try {
      emit(ChangePasswordLoading());

      FormData formData = FormData.fromMap({
        "CurrentPassword": currentPasswordController.text,
        "NewPassword": newPasswordController.text,
        "ConfirmNewPassword": confirmNewPasswordController.text,
      });

      await api.put(
        'http://10.0.2.2:5282/change?id=$userId',
        data: formData,
      );

      emit(ChangePasswordSuccess());
    } on DioException catch (e) {
      print("Error in changePassword: ${e.response?.data}");
      emit(ChangePasswordFailure(
          errorMessage: e.response?.data ?? "حدث خطأ أثناء تغيير كلمة المرور"));
    } catch (e) {
      print("Unexpected error in changePassword: $e");
      emit(ChangePasswordFailure(errorMessage: "ادخل كلمة المرور جديدة"));
    }
  }

  void resetState() {
    emit(UserProfileInitial());
  }
}

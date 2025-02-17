import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health_app/core/api/api_consumer.dart';
import 'package:health_app/core/api/end_points.dart';
import 'package:health_app/core/errors/exceptions.dart';
import 'package:health_app/cubits/profile_cubit/profile_state.dart';
import 'package:health_app/models/user_profile.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<void> fetchUserProfile(int patientId) async {
    try {
      emit(UserProfileLoading());
      final response = await api.get(
        EndPoints.getUserProfile,
        queryParameters: {"id": patientId},
      );

      final UserProfile userProfile = UserProfile.fromJson(response);

      emit(UserProfileSuccess(userProfile));
    } on ServerException catch (e) {
      print("Error in getUserProfile: ${e.errorModel.errorMessage}");
      emit(UserProfileFailure(e.errorModel.errorMessage));
    } catch (e) {
      print("Unexpected error in getUserProfile: $e");
      emit(UserProfileFailure("Unexpected error occurred: $e"));
    }
  }

  String profilePhotoPath = "";

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      profilePhotoPath = image.path;
      print("Selected Image Path: $profilePhotoPath");
    } else {
      print("No image selected");
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
      print(
          "Updating profile with URL: ${EndPoints.updateUserProfile}?id=$userId");

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

      print("Sending password change request for user ID: $userId");

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
      emit(ChangePasswordFailure(errorMessage: "حدث خطأ غير متوقع: $e"));
    }
  }

  void resetState() {
    emit(UserProfileInitial());
  }
}

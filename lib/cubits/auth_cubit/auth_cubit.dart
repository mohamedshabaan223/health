import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/core/api/api_consumer.dart';
import 'package:health_app/core/api/end_points.dart';
import 'package:health_app/core/errors/exceptions.dart';
import 'package:health_app/models/register_model.dart';
import 'package:health_app/models/sign_in_model.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.api) : super(AuthInitial());

  final ApiConsumer api;
  GlobalKey<FormState> logInFormKey = GlobalKey();
  TextEditingController logInEmail = TextEditingController();
  TextEditingController logInPassword = TextEditingController();
  GlobalKey<FormState> registerFormKey = GlobalKey();
  TextEditingController registerUserName = TextEditingController();
  TextEditingController registerPhoneNumber = TextEditingController();
  TextEditingController registerEmail = TextEditingController();
  TextEditingController registerPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController patientName = TextEditingController();

  SignInModel? user;
  RegisterModel? registerUser;

  Future<void> logIn() async {
    try {
      emit(LoginLoading());
      print("Initiating API call for login...");
      final response = await api.post(
        'http://medicalservicesproject.runasp.net/Api/V1/Account/Login',
        data: {
          ApiKey.email: logInEmail.text,
          ApiKey.password: logInPassword.text,
        },
      );

      user = SignInModel.fromJson(response);
      final decodedToken = JwtDecoder.decode(user!.token.result);
      await CacheHelper().saveData(key: "role", value: decodedToken["role"]);
      await CacheHelper()
          .saveData(key: ApiKey.token, value: user!.token.result);
      await CacheHelper().saveData(key: "id", value: user!.id);

      emit(LoginSuccess());
    } on ServerException catch (e) {
      print("Error caught in logIn: ${e.errorModel.errorMessage}");
      emit(LoginFailure(
        errorMessage: e.errorModel.errorMessage,
      ));
    } catch (e) {
      print("Unexpected error in logIn: $e");
      emit(LoginFailure(errorMessage: "Unexpected error occurred: $e"));
    }
  }

  Future<void> register() async {
    try {
      emit(RegisterLoading());
      final response = await api.post(
        'http://medicalservicesproject.runasp.net/Api/V1/Account/Register',
        data: {
          ApiKey.username: registerUserName.text,
          ApiKey.email: registerEmail.text,
          ApiKey.password: registerPassword.text,
          ApiKey.phone: registerPhoneNumber.text,
        },
      );
      registerUser = RegisterModel.fromJson(response);
      final decodedToken = JwtDecoder.decode(registerUser!.token.result);
      await CacheHelper().saveData(key: "role", value: decodedToken["role"]);
      await CacheHelper()
          .saveData(key: ApiKey.token, value: registerUser!.token.result);
      await CacheHelper().saveData(key: "id", value: registerUser!.id);

      emit(RegisterSuccess());
    } on ServerException catch (e) {
      print("Error caught in register: ${e.errorModel.errorMessage}");
      emit(RegisterFailure(
        errorMessage: e.errorModel.errorMessage,
      ));
    } catch (e) {
      print("Unexpected error in register: $e");
      emit(RegisterFailure(errorMessage: "Unexpected error occurred: $e"));
    }
  }

  Future<void> deleteAccount() async {
    try {
      emit(DeleteAccountLoading());

      final userId = await CacheHelper().getData(key: "id");
      if (userId == null) {
        emit(DeleteAccountFailure("User ID not found in cache"));
        return;
      }

      final response = await api.delete(
        "${EndPoints.deleteAccount}?accountId=$userId",
      );

      if (response == "Account deleted successfully.") {
        emit(DeleteAccountSuccess(response));
      } else {
        emit(DeleteAccountFailure(response));
      }
    } catch (e) {
      emit(DeleteAccountFailure("Error deleting account: $e"));
    }
  }

  void resetState() {
    emit(AuthInitial());
  }
}

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health_app/core/api/api_consumer.dart';
import 'package:health_app/core/api/end_points.dart';
import 'package:health_app/core/errors/exceptions.dart';
import 'package:health_app/models/sign_in_model.dart';
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

  SignInModel? user;

  Future<void> logIn() async {
    try {
      emit(LoginLoading());
      final response = await api.post(
        EndPoints.login,
        data: {
          ApiKey.email: logInEmail.text,
          ApiKey.password: logInPassword.text,
        },
      );
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
        EndPoints.register,
        data: {
          ApiKey.email: registerEmail.text,
          ApiKey.password: registerPassword.text,
          ApiKey.username: registerUserName.text,
          ApiKey.phone: registerPhoneNumber.text,
        },
      );
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
}
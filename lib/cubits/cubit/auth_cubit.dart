import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health_app/core/api/api_consumer.dart';
import 'package:health_app/models/sign_in_model.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.api) : super(AuthInitial());

  final ApiConsumer api;
  SignInModel? user;

  void logIn({required String email, required String password}) async {}

  void register(
      {required String email,
      required String password,
      required String fullName,
      required String phoneNumber}) async {}
}

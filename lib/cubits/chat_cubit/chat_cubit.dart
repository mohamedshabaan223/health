import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:health_app/core/api/api_consumer.dart';
import 'package:health_app/core/api/end_points.dart';
import 'package:health_app/core/errors/exceptions.dart';
import 'package:health_app/cubits/chat_cubit/chat_state.dart';
import 'package:health_app/models/get_all_chats.dart';
import 'package:health_app/models/get_all_message_between_doctor_and_patient.dart';
import 'package:image_picker/image_picker.dart';

class ChatCubit extends Cubit<ChatState> {
  final ApiConsumer api;

  ChatCubit(this.api) : super(ChatInitial());

  Future<void> fetchMessages({
    required int senderId,
    required int receiverId,
  }) async {
    try {
      emit(ChatLoading());

      final response = await api.get(
        EndPoints.getAllMessages,
        queryParameters: {"senderId": senderId, "receiverId": receiverId},
      );

      if (response is List) {
        // هنا نتحقق أنه List مباشرة
        final List<GetAllMessageBetweenDoctorAndPatient> messages = response
            .map((json) => GetAllMessageBetweenDoctorAndPatient.fromJson(
                json as Map<String, dynamic>))
            .toList();

        emit(ChatSuccess(messages));
      } else {
        emit(ChatFailure("Invalid response format"));
      }
    } on ServerException catch (e) {
      print("Error in fetchMessages: ${e.errorModel.errorMessage}");
      emit(ChatFailure(e.errorModel.errorMessage));
    } catch (e) {
      print("Unexpected error in fetchMessages: $e");
      emit(ChatFailure("Unexpected error occurred: $e"));
    }
  }

  Future<void> sendMessage({
    required int senderId,
    required int receiverId,
    String? message,
    required String senderType,
    required String receiverType,
    XFile? image,
  }) async {
    try {
      if (image != null) {
        print("Image Path: ${image.path}");
        File file = File(image.path);
        if (!await file.exists()) {
          print("Error: Image file does not exist!");
          emit(ChatFailure("Selected image does not exist!"));
          return;
        }
      }

      FormData formData = FormData.fromMap({
        "senderId": senderId,
        "receiverId": receiverId,
        "message": (message == null || message.isEmpty) && image != null
            ? "📷 Image"
            : message ?? "",
        "senderType": senderType,
        "receiverType": receiverType,
        if (image != null)
          "image": await MultipartFile.fromFile(
            image.path,
            filename: image.name ?? "uploaded_image.jpg",
          ),
      });

      final response = await api.post(
        EndPoints.sendMessage,
        data: formData,
      );

      final newMessage =
          GetAllMessageBetweenDoctorAndPatient.fromJson(response);

      if (state is ChatSuccess) {
        final updatedMessages = List<GetAllMessageBetweenDoctorAndPatient>.from(
          (state as ChatSuccess).messages,
        )..add(newMessage);

        emit(ChatSuccess(updatedMessages));
      } else {
        emit(ChatSuccess([newMessage]));
      }
    } on ServerException catch (e) {
      print("Error in sendMessage: ${e.errorModel.errorMessage}");
      emit(ChatFailure(e.errorModel.errorMessage));
    } catch (e) {
      print("Unexpected error in sendMessage: $e");
      emit(ChatFailure("Unexpected error occurred: $e"));
    }
  }

  Future<void> fetchChatList({
    required int userId,
    required String userType,
  }) async {
    try {
      emit(ChatLoading());

      final response = await api.get(
        EndPoints.getAllChats,
        queryParameters: {"userId": userId, "userType": userType},
      );

      if (response is List) {
        final List<ChatSummary> chatList = response
            .map((json) => ChatSummary.fromJson(json as Map<String, dynamic>))
            .toList();

        emit(ChatListSuccess(chatList));
      } else {
        emit(ChatFailure("Invalid response format"));
      }
    } on ServerException catch (e) {
      print("Error in fetchChatList: ${e.errorModel.errorMessage}");
      emit(ChatFailure(e.errorModel.errorMessage));
    } catch (e) {
      print("Unexpected error in fetchChatList: $e");
      emit(ChatFailure("Unexpected error occurred: $e"));
    }
  }

  void resetState() {
    emit(ChatInitial());
  }
}

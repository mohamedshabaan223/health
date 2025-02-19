import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:health_app/core/api/api_consumer.dart';
import 'package:health_app/core/api/end_points.dart';
import 'package:health_app/core/errors/exceptions.dart';
import 'package:health_app/cubits/chat_cubit/chat_state.dart';
import 'package:health_app/models/get_all_chats.dart';
import 'package:health_app/models/get_all_message_between_doctor_and_patient.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ChatCubit extends Cubit<ChatState> {
  final ApiConsumer api;

  ChatCubit(this.api) : super(ChatInitial());

  Future<File> saveBase64Image(String base64String) async {
    try {
      Uint8List bytes = base64Decode(base64String);

      final directory = await getApplicationDocumentsDirectory();
      final String filePath =
          '${directory.path}/chat_image_${DateTime.now().millisecondsSinceEpoch}.png';

      final File file = File(filePath);
      await file.writeAsBytes(bytes);

      print("Image saved at: $filePath");
      return file;
    } catch (e) {
      print("Failed to save image: $e");
      rethrow;
    }
  }

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
        final List<GetAllMessageBetweenDoctorAndPatient> messages = [];
        for (var json in response) {
          String? imagePath;
          if (json["image"] != null && json["image"].isNotEmpty) {
            try {
              File savedFile = await saveBase64Image(json["image"]);
              imagePath = savedFile.path;
            } catch (e) {
              print("Failed to save image: $e");
            }
          }
          messages.add(GetAllMessageBetweenDoctorAndPatient.fromJson({
            ...json,
            "image": imagePath,
          }));
        }
        emit(ChatSuccess(messages));
      } else {
        emit(ChatFailure("Invalid response format"));
      }
    } on ServerException catch (e) {
      emit(ChatFailure(e.errorModel.errorMessage));
    } catch (e) {
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
      if ((message == null || message.isEmpty) && image == null) {
        emit(ChatFailure("يجب إرسال رسالة نصية أو صورة!"));
        return;
      }
      FormData formData = FormData.fromMap({
        "senderId": senderId,
        "receiverId": receiverId,
        "message": message ?? (image != null ? "Image" : ""),
        "senderType": senderType,
        "receiverType": receiverType,
      });
      if (image != null) {
        File file = File(image.path);
        if (await file.exists()) {
          formData.files.add(MapEntry(
            "image",
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            ),
          ));
        } else {
          emit(ChatFailure("الملف المحدد غير موجود!"));
          return;
        }
      }
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
      emit(ChatFailure(e.errorModel.errorMessage));
    } catch (e) {
      emit(ChatFailure("حدث خطأ غير متوقع: $e"));
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
        final List<ChatSummary> chatList = [];
        for (var json in response) {
          String? lastMessage;
          bool isImage = false;
          if (json["image"] != null && json["image"].startsWith("/9j")) {
            try {
              File savedFile = await saveBase64Image(json["image"]);
              lastMessage = savedFile.path;
              isImage = true;
            } catch (e) {
              print("Failed to save image: $e");
            }
          } else {
            lastMessage = json["message"];
          }
          chatList.add(ChatSummary.fromJson({
            ...json,
            "lastMessage": lastMessage,
            "isImage": isImage,
          }));
        }
        emit(ChatListSuccess(chatList));
      } else {
        emit(ChatFailure("Invalid response format"));
      }
    } on ServerException catch (e) {
      emit(ChatFailure(e.errorModel.errorMessage));
    } catch (e) {
      emit(ChatFailure("Unexpected error occurred: $e"));
    }
  }

  void resetState() {
    emit(ChatInitial());
  }
}

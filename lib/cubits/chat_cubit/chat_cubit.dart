import 'package:bloc/bloc.dart';
import 'package:health_app/core/api/api_consumer.dart';
import 'package:health_app/core/api/end_points.dart';
import 'package:health_app/core/errors/exceptions.dart';
import 'package:health_app/cubits/chat_cubit/chat_state.dart';
import 'package:health_app/models/get_all_message_between_doctor_and_patient.dart';

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

      final List<GetAllMessageBetweenDoctorAndPatient> messages =
          List<GetAllMessageBetweenDoctorAndPatient>.from(
        response
            .map((json) => GetAllMessageBetweenDoctorAndPatient.fromJson(json)),
      );

      emit(ChatSuccess(messages));
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
    required String message,
    required String senderType,
    required String receiverType,
  }) async {
    try {
      final response = await api.post(
        EndPoints.sendMessage,
        data: {
          "senderId": senderId,
          "receiverId": receiverId,
          "message": message,
          "senderType": senderType,
          "receiverType": receiverType,
        },
      );

      final newMessage =
          GetAllMessageBetweenDoctorAndPatient.fromJson(response);

      if (state is ChatSuccess) {
        final updatedMessages = List<GetAllMessageBetweenDoctorAndPatient>.from(
          (state as ChatSuccess).messages,
        )..add(newMessage); // ✅ إدراج الرسالة الجديدة في البداية

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

  void resetState() {
    emit(ChatInitial());
  }
}

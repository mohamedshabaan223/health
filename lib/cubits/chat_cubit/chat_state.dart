import 'package:health_app/models/get_all_message_between_doctor_and_patient.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatSuccess extends ChatState {
  final List<GetAllMessageBetweenDoctorAndPatient> messages;

  ChatSuccess(this.messages);
}

class ChatFailure extends ChatState {
  final String errorMessage;

  ChatFailure(this.errorMessage);
}

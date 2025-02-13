import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cubits/chat_cubit/chat_cubit.dart';
import 'package:health_app/cubits/chat_cubit/chat_state.dart';
import 'package:health_app/widgets/container_icon.dart';
import 'package:health_app/widgets/receive_message.dart';
import 'package:health_app/widgets/send_message.dart';

class ChatScreen extends StatefulWidget {
  static const String id = "/chat";

  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late int patientId;
  late int doctorId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Object? args = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic> arguments =
        (args is Map<String, dynamic>) ? args : {};
    patientId = arguments["patientId"] ?? 0;
    doctorId = arguments["doctorId"] ?? 0;

    context
        .read<ChatCubit>()
        .fetchMessages(senderId: patientId, receiverId: doctorId)
        .then((_) => _scrollToBottom());
  }

  void sendMessage() {
    final message = textController.text.trim();
    if (message.isNotEmpty) {
      context.read<ChatCubit>().sendMessage(
            senderId: patientId,
            receiverId: doctorId,
            message: message,
            senderType: "patient",
            receiverType: "doctor",
          );
      textController.clear();
      Future.delayed(const Duration(milliseconds: 300), _scrollToBottom);
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Container(
                width: double.infinity,
                height: 78,
                color: AppTheme.green,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: 30,
                          color: AppTheme.white,
                        )),
                    const SizedBox(width: 10),
                    Text(
                      'Dr. Olivia Turner',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.white, fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    ContainerIcon(
                      onTap: () {},
                      iconName: Icons.phone_outlined,
                      containerColor: AppTheme.white,
                      iconColor: AppTheme.green,
                    ),
                    const SizedBox(width: 10),
                    ContainerIcon(
                      onTap: () {},
                      iconName: Icons.videocam_outlined,
                      containerColor: AppTheme.white,
                      iconColor: AppTheme.green,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ChatFailure) {
                    return Center(child: Text("Error: ${state.errorMessage}"));
                  } else if (state is ChatSuccess) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToBottom();
                    });
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        return message.senderId == patientId
                            ? SendMessage(
                                message: message.message,
                                messageTime: message.sendTime)
                            : ReceiveMessage(
                                message: message.message,
                                messageTime: message.sendTime);
                      },
                    );
                  } else {
                    return const Center(child: Text("No messages yet."));
                  }
                },
              ),
            ),
            Container(
              height: 72,
              width: double.infinity,
              color: const Color(0xffECF1FF),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.attach_file),
                        color: AppTheme.green),
                    Expanded(
                      child: TextField(
                        controller: textController,
                        cursorColor: AppTheme.green,
                        cursorHeight: 20,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppTheme.white,
                          hintText: 'Write Here...',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  color: const Color(0xffA9BCFE),
                                  fontWeight: FontWeight.w400),
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.send,
                              size: 25,
                              color: AppTheme.green,
                            ),
                            onPressed: sendMessage,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: AppTheme.white),
                            borderRadius: BorderRadius.circular(31),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: AppTheme.white),
                            borderRadius: BorderRadius.circular(31),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

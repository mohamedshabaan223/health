import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/tabs/chat/display_all_chat.dart';
import 'package:image_picker/image_picker.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cubits/chat_cubit/chat_cubit.dart';
import 'package:health_app/cubits/chat_cubit/chat_state.dart';
import 'package:health_app/widgets/receive_message.dart';
import 'package:health_app/widgets/send_message.dart';

class ChatScreen extends StatefulWidget {
  static const String id = "/chat";

  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  late int patientId;
  late int doctorId;
  late String doctorName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is Map<String, dynamic>) {
      patientId = args["patientId"] ?? 0;
      doctorId = args["doctorId"] ?? 0;
      doctorName = args["doctorName"] ?? "";

      if (patientId != 0 && doctorId != 0) {
        context
            .read<ChatCubit>()
            .fetchMessages(senderId: patientId, receiverId: doctorId)
            .then((_) => _scrollToBottom());
      }
    }
  }

  void sendMessage({String? text, XFile? image}) {
    if ((text == null || text.trim().isEmpty) && image == null) {
      return;
    }

    context.read<ChatCubit>().sendMessage(
          senderId: patientId,
          receiverId: doctorId,
          message: text ?? "",
          senderType: "Patient",
          receiverType: "Doctor",
          image: image,
        );

    textController.clear();
    Future.delayed(const Duration(milliseconds: 300), _scrollToBottom);
  }

  Future<void> pickImage() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        sendMessage(image: pickedFile);
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.green,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.white),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.of(context)
                  .pushReplacementNamed(DisplayAllChat.routeName);
            }
          },
        ),
        title: Text(
          doctorName,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: AppTheme.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatFailure) {
                  return Center(child: Text("Error: ${state.errorMessage}"));
                } else if (state is ChatSuccess) {
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: message.senderId == patientId
                            ? SendMessage(
                                message: message.message,
                                imageUrl: message.image,
                                messageTime: message.sendTime,
                              )
                            : ReceiveMessage(
                                message: message.message ?? "",
                                imageUrl: message.image,
                                messageTime: message.sendTime,
                              ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text("No messages yet."));
                }
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          IconButton(
            onPressed: pickImage,
            icon: const Icon(Icons.attach_file, size: 28),
            color: AppTheme.green,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.gray,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey.shade400, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: TextField(
                controller: textController,
                cursorColor: AppTheme.green,
                decoration: InputDecoration(
                  hintText: 'Write Here...',
                  hintStyle: const TextStyle(color: AppTheme.green),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send, color: AppTheme.green),
                    onPressed: () => sendMessage(text: textController.text),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

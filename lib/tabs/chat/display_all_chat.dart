import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/core/api/dio_consumer.dart';
import 'package:health_app/cubits/chat_cubit/chat_cubit.dart';
import 'package:health_app/cubits/chat_cubit/chat_state.dart';
import 'package:health_app/models/get_all_chats.dart';
import 'package:health_app/pages/chat_page.dart';

class DisplayAllChat extends StatelessWidget {
  static const routeName = '/display-all-chat';
  const DisplayAllChat({super.key});

  @override
  Widget build(BuildContext context) {
    final int userId = CacheHelper().getData(key: "id");
    const String userType = 'Patient';

    return BlocProvider(
      create: (context) => ChatCubit(DioConsumer(dio: Dio()))
        ..fetchChatList(userId: userId, userType: userType),
      child: Scaffold(
        appBar: AppBar(
          title: const Column(
            children: [
              SizedBox(height: 15),
              Text('All Chats'),
            ],
          ),
        ),
        body: BlocListener<ChatCubit, ChatState>(
          listener: (context, state) {
            if (state is ChatFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error: ${state.errorMessage}")),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatListSuccess) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: state.chatList.length,
                    itemBuilder: (context, index) {
                      final ChatSummary chat = state.chatList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 130,
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 11,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.gray,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    ChatScreen.id,
                                    arguments: {
                                      'doctorId': chat.otherUserId,
                                      'patientId': userId,
                                      'doctorName': chat.otherUserName,
                                    },
                                  ).then((_) {
                                    context.read<ChatCubit>().fetchChatList(
                                        userId: userId, userType: userType);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: AppTheme.gray,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 45,
                                        backgroundImage: chat.image != null &&
                                                chat.image!.isNotEmpty
                                            ? NetworkImage(chat.image!)
                                            : const AssetImage(
                                                    'assets/images/doctor_image.png')
                                                as ImageProvider,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              chat.otherUserName,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              chat.message ?? "No message",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black87),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        "${chat.sendTime.hour}:${chat.sendTime.minute}",
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      );
                    },
                  );
                } else if (state is ChatFailure) {
                  return Center(child: Text("Error: ${state.errorMessage}"));
                }
                return const Center(child: Text("No chats available"));
              },
            ),
          ),
        ),
      ),
    );
  }
}

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
import 'package:intl/intl.dart';

class DisplayAllChat extends StatefulWidget {
  static const routeName = '/display-all-chat';

  const DisplayAllChat({super.key});

  @override
  State<DisplayAllChat> createState() => _DisplayAllChatState();
}

class _DisplayAllChatState extends State<DisplayAllChat> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<ChatSummary> _filteredChats = [];
  List<ChatSummary> _allChats = [];

  @override
  Widget build(BuildContext context) {
    double heigth = MediaQuery.of(context).size.height;
    final int userId = CacheHelper().getData(key: "id");
    final String role = CacheHelper().getData(key: "role");
    String userType = role == 'Patient' ? 'Patient' : 'Doctor';

    return BlocProvider(
      create: (context) => ChatCubit(DioConsumer(dio: Dio()))
        ..fetchChatList(userId: userId, userType: userType),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: "Search...",
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _filteredChats = _allChats
                          .where((chat) => chat.otherUserName
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    });
                  },
                )
              : Column(
                  children: [
                    SizedBox(height: heigth * 0.03),
                    const Text(
                      'All Chats',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              onPressed: () {
                setState(() {
                  if (_isSearching) {
                    _searchController.clear();
                    _filteredChats = _allChats;
                  }
                  _isSearching = !_isSearching;
                });
              },
            ),
          ],
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
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatListSuccess) {
                  _allChats = state.chatList;
                  _filteredChats = _searchController.text.isEmpty
                      ? _allChats
                      : _filteredChats;

                  if (_filteredChats.isEmpty) {
                    return _buildNoChatsView();
                  }

                  return ListView.builder(
                    itemCount: _filteredChats.length,
                    itemBuilder: (context, index) {
                      return _buildChatItem(
                          context, _filteredChats[index], userId, userType);
                    },
                  );
                } else if (state is ChatFailure) {
                  return Center(child: Text("Error: ${state.errorMessage}"));
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoChatsView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 150,
            width: 150,
            child: Image.asset("assets/images/undraw_new-message_qvv6.png",
                colorBlendMode: BlendMode.modulate,
                color: Colors.white.withOpacity(0.4)),
          ),
          const SizedBox(height: 20),
          const Text("No chats available.",
              style: TextStyle(color: Colors.black54, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildChatItem(
      BuildContext context, ChatSummary chat, int userId, String userType) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 7,
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
            context
                .read<ChatCubit>()
                .fetchChatList(userId: userId, userType: userType);
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.gray,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.13),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('assets/images/male.png'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat.otherUserName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      chat.image != null && chat.image!.isNotEmpty
                          ? Row(
                              children: [
                                const Icon(Icons.image,
                                    size: 20, color: Colors.grey),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    chat.message ?? "Image",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black87),
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              chat.message ?? "No message",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black87),
                            ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      DateFormat('hh:mm a').format(chat.sendTime),
                      style:
                          const TextStyle(fontSize: 12, color: AppTheme.green2),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

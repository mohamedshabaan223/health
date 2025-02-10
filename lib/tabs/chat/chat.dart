import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/widgets/container_icon.dart';
import 'package:health_app/widgets/receive_message.dart';
import 'package:health_app/widgets/send_message.dart';

class ChatScreen extends StatelessWidget {
  static const String id = "/chat";
  final textController = TextEditingController();
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
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Dr. Olivia Turner',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.white, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      width: 60,
                    ),
                    ContainerIcon(
                      onTap: () {},
                      iconName: Icons.phone_outlined,
                      containerColor: AppTheme.white,
                      iconColor: AppTheme.green,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
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
            const SendMessage(),
            const SizedBox(
              height: 10,
            ),
            ReceiveMessage(),
            const SizedBox(
              height: 10,
            ),
            const SendMessage(),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 20,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Dr. Olivia is typing...',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppTheme.green, fontWeight: FontWeight.w400),
                    ),
                  ),
                  const Spacer(),
                ],
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
                          suffixIcon: const Icon(
                            Icons.mic,
                            size: 25,
                            color: AppTheme.green,
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
                    const SizedBox(
                      width: 10,
                    ),
                    ContainerIcon(
                        onTap: () {},
                        iconName: Icons.send,
                        containerColor: AppTheme.green,
                        iconColor: AppTheme.white)
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

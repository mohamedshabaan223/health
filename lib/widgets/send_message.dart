import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';

class SendMessage extends StatelessWidget {
  final String message;
  final DateTime messageTime;

  const SendMessage(
      {super.key, required this.message, required this.messageTime});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min, // Prevent unnecessary height
            children: [
              Container(
                padding: const EdgeInsets.all(12), // Adjust padding as needed
                constraints: const BoxConstraints(
                  maxWidth:
                      250, // Set a max width to prevent overly wide messages
                ),
                decoration: BoxDecoration(
                  color: AppTheme.gray,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                  ),
                ),
                child: Text(
                  message,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontSize: 18),
                ),
              ),
              const SizedBox(height: 4), // Small space between message and time
              Text(
                '${messageTime.hour}:${messageTime.minute.toString().padLeft(2, '0')}', // Ensure two-digit minutes
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: AppTheme.green3, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

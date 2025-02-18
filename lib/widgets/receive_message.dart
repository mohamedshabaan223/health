import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:health_app/app_theme.dart';

class ReceiveMessage extends StatelessWidget {
  final String? message;
  final String? imageUrl;
  final DateTime? messageTime;

  const ReceiveMessage({
    super.key,
    required this.message,
    required this.messageTime,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    String formattedMessage =
        message?.trim().isNotEmpty == true ? message! : "";
    String formattedTime = messageTime != null
        ? DateFormat('hh:mm a').format(messageTime!)
        : "No Time";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (formattedMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  decoration: const BoxDecoration(
                    color: AppTheme.gray,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                  ),
                  child: Text(
                    formattedMessage,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontSize: 16),
                  ),
                ),
              if (imageUrl != null && imageUrl!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(
                      imageUrl!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                formattedTime,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppTheme.black, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

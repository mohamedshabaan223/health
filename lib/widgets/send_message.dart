import 'dart:convert'; // لاستعمال base64Decode
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:health_app/app_theme.dart';

class SendMessage extends StatelessWidget {
  final String? message;
  final String? imageUrl;
  final DateTime? messageTime;

  const SendMessage({
    super.key,
    required this.message,
    required this.messageTime,
    this.imageUrl,
  });

  bool isBase64(String str) {
    return str.length > 100 && (str.startsWith('/9j') || str.contains(','));
  }

  @override
  Widget build(BuildContext context) {
    String formattedMessage =
        message?.trim().isNotEmpty == true ? message! : "";
    String formattedTime = messageTime != null
        ? DateFormat('hh:mm a').format(messageTime!)
        : "غير متوفر";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
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
                      bottomLeft: Radius.circular(18),
                    ),
                  ),
                  child: Text(
                    formattedMessage,
                    style: const TextStyle(color: AppTheme.black, fontSize: 16),
                  ),
                ),
              if (imageUrl != null && imageUrl!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: isBase64(imageUrl!)
                        ? Image.memory(
                            base64Decode(imageUrl!),
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          )
                        : imageUrl!.startsWith("http")
                            ? Image.network(
                                imageUrl!,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              )
                            : File(imageUrl!).existsSync()
                                ? Image.file(
                                    File(imageUrl!),
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  )
                                : const SizedBox(),
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

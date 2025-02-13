import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';

class ReceiveMessage extends StatelessWidget {
  ReceiveMessage({super.key, required this.message, required this.messageTime});
  String message;
  DateTime messageTime;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(18),
                width: 250,
                height: 120,
                decoration: const BoxDecoration(
                    color: AppTheme.gray,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                        bottomRight: Radius.circular(18))),
                child: Text(
                  message,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontSize: 18),
                ),
              ),
              Text(
                '${messageTime.hour}:${messageTime.minute}',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: AppTheme.black, fontSize: 13),
              )
            ],
          ),
        ],
      ),
    );
  }
}

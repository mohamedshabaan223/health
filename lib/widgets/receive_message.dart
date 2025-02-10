import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';

class ReceiveMessage extends StatelessWidget {
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
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w300),
                ),
              ),
              Text(
                '09:00',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppTheme.green, fontWeight: FontWeight.w300),
              )
            ],
          ),
        ],
      ),
    );
  }
}

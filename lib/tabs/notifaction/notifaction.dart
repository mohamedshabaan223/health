import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';

class Notifaction extends StatelessWidget {
  const Notifaction({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Text('My Notification'),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Container(
              width: double.infinity,
              height: height * 0.11,
              decoration: BoxDecoration(
                color: AppTheme.gray,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Text('data'),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Text('message'),
                ],
              )),
        ),
      ),
    );
  }
}

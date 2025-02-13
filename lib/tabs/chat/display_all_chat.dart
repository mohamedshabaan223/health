import 'package:flutter/material.dart';

class DisplayAllChat extends StatelessWidget {
  const DisplayAllChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Text('All Chats'),
          ],
        ),
      ),
    );
  }
}

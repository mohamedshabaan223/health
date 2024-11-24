import 'package:flutter/material.dart';
import 'package:health_app/widgets/create_icons.dart';

class ListViewIcons extends StatelessWidget {
  const ListViewIcons({super.key});
  final List<String> icons = const [
    'assets/images/google_icon.png',
    'assets/images/facebook_icon.png',
    'assets/images/finger_icon.png',
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.42,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: icons.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: CreateIcons(
                onTap: () {},
                logo_image: icons[index],
              ),
            );
          },
        ),
      ),
    );
  }
}

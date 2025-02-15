import 'package:flutter/material.dart';

class RowProfile extends StatelessWidget {
  const RowProfile(
      {super.key,
      required this.label,
      required this.iconName,
      required this.containerColor,
      required this.iconColor,
      this.onTap});
  final String label;
  final IconData iconName;
  final Color containerColor;
  final Color iconColor;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(30)),
              child: Icon(
                iconName,
                size: 25,
                color: iconColor,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}

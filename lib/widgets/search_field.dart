import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(left: 20),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: AppTheme.gray,
          borderRadius: BorderRadius.circular(35),
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/images/filter.png',
              height: 30,
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: TextField(
                style: TextStyle(
                  color: AppTheme.green3,
                  fontSize: 20,
                ),
                cursorColor: AppTheme.green,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: AppTheme.green,
                size: 25,
              ),
            )
          ],
        ),
      ),
    );
  }
}

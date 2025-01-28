import 'package:flutter/material.dart';

class RadioButtonForUsers extends StatefulWidget {
  @override
  _RadioButtonForUsersState createState() => _RadioButtonForUsersState();
}

class _RadioButtonForUsersState extends State<RadioButtonForUsers> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            title: Text('user'),
            leading: Radio<String>(
              value: 'user',
              groupValue: _selectedOption,
              onChanged: (value) {
                setState(() {
                  if (_selectedOption == value) {
                    _selectedOption = null; // إزالة التحديد
                  } else {
                    _selectedOption = value; // تحديد الخيار
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

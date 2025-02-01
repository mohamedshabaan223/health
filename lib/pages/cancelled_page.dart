import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';

class CancelledPage extends StatefulWidget {
  static const String id = '/cancelled_page';

  @override
  State<CancelledPage> createState() => _CancelledPageState();
}

class _CancelledPageState extends State<CancelledPage> {
  String? cancelled;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cancel Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontSize: 14),
            ),
            const SizedBox(
              height: 50,
            ),
            RadioListTile(
                fillColor: WidgetStatePropertyAll(AppTheme.gray),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                // hoverColor: AppTheme.green,
                activeColor: AppTheme.green,
                title: const Text('rescheduling'),
                value: "rescheduling",
                groupValue: cancelled,
                onChanged: (val) {
                  setState(() {
                    cancelled = val;
                  });
                }),
            RadioListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                // hoverColor: AppTheme.green,
                activeColor: AppTheme.green,
                title: const Text('Weather Conditions'),
                value: "Weather Conditions",
                groupValue: cancelled,
                onChanged: (val) {
                  setState(() {
                    cancelled = val;
                  });
                }),
            RadioListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                activeColor: AppTheme.green,
                title: const Text('Unexpected Work'),
                value: "Unexpected Work",
                groupValue: cancelled,
                onChanged: (val) {
                  setState(() {
                    cancelled = val;
                  });
                }),
            RadioListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                activeColor: AppTheme.green,
                title: const Text('Others'),
                value: "Others",
                groupValue: cancelled,
                onChanged: (val) {
                  setState(() {
                    cancelled = val;
                  });
                }),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w200,
                color: Color(0xff5A7A6E),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 152,
              width: 300,
              decoration: BoxDecoration(
                  color: AppTheme.gray,
                  borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'enter your comment here...',
                    hintStyle:
                        TextStyle(fontSize: 15, color: Color(0xff58CFA4)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffECF1FF))),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffECF1FF))),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: () {},
              child: Container(
                alignment: Alignment.center,
                height: 48,
                width: 256,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: AppTheme.green,
                ),
                child: const Text(
                  'Cancel Appointment',
                  style: TextStyle(
                      color: AppTheme.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w400),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

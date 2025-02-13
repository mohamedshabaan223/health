import 'package:flutter/material.dart';
import 'package:health_app/pages/doctor_page.dart';

class MyNavigatorObserver extends NavigatorObserver {
  final Function() onPopNext;

  MyNavigatorObserver({required this.onPopNext});

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute?.settings.name == DoctorPage.routeName) {
      onPopNext();
    }
    super.didPop(route, previousRoute);
  }
}

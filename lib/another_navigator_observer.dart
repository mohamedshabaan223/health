import 'package:flutter/material.dart';
import 'package:health_app/pages/all_appoinements_for_doctor.dart';

class AnotherNavigatorObserver extends NavigatorObserver {
  final Function() onPopNext;

  AnotherNavigatorObserver({required this.onPopNext});

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute?.settings.name == AllAppoinementForDoctor.id) {
      onPopNext();
    }
    super.didPop(route, previousRoute);
  }
}

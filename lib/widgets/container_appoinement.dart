import 'package:flutter/material.dart';

class ContainerAppointment extends StatelessWidget {
  ContainerAppointment(
      {required this.label,
      required this.onTap,
      required this.containerColor,
      required this.labelColor});
  String label;
  final Function()? onTap;
  Color labelColor;
  Color containerColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 27,
        width: 94,
        decoration: BoxDecoration(
            color: containerColor, borderRadius: BorderRadius.circular(18)),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: labelColor,
          ),
        ),
      ),
    );
  }
}

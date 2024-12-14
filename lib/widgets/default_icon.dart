import 'package:flutter/material.dart';

class Defaulticon extends StatelessWidget {
  Defaulticon(
      {required this.icon, required this.containerClolor, required this.onTap});
  final Icon icon;
  final Color containerClolor;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: 25,
          width: 30,
          decoration: BoxDecoration(
              color: containerClolor, borderRadius: BorderRadius.circular(13)),
          child: Center(child: icon)),
    );
  }
}

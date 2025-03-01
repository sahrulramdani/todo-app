import 'package:flutter/material.dart';

class BodyAtomWidget extends StatelessWidget {
  final List<Widget> children;

  const BodyAtomWidget({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.all(15),
      child: SizedBox(width: screenWidth, child: Column(children: children)),
    );
  }
}

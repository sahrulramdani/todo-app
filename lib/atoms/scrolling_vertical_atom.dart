import 'package:flutter/material.dart';

class ScrollingAtomWidget extends StatelessWidget {
  ListView list;

  ScrollingAtomWidget({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.8,
      child: SingleChildScrollView(scrollDirection: Axis.vertical, child: list),
    );
  }
}

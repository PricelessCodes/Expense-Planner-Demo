import 'package:flutter/material.dart';

import 'package:expense_planner/Widgets/landscape_content.dart';
import 'package:expense_planner/Widgets/portrait_content.dart';

class MyHomePageBody extends StatelessWidget {
  final bool isLandScape;
  final double screenHeight;

  const MyHomePageBody(
      {Key? key, required this.isLandScape, required this.screenHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      //SafeArea used because of the notch take a space from the height of the screen.
      child: SingleChildScrollView(
        child: isLandScape
            ? LandScapeContent(screenHeight: screenHeight)
            : PortraitContent(screenHeight: screenHeight),
      ),
    );
  }
}

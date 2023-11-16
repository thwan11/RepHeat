import 'package:flutter/material.dart';
import 'LayoutBar.dart';
import 'ColorScheme.dart';

class LandingScene extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSet['gray'],
      appBar: LayoutAppBar().toPreferredSizeWidget(context),
      body: _greetingWidget,
      bottomNavigationBar: LayoutBottomNavigationBar(),
    );
  }

  Widget get _greetingWidget {
    return Text("Worked!");
  }
}
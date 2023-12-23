import 'package:flutter/material.dart';
import 'ColorScheme.dart';

class Timer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.currentColorSet[1],
      body: _greetingWidget,
    );
  }

  Widget get _greetingWidget {
    return Text("Timer", style: TextStyle(color: AppTheme.currentColorSet[2]),);
  }
}
import 'package:flutter/material.dart';
import 'ColorScheme.dart';

class Statistics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSet['gray'],
      body: _greetingWidget,
    );
  }

  Widget get _greetingWidget {
    return Text("Statistics", style: TextStyle(color: ColorSet['white']),);
  }
}
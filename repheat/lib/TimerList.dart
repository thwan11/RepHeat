import 'package:flutter/material.dart';
import 'ColorScheme.dart';

class TimerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSet['gray'],
      body: _greetingWidget,
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.add, color: ColorSet['white']),
        backgroundColor: ColorSet['black'],
      ),
    );
  }

  Widget get _greetingWidget {
    return Text("TimerList", style: TextStyle(color: ColorSet['white']),);
  }
}
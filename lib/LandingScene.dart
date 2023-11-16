import 'package:flutter/material.dart';
import 'LayoutBar.dart';
import 'ColorScheme.dart';
import 'Statistics.dart';
import 'TimerList.dart';
import 'Timer.dart';

class LandingScene extends StatefulWidget {
  _LandingSceneState createState() => _LandingSceneState();
}

class _LandingSceneState extends State<LandingScene> {
  int _currentIndex = 1;
  final List<Widget> _children = [Timer(), TimerList(), Statistics()];
  void _onTap(int index) {
    setState(() {
      this._currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSet['gray'],
      appBar: LayoutAppBar().toPreferredSizeWidget(context),
      body: _children[_currentIndex],
      bottomNavigationBar: LayoutBottomNavigationBar(currentIndex: this._currentIndex, onTap: _onTap),
    );
  }

  Widget get _greetingWidget {
    return Text("LandingPage", style: TextStyle(color: ColorSet['white']),);
  }
}
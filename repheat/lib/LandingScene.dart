import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
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
  List<Widget> _children = [];

  @override
  void initState() {
    super.initState();
    loadUserData().then((routines) {
      setState(() {
        _children = [
          Timer(),
          TimerList(routines: routines), // TimerList에 routines 전달
          Statistics()
        ];
      });
    });
  }

  Future<List<Map<String, dynamic>>> loadUserData() async {
    try {
      String jsonString = await rootBundle.loadString('assets/data/user.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      // 'dmkthwan11@gmail.com' 사용자의 루틴 데이터를 가져옵니다.
      var userRoutines = jsonMap['dmkthwan11@gmail.com']['routines'];
      if (userRoutines != null) {
        // 데이터가 존재하면 변환하여 반환합니다.
        return List<Map<String, dynamic>>.from(userRoutines);
      } else {
        // 데이터가 없으면 빈 리스트를 반환합니다.
        return [];
      }
    } catch (e) {
      print('Error loading user data: $e');
      // 오류 발생 시 빈 리스트를 반환합니다.
      return [];
    }
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSet['gray'],
      appBar: LayoutAppBar().toPreferredSizeWidget(context),
      body: _currentIndex < _children.length ? _children[_currentIndex] : CircularProgressIndicator(),
      bottomNavigationBar: LayoutBottomNavigationBar(currentIndex: _currentIndex, onTap: _onTap),
    );
  }

  Widget get _greetingWidget {
    return Text("LandingPage", style: TextStyle(color: ColorSet['white']),);
  }
}
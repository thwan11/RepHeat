// import 'package:flutter/material.dart';
// import 'LayoutBar.dart';
// import 'ColorScheme.dart';
// import 'Statistics.dart';
// import 'TimerList.dart';
// import 'Timer.dart';
//
// class LandingScene extends StatefulWidget {
//   _LandingSceneState createState() => _LandingSceneState();
// }
//
// class _LandingSceneState extends State<LandingScene> {
//   int _currentIndex = 1;
//   final List<Widget> _children = [Timer(), TimerList(), Statistics()];
//   void _onTap(int index) {
//     setState(() {
//       this._currentIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorSet['gray'],
//       appBar: LayoutAppBar().toPreferredSizeWidget(context),
//       body: _children[_currentIndex],
//       bottomNavigationBar: LayoutBottomNavigationBar(currentIndex: this._currentIndex, onTap: _onTap),
//     );
//   }
//
//   Widget get _greetingWidget {
//     return Text("LandingPage", style: TextStyle(color: ColorSet['white']),);
//   }
// }
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
  List<Widget> _children = []; // _children을 여기서 초기화하지 않고, 데이터를 읽은 후에 초기화합니다.

  @override
  void initState() {
    super.initState();
    loadUserData().then((routineNames) {
      setState(() {
        _children = [
          Timer(),
          TimerList(routineNames: routineNames), // TimerList에 routineNames 전달
          Statistics()
        ];
      });
    });
  }

  Future<List<String>> loadUserData() async {
    try {
      String jsonString = await rootBundle.loadString('assets/data/user.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      List<dynamic> routines = jsonMap['caukdk@gmail.com']['routines'];
      List<dynamic> names = routines.map((routine) => routine['name'].toString()).toList();
      print(names);
      return routines.map((routine) => routine['name'].toString()).toList();
    } catch (e) {
      print('Error loading user data: $e');
      return []; // 오류 발생 시 빈 리스트 반환
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
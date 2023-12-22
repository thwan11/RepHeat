import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'LayoutBar.dart';
import 'ColorScheme.dart';
import 'Statistics.dart';
import 'TimerList.dart';
import '_Timer.dart';
import 'GoogleSignIn.dart';


import 'global.dart';

class LandingScene extends StatefulWidget {
  const LandingScene({super.key});

  @override
  LandingSceneState createState() => LandingSceneState();
}

class LandingSceneState extends State<LandingScene> {
  final GlobalKey<TimerState> timer = GlobalKey();
  final GlobalKey<LayoutAppBarState> layout = GlobalKey();
  final GlobalKey<StatisticsState> stat = GlobalKey();

  int currentIndex = 1;
  List<Widget> _children = [];
  int routineIndex = 0;


  bool loggedIn = false;
  String email = 'dmkthwan11@gmail.com';

  late List<dynamic> routine;

  @override
  void initState() {
    super.initState();
    Future.wait([loadUserRoutine(), loadUserHistory()]).then((results) {
      setState(() {
        _children = [
          const Timers({}),
          TimerList(routines: results[0] as List<Map<String, dynamic>>, onTap: _onTap, changeRoutine: changeRoutine), // 첫 번째 결과 사용
          Statistics(key: stat, history: results[1] as Map<String, dynamic>) // 두 번째 결과 사용
        ];
      });
    });
  }

  Future<List<Map<String, dynamic>>> loadUserRoutine() async {
    try {
      String jsonString = await rootBundle.loadString('assets/data/user_modified.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      // 'dmkthwan11@gmail.com' 사용자의 루틴 데이터를 가져옵니다.
      var userRoutines = await jsonMap['dmkthwan11@gmail.com']['routines'];
      routine = userRoutines;
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

  Future<Map<String, dynamic>> loadUserHistory() async {
    try {
      String jsonString = await rootBundle.loadString('assets/data/user_modified.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      // 'dmkthwan11@gmail.com' 사용자의 루틴 데이터를 가져옵니다.
      var userHistory = jsonMap['dmkthwan11@gmail.com']['history'];
      if (userHistory != null) {
        // 데이터가 존재하면 변환하여 반환합니다.
        return Map<String, dynamic>.from(userHistory);
      } else {
        // 데이터가 없으면 빈 리스트를 반환합니다.
        return {};
      }
    } catch (e) {
      print('Error loading user data: $e');
      // 오류 발생 시 빈 리스트를 반환합니다.
      return {};
    }
  }

  void _onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }
  void changeRoutine(int index) {
    routineIndex = index;

    setState(() {
    });
    print(routineIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSet['gray'],
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize, // Use the same size as a regular AppBar
        child: LayoutAppBar(key: layout, signIn: signIn, signOut: signOut, loggedIn: loggedIn, email: email, share: currentIndex, onSharePressed: () => stat.currentState?.onShare()),
      ),
      body: currentIndex < _children.length ? _children[currentIndex] : const CircularProgressIndicator(),
      bottomNavigationBar: LayoutBottomNavigationBar(key: bottomNavBarKey, currentIndex: currentIndex, onTap: _onTap),
    );
  }

  Future<void> signIn() async {
    loggedIn = true;
    email = 'dmkthwan11@gmail.com';
    Future.wait([loadUserRoutine(), loadUserHistory()]).then((results) {
      setState(() {
        _children = [
          Timers(routine[routineIndex]),
          TimerList(routines: results[0] as List<Map<String, dynamic>>, onTap: _onTap, changeRoutine: changeRoutine),
          Statistics(key: stat, history: results[1] as Map<String, dynamic>)
        ];
      });});
    }

  void signOut() async {
    await GoogleSignInApi.logout();
    setState(() {
      loggedIn = false;
      email = '';
      _children = [
        const Timers({}),
        TimerList(routines: const [], onTap: _onTap, changeRoutine: changeRoutine), // 비어있는 리스트 전달
        Statistics(key: stat, history: const {})
      ];
    });
  }
}
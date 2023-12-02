import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'LayoutBar.dart';
import 'ColorScheme.dart';
import 'Statistics.dart';
import 'TimerList.dart';
import 'Timer.dart';
import 'GoogleSignIn.dart';

class LandingScene extends StatefulWidget {
  _LandingSceneState createState() => _LandingSceneState();
}

class _LandingSceneState extends State<LandingScene> {
  int _currentIndex = 1;
  List<Widget> _children = [];

  bool loggedIn = false;
  String email = '';

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
      String jsonString = await rootBundle.loadString('assets/data/user_modified.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      // 'dmkthwan11@gmail.com' 사용자의 루틴 데이터를 가져옵니다.
      var userRoutines = jsonMap[email]['routines'];
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
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize, // Use the same size as a regular AppBar
        child: LayoutAppBar(signIn: signIn, signOut: signOut, loggedIn: loggedIn, email: email),
      ),
      body: _currentIndex < _children.length ? _children[_currentIndex] : CircularProgressIndicator(),
      bottomNavigationBar: LayoutBottomNavigationBar(currentIndex: _currentIndex, onTap: _onTap),
    );
  }

  Future<void> signIn() async {
    await GoogleSignInApi.logout();
    final user = await GoogleSignInApi.login();
    if (user != null) {
      setState(() {
        loggedIn = true;
        email = user.email;
      });
      loadUserData().then((routines) {
        setState(() {
          _children = [
            Timer(),
            TimerList(routines: routines), // TimerList에 새로운 routines 전달
            Statistics()
          ];
        });
      });
    }
  }

  void signOut() async {
    await GoogleSignInApi.logout();
    setState(() {
      loggedIn = false;
      email = '';
      _children = [
        Timer(),
        TimerList(routines: []), // 비어있는 리스트 전달
        Statistics()
      ];
    });
  }
}
import 'package:flutter/material.dart';
import 'LandingScene.dart';
import 'Statistics.dart';
import 'Timer.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(App()));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RepHeat',
      theme: ThemeData(primarySwatch: Colors.grey, useMaterial3: false),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext ctx) => LandingScene(),
        // '/timerlist' 라우트는 제거하고, LandingScene 내부에서 TimerList를 관리합니다.
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
import 'package:flutter/material.dart';
import 'LandingScene.dart';

void main() {
//debugPaintSizeEnabled=true;
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RepHeat',
      theme: ThemeData(primarySwatch: Colors.red, useMaterial3: false),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext ctx) => LandingScene(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

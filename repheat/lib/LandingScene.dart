import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
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

  int jandi = 0;

  get http => null; // Default value

  void handleJandiChange(int newJandi) {

    Future.wait([loadUserRoutine(), loadUserHistory()]).then((results){
      setState(() {
        jandi = newJandi;
        // Rebuild the Statistics widget with the new jandi value
        _children[2] = Statistics(key: stat, history: results[1] as Map<String, dynamic>, jandi: jandi);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    AppTheme.onThemeChanged = () {
      // Trigger a rebuild whenever the theme changes
      setState(() {});
    };
    Future.wait([loadUserRoutine(), loadUserHistory()]).then((results) {
      setState(() {
        _children = [
          Timers({}),
          TimerList(routines: results[0] as List<Map<String, dynamic>>, onTap: _onTap, changeRoutine: changeRoutine), // 첫 번째 결과 사용
          Statistics(key: stat, history: results[1] as Map<String, dynamic>, jandi: layout.currentState!.jandi) // 두 번째 결과 사용
        ];
      });
    });
  }

  @override
  void dispose() {
    // Clean up the listener when the widget is removed from the tree
    AppTheme.onThemeChanged = null;
    super.dispose();
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

    setState(() {});
    print(routineIndex);
    setState(() {
      _children = [Timers(routine[routineIndex], key: timerkey,), _children[1],_children[2]];
    });
    timerkey.currentState?.sets(routine[routineIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.currentColorSet[0],
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize, // Use the same size as a regular AppBar
        child: LayoutAppBar(key: layout, signIn: signIn, signOut: signOut, loggedIn: loggedIn, email: email, share: currentIndex, onCapture: stat.currentState?.captureImage, onSharePressed: stat.currentState?.onShare, onJandiChanged: handleJandiChange, loaddb: loaddb, writedb: writedb, makedb: makedb, fetch: fetchRoutineFromAPI, upload: uploadRoutineToAPI),
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
          Timers(routine[routineIndex], key: timerkey,),
          TimerList(routines: results[0] as List<Map<String, dynamic>>, onTap: _onTap, changeRoutine: changeRoutine),
          Statistics(key: stat, history: results[1] as Map<String, dynamic>, jandi: layout.currentState!.jandi)
        ];
      });});
    }

  void signOut() async {
    await GoogleSignInApi.logout();
    setState(() {
      loggedIn = false;
      email = '';
      _children = [
        Timers({}),
        TimerList(routines: const [], onTap: _onTap, changeRoutine: changeRoutine), // 비어있는 리스트 전달
        Statistics(key: stat, history: const {}, jandi: layout.currentState!.jandi)
      ];
    });
  }

  void loaddb() async {
    try {
      Directory documents = await getApplicationDocumentsDirectory();
      File file = File('${documents.path}/db.json');

      String text = await file.readAsString();
      setState(() {
        List<dynamic> db = json.decode(text);
        routine = db;
      });
    } catch (e) {
      // 오류 처리
      print("Error loading database: $e");
    }
  }

  void writedb() async {
    try {
      Directory documents = await getApplicationDocumentsDirectory();
      File file = File('${documents.path}/db.json');
      List<dynamic> jsonObject = routine;

      await file.writeAsString(json.encode(jsonObject));
    } catch (e) {
      // 오류 처리
      print("Error writing to database: $e");
    }
  }

  void makedb() async {
    try {
      String _stringData = await rootBundle.loadString('assets/user_modified.json');
      Directory documents = await getApplicationDocumentsDirectory();
      Map<String, dynamic> db = json.decode(_stringData);
      List<dynamic> rou = db[email]['routines'];
      File file = File('${documents.path}/db.json');
      await file.writeAsString(jsonEncode(rou));
    } catch (e) {
      // 오류 처리
      print("Error creating database: $e");
    }
  }

  Future<void> fetchRoutineFromAPI(String email) async {
    final apiUrl = 'http://10.210.60.22:60000/get/$email';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Update your routine data with the data received from the API
        setState(() {
          routine = List<Map<String, dynamic>>.from(data['routines']);
        });
      } else {
        print('Failed to fetch routine data from the API.');
      }
    } catch (e) {
      print('Error fetching routine data: $e');
    }
  }

  Future<void> uploadRoutineToAPI(String email) async {
    final apiUrl = 'http://10.210.60.22:60000/upload/$email';

    try {
      final response = await http.post(Uri.parse(apiUrl), body: json.encode(routine));

      if (response.statusCode == 200) {
        print('Routine data uploaded successfully to the API.');
      } else {
        print('Failed to upload routine data to the API.');
      }
    } catch (e) {
      print('Error uploading routine data: $e');
    }
  }

}
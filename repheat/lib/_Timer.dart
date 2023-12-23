import 'dart:async';
import 'package:flutter/material.dart';
import 'ColorScheme.dart';
import 'pie_chart.dart';
import 'LayoutBar.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'global.dart';



class Timers extends StatefulWidget {
  final Map<String, dynamic> config; //routine을 받아옵니다.
  const Timers(this.config, {super.key});

  @override
  TimerState createState() => TimerState();
}

class TimerState extends State<Timers> {
  String? name;
  late List<dynamic> subroutines;
  String? subname;

  late List<dynamic> time;

  late int iter;
  late Timer timer;
  bool running = false;
  late int t60;

  int t60now = 0;
  double perc = 0.0;
  int subroutineindex = 0;
  late int nowiter;

  @override
  void initState() {
    super.initState();

    name = widget.config['name'] ?? 'bug occured';
    subroutines = widget.config['subroutines'];
    subname = subroutines[0]['name'];

    iter = widget.config['iter'] ?? -1;
    time = [subroutines[0]['hour']??0.0, subroutines[0]['minute']??0.0, subroutines[0]['second']??0.0];
    nowiter = 1;

    t60 = time[0]*3600 + time[1]*60 + time[2];
    t60now = 0;
  }

  void nextsub(){
    setState(() {
      subroutineindex = subroutineindex+1;
      if(subroutines.length == subroutineindex){
        subroutineindex = 0;
        nowiter = nowiter+1;
        if(nowiter > iter){
          resetTimer();
          saveRoutineHistory();
        }else{
          subname = subroutines[subroutineindex]['name'];
          time = [subroutines[subroutineindex]['hour'], subroutines[subroutineindex]['minute'], subroutines[subroutineindex]['second']];
          t60 = time[0]*3600 + time[1]*60 + time[2];
          t60now = 0;
        }
      }else{
        subname = subroutines[subroutineindex]['name'];
        time = [subroutines[subroutineindex]['hour'], subroutines[subroutineindex]['minute'], subroutines[subroutineindex]['second']];
        t60 = time[0]*3600 + time[1]*60 + time[2];
        t60now = 0;
      }
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      onTick(timer);
    });
    setState(() {
      //Todo 여기에 네비게이션 바 끄는 코드 필요
      bottomNavBarKey.currentState?.toggleVisibility();
      running = true;
    });
  }

  void pauseTimer() {
    timer.cancel();
    setState(() {
      running = false;
      //Todo 여기에 네비게이션 바 켜는 코드 필요
      bottomNavBarKey.currentState?.toggleVisibility();

    });
  }

  void resetTimer() {
    timer.cancel();
    setState(() {
      //Todo 여기에 네비게이션 바 켜는 코드 필요
      bottomNavBarKey.currentState?.toggleVisibility();

      running = false;
      name = widget.config['name'] ?? 'bug occured';
      subroutines = widget.config['subroutines'];
      subname = subroutines[0]['name'];

      iter = widget.config['iter'] ?? -1;
      time = [subroutines[0]['hour']??0.0, subroutines[0]['minute']??0.0, subroutines[0]['second']??0.0];
      nowiter = 1;
      subroutineindex = 0;

      t60 = time[0]*3600 + time[1]*60 + time[2];
      t60now = 0;
      perc = 0.0;
    });
  }

  void onTick(Timer timer){
    if(t60 == t60now){
      nextsub();
    }else{
      setState(() {
        t60now = t60now+1;
        perc = (t60now / t60) * 100; // 백분율 계산
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorSet['gray'],
        body: Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(3, 10, 3, 3),
                child: Text(name!, style: TextStyle(color: ColorSet['white'], fontWeight: FontWeight.bold, fontSize: 32 ),),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(3, 2, 3, 30),
                child: Text('<${subname!}>', style: TextStyle(color: ColorSet['white'], fontWeight: FontWeight.bold ,fontSize: 20)),
              ),
              Container(
                child: CustomPaint( // CustomPaint를 그리고 이 안에 차트를 그려줍니다..
                  size: const Size(300, 300), // CustomPaint의 크기는 가로 세로 150, 150으로 합니다.
                  painter: PieChart(
                      time: t60,
                      timenow: t60now,
                      percentage: perc, // 파이 차트가 얼마나 칠해져 있는지 정하는 변수입니다.
                      textScaleFactor: 1.0, // 파이 차트에 들어갈 텍스트 크기를 정합니다.
                      textColor: Colors.blueGrey,
                      nextsub : subroutines[(subroutineindex+1)%subroutines.length] ,
                      nowiter : nowiter,
                      iter : iter
                  ),
                ),
              ),
              _BottomButton(),
              // 타이머 표시 위젯
            ],
          ),
        )
    );
  }
  void saveRoutineHistory() async {
    final DateTime now = DateTime.now(); // 현재 날짜와 시간을 가져옵니다.
    final String formattedDate = "${now.year}-${now.month}-${now.day}"; // 날짜 형식화

    final Map<String, dynamic> historyData = {
      'date': formattedDate,
      'routine': widget.config,
    };

    final directory = await getApplicationDocumentsDirectory(); // 앱 문서 디렉토리 경로를 가져옵니다.
    final file = File('${directory.path}/routine_history.json'); // 파일 경로 설정

    List<dynamic> historyList = [];
    if (await file.exists()) {
      // 파일이 존재하는 경우, 기존 내용을 불러옵니다.
      String contents = await file.readAsString();
      historyList = json.decode(contents);
    }

    historyList.add(historyData); // 새로운 기록을 추가합니다.
    await file.writeAsString(json.encode(historyList)); // 파일에 데이터를 저장합니다.
  }

  Widget _BottomButton() {
    if (!running) {
      return ElevatedButton(
        onPressed: startTimer,
        style: ElevatedButton.styleFrom(
            backgroundColor: ColorSet['black'],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)
            ),
            fixedSize: const Size(100,10)
        ),
        child: Icon(Icons.play_arrow_outlined, color: ColorSet['white'], size: 30,),
      );
    } else {
      return Container(
        padding: const EdgeInsets.fromLTRB(83, 0, 30, 0),
        alignment: Alignment.center,
        child: Row(
          children: <Widget>[
            ElevatedButton(
              onPressed: resetTimer,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorSet['black'],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)
                ),
              ),
              child: Icon(Icons.stop_outlined, color: ColorSet['white'],),
            ),
            ElevatedButton(
              onPressed: pauseTimer,
              style: ElevatedButton.styleFrom(
                  backgroundColor: ColorSet['black'],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)
                  ),
                  fixedSize: const Size(100,10)
              ),
              child: Icon(Icons.pause_outlined, color: ColorSet['white'],),
            ),

          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    timer.cancel();
      super.dispose();
  }
}

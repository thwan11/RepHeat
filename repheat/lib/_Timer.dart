import 'dart:async';
import 'package:flutter/material.dart';
import 'ColorScheme.dart';
import 'pie_chart.dart';

class Timers extends StatefulWidget {
  final Map<String, dynamic> config; //routine을 받아옵니다.
  Timers(this.config);

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
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      onTick(timer);
    });
    setState(() {
      running = true;
    });
  }

  void pauseTimer() {
    timer.cancel();
    setState(() {
      running = false;
    });
  }

  void resetTimer() {
    timer.cancel();
    setState(() {
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
                child: Text(name!, style: TextStyle(color: ColorSet['white'], fontWeight: FontWeight.bold, fontSize: 32 ),),
                padding: EdgeInsets.fromLTRB(3, 10, 3, 3),
              ),
              Container(
                child: Text('<'+subname!+'>', style: TextStyle(color: ColorSet['white'], fontWeight: FontWeight.bold ,fontSize: 20)),
                padding: EdgeInsets.fromLTRB(3, 2, 3, 30),
              ),
              Container(
                child: CustomPaint( // CustomPaint를 그리고 이 안에 차트를 그려줍니다..
                  size: Size(300, 300), // CustomPaint의 크기는 가로 세로 150, 150으로 합니다.
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

  Widget _BottomButton() {
    if (!running) {
      return ElevatedButton(
        onPressed: startTimer,
        child: Icon(Icons.play_arrow_outlined, color: ColorSet['white'], size: 30,),
        style: ElevatedButton.styleFrom(
            backgroundColor: ColorSet['black'],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)
            ),
            fixedSize: Size(100,10)
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.fromLTRB(145, 5, 30, 0),
        alignment: Alignment.center,
        child: Row(
          children: <Widget>[
            ElevatedButton(
              onPressed: resetTimer,
              child: Icon(Icons.stop_outlined, color: ColorSet['white'],),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorSet['black'],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)
                ),
              ),
            ),
            ElevatedButton(
              onPressed: pauseTimer,
              child: Icon(Icons.pause_outlined, color: ColorSet['white'],),
              style: ElevatedButton.styleFrom(
                  backgroundColor: ColorSet['black'],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)
                  ),
                  fixedSize: Size(100,10)
              ),
            ),

          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    if (timer != null) {
      timer.cancel();
    }
    super.dispose();
  }
}

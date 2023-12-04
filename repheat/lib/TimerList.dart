import 'package:flutter/material.dart';
import 'ColorScheme.dart';

class TimerList extends StatefulWidget {
  final List<Map<String, dynamic>> routines; // Routines including subroutines

  TimerList({Key? key, required this.routines}) : super(key: key);

  @override
  _TimerListState createState() => _TimerListState();
}

class _TimerListState extends State<TimerList> {
  int? selectedBoxIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSet['gray'],
      body: SingleChildScrollView( // Wrap with SingleChildScrollView
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: List<Widget>.generate(widget.routines.length, (index) {
              var routine = widget.routines[index];
              var subroutines = routine['subroutines'] as List<dynamic>;
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedBoxIndex = selectedBoxIndex == index ? null : index;
                      });
                    },
                    child: bigBox(context, routine),
                  ),
                  if (selectedBoxIndex == index) ...subroutines.map((sub) {
                    return littleBox(context, sub);
                  }).toList(),
                ],
              );
            }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addTimerEvent(context),
        child: Text('+', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400)),
        backgroundColor: ColorSet['white'],
      ),
    );
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  Future<void> addTimerEvent(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('타이머 추가'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: '제목'
                  ),
                ),
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(
                    labelText: '내용'
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('cancel'),
              ),
              TextButton(
                  child: Text('add'),
                  onPressed: () {
                    setState(() {
                      String title = titleController.text;
                      String content = contentController.text;
                    });
                    Navigator.of(context).pop();
                  },
              ),
            ],
          );
        },
    );
  }

  String timeToString(int time) {
    int hour = 0;
    int minute = 0;
    int second = 0;
    second = time % 60;
    minute = (time ~/ 60) % 60;
    hour = (time ~/ 60) ~/ 60;
    return '${hour.toString().padLeft(2, "0")}:${minute.toString().padLeft(2, "0")}:${second.toString().padLeft(2, "0")}';
  }

  Widget bigBox(BuildContext context, dynamic routine) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    String iter = (routine['iter'] > 0) ? routine['iter'].toString() : '∞';
    String title = '${routine["name"]}x$iter';
    int fontSize = 27;
    int routineTime = 0;
    String routineTimeString = '';
    int totalTime = 0;
    String totalTimeString = '∞';

    switch(title.length){
      case 11:  // 표시되는 최대 길이 제목:8, x:1, 횟수:2
        fontSize = 17;
      case 10:
        fontSize = 29;
      case 9:
        fontSize = 21;
      case 8:
        fontSize = 23;
      case 7:
        fontSize = 25;
    }

    routine['subroutines'].forEach((sub) => routineTime += (sub['hour']*3600 + sub['minute']*60 + sub['second']) as int);
    routineTimeString = timeToString(routineTime);

    if (routine['iter'] > 0){
      totalTime = routineTime * routine['iter'] as int;
      totalTimeString = timeToString(totalTime);
    }

    return Container(
      padding: EdgeInsets.fromLTRB(0, 10*fem, 0, 2*fem),
      child: Container(
        padding: EdgeInsets.fromLTRB(26*fem, 8*fem, 27*fem, 8*fem),
        width: 299*fem,
        height: 100*fem,
        decoration: BoxDecoration (
          color: ColorSet['black'],
          borderRadius: BorderRadius.circular(10*fem),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title, // '달리기' 대신에 제공된 title 사용
              style: TextStyle(
                  fontSize: fontSize*ffem,
                  fontWeight: FontWeight.w400,
                  height: 1.2125*ffem/fem,
                  color: ColorSet['white']
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '1회 ',
                      style: TextStyle(
                          fontSize: 16*ffem,
                          fontWeight: FontWeight.w400,
                          height: 1.2125*ffem/fem,
                          color: ColorSet['white']
                      ),
                    ),
                    Text(
                      '전체 ',
                      style: TextStyle(
                          fontSize: 16*ffem,
                          fontWeight: FontWeight.w400,
                          height: 1.2125*ffem/fem,
                          color: ColorSet['white']
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      routineTimeString,
                      style: TextStyle(
                          fontSize: 16*ffem,
                          fontWeight: FontWeight.w400,
                          height: 1.2125*ffem/fem,
                          color: ColorSet['white']
                      ),
                    ),
                    Text(
                      totalTimeString,
                      style: TextStyle(
                          fontSize: 16*ffem,
                          fontWeight: FontWeight.w400,
                          height: 1.2125*ffem/fem,
                          color: ColorSet['white']
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget littleBox(BuildContext context, dynamic sub) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2*fem),
      child: Container(
        padding: EdgeInsets.fromLTRB(26*fem, 8*fem, 27*fem, 8*fem),
        width: 299*fem,
        height: 36*fem,
        decoration: BoxDecoration (
          color: ColorSet['black'],
          borderRadius: BorderRadius.circular(10*fem),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              sub['name'], // '달리기' 대신에 제공된 subtitle 사용
              style: TextStyle(
                  fontSize: 16*ffem,
                  fontWeight: FontWeight.w400,
                  height: 1.2125*ffem/fem,
                  color: ColorSet['white']
              ),
            ),
            Text(
                '${sub["hour"].toString().padLeft(2, "0")}:${sub["minute"].toString().padLeft(2, "0")}:${sub["second"].toString().padLeft(2, "0")}',
                style: TextStyle(
                    fontSize: 16*ffem,
                    fontWeight: FontWeight.w400,
                    height: 1.2125*ffem/fem,
                    color: ColorSet['white']
                )
            ),
          ],
        ),
      ),
    );
  }
}
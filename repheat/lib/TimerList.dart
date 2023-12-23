import 'package:flutter/material.dart';
import 'ColorScheme.dart';
import 'LandingScene.dart';
import '_Timer.dart';

class TimerList extends StatefulWidget {
  final List<Map<String, dynamic>> routines; // Routines including subroutines
  Function onTap;
  Function changeRoutine;

  TimerList({Key? key, required this.routines, required this.onTap, required this.changeRoutine}) : super(key: key);

  @override
  TimerListState createState() => TimerListState();
}

class _subRoutine {
  String subname;
  int subh;
  int submin;
  int subsec;

  _subRoutine({required this.subname, required this.subh, required this.submin, required this.subsec});
}

class TimerListState extends State<TimerList> {
  final GlobalKey<TimerState> timer = GlobalKey();
  int? selectedBoxIndex;

  get subroutines => null;

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
                    child: (selectedBoxIndex != index)
                        ? bigBox(context, routine, false, index)
                        :bigBox(context, routine, true, index),
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
      barrierDismissible: true, //바깥 영역 터치 시 닫을지 여부, 현재 true
      builder: (BuildContext context) {

        int setiter = 1;
        bool _isSound = false;
        bool _isVibrate = false;

        List<_subRoutine> subroutines = [];

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(//루틴 이름 입력
                      style: TextStyle(
                          fontSize: 30,
                          color: ColorSet['white']
                      ),
                      controller: titleController,
                      maxLength: 8,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: '', //count 안보이게 하면 8자 넘어서까지 입력되다가
                        // 그 이상 입력한건 사라지더라, count 있는게 나을듯?
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [//루틴 반복 횟수
                            Text(
                              'x$setiter',
                              style: (
                                  TextStyle(
                                      fontSize: 30,
                                      color: ColorSet['white']
                                  )
                              ),
                            ),
                            Column(//루틴 반복 횟수 조절 버튼
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 15,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (setiter < 98) {
                                        setState(() {
                                          setiter = setiter + 1;
                                        });
                                      };
                                    },
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text('↑',
                                        textAlign: TextAlign.left,
                                        style: (
                                            TextStyle(
                                                fontSize: 5,
                                                color: ColorSet['black']
                                            )
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  width: 20,
                                  height: 15,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (setiter > 1) {
                                        setState(() {
                                          setiter--;
                                        });
                                      };
                                    },
                                    child: Text('↓',
                                      textAlign: TextAlign.center,
                                      style: (
                                          TextStyle(
                                              fontSize: 10,
                                              color: ColorSet['black']
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text('소리',
                                  style: TextStyle(
                                  color: ColorSet['white'],
                                  ),
                                ),
                                Switch(
                                    value: _isSound,
                                    onChanged: (value) {
                                      setState(() {
                                        _isSound = value;
                                      });
                                    }
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text('진동',
                                  style: TextStyle(
                                    color: ColorSet['white'],
                                  ),
                                ),
                                Switch(
                                    value: _isVibrate,
                                    onChanged: (value) {
                                      setState(() {
                                        _isVibrate = value;
                                      });
                                    }
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: subroutines.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text('${subroutines[index].subname} - ${subroutines[index].subh}:${subroutines[index].submin}:${subroutines[index].subsec}'),
                            onTap: () {
                              // 탭 시, 시간과 이름 변경하는 다이얼로그 표시
                              _showEditDialog(index);
                            },
                          );
                        },
                      ),
                    ),
                    // + 버튼
                    ElevatedButton(
                      onPressed: () {
                        // + 버튼 눌렀을 때, 새로운 타이머 추가
                        _addSubroutine();
                      },
                      child: Text('Add Subroutiner'),
                    ),
                  ],
                );
              }
              ),


            actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 창닫기
                  },
                  child: Text('취소'),
                ),
                ElevatedButton(
                  child: Text('등록'),
                  onPressed: () {
                    setState(() {
                      String title = titleController.text;
                      String content = contentController.text;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
          backgroundColor: ColorSet['black'],
        );
      },
    );
  }

  void _addSubroutine() {
    subroutines.add(_subRoutine(subname: 'New Timer', subh: 0, submin: 0, subsec: 0));
    setState(() {});
  }


  // 타이머 편집 다이얼로그 표시
  void _showEditDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Timer'),
          content: Column(
            children: [
              // 이름 입력 필드
              TextField(
                onChanged: (value) {
                  subroutines[index].name = value;
                },
                decoration: InputDecoration(labelText: 'Name'),
              ),
              // 시간 입력 필드
              TextField(
                onChanged: (value) {
                  subroutines[index].hours = int.tryParse(value) ?? 0;
                },
                decoration: InputDecoration(labelText: 'Hours'),
              ),
              TextField(
                onChanged: (value) {
                  subroutines[index].minutes = int.tryParse(value) ?? 0;
                },
                decoration: InputDecoration(labelText: 'Minutes'),
              ),
              TextField(
                onChanged: (value) {
                  subroutines[index].seconds = int.tryParse(value) ?? 0;
                },
                decoration: InputDecoration(labelText: 'Seconds'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {});
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
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

  Widget bigBox(BuildContext context, dynamic routine, bool isSelected, int index) {
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
              children: isSelected
                  ? [
                ElevatedButton(
                    onPressed: (){
                        widget.onTap(0);
                        widget.changeRoutine(index);
                    },
                    child: Icon(Icons.start)
                )
              ]
                  :[
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
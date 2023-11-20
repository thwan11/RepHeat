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
      body: Container(
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
                  child: bigBox(context, routine['name']),
                ),
                if (selectedBoxIndex == index) ...subroutines.map((sub) {
                  return littleBox(context, sub['name']);
                }).toList(),
              ],
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.add, color: ColorSet['white']),
        backgroundColor: ColorSet['black'],
      ),
    );
  }

  Widget bigBox(BuildContext context, String title) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
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
                  fontSize: 32*ffem,
                  fontWeight: FontWeight.w400,
                  height: 1.2125*ffem/fem,
                  color: ColorSet['white']
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '1회 00:00:00',
                  style: TextStyle(
                      fontSize: 16*ffem,
                      fontWeight: FontWeight.w400,
                      height: 1.2125*ffem/fem,
                      color: ColorSet['white']
                  ),
                ),
                Text(
                  '전체 00:00:00',
                  style: TextStyle(
                      fontSize: 16*ffem,
                      fontWeight: FontWeight.w400,
                      height: 1.2125*ffem/fem,
                      color: ColorSet['white']
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget littleBox(BuildContext context, String subtitle) {
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
              subtitle, // '달리기' 대신에 제공된 subtitle 사용
              style: TextStyle(
                  fontSize: 16*ffem,
                  fontWeight: FontWeight.w400,
                  height: 1.2125*ffem/fem,
                  color: ColorSet['white']
              ),
            ),
            Text(
                '00:10:00',
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
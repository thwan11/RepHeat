// import 'package:flutter/material.dart';
// import 'ColorScheme.dart';
//
// class TimerList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorSet['gray'],
//       // body: _greetingWidget,
//       body: _greetingWidget,
//       floatingActionButton: FloatingActionButton(
//         onPressed: (){},
//         child: Icon(Icons.add, color: ColorSet['white']),
//         backgroundColor: ColorSet['black'],
//       ),
//     );
//   }
//
//   Widget get _greetingWidget {
//     return Text("TimerList", style: TextStyle(color: ColorSet['white']),);
//   }
// }
import 'package:flutter/material.dart';
import 'ColorScheme.dart';

class TimerList extends StatelessWidget {
  final List<String> routineNames; // Add a parameter to accept routine names

  TimerList({Key? key, required this.routineNames}) : super(key: key); // Initialize in constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSet['gray'],
      body: buildRoutineListView(), // Use a method to build the ListView
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.add, color: ColorSet['white']),
        backgroundColor: ColorSet['black'],
      ),
    );
  }

  Widget buildRoutineListView() {
    return ListView.builder(
      itemCount: routineNames.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(routineNames[index], style: TextStyle(color: ColorSet['white'])),
        );
      },
    );
  }
}
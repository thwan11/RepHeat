import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'ColorScheme.dart';
import 'package:table_calendar/table_calendar.dart';

import 'TimerList.dart';

class Statistics extends StatelessWidget {
  Map<String, dynamic> history;
  Statistics({required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSet['gray'],
      body: Container(
          alignment: Alignment.topCenter,
          child: TableCalendarScreen(history: history)
      ),
    );
  }

  Widget get _greetingWidget {
    return Text("Statistics", style: TextStyle(color: ColorSet['white']),);
  }
}

class TableCalendarScreen extends StatefulWidget {
  Map<String, dynamic> history;
  TableCalendarScreen({Key? key, required this.history}) : super(key: key);

  @override
  State<TableCalendarScreen> createState() => _TableCalendarScreenState();
}

class _TableCalendarScreenState extends State<TableCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;


  int _numberOfWeeksInMonth(DateTime date) {
    // Find the first day of the month
    DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);

    // Find the Sunday before the first day of the month
    DateTime startOfCalendarView = firstDayOfMonth.subtract(Duration(days: firstDayOfMonth.weekday % 7));

    // Find the last day of the month
    DateTime lastDayOfMonth = DateTime(date.year, date.month + 1, 0);

    // Find the Saturday after the last day of the month
    DateTime endOfCalendarView = lastDayOfMonth.add(Duration(days: DateTime.saturday - lastDayOfMonth.weekday % 7));

    // Calculate the number of days in the calendar view
    int daysInView = endOfCalendarView.difference(startOfCalendarView).inDays + 1;

    // Calculate the number of weeks
    return (daysInView / 7).ceil();
  }

  int? selectedBoxIndex;
  void handleBoxTap(int index) {
    setState(() {
      // Toggle selection
      selectedBoxIndex = selectedBoxIndex == index ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey _calendarKey = GlobalKey();
    int numberOfWeeks = _numberOfWeeksInMonth(_focusedDay);
    double calendarHeight = (numberOfWeeks == 6) ? 290.0 : 250.0;
    var log;
    if (_selectedDay != null) {
      log = widget.history[_selectedDay!.year.toString()]?[_selectedDay!.month.toString()]?[_selectedDay!.day.toString()];
      if (log is! List) {
        log = [];
      }
    }

    return Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 263,
                height: calendarHeight,
                child: TableCalendar(
                  key: _calendarKey,
                  shouldFillViewport: true,
                  locale: 'ko-KR',
                  firstDay: DateTime.utc(2000, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                      // Reassign the key to force a rebuild
                      _calendarKey = GlobalKey();
                    });
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_focusedDay, focusedDay)) {
                      setState(() {
                        _focusedDay = focusedDay;
                        _selectedDay = selectedDay;
                      });
                    }
                  },
                  focusedDay: _focusedDay,
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) => cellBuilder(context, day, focusedDay, false),
                    todayBuilder: (context, day, focusedDay) => cellBuilder(context, day, focusedDay, true),
                    outsideBuilder: (context, day, focusedDay) => cellBuilder(context, day, focusedDay, false),
                    disabledBuilder: (context, day, focusedDay) => cellBuilder(context, day, focusedDay, false),
                    dowBuilder: (context, day) {
                      return Center(child: Text(''));
                    },
                  ),

                  headerStyle: HeaderStyle(
                      titleCentered: true,
                      titleTextFormatter: (date, locale) => DateFormat('yyyy.MM').format(date),
                      formatButtonVisible: false,
                      titleTextStyle: TextStyle(
                        fontSize: 30.0,
                        color: ColorSet['white'],
                      ),
                      leftChevronIcon: Center(
                        child: Container(
                          width: 20,
                          height: 20,
                          alignment: Alignment.center, // This centers the icon within the container
                          decoration: BoxDecoration(
                            color: ColorSet['black'],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(Icons.chevron_left, color: ColorSet['white'], size: 15,),
                        ),
                      ),
                      leftChevronPadding: EdgeInsets.all(0),
                      rightChevronIcon: Center(
                        child: Container(
                          width: 20,
                          height: 20,
                          alignment: Alignment.center, // This centers the icon within the container
                          decoration: BoxDecoration(
                            color: ColorSet['black'],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(Icons.chevron_right, color: ColorSet['white'], size: 15,),
                        ),
                      ),
                      rightChevronPadding: EdgeInsets.all(0)
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(100, 2.0, 0, 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text('Less', style: TextStyle(color: ColorSet['white'], fontSize: 12),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Gradient1['0'],
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Gradient1['1'],
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Gradient1['2'],
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Gradient1['3'],
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Gradient1['4'],
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text('More', style: TextStyle(color: ColorSet['white'], fontSize: 12),),
                    ),
                  ],
                ),
              ),

              if (_selectedDay != null)
                Container(
                  // Your widget to display below the calendar
                    child: SingleChildScrollView( // Wrap with SingleChildScrollView
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          children: List<Widget>.generate(log.length, (index) {
                            var routine = log[index];
                            var subroutines = routine['subroutines'] as List<dynamic>;

                            TimerListState util = TimerListState();
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () => handleBoxTap(index),
                                  child: util.bigBox(context, routine, false, index)
                                ),
                                if (selectedBoxIndex == index) ...subroutines.map((sub) {
                                  // print('$selectedBoxIndex : $index');
                                  return util.littleBox(context, sub);
                                }).toList(),
                              ],
                            );
                          }),
                        ),
                      ),
                    )


                  // Text("Details for ${widget.history[_selectedDay!.year.toString()]?[_selectedDay!.month.toString()]?[_selectedDay!.day.toString()]}"),

                  // Implement more complex logic or additional widgets here
                ),
            ],
          ),
        )
    );
  }

  Widget cellBuilder(context, day, focusedDay, isToday) {
    String year = day.year.toString();
    String month = day.month.toString();
    String dayOfMonth = day.day.toString();

    // Determine the styling based on user history
    var log = widget.history[year]?[month]?[dayOfMonth];
    // Ensure the log is a list before proceeding.
    if (log is! List) {
      log = [];  // Default to an empty list if it's not a list.
    }

    int userActivity = log.length;

    Border? border = (isToday) ? Border.all(
        color: ColorSet['white']!,
        width: 2
    ) : null;

    // Apply different styles based on the activity level
    BoxDecoration boxDecoration;
    if (userActivity != null && userActivity > 0) {
      // Example: different color intensity based on activity level
      boxDecoration = BoxDecoration(
        color: Gradient1[(userActivity < 4) ? userActivity.toString() : '4'],
        borderRadius: BorderRadius.circular(5),
        border: border,
      );
    } else {
      // Default style for days with no activity
      boxDecoration = BoxDecoration(
        color: Gradient1['0'],
        borderRadius: BorderRadius.circular(5),
        border: border,
      );
    }

    return Container(
      margin: const EdgeInsets.all(1.0),
      decoration: boxDecoration,
      child: Container(
        width: 35,
        height: 35,
        padding: EdgeInsets.fromLTRB(4.5,3,0,0),
        child: Text(
          dayOfMonth,
          style: TextStyle(color: ColorSet['white'], fontSize: 10),
        ),
      ),
    );
  }
}
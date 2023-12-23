import 'dart:typed_data';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'ColorScheme.dart';
import 'package:table_calendar/table_calendar.dart';

import 'TimerList.dart';

class Statistics extends StatefulWidget {

  Map<String, dynamic> history;
  int jandi;

  Statistics({super.key, required this.history, required this.jandi});

  @override
  State<Statistics> createState() => StatisticsState();
}

class StatisticsState extends State<Statistics> {
  GlobalKey repaintBoundaryKey = GlobalKey();

  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();

    // Set up a listener
    AppTheme.onThemeChanged = () {
      // Trigger a rebuild whenever the theme changes
      setState(() {});
    };
  }

  @override
  void dispose() {
    // Clean up the listener when the widget is removed from the tree
    AppTheme.onThemeChanged = null;
    super.dispose();
  }

  Future<Uint8List> captureImage() async {
    RenderRepaintBoundary boundary = repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    return pngBytes;
  }

  Future<void> onShare(Uint8List pngBytes) async {
    try {
      // RenderRepaintBoundary boundary = repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      // var image = await boundary.toImage();
      // ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      // Uint8List pngBytes = byteData!.buffer.asUint8List();

      if (pngBytes != null) {
        final directory = await getTemporaryDirectory();
        final imagePath = await File('${directory.path}/statistics.png').create();
        await imagePath.writeAsBytes(pngBytes);

        Share.shareFiles([imagePath.path], text: 'Check out my statistics!');
      }
    } catch (e) {
      print("Error capturing long widget: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        backgroundColor: AppTheme.currentColorSet[1],
        body: SingleChildScrollView(
          child: RepaintBoundary(
            key: repaintBoundaryKey,
            child: Container(
                color: AppTheme.currentColorSet[1],
                alignment: Alignment.topCenter,
                child: TableCalendarScreen(history: widget.history, jandi: widget.jandi)
            ),
          ),
        ),
      ),
    );
  }

  Widget get _greetingWidget {
    return Text("Statistics", style: TextStyle(color: AppTheme.currentColorSet[2]),);
  }
}

class TableCalendarScreen extends StatefulWidget {
  Map<String, dynamic> history;
  int jandi;

  TableCalendarScreen({Key? key, required this.history, required this.jandi}) : super(key: key);

  @override
  State<TableCalendarScreen> createState() => _TableCalendarScreenState();
}

class _TableCalendarScreenState extends State<TableCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;


  int _numberOfWeeksInMonth(DateTime date) {
    DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
    DateTime startOfCalendarView = firstDayOfMonth.subtract(Duration(days: firstDayOfMonth.weekday % 7));
    DateTime lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
    DateTime endOfCalendarView = lastDayOfMonth.add(Duration(days: DateTime.saturday - lastDayOfMonth.weekday % 7));
    int daysInView = endOfCalendarView.difference(startOfCalendarView).inDays + 1;
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
  void initState() {
    super.initState();

    // Set up a listener
    AppTheme.onThemeChanged = () {
      // Trigger a rebuild whenever the theme changes
      setState(() {});
    };
  }

  @override
  void dispose() {
    // Clean up the listener when the widget is removed from the tree
    AppTheme.onThemeChanged = null;
    super.dispose();
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
                        color: AppTheme.currentColorSet[2],
                      ),
                      leftChevronIcon: Center(
                        child: Container(
                          width: 20,
                          height: 20,
                          alignment: Alignment.center, // This centers the icon within the container
                          decoration: BoxDecoration(
                            color: AppTheme.currentColorSet[0],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(Icons.chevron_left, color: AppTheme.currentColorSet[2], size: 15,),
                        ),
                      ),
                      leftChevronPadding: EdgeInsets.all(0),
                      rightChevronIcon: Center(
                        child: Container(
                          width: 20,
                          height: 20,
                          alignment: Alignment.center, // This centers the icon within the container
                          decoration: BoxDecoration(
                            color: AppTheme.currentColorSet[0],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(Icons.chevron_right, color: AppTheme.currentColorSet[2], size: 15,),
                        ),
                      ),
                      rightChevronPadding: EdgeInsets.all(0)
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 100),
                child: ColorList(true, widget.jandi),
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
        color: AppTheme.currentColorSet[2]!,
        width: 2
    ) : null;

    // Apply different styles based on the activity level
    BoxDecoration boxDecoration;
    if (userActivity != null && userActivity > 0) {
      // Example: different color intensity based on activity level
      boxDecoration = BoxDecoration(
        color: gradient[widget.jandi][(userActivity < 4) ? userActivity : 4],
        borderRadius: BorderRadius.circular(5),
        border: border,
      );
    } else {
      // Default style for days with no activity
      boxDecoration = BoxDecoration(
        color: gradient[widget.jandi][0],
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
          style: TextStyle(color: AppTheme.currentColorSet[2], fontSize: 10),
        ),
      ),
    );
  }
}
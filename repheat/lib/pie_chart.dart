import 'dart:math';
import 'package:flutter/material.dart';
import 'ColorScheme.dart';


class PieChart extends CustomPainter {
  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    String formattedTime = "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
    return formattedTime;
  }

  late dynamic nextsub;
  late int nexttime;
  double percentage = 0.0;
  double textScaleFactor = 1.0;
  Color textColor;
  int timenow;
  int time;
  int nowiter;
  int iter;


  PieChart({required this.time, required this.timenow, required this.percentage,required this.textScaleFactor,required this.textColor, required this.nextsub, required this.nowiter, required this.iter});

  @override
  void paint(Canvas canvas, Size size) {
    nexttime = nextsub['hour'] * 3600 + nextsub['minute'] * 60 + nextsub['second'];
    Paint paint = Paint()
        ..color = ColorSet['gray']!
        ..strokeWidth = 10.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;


    double radius = min(size.width / 2 - paint.strokeWidth / 2 , size.height / 2 - paint.strokeWidth/2);
    Offset center = Offset(size.width / 2, size.height/ 2);
    Paint blackCirclePaint = Paint()
      ..color = ColorSet['black']!
      ..style = PaintingStyle.fill; // 채우기 스타일

    // 검은색 원의 반지름은 기존 원의 반지름보다 작게 설정
    double blackCircleRadius = radius * 0.98;
    canvas.drawCircle(center, blackCircleRadius, blackCirclePaint);
    canvas.drawCircle(center, radius, paint);
    drawArc(paint, canvas, center, radius);
    int lasttime = time - timenow;
    drawText(canvas, size, lasttime);

  }

  void drawArc(Paint paint, Canvas canvas, Offset center, double radius) {
    if(percentage == 0){
      double arcAngle = 2 * pi * (0.01 / 100);
      paint..color = ColorSet['white']!;
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, arcAngle, false, paint);
    }else{
      double arcAngle = 2 * pi * (percentage / 100);
      paint..color = ColorSet['white']!;
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, arcAngle, false, paint);
    }

  }

  void drawText(Canvas canvas, Size size, int text) {
    double fontSize = getFontSize(size, formatTime(text));

    TextSpan sp = TextSpan(style: TextStyle(fontSize: fontSize+10, fontWeight: FontWeight.bold, color: ColorSet['white'], fontStyle: FontStyle.italic), text:  formatTime(text));
    TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);

    tp.layout();
    double dx = size.width / 2 - tp.width / 2;
    double dy = size.height / 2 - tp.height /2 ;

    Offset offset = Offset(dx, dy);
    tp.paint(canvas, offset);
//==========================================================================================

    TextSpan sp1 = TextSpan(style: TextStyle(fontSize: 25, color: ColorSet['white'], fontStyle: FontStyle.italic), text: nowiter.toString() + '/' + iter.toString());
    TextPainter tp1 = TextPainter(text: sp1, textDirection: TextDirection.ltr);

    tp1.layout();
    double dx1 = size.width / 2 - tp.width / 8;
    double dy1 = size.height / 3 - tp.height /15 ;

    Offset offset1 = Offset(dx1, dy1);
    tp1.paint(canvas, offset1);
//==========================================================================================

    TextSpan sp2 = TextSpan(style: TextStyle(fontSize: 25, color: ColorSet['gray'], fontStyle: FontStyle.italic), text: formatTime(nexttime));
    TextPainter tp2 = TextPainter(text: sp2, textDirection: TextDirection.ltr);

    tp2.layout();
    double dx2 = size.width / 2 - tp.width / 4;
    double dy2 = size.height/1.8 - tp.height/900000 ;

    Offset offset2 = Offset(dx2, dy2);
    tp2.paint(canvas, offset2);
  }

  double getFontSize(Size size, String text) {
    return size.width / text.length * textScaleFactor;
  }

  @override
  bool shouldRepaint(PieChart old) {
    return old.percentage != percentage;
  }
}
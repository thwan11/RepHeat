
import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'ColorScheme.dart';

class LayoutAppBar extends StatefulWidget {
  Function signIn;
  Function signOut;
  bool loggedIn;
  String email;
  int share;

  final Future<Uint8List?> Function()? onCapture;
  final Future<void> Function(Uint8List image)? onSharePressed;

  LayoutAppBar({super.key, required this.signIn, required this.signOut, required this.loggedIn, required this.email, required this.share, this.onCapture, this.onSharePressed});
  @override
  LayoutAppBarState createState() => LayoutAppBarState();
}

class LayoutAppBarState extends State<LayoutAppBar> {
  Uint8List? _imageFile;

  // Function to capture, show dialog, and share
  void captureAndShare() async {
    if (widget.onCapture != null) {
      // Await the capture function if it's provided
      _imageFile = await widget.onCapture!();
    }

    // Show dialog if image is captured
    if (_imageFile != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
              side: BorderSide(
                color: ColorSet['white']!,
                width: 1.0,
              ),
            ),
            backgroundColor: ColorSet['black'],
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Use min size for the dialog
                children: [
                  Image.memory(_imageFile!),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: ColorSet['white']),
                    onPressed: () {
                      // Call share function if provided and image is available
                      if (widget.onSharePressed != null) {
                        widget.onSharePressed!(_imageFile!);
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Share", style: TextStyle(color: ColorSet['black'])),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return AppBar(
      title: Row(
        children: [
          IconButton(
            onPressed: () {
              if (widget.loggedIn) {
                widget.signOut();
              } else {
                widget.signIn();
              }
            },
            icon: Icon(
              widget.loggedIn ? Icons.logout : Icons.login,
              color: ColorSet['white'],
            ),
          ),
          Text(widget.email, style: TextStyle(color: ColorSet['white'], fontSize: 13*ffem),),
          const Spacer(),
          if(widget.share == 2)
            IconButton(
              onPressed: captureAndShare,
              icon: Icon(Icons.share, color: ColorSet['white']),
            ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings, color: ColorSet['white']),
          ),
        ],
      ),
      backgroundColor: ColorSet['gray'],
      elevation: 0.0,
    );
  }

}


class LayoutBottomNavigationBar extends StatefulWidget {
  int currentIndex;
  bool isVisible = true;

  final Function(int) onTap;
  LayoutBottomNavigationBarState createState() => LayoutBottomNavigationBarState();

  LayoutBottomNavigationBar({super.key, required this.currentIndex, required this.onTap});
}

class LayoutBottomNavigationBarState extends State<LayoutBottomNavigationBar> {
  bool isVisible = true; // 초기 가시성 상태

  // 가시성을 토글하는 메소드
  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> iconColors = [ColorSet['gray'], ColorSet['gray'], ColorSet['gray']];
    iconColors[widget.currentIndex] = ColorSet['white'];
    return isVisible ? BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.timer_outlined, color: iconColors[0], ), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.storage_outlined, color: iconColors[1]), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.show_chart_outlined, color: iconColors[2],), label: '')
      ],
      backgroundColor: ColorSet['black'],
    ): SizedBox.shrink();
  }

}
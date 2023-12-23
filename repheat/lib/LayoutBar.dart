
import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'ColorScheme.dart';
import 'package:http/http.dart' as http;


class LayoutAppBar extends StatefulWidget {
  Function signIn;
  Function signOut;
  bool loggedIn;
  String email;
  int share;

  final Future<Uint8List?> Function()? onCapture;
  final Future<void> Function(Uint8List image)? onSharePressed;
  final Function(int) onJandiChanged;

  final Function loaddb;
  final Function writedb;
  final Function makedb;

  final Function fetch;
  final Function upload;

  LayoutAppBar({super.key, required this.signIn, required this.signOut, required this.loggedIn, required this.email, required this.share, this.onCapture, this.onSharePressed, required this.onJandiChanged, required this.loaddb, required this.writedb, required this.makedb, required this.fetch, required this.upload});
  @override
  LayoutAppBarState createState() => LayoutAppBarState();
}

class LayoutAppBarState extends State<LayoutAppBar> {
  Uint8List? _imageFile;
  int jandi = 0;
  int theme = 0;

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
                color: AppTheme.currentColorSet[2]!,
                width: 1.0,
              ),
            ),
            backgroundColor: AppTheme.currentColorSet[1],
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Use min size for the dialog
                children: [
                  Text('공유', style: TextStyle(color: AppTheme.currentColorSet[2], fontSize: 30)),
                  Image.memory(_imageFile!),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.currentColorSet[2]),
                    onPressed: () {
                      // Call share function if provided and image is available
                      if (widget.onSharePressed != null) {
                        widget.onSharePressed!(_imageFile!);
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Share", style: TextStyle(color: AppTheme.currentColorSet[0])),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  void setting() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(
              color: AppTheme.currentColorSet[2]!,
              width: 1.0,
            ),
          ),
          backgroundColor: AppTheme.currentColorSet[0],
          content: Column(
            mainAxisSize: MainAxisSize.min, // Use min size for the dialog
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: Text('설정', style: TextStyle(color: AppTheme.currentColorSet[2], fontSize: 30)),
              ),
              Text('백업파일', style: TextStyle(color: AppTheme.currentColorSet[2], fontSize: 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.currentColorSet[2]),
                      onPressed: () {
                        setState(() {
                          widget.writedb();
                          widget.upload(widget.email);
                        });
                        Navigator.pop(context);
                      },
                      child: Text("저장하기", style: TextStyle(color: AppTheme.currentColorSet[0])),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.currentColorSet[2]),
                      onPressed: () {
                        setState(() {
                          widget.fetch(widget.email);
                          widget.loaddb();
                        });
                        Navigator.pop(context);
                      },
                      child: Text("불러오기", style: TextStyle(color: AppTheme.currentColorSet[0])),
                    ),
                  )
                ],
              ),

              Text('테마', style: TextStyle(color: AppTheme.currentColorSet[2], fontSize: 20)),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('메인 테마', style: TextStyle(color: AppTheme.currentColorSet[2], fontSize: 20)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                            onTap: (){
                              AppTheme.changeTheme(0); // Change to the second theme
                              setState(() {
                              });
                            },
                            child: ColorList(false, 0)
                        ),
                        InkWell(
                            onTap: (){
                              AppTheme.changeTheme(1);// Change to the second theme
                              setState(() {
                              });
                            },
                            child: ColorList(false, 1)
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('달력 잔디', style: TextStyle(color: AppTheme.currentColorSet[2], fontSize: 20)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                          onTap: (){
                            setState(() {
                              jandi = 0;
                            });
                            widget.onJandiChanged(jandi);
                          },
                          child: ColorList(false, 0)
                      ),
                      InkWell(
                          onTap: (){
                            setState(() {
                              jandi = 1;
                            });
                            widget.onJandiChanged(jandi);
                          },
                          child: ColorList(false, 1)
                      ),
                      InkWell(
                          onTap: (){
                            setState(() {
                              jandi = 2;
                            });
                            widget.onJandiChanged(jandi);
                          },
                          child: ColorList(false, 2)
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        );
      },
    );
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
              color: colorSet[0][2],
            ),
          ),
          Text(widget.email, style: TextStyle(color: colorSet[0][2], fontSize: 13*ffem),),
          const Spacer(),
          if(widget.share == 2)
            IconButton(
              onPressed: captureAndShare,
              icon: Icon(Icons.share, color: colorSet[0][2]),
            ),
          IconButton(
            onPressed: setting,
            icon: Icon(Icons.settings, color: colorSet[0][2]),
          ),
        ],
      ),
      backgroundColor: AppTheme.currentColorSet[1],
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
    List<dynamic> iconColors = [AppTheme.currentColorSet[1], AppTheme.currentColorSet[1], AppTheme.currentColorSet[1]];
    iconColors[widget.currentIndex] = AppTheme.currentColorSet[2];
    return isVisible ? BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.timer_outlined, color: iconColors[0], ), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.storage_outlined, color: iconColors[1]), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.show_chart_outlined, color: iconColors[2],), label: '')
      ],
      backgroundColor: AppTheme.currentColorSet[0],
    ): SizedBox.shrink();
  }


}
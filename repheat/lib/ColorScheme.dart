import 'dart:ui';

import 'package:flutter/material.dart';

List<List<Color>> colorSet = [
  [
    Color(0xFF181818),
    Color(0xFF313131),
    Color(0xFFDDDDDD)
  ],
  [
    Color(0xFFDEFE1D),
    Color(0xFF313131),
    Color(0xFF181818)
  ],

];

class AppTheme {
  static int currentThemeIndex = 0; // default to first theme

  static List<List<Color>> colorSets = [
    [
      Color(0xFF181818),
      Color(0xFF313131),
      Color(0xFFDDDDDD)
    ],
    [
      Color(0xFFDEFE1D),
      Color(0xFF313131),
      Color(0xFF181818)
    ],
  ];

  static VoidCallback? onThemeChanged;

  // Function to change the theme
  static void changeTheme(int index) {
    currentThemeIndex = index;
    onThemeChanged?.call();
  }

  static List<Color> get currentColorSet => colorSets[currentThemeIndex];
}

List<List<Color>> gradient = [
  [
    Color(0xFF151B22),
    Color(0xFF0E4429),
    Color(0xFF016D32),
    Color(0xFF27A642),
    Color(0xFF3AD354)
  ],
  [
    Color(0xFF151B22),
    Color(0xFF5B210C),
    Color(0xFFB05C2D),
    Color(0xFFEA8137),
    Color(0xFFF8E07A),
  ],
  [
    Color(0xFF151B22),
    Color(0xFF152F65),
    Color(0xFF2E67D3),
    Color(0xFF6BACF8),
    Color(0xFFBFE2FC),
  ]
];

Widget ColorList(bool label, int gradNum) {
  return Container(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(0, 2.0, 0, 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(label)
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text('Less', style: TextStyle(color: AppTheme.currentColorSet[2], fontSize: 12),),
            ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: gradient[gradNum][0],
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
                color: gradient[gradNum][1],
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
                color: gradient[gradNum][2],
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
                color: gradient[gradNum][3],
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
                color: gradient[gradNum][4],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          if(label)
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text('More', style: TextStyle(color: AppTheme.currentColorSet[2], fontSize: 12),),
            ),
        ],
      ),
    ),
  );
}
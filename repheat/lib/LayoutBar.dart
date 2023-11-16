import 'package:flutter/material.dart';
import 'ColorScheme.dart';

class LayoutAppBar extends StatelessWidget {
  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.login, color: ColorSet['white'],)
          ),
          Spacer(),
          IconButton(
              onPressed: (){},
              icon: Icon(Icons.settings, color: ColorSet['white'],)
          ),
        ],
      ),
      backgroundColor: ColorSet['gray'],
      elevation: 0.0,
    );
  }

  PreferredSizeWidget toPreferredSizeWidget(BuildContext context) {
    return build(context);
  }
}
class LayoutBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.timer_outlined, color: ColorSet['white'], ), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.storage_outlined, color: ColorSet['white'],), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.show_chart_outlined, color: ColorSet['white'],), label: '')
      ],
      backgroundColor: ColorSet['black'],
    );
  }
  
}
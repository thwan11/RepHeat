import 'package:flutter/material.dart';
import 'ColorScheme.dart';

class LayoutAppBar extends StatefulWidget {
  Function signIn;
  Function signOut;
  bool loggedIn;
  String email;
  LayoutAppBar({required this.signIn, required this.signOut, required this.loggedIn, required this.email});
  @override
  _LayoutAppBarState createState() => _LayoutAppBarState();
}

class _LayoutAppBarState extends State<LayoutAppBar> {
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
          Spacer(),
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

// class LayoutAppBar extends StatelessWidget {
//   @override
//   PreferredSizeWidget build(BuildContext context) {
//     return AppBar(
//       title: Row(
//         children: [
//           IconButton(
//             onPressed: signIn,
//             icon: Icon(Icons.login, color: ColorSet['white'],)
//           ),
//           Spacer(),
//           IconButton(
//               onPressed: (){},
//               icon: Icon(Icons.settings, color: ColorSet['white'],)
//           ),
//         ],
//       ),
//       backgroundColor: ColorSet['gray'],
//       elevation: 0.0,
//     );
//   }
//
//   Future signIn() async {
//     final user = await GoogleSignInApi.login();
//     print(user?.email);
//   }
//
//   PreferredSizeWidget toPreferredSizeWidget(BuildContext context) {
//     return build(context);
//   }
// }

class LayoutBottomNavigationBar extends StatefulWidget {
  int currentIndex;
  final Function(int) onTap;

  LayoutBottomNavigationBar({required this.currentIndex, required this.onTap});

  @override
  _LayoutBottomNavigationBarState createState() => _LayoutBottomNavigationBarState();
}

class _LayoutBottomNavigationBarState extends State<LayoutBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> iconColors = [ColorSet['gray'], ColorSet['gray'], ColorSet['gray']];
    iconColors[widget.currentIndex] = ColorSet['white'];
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.timer_outlined, color: iconColors[0], ), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.storage_outlined, color: iconColors[1]), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.show_chart_outlined, color: iconColors[2],), label: '')
      ],
      backgroundColor: ColorSet['black'],
    );
  }
  
}
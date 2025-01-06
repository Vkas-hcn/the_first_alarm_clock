import 'package:flutter/material.dart';
import 'package:the_first_alarm_clock/home/Home.dart';
import 'package:the_first_alarm_clock/set/SettingPaper.dart';
import 'package:the_first_alarm_clock/statistics/Statistics.dart';
import 'package:the_first_alarm_clock/target/Target.dart';

import 'data/TaskBean.dart';

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
       Home(onTap: _onItemTapped),
      const Target(),
      const SettingPaper(),
    ];
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFF3C1D1A),
        body: Column(
          children: [
            Expanded(
              child: _pages[_selectedIndex],
            ),
            BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Color(0xFF3C1D1A),
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Image.asset(
                    width: 32,
                    height: 32,
                    _selectedIndex == 0
                        ? 'assets/img/icon_home.webp'
                        : 'assets/img/icon_home_2.webp',
                    fit: BoxFit.contain,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    width: 32,
                    height: 32,
                    _selectedIndex == 1
                        ? 'assets/img/icon_target.webp'
                        : 'assets/img/icon_target_2.webp',
                    fit: BoxFit.contain,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    width: 32,
                    height: 32,
                    _selectedIndex ==2
                        ? 'assets/img/icon_set.webp'
                        : 'assets/img/icon_set_2.webp',
                    fit: BoxFit.contain,
                  ),
                  label: '',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Color(0xFFFFD857),
              unselectedItemColor: Color(0xFF7D3D36),
              onTap: _onItemTapped,
            ),
          ],
        ),
      ),
    );
  }
}



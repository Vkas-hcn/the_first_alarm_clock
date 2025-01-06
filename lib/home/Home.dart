import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:the_first_alarm_clock/clock/ClockPage.dart';
import 'package:the_first_alarm_clock/countdown/CountdownPage.dart';
import 'package:the_first_alarm_clock/data/TimerUtils.dart';
import 'package:the_first_alarm_clock/focus/FocusRest.dart';
import 'package:the_first_alarm_clock/positive/PositionPage.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:share_plus/share_plus.dart';

import '../data/LocalStorage.dart';
import '../data/TaskBean.dart';

class Home extends StatelessWidget {
  final Function(int) onTap;
  const Home({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: HomeScreen(onTap: onTap),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final Function(int) onTap;
  const HomeScreen({super.key, required this.onTap});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String focusTime = '25';

  @override
  void initState() {
    super.initState();
    getTaskListData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void jumpToFR(bool isFocus) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FocusRest(
                isFocus: isFocus,
                timeData: 0,
                taskId: '',
              )),
    ).then((value) {
      getTaskListData();
    });
  }

  void jumpToClock() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ClockPage()),
    ).then((value) {});
  }

  void jumpToPosition() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PositionPage()),
    ).then((value) {});
  }

  void jumpToCountdown() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CountdownPage()),
    ).then((value) {});
  }



  List<TaskBean> taskBeans = [];
  double totalTotalTime = 0;
  String totalUserTimeH = "0";
  String totalUserTimeM = "0";
  String userTimeRatio = "0.0";

  void getTaskListData() async {
    int date = await LocalStorage().getFocusData();
    print("getFoucsTime====${date}");
    focusTime = date.toString();
    taskBeans = await TaskBean.loadTasks();
    List<TaskBean> taskBeansFast = await TaskBean.loadTasks(isFast: true);

    final String jsonData =
        jsonEncode(taskBeans.map((task) => task.toJson()).toList());
    print("getTaskListData=${jsonData}");
    Map<String,dynamic> calculateTimeData = TaskBean.calculateDailyTimeStats(taskBeans,taskBeansFast);
    totalTotalTime = calculateTimeData['totalTotalTime'].toDouble();
    totalUserTimeH = TimerUtils.timestampToTimeString(calculateTimeData['totalUserTime'])['hoursStr'] ?? '00';
    totalUserTimeM = TimerUtils.timestampToTimeString((calculateTimeData)['totalUserTime'])['minutesStr'] ?? '00';
    print("totalUserTime=${calculateTimeData['totalUserTime']}");
    print("totalTotalTime=${calculateTimeData['totalTotalTime']}");

    if (totalTotalTime > 0) {
      userTimeRatio =
          (calculateTimeData['totalUserTime'] / (totalTotalTime*60)*100).toStringAsFixed(2);
    } else {
      userTimeRatio = "0.0";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop();
            return false;
          },
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/ic_guide.webp'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(width: 16),
                Text(
                  'App Name',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'plus',
                    fontSize: 20,
                    color: Color(0xFFFFD757),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 133,
                            height: 24,
                            child: Image.asset('assets/img/ic_txt_2.webp'),
                          ),
                           Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                totalUserTimeH,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'sf',
                                  fontSize: 32,
                                  color: Color(0xFFFFD757),
                                ),
                              ),
                              const SizedBox(width: 3),
                              const Text(
                                'h',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 3),
                              Text(
                                totalUserTimeM,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'sf',
                                  fontSize: 32,
                                  color: Color(0xFFFFD757),
                                ),
                              ),
                              const SizedBox(width: 3),
                              const Text(
                                'm',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 94,
                            height: 24,
                            child: Image.asset('assets/img/ic_txt_1.webp'),
                          ),
                           Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                userTimeRatio,
                                textAlign: TextAlign.center,
                                style:const TextStyle(
                                  fontFamily: 'sf',
                                  fontSize: 32,
                                  color: Color(0xFFFFD757),
                                ),
                              ),
                              const SizedBox(width: 3),
                              const Text(
                                '%',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontFamily: 'sf',
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 186,
                    height: 152,
                    child: Image.asset('assets/img/ic_home_top.webp'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 193,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/img/bg_home_2.webp"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Center(
                child: Text(
                  '${focusTime}:00',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'sf',
                    fontSize: 68,
                    color: Color(0xFFFFD757),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        jumpToFR(true);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFC45618),
                            width: 2,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xBD03051C),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Text(
                          'Quick Start',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'sf',
                            fontSize: 16,
                            color: Color(0xFFFFDF7A),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        widget.onTap(1);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFFC45618),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xBD03051C),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          'View Goals',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'sf',
                            fontSize: 16,
                            color: Color(0xFFFFDF7A),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        jumpToClock();
                      },
                      child: Container(
                        height: 113,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/img/bg_home_1.webp"),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Clock',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'sf',
                                      fontSize: 14,
                                      color: Color(0xFFFFDF7A),
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Image.asset(
                                        'assets/img/icon_clock.webp'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        jumpToPosition();
                      },
                      child: Container(
                        height: 113,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/img/bg_home_1.webp"),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Count Up\nTimer',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontFamily: 'sf',
                                      fontSize: 14,
                                      color: Color(0xFFFFDF7A),
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Image.asset(
                                        'assets/img/icon_count_up_timer.webp'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        jumpToCountdown();
                      },
                      child: Container(
                        height: 113,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/img/bg_home_1.webp"),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Countdown\nTimer",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontFamily: 'sf',
                                      fontSize: 14,
                                      color: Color(0xFFFFDF7A),
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Image.asset(
                                        'assets/img/icon_countdown_timer.webp'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

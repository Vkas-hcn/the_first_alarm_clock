import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:share_plus/share_plus.dart';

import '../MainApp.dart';
import '../data/LocalStorage.dart';
import 'FocusRest.dart';

class FocusFinish extends StatelessWidget {
  final bool isFinish;
  final bool isRestSuccess;
  final String finishTime;
  final int timeData;
  final String taskId;

  const FocusFinish(
      {super.key,
      required this.isFinish,
      required this.isRestSuccess,
      required this.finishTime,
      required this.timeData,
      required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FocusFinishScreen(
          isFinish: isFinish,
          isRestSuccess: isRestSuccess,
          finishTime: finishTime,
          timeData: timeData,
          taskId: taskId),
    );
  }
}

class FocusFinishScreen extends StatefulWidget {
  final bool isFinish;
  final bool isRestSuccess;
  final String finishTime;
  final int timeData;
  final String taskId;

  const FocusFinishScreen(
      {super.key,
      required this.isFinish,
      required this.isRestSuccess,
      required this.finishTime,
      required this.timeData,
      required this.taskId});

  @override
  _FocusFinishScreenState createState() => _FocusFinishScreenState();
}

class _FocusFinishScreenState extends State<FocusFinishScreen>
    with SingleTickerProviderStateMixin {
  int timeDjs = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getFocusRestTime() async {
    timeDjs = await LocalStorage().getRestData();
  }

  void restartFocus() async {
    if (widget.isFinish && widget.isRestSuccess) {
      print("restartFocus-1");
      jumpToFR(true);
    }
    if (widget.isFinish && !widget.isRestSuccess) {
      print("restartFocus-2");
      jumpToFR(false);
    }
    if (!widget.isFinish) {
      print("restartFocus-3");
      Navigator.of(context).pop();
    }
  }

  void backRestartFocus() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                (MainApp(selectedIndex: widget.taskId.isEmpty ? 0 : 1))));
  }

  void jumpToFR(bool isFocus) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FocusRest(
              isFocus: isFocus,
              timeData: widget.timeData,
              taskId: widget.taskId)),
    ).then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
      onWillPop: () async {
        backRestartFocus();
        return false;
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/ic_guide.webp'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 50),
            Row(
              children: [
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    backRestartFocus();
                  },
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: Image.asset(
                      'assets/img/ic_back.webp',
                    ),
                  ),
                ),
                Spacer()
              ],
            ),
            SizedBox(height: 62),
            SizedBox(
              width: 150,
              height: 150,
              child: Image.asset(widget.isFinish
                  ? 'assets/img/ic_finish_sm.webp'
                  : 'assets/img/ic_unfinish_sm.webp'),
            ),
            Text(
              widget.isFinish
                  ? widget.isRestSuccess
                      ? "This Break Duration"
                      : "Great Job!"
                  : "Focus Time for This Session",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 32),
            Text(
              widget.finishTime,
              style: TextStyle(
                fontFamily: 'sf',
                fontWeight: FontWeight.w700,
                color: Color(0xFFFFA407),
                fontSize: 44,
              ),
            ),
            SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                widget.isFinish
                    ? widget.isRestSuccess
                        ? "Break Time Over! Fully Recharged! Ready to Take on the Next Challenge!"
                        : "You’ve completed this focus session, now take a break!"
                    : "This focus session failed. Do you want to return and continue the current focus?",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFCDCDCD),
                  fontSize: 14,
                ),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                restartFocus();
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 52),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFC35010),
                  borderRadius: BorderRadius.circular(75),
                ),
                child: Text(
                  widget.isFinish
                      ? widget.isRestSuccess
                          ? "Start Focus"
                          : "Rest"
                      : "Continue",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                backRestartFocus();
              },
              child: Text(
                widget.isFinish ? "No break，start again" : "Exit",
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFF09428),
                  fontSize: 15,
                  //下划线
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    ));
  }
}

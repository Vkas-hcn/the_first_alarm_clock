import 'dart:async';
import 'package:flutter/material.dart';

import '../MainApp.dart';
import '../data/LocalStorage.dart';

class Start extends StatelessWidget {
  const Start({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: StartScreen(),
    );
  }
}

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  double _progress = 0.0;
  Timer? _timerProgress;
  bool restartState = false;
  final Duration checkInterval = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startProgress();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _startProgress() {
    const int totalDuration = 2000;
    const int updateInterval = 50;
    const int totalUpdates = totalDuration ~/ updateInterval;
    int currentUpdate = 0;
    _progress = 0.0;
    _timerProgress =
        Timer.periodic(const Duration(milliseconds: updateInterval), (timer) {
          setState(() {
            _progress = (currentUpdate + 1) / totalUpdates;
          });
          currentUpdate++;
          if (currentUpdate >= totalUpdates) {
            _timerProgress?.cancel();
            pageToHome();
          }
        });
  }

  void pageToHome() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
            ( MainApp(selectedIndex: 0,) )),
            (route) => route == null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/img/ic_guide.webp"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  const Text(
                    'APP Name',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: 'sh',
                      fontSize: 32,
                      color: Color(0xFFFFDF7A),
                    ),
                  ),
                  SizedBox(height: 52),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 98, right: 72, left: 72),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ProgressBar(
                            progress: _progress,
                            // Set initial progress here
                            height: 12,
                            borderRadius: 6,
                            progressColor: Color(0xFFF7AC1E),
                            bgImagePath: 'assets/img/icon_pro.webp',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProgressBar extends StatelessWidget {
  final double progress;
  final double height;
  final double borderRadius;
  final Color progressColor;
  final String bgImagePath;
  ProgressBar({
    required this.progress,
    required this.height,
    required this.borderRadius,
    required this.progressColor,
    required this.bgImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        image:  DecorationImage(
          image: AssetImage(bgImagePath),
          fit: BoxFit.cover,
        ),      ),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: height,
            padding: EdgeInsets.all(3),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

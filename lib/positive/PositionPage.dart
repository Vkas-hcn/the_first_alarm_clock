import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/TimerUtils.dart';
import '../wight/BottomSheetWithInput.dart';

class PositionPage extends StatelessWidget {
  const PositionPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PositionPageScreen(),
    );
  }
}

class PositionPageScreen extends StatefulWidget {
  const PositionPageScreen({super.key});

  @override
  _PositionPageScreenState createState() => _PositionPageScreenState();
}

class _PositionPageScreenState extends State<PositionPageScreen>
    with SingleTickerProviderStateMixin {
  bool isPortrait = true;
  String hoursData = "00";
  String minutesData = "00";
  String secondsData = "00";
  Timer? _timeUpdateTimer;
  int _elapsedSeconds = 0;
  @override
  void initState() {
    super.initState();
    setNowTime();
  }

  @override
  void dispose() {
    super.dispose();
    _timeUpdateTimer?.cancel();
  }

  void setNowTime() async {
    _timeUpdateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
        updateFormattedTime();
      });    });
  }

  void updateFormattedTime() {
    int hours = (_elapsedSeconds ~/ 3600) % 24;
    int minutes = (_elapsedSeconds ~/ 60) % 60;
    int seconds = _elapsedSeconds % 60;

    hoursData = hours.toString().padLeft(2, '0');
    minutesData = minutes.toString().padLeft(2, '0');
    secondsData = seconds.toString().padLeft(2, '0');
  }
  /// 切换屏幕方向和 UI
  void switchingScreens() {
    setState(() {
      isPortrait = !isPortrait;
    });

    // 设置屏幕方向
    if (isPortrait) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
      onWillPop: () async {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        Navigator.pop(context);
        return false;
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/bg_fr.webp'),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const BouncingScrollPhysics(),
          child: isPortrait ? _buildPortraitUI() : _buildLandscapeUI(),
        ),
      ),
    ));
  }

  Widget _buildPortraitUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(height: 40),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                Navigator.pop(context);
              },
              child: SizedBox(
                  width: 32,
                  height: 32,
                  child: Image.asset('assets/img/ic_back.webp')),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                switchingScreens();
              },
              child: SizedBox(
                width: 32,
                height: 32,
                child: Image.asset('assets/img/ic_hav.webp'),
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
        const SizedBox(height: 40),
        const SizedBox(height: 32),
        Container(
          width: 276,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/bg_djs.webp'),
              fit: BoxFit.fill,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  const SizedBox(height: 2),
                  SizedBox(
                    width: 269,
                    height: 94,
                    child: Image.asset('assets/img/bg_djs_t.webp'),
                  ),
                  SizedBox(
                    width: 269,
                    height: 94,
                    child: Image.asset('assets/img/bg_djs_b.webp'),
                  ),
                  SizedBox(height: 4),
                ],
              ),
              Text(
                hoursData == "00" ? minutesData : hoursData,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 130,
                  fontFamily: 'sf',
                  color: Color(0xFFFFD757),
                ),
              ),
              SizedBox(
                width: 270,
                height: 67,
                child: Image.asset('assets/img/ic_line.webp'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Container(
          width: 276,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/bg_djs.webp'),
              fit: BoxFit.fill,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  SizedBox(height: 2),
                  SizedBox(
                    width: 269,
                    height: 94,
                    child: Image.asset('assets/img/bg_djs_t.webp'),
                  ),
                  SizedBox(
                    width: 269,
                    height: 94,
                    child: Image.asset('assets/img/bg_djs_b.webp'),
                  ),
                  SizedBox(height: 4),
                ],
              ),
              Text(
                hoursData == "00"
                    ? secondsData.toString()
                    : minutesData.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 130,
                  fontFamily: 'sf',
                  color: Color(0xFFFFD757),
                ),
              ),
              SizedBox(
                width: 270,
                height: 67,
                child: Image.asset('assets/img/ic_line.webp'),
              ),
              if (hoursData != "00")
                Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  width: 46,
                  height: 22,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8A3E18),
                    borderRadius: const BorderRadius.all(Radius.circular(11)),
                    border: Border.all(
                      color: Color(0xFF8A3E18),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    secondsData,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildLandscapeUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(height: 40),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(width: 20),
            GestureDetector(
              onTap: () {
                SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                Navigator.pop(context);
              },
              child: SizedBox(
                  width: 32,
                  height: 32,
                  child: Image.asset('assets/img/ic_back.webp')),
            ),
            Expanded(flex: 1, child: Container()),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: () {
                switchingScreens();
              },
              child: SizedBox(
                width: 32,
                height: 32,
                child: Image.asset(
                  'assets/img/ic_hav.webp',
                ),
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
        const SizedBox(height: 29),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 276,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/img/bg_djs.webp'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 2),
                            SizedBox(
                              width: 269,
                              height: 94,
                              child: Image.asset('assets/img/bg_djs_t.webp'),
                            ),
                            SizedBox(
                              width: 269,
                              height: 94,
                              child: Image.asset('assets/img/bg_djs_b.webp'),
                            ),
                            SizedBox(height: 4),
                          ],
                        ),
                        Text(
                          hoursData == "00" ? minutesData : hoursData,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 130,
                            fontFamily: 'sf',
                            color: Color(0xFFFFD757),
                          ),
                        ),
                        SizedBox(
                          width: 270,
                          height: 67,
                          child: Image.asset('assets/img/ic_line.webp'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 276,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/img/bg_djs.webp'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 2),
                            SizedBox(
                              width: 269,
                              height: 94,
                              child: Image.asset('assets/img/bg_djs_t.webp'),
                            ),
                            SizedBox(
                              width: 269,
                              height: 94,
                              child: Image.asset('assets/img/bg_djs_b.webp'),
                            ),
                            SizedBox(height: 4),
                          ],
                        ),
                        Text(
                          hoursData == "00"
                              ? secondsData.toString()
                              : minutesData.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 130,
                            fontFamily: 'sf',
                            color: Color(0xFFFFD757),
                          ),
                        ),
                        SizedBox(
                          width: 270,
                          height: 67,
                          child: Image.asset('assets/img/ic_line.webp'),
                        ),
                        if (hoursData != "00")
                          Positioned(
                          bottom: 12,
                          right: 12,
                          child: Container(
                            width: 46,
                            height: 22,
                            decoration: BoxDecoration(
                              color: const Color(0xFF8A3E18),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(11)),
                              border: Border.all(
                                color: Color(0xFF8A3E18),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              secondsData,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

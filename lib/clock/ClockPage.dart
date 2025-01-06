import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/TimerUtils.dart';

class ClockPage extends StatelessWidget {
  const ClockPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ClockPageScreen(),
    );
  }
}

class ClockPageScreen extends StatefulWidget {
  const ClockPageScreen({super.key});

  @override
  _ClockPageScreenState createState() => _ClockPageScreenState();
}

class _ClockPageScreenState extends State<ClockPageScreen>
    with SingleTickerProviderStateMixin {
  bool isPortrait = true; // 标识当前屏幕方向
  String monthAndDay = "-";
  String hoursData = "00";
  String minutesData = "00";
  String secondsData = "00";
  String amorpm = "AM";
  Timer? _timeUpdateTimer;

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

  void getTime() async {
    final formattedTime = TimerUtils.getCurrentTimeFormatted();
    setState(() {
      monthAndDay = formattedTime['monthDay'] ?? '-';
      hoursData = formattedTime['hour'] ?? "00";
      minutesData = formattedTime['minute'] ?? "00";
      secondsData = formattedTime['second'] ?? "00";
      amorpm = formattedTime['amPm'] ?? "-";
    });
  }

  void setNowTime() async {
    _timeUpdateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      getTime();
    });
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
        await SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp]);
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

  Widget _buildText() {
    return Text(monthAndDay,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Color(0xFFFFD757),
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
                SystemChrome.setPreferredOrientations(
                    [DeviceOrientation.portraitUp]);
                Navigator.pop(context);
              },
              child: SizedBox(
                  width: 32,
                  height: 32,
                  child: Image.asset('assets/img/ic_back.webp')),
            ),
            Spacer(),
            SizedBox(width: 20),
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
            SizedBox(width: 20),
          ],
        ),
        const SizedBox(height: 40),
        Container(
          width: 275,
          height: 40,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/bg_focusing.webp'),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: _buildText(),
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
                hoursData,
                textAlign: TextAlign.center,
                style: TextStyle(
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
                minutesData,
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
              Positioned(
                bottom: 12,
                left: 12,
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
                    amorpm,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
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
                SystemChrome.setPreferredOrientations(
                    [DeviceOrientation.portraitUp]);
                Navigator.pop(context);
              },
              child: SizedBox(
                  width: 32,
                  height: 32,
                  child: Image.asset('assets/img/ic_back.webp')),
            ),
            Expanded(flex: 1, child: Container()),
            Expanded(
              child: Container(
                width: 293,
                height: 41,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/img/bg_focusing.webp'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Center(
                  child: _buildText(),
                ),
              ),
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
                          hoursData,
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
                        Positioned(
                          bottom: 12,
                          left: 12,
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
                              amorpm,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
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
                          minutesData,
                          textAlign: TextAlign.center,
                          style: TextStyle(
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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_first_alarm_clock/data/TaskBean.dart';
import 'package:the_first_alarm_clock/focus/FocusFinish.dart';

import '../data/LocalStorage.dart';
import '../data/TimerUtils.dart';
import '../start/Start.dart';
import '../wight/BottomSheetWithInput.dart';

class FocusRest extends StatelessWidget {
  final bool isFocus;
  final int timeData;
  final String taskId;

  const FocusRest(
      {super.key,
      required this.isFocus,
      required this.timeData,
      required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FocusRestScreen(
        isFocus: isFocus,
        timeData: timeData,
        taskId: taskId,
      ),
    );
  }
}

class FocusRestScreen extends StatefulWidget {
  final bool isFocus;
  final int timeData;
  final String taskId;

  const FocusRestScreen(
      {super.key,
      required this.isFocus,
      required this.timeData,
      required this.taskId});

  @override
  _FocusRestScreenState createState() => _FocusRestScreenState();
}

class _FocusRestScreenState extends State<FocusRestScreen>
    with SingleTickerProviderStateMixin {
  bool isPortrait = true; // 标识当前屏幕方向
  int skinInt = 1;
  String hoursData = "00";
  String minutesData = "00";
  String secondsData = "00";
  bool showProgress = false;
  double _progress = 0.0;
  Timer? _timerProgress;
  Timer? _timeUpdateTimer;
  TimerUtils? timerUtils;
  String _formattedTime = '';
  String resultTime = '';
  bool _isLoading = true; // 添加加载状态
  bool isBackPage = false;
  bool _showControls = true; // 控制日期、个性化入口、横竖屏入口的显示状态

  @override
  void initState() {
    super.initState();
    setDjsTime();
    setNowTime();
    Future.delayed(Duration.zero, () {
      setState(() {
        _isLoading = false; // 加载完成后设置为 false
      });
    });
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
    sySkinData();
  }

  @override
  void dispose() {
    super.dispose();
    _timeUpdateTimer?.cancel();
    timerUtils?.stop();
    showProgress = false;
  }

  void sySkinData() async {
    skinInt = await LocalStorage().getSkinData();
    setState(() {});
  }

  void setNowTime() async {
    _formattedTime = TimerUtils.getCurrentFormattedTime();
    _timeUpdateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _formattedTime = TimerUtils.getCurrentFormattedTime();
      });
    });
  }

  void setDjsTime() async {
    int timeDjs = widget.isFocus
        ? await LocalStorage().getFocusData()
        : await LocalStorage().getRestData();
    if (widget.timeData != 0) {
      timeDjs = widget.timeData;
    }
    if (timerUtils != null) {
      timerUtils?.stop();
    }
    timerUtils = TimerUtils(
      initialMinutes: timeDjs,
      onTick: (hours, minutes, seconds) {
        // print("当前时间: $hours:$minutes:$seconds");
        setState(() {
          hoursData = hours;
          minutesData = minutes;
          secondsData = seconds;
        });
        if (hours == "00" && minutesData == "00" && secondsData == "00") {
          if (widget.isFocus) {
            pageToFinish(true, false);
          } else {
            pageToFinish(true, true);
          }
        }
      },
    );
    timerUtils?.start();
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

  void switchingSkin() {
    showBottomSheetWithInput(context, (value) {
      LocalStorage().setSkinData(value);
      setState(() {
        print("object---switchingSkin=${value}");
        skinInt = value;
      });
    });
  }

  void _startProgress(bool isLongPress) {
    setState(() {
      print("object=_startProgress${isLongPress}");
      showProgress = isLongPress;
    });
    if (isLongPress) {
      showSetProgress();
    } else {
      _timerProgress?.cancel();
    }
  }

  void showSetProgress() {
    _timerProgress?.cancel();
    const int totalDuration = 3000;
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
        print("widget.isFocus======${widget.isFocus}");
        if (widget.isFocus) {
          timerUtils?.pause();
          pageToFinish(false, false);
        } else {
          Navigator.pop(context);
        }
      }
    });
  }

  Future<String> setUserTimeData() async {
    int timeDjs = widget.isFocus
        ? await LocalStorage().getFocusData()
        : await LocalStorage().getRestData();
    if (widget.timeData != 0) {
      timeDjs = widget.timeData;
    }
    resultTime = TimerUtils.subtractTime(
      baseMinutes: timeDjs,
      hoursData: hoursData,
      minutesData: minutesData,
      secondsData: secondsData,
    );
    int totleTime = TimerUtils.timeStringToTimestamp2(
      timeDjs,
      hoursData,
      minutesData,
      secondsData,
    );
    print("object-------setUserTimeData=${resultTime}");

    if (widget.taskId.isNotEmpty) {
      print("object=resultTime=${resultTime}");
      print("object=totleTime=${totleTime}");
      print("object=widget.taskId=${widget.taskId}");
      await TaskBean.updateUserTime(widget.taskId, totleTime);
    } else {
      print("object=totleTime-fast=${totleTime}");
      await TaskBean.updateUserTime(widget.taskId, totleTime, isFast: true);
    }
    return resultTime;
  }

  //跳转结果页
  void pageToFinish(bool isFinish, bool isRestSuccess) async {
    isBackPage = true;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    String resultTimeData = await setUserTimeData();
    print("object----pageToFinish=${resultTimeData}");
    showProgress = false;
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => FocusFinish(
                  isFinish: isFinish,
                  isRestSuccess: isRestSuccess,
                  finishTime: resultTimeData,
                  timeData: widget.timeData,
                  taskId: widget.taskId,
                )))
        .then((value) {
      print("pageToFinish-fanhui=${isFinish}===${isRestSuccess}");
      if (isFinish) {
        setNowTime();
      } else {
        timerUtils?.start();
      }
    });
  }

  void backFun() async {
    await setUserTimeData();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
      onWillPop: () async {
        backFun();
        return false;
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            _showControls = !_showControls;
          });
        },
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(), // 显示加载动画
              )
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(skinInt == 1
                        ? 'assets/img/bg_fr.webp'
                        : skinInt == 2
                            ? 'assets/img/bg_fr_2.webp'
                            : 'assets/img/bg_fr_3.webp'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: const BouncingScrollPhysics(),
                  child: isPortrait ? _buildPortraitUI() : _buildLandscapeUI(),
                ),
              ),
      ),
    ));
  }

//Text组件
  Widget _buildText() {
    return Text("Resting...",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: skinInt != 3 ? Color(0xFFFFD757) : Color(0xFF57CDFF),
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
            Visibility(
              visible: _showControls,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Text(
                _formattedTime,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'sf',
                  fontSize: 20,
                  color: skinInt != 3 ? Color(0xFFFFD757) : Color(0xFF57CDFF),
                  shadows: const [
                    Shadow(
                      color: Color(0x75000000),
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                switchingSkin();
              },
              child: Visibility(
                visible: _showControls,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: Image.asset(
                    skinInt != 3
                        ? 'assets/img/ic_show.webp'
                        : 'assets/img/ic_show_3.webp',
                  ),
                ),
              ),
            ),
            Visibility(
                visible: _showControls,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: SizedBox(width: 20)),
            GestureDetector(
              onTap: () {
                switchingScreens();
              },
              child: Visibility(
                visible: _showControls,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: Image.asset(
                    skinInt != 3
                        ? 'assets/img/ic_hav.webp'
                        : 'assets/img/ic_hav_3.webp',
                  ),
                ),
              ),
            ),
            Visibility(
                visible: _showControls,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: SizedBox(width: 20)),
          ],
        ),
        const SizedBox(height: 40),
        Container(
          width: 275,
          height: 40,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(skinInt == 1
                  ? 'assets/img/bg_focusing.webp'
                  : skinInt == 2
                      ? 'assets/img/bg_focusing_2.webp'
                      : 'assets/img/bg_focusing_3.webp'),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: widget.isFocus
                ? SizedBox(
                    width: 84,
                    height: 24,
                    child: Image.asset(skinInt == 1
                        ? 'assets/img/ic_focusing.webp'
                        : skinInt == 2
                            ? 'assets/img/ic_focusing_2.webp'
                            : 'assets/img/ic_focusing_3.webp'),
                  )
                : _buildText(),
          ),
        ),
        const SizedBox(height: 32),
        Container(
          width: 276,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(skinInt == 1
                  ? 'assets/img/bg_djs.webp'
                  : skinInt == 2
                      ? 'assets/img/bg_djs_2.webp'
                      : 'assets/img/bg_djs_3.webp'),
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
                    child: Image.asset(skinInt == 1
                        ? 'assets/img/bg_djs_t.webp'
                        : skinInt == 2
                            ? 'assets/img/bg_djs_t_2.webp'
                            : 'assets/img/bg_djs_t_3.webp'),
                  ),
                  SizedBox(
                    width: 269,
                    height: 94,
                    child: Image.asset(skinInt == 1
                        ? 'assets/img/bg_djs_b.webp'
                        : skinInt == 2
                            ? 'assets/img/bg_djs_b_2.webp'
                            : 'assets/img/bg_djs_b_3.webp'),
                  ),
                  SizedBox(height: 4),
                ],
              ),
              Text(
                hoursData == "00" ? minutesData : hoursData,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 130,
                  fontFamily: skinInt != 2 ? 'sf' : 'lu',
                  color: skinInt == 1
                      ? Color(0xFFFFD757)
                      : skinInt == 2
                          ? Color(0xFF823F16)
                          : Color(0xFF57CDFF),
                ),
              ),
              SizedBox(
                width: 270,
                height: 67,
                child: Image.asset(skinInt == 1
                    ? 'assets/img/ic_line.webp'
                    : skinInt == 2
                        ? 'assets/img/ic_line_2.webp'
                        : 'assets/img/ic_line_3.webp'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Container(
          width: 276,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(skinInt == 1
                  ? 'assets/img/bg_djs.webp'
                  : skinInt == 2
                      ? 'assets/img/bg_djs_2.webp'
                      : 'assets/img/bg_djs_3.webp'),
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
                    child: Image.asset(skinInt == 1
                        ? 'assets/img/bg_djs_t.webp'
                        : skinInt == 2
                            ? 'assets/img/bg_djs_t_2.webp'
                            : 'assets/img/bg_djs_t_3.webp'),
                  ),
                  SizedBox(
                    width: 269,
                    height: 94,
                    child: Image.asset(skinInt == 1
                        ? 'assets/img/bg_djs_b.webp'
                        : skinInt == 2
                            ? 'assets/img/bg_djs_b_2.webp'
                            : 'assets/img/bg_djs_b_3.webp'),
                  ),
                  SizedBox(height: 4),
                ],
              ),
              Text(
                hoursData == "00"
                    ? secondsData.toString()
                    : minutesData.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 130,
                  fontFamily: skinInt != 2 ? 'sf' : 'lu',
                  color: skinInt == 1
                      ? const Color(0xFFFFD757)
                      : skinInt == 2
                          ? const Color(0xFF823F16)
                          : const Color(0xFF57CDFF),
                ),
              ),
              SizedBox(
                width: 270,
                height: 67,
                child: Image.asset(skinInt == 1
                    ? 'assets/img/ic_line.webp'
                    : skinInt == 2
                        ? 'assets/img/ic_line_2.webp'
                        : 'assets/img/ic_line_3.webp'),
              ),
              if (hoursData != "00")
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    width: 46,
                    height: 22,
                    decoration: BoxDecoration(
                      color: skinInt != 3
                          ? const Color(0xFF8A3E18)
                          : const Color(0xFF0B3975),
                      borderRadius: const BorderRadius.all(Radius.circular(11)),
                      border: Border.all(
                        color: skinInt != 3
                            ? Color(0xFF8A3E18)
                            : Color(0xFF2761AB),
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
                )
            ],
          ),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: GestureDetector(
            onLongPress: () {
              print("object-----按下");
              _startProgress(true);
            },
            onLongPressEnd: (details) {
              print("object-----抬起");
              _startProgress(false);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 9, horizontal: 34),
              decoration: BoxDecoration(
                color: skinInt != 3 ? Color(0xFF3C1D1A) : Color(0xFF081645),
                border: Border.all(
                  color: skinInt != 3 ? Color(0xFFC45618) : Color(0xFF1852C4),
                  width: skinInt != 3 ? 2 : 1,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(26)),
                boxShadow: [
                  BoxShadow(
                    color: skinInt != 3 ? Color(0x80231101) : Color(0xFF231101),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                'Long press to exit',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'sf',
                  fontSize: 16,
                  color: skinInt != 3
                      ? const Color(0xFFFFDF7A)
                      : const Color(0xFF57CDFF),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.only(left: 44, right: 44),
          child: Visibility(
            visible: showProgress,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: ProgressBar(
              progress: _progress,
              // Set initial progress here
              height: 12,
              borderRadius: 6,
              progressColor:
                  skinInt != 3 ? Color(0xFFF7AC1E) : Color(0xFF5DB3FF),
              bgImagePath: skinInt != 3
                  ? 'assets/img/icon_pro.webp'
                  : 'assets/img/bg_pro_3.webp',
            ),
          ),
        ),
        Visibility(
            visible: showProgress,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: const SizedBox(height: 32)),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: Visibility(
                visible: _showControls,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Text(
                  _formattedTime,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'sf',
                    fontSize: 16,
                    color: skinInt != 3 ? Color(0xFFFFD757) : Color(0xFF57CDFF),
                    shadows: const [
                      Shadow(
                        color: Color(0x75000000),
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Spacer(),
            Expanded(
              child: Container(
                width: 293,
                height: 41,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(skinInt == 1
                        ? 'assets/img/bg_focusing.webp'
                        : skinInt == 2
                            ? 'assets/img/bg_focusing_2.webp'
                            : 'assets/img/bg_focusing_3.webp'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Center(
                  child: widget.isFocus
                      ? SizedBox(
                          width: 84,
                          height: 24,
                          child: Image.asset(skinInt == 1
                              ? 'assets/img/ic_focusing.webp'
                              : skinInt == 2
                                  ? 'assets/img/ic_focusing_2.webp'
                                  : 'assets/img/ic_focusing_3.webp'),
                        )
                      : _buildText(),
                ),
              ),
            ),
            Expanded(flex: 1, child: Container()),
            GestureDetector(
              onTap: () {
                switchingSkin();
              },
              child: Visibility(
                visible: _showControls,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: Image.asset(
                    skinInt != 3
                        ? 'assets/img/ic_show.webp'
                        : 'assets/img/ic_show_3.webp',
                  ),
                ),
              ),
            ),
            Visibility(
                visible: _showControls,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: const SizedBox(width: 20)),
            GestureDetector(
              onTap: () {
                switchingScreens();
              },
              child: Visibility(
                visible: _showControls,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: Image.asset(
                    skinInt != 3
                        ? 'assets/img/ic_hav.webp'
                        : 'assets/img/ic_hav_3.webp',
                  ),
                ),
              ),
            ),
            Visibility(
                visible: _showControls,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: SizedBox(width: 20)),
          ],
        ),
        const SizedBox(height: 29),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Row(
                mainAxisAlignment: skinInt != 2
                    ? MainAxisAlignment.spaceEvenly
                    : MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 276,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(skinInt == 1
                            ? 'assets/img/bg_djs.webp'
                            : skinInt == 2
                                ? 'assets/img/bg_djs_2.webp'
                                : 'assets/img/bg_djs_3.webp'),
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
                              child: Image.asset(skinInt == 1
                                  ? 'assets/img/bg_djs_t.webp'
                                  : skinInt == 2
                                      ? 'assets/img/bg_djs_t_2.webp'
                                      : 'assets/img/bg_djs_t_3.webp'),
                            ),
                            SizedBox(
                              width: 269,
                              height: 94,
                              child: Image.asset(skinInt == 1
                                  ? 'assets/img/bg_djs_b.webp'
                                  : skinInt == 2
                                      ? 'assets/img/bg_djs_b_2.webp'
                                      : 'assets/img/bg_djs_b_3.webp'),
                            ),
                            SizedBox(height: 4),
                          ],
                        ),
                        Text(
                          hoursData == "00" ? minutesData : hoursData,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 130,
                            fontFamily: skinInt != 2 ? 'sf' : 'lu',
                            color: skinInt == 1
                                ? Color(0xFFFFD757)
                                : skinInt == 2
                                    ? Color(0xFF823F16)
                                    : Color(0xFF57CDFF),
                          ),
                        ),
                        skinInt != 2
                            ? SizedBox(
                                width: 270,
                                height: 67,
                                child: Image.asset(skinInt == 1
                                    ? 'assets/img/ic_line.webp'
                                    : skinInt == 2
                                        ? 'assets/img/ic_line_2.webp'
                                        : 'assets/img/ic_line_3.webp'),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                  Container(
                    width: 276,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(skinInt == 1
                            ? 'assets/img/bg_djs.webp'
                            : skinInt == 2
                                ? 'assets/img/bg_djs_2.webp'
                                : 'assets/img/bg_djs_3.webp'),
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
                              child: Image.asset(skinInt == 1
                                  ? 'assets/img/bg_djs_t.webp'
                                  : skinInt == 2
                                      ? 'assets/img/bg_djs_t_2.webp'
                                      : 'assets/img/bg_djs_t_3.webp'),
                            ),
                            SizedBox(
                              width: 269,
                              height: 94,
                              child: Image.asset(skinInt == 1
                                  ? 'assets/img/bg_djs_b.webp'
                                  : skinInt == 2
                                      ? 'assets/img/bg_djs_b_2.webp'
                                      : 'assets/img/bg_djs_b_3.webp'),
                            ),
                            SizedBox(height: 4),
                          ],
                        ),
                        Text(
                          hoursData == "00"
                              ? secondsData.toString()
                              : minutesData.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 130,
                            fontFamily: skinInt != 2 ? 'sf' : 'lu',
                            color: skinInt == 1
                                ? Color(0xFFFFD757)
                                : skinInt == 2
                                    ? Color(0xFF823F16)
                                    : Color(0xFF57CDFF),
                          ),
                        ),
                        skinInt != 2
                            ? SizedBox(
                                width: 270,
                                height: 67,
                                child: Image.asset(skinInt == 1
                                    ? 'assets/img/ic_line.webp'
                                    : skinInt == 2
                                        ? 'assets/img/ic_line_2.webp'
                                        : 'assets/img/ic_line_3.webp'),
                              )
                            : SizedBox(),
                        if (hoursData != "00")
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: Container(
                              width: 46,
                              height: 22,
                              decoration: BoxDecoration(
                                color: skinInt != 3
                                    ? const Color(0xFF8A3E18)
                                    : const Color(0xFF0B3975),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(11)),
                                border: Border.all(
                                  color: skinInt != 3
                                      ? Color(0xFF8A3E18)
                                      : Color(0xFF2761AB),
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
                          )
                      ],
                    ),
                  ),
                ],
              ),
              if (skinInt == 2)
                SizedBox(
                  width: 67,
                  height: 203,
                  child: Image.asset('assets/img/ic_line_shu.webp'),
                ),
              if (showProgress)
                Container(
                  width: 287,
                  padding: EdgeInsets.only(bottom: skinInt == 2 ? 12 : 0),
                  child: ProgressBar(
                    progress: _progress,
                    // Set initial progress here
                    height: 12,
                    borderRadius: 6,
                    progressColor:
                        skinInt != 3 ? Color(0xFFF7AC1E) : Color(0xFF5DB3FF),
                    bgImagePath: skinInt != 3
                        ? 'assets/img/icon_pro.webp'
                        : 'assets/img/bg_pro_3.webp',
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: GestureDetector(
            onLongPress: () {
              _startProgress(true);
            },
            onLongPressEnd: (details) {
              _startProgress(false);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 9, horizontal: 34),
              decoration: BoxDecoration(
                color: skinInt != 3 ? Color(0xFF3C1D1A) : Color(0xFF081645),
                border: Border.all(
                  color: skinInt != 3 ? Color(0xFFC45618) : Color(0xFF1852C4),
                  width: skinInt != 3 ? 2 : 1,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(26)),
                boxShadow: [
                  BoxShadow(
                    color: skinInt != 3 ? Color(0x80231101) : Color(0xFF231101),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                'Long press to exit',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'sf',
                  fontSize: 16,
                  color: skinInt != 3 ? Color(0xFFFFDF7A) : Color(0xFF57CDFF),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

void showBottomSheetWithInput(BuildContext context, void Function(int) onSave) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Wrap(
        children: [
          BottomSheetWithInput(
            onSave: onSave,
          ),
        ],
      );
    },
  );
}

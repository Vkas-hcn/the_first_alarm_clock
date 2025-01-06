import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:the_first_alarm_clock/wight/BottomSetTimeInput.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:share_plus/share_plus.dart';

import '../data/LocalStorage.dart';

class SettingPaper extends StatelessWidget {
  const SettingPaper({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  String focusTime = '25';
  String restTime = '5';

  @override
  void initState() {
    super.initState();
    getTimeData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getTimeData() {
    LocalStorage().getFocusData().then((value) {
      setState(() {
        focusTime = value.toString();
      });
    });
    LocalStorage().getRestData().then((value) {
      setState(() {
        restTime = value.toString();
      });
    });
  }

  void showDiaLogFocusSeting() {
    showBottomSetTimeInput(context, 1, (value) {
      print("showDiaLogSeting====${value}");
      LocalStorage().setFocusData(value.toInt());
      getFoucsTime();
    });
  }

  void showDiaLogRestSetting() {
    showBottomSetTimeInput(context, 2, (value) {
      print("showDiaLogSeting====${value}");
      LocalStorage().setRestData(value.toInt());
      getRestTime();
    });
  }

  void getFoucsTime() async {
    int date = await LocalStorage().getFocusData();
    print("getFoucsTime====${date}");
    setState(() {
      focusTime = date.toString();
    });
  }

  void getRestTime() async {
    int date = await LocalStorage().getRestData();
    print("getRestTime====${date}");
    setState(() {
      restTime = date.toString();
    });
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
              children: [
                SizedBox(width: 16),
                Text(
                  'Settings',
                  style: TextStyle(
                    fontFamily: 'sf',
                    fontSize: 16,
                    color: Color(0xFFFFD757),
                  ),
                ),
                Spacer()
              ],
            ),
            SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 83,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/img/ic_setting_top.webp'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    showDiaLogFocusSeting();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      image: DecorationImage(
                        image: AssetImage('assets/img/bg_setting.webp'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 11, horizontal: 12),
                      decoration: const BoxDecoration(
                        color: Color(0xFF210D04),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Focus Time',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFFFDF7A),
                            ),
                          ),
                          Text(
                            '${focusTime}min',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'sf',
                              fontSize: 16,
                              color: Color(0xFFFFDF7A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    showDiaLogRestSetting();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      image: DecorationImage(
                        image: AssetImage('assets/img/bg_setting.webp'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 11, horizontal: 12),
                      decoration: const BoxDecoration(
                        color: Color(0xFF210D04),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rest Time',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFFFDF7A),
                            ),
                          ),
                          Text(
                            '${restTime}min',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'sf',
                              fontSize: 16,
                              color: Color(0xFFFFDF7A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    postAComment();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 19, horizontal: 20),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      image: DecorationImage(
                        image: AssetImage('assets/img/bg_setting.webp'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Post a Comment',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFFFDF7A),
                          ),
                        ),
                        SizedBox(
                            width: 8,
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Color(0xFFFFDF7A),
                            ))
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    shareWithFriends();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 19, horizontal: 20),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      image: DecorationImage(
                        image: AssetImage('assets/img/bg_setting.webp'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Share with Friends',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFFFDF7A),
                          ),
                        ),
                        SizedBox(
                            width: 8,
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Color(0xFFFFDF7A),
                            ))
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    launchPP();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 19, horizontal: 20),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      image: DecorationImage(
                        image: AssetImage('assets/img/bg_setting.webp'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Privacy Policy',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFFFDF7A),
                          ),
                        ),
                        SizedBox(
                            width: 8,
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Color(0xFFFFDF7A),
                            ))
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    launchUserAgreement();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 19, horizontal: 20),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      image: DecorationImage(
                        image: AssetImage('assets/img/bg_setting.webp'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Terms of Service',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFFFDF7A),
                          ),
                        ),
                        SizedBox(
                            width: 8,
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Color(0xFFFFDF7A),
                            ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  void postAComment() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.blooming.unlimited.fast';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // ThirdUtils.showToast('Cant open web page $url');
    }
  }

  void shareWithFriends() async {
    Share.share(
        "https://book.flutterchina.club/chapter6/keepalive.html#_6-8-1-automatickeepalive");
  }

  void launchPP() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.blooming.unlimited.fast';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // ThirdUtils.showToast('Cant open web page $url');
    }
  }

  void launchUserAgreement() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.blooming.unlimited.fast';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // ThirdUtils.showToast('Cant open web page $url');
    }
  }
}

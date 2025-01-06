import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:the_first_alarm_clock/target/AddTarget.dart';
import 'package:the_first_alarm_clock/target/TargetDetail.dart';

import '../data/TaskBean.dart';
import '../data/TimerUtils.dart';
import '../focus/FocusRest.dart';

class Target extends StatelessWidget {
  const Target({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TargetScreen(),
    );
  }
}

class TargetScreen extends StatefulWidget {
  const TargetScreen({super.key});

  @override
  _TargetScreenState createState() => _TargetScreenState();
}

class _TargetScreenState extends State<TargetScreen>
    with SingleTickerProviderStateMixin {
  List<TaskBean> taskBeans = [];
  double totalTotalTime = 0;
  double totalUserTime = 0;
  String userTimeRatio = "0.0";

  @override
  void initState() {
    super.initState();
    getTaskListData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getTaskListData() async {
    taskBeans = await TaskBean.loadTasks();
    final String jsonData =
        jsonEncode(taskBeans.map((task) => task.toJson()).toList());
    List<TaskBean> taskBeansFast = await TaskBean.loadTasks(isFast: true);
    final String jsonDataFast =
        jsonEncode(taskBeansFast.map((task) => task.toJson()).toList());
    print("jsonData=${jsonData}");

    print("jsonDataFast=${jsonDataFast}");
    totalTotalTime = (TaskBean.sumTotalTime(taskBeans)).toDouble();
    totalUserTime = (TaskBean.sumUserTime(taskBeans) / 60.0);
    if (totalTotalTime > 0) {
      userTimeRatio =
          (totalUserTime / (totalTotalTime) * 100).toStringAsFixed(2);
    } else {
      userTimeRatio = "0.0";
    }
    setState(() {});
  }

  String getTaskProData(int index) {
    TaskBean data = taskBeans[index];
    double progess = (data.userTime / (data.totalTime * 60)) * 100;
    return progess.toStringAsFixed(2);
  }

  String getTaskUserData(int index) {
    TaskBean data = taskBeans[index];
    return ((data.userTime % 3600) / 60).toStringAsFixed(2);
  }

  void jumpToFR(TaskBean taskBean) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FocusRest(
              isFocus: true,
              timeData: taskBean.focusTime,
              taskId: taskBean.id)),
    ).then((value) {
      getTaskListData();
    });
  }

  void jumpToTaskDetail(TaskBean task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TargetDetail(taskBean: task)),
    ).then((value) {
      getTaskListData();
    });
  }

  void jumpToAddPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTarget(taskBean: null)),
    ).then((value) {
      getTaskListData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/ic_guide.webp'),
                fit: BoxFit.fill,
              ),
            ),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const BouncingScrollPhysics(),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                const SizedBox(height: 50),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(width: 16),
                    Text(
                      'Goal',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: 'sf',
                        fontSize: 16,
                        color: Color(0xFFFFD757),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  padding: const EdgeInsets.only(
                      top: 16, bottom: 20, left: 15, right: 15),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/img/bg_target_1.webp"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Goal Progress',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'sf',
                              fontSize: 18,
                              color: Color(0xFFFFD757),
                            ),
                          ),
                          Text(
                            'Summary of All Goals',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFFFD757),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '${userTimeRatio}%',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'sf',
                                fontSize: 20,
                                color: Color(0xFFFFD757),
                              ),
                            ),
                            Text(
                              '${totalUserTime.toStringAsFixed(2)}/${totalTotalTime}mins',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFFFD757),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 12),
                  child: Column(
                    children: taskBeans.map((taskBean) {
                      return GestureDetector(
                        onTap: () {
                          jumpToTaskDetail(taskBean);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7F3610),
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
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 12),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF210D04),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        taskBean.name,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          fontFamily: 'sf',
                                          fontSize: 14,
                                          color: Color(0xFFFFDF7A),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        "${getTaskProData(taskBeans.indexOf(taskBean))}%",
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                          fontFamily: 'sf',
                                          fontSize: 16,
                                          color: Color(0xFFFFDF7A),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            top: 16,
                                            bottom: 19,
                                            left: 12,
                                            right: 12),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF682706),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                        ),
                                        child: const Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Goal Progress',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFFFFD757),
                                              ),
                                            ),
                                            SizedBox(height: 28),
                                            Text(
                                              'Remaining Days',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFFFFD757),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            top: 16,
                                            bottom: 19,
                                            left: 12,
                                            right: 12),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF682706),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${getTaskUserData(taskBeans.indexOf(taskBean))}/${taskBean.totalTime}mins',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFFFFD757),
                                              ),
                                            ),
                                            const SizedBox(height: 28),
                                            Text(
                                              '${(TimerUtils.calculateDateDifference(taskBean.deadData))} days',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFFFFD757),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (TimerUtils.calculateDateDifference(taskBean.deadData) > 0 &&
                                  taskBean.userTime < (taskBean.totalTime * 60))
                                GestureDetector(
                                  onTap: () {
                                    jumpToFR(taskBean);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 12),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFC35011),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(75)),
                                    ),
                                    child: Column(
                                      children: [
                                        const Text(
                                          'Start',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFFFFFFFF),
                                          ),
                                        ),
                                        Text(
                                          '${taskBean.focusTime} mins',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFFFDCD57),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              if (taskBean.userTime >=
                                  (taskBean.totalTime * 60))
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      flex:3,
                                      child: Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 12),
                                        padding: const EdgeInsets.only(
                                            top: 16,
                                            bottom: 19,
                                            left: 8,
                                            right: 8),
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                'assets/img/bg_target_g.webp'),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        child: SizedBox(
                                          width: 44,
                                          height: 44,
                                          child: Image.asset(
                                              'assets/img/ic_finish_sm.webp'),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex:4,
                                      child: Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 12),
                                        padding: const EdgeInsets.only(
                                            top: 16,
                                            bottom: 19,
                                            left: 8,
                                            right: 8),
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                'assets/img/bg_target_g.webp'),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        child: const Text(
                                          'Congratulations, this goal is complete!',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFFFFD757),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (TimerUtils.calculateDateDifference(taskBean.deadData) <= 0)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      flex:3,
                                      child: Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 12),
                                        padding: const EdgeInsets.only(
                                            top: 16,
                                            bottom: 19,
                                            left: 8,
                                            right: 8),
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                'assets/img/bg_target_r.webp'),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        child: SizedBox(
                                          width: 44,
                                          height: 44,
                                          child: Image.asset(
                                              'assets/img/ic_unfinish_sm.webp'),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex:4,
                                      child: Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 12),
                                        padding: const EdgeInsets.only(
                                            top: 16, bottom: 19, left: 8, right: 8),
                                        decoration: const BoxDecoration(
                                          borderRadius:
                                              BorderRadius.all(Radius.circular(8)),
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                'assets/img/bg_target_r.webp'),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        child: const Text(
                                          'The deadline has passed, and you did not complete the goal.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFFFFD757),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 66),
              ]),
            ),
          ),
          Positioned(
              bottom: 20,
              right: 20,
              child: Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFBC4714),
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      jumpToAddPage();
                    },
                  ))),
        ],
      ),
    ));
  }
}

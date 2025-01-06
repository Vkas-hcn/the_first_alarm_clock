import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:the_first_alarm_clock/target/AddTarget.dart';

import '../data/LocalStorage.dart';
import '../data/TaskBean.dart';
import '../data/TimerUtils.dart';
import '../focus/FocusRest.dart';
import '../wight/BottomSetTimeInput.dart';
import '../wight/BottomWithMenu.dart';

class TargetDetail extends StatelessWidget {
  final TaskBean taskBean;

  const TargetDetail({
    super.key,
    required this.taskBean,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TargetDetailScreen(taskBean: taskBean),
    );
  }
}

class TargetDetailScreen extends StatefulWidget {
  final TaskBean taskBean;

  const TargetDetailScreen({
    super.key,
    required this.taskBean,
  });

  @override
  _TargetDetailScreenState createState() => _TargetDetailScreenState();
}

class _TargetDetailScreenState extends State<TargetDetailScreen>
    with SingleTickerProviderStateMixin {
  List<TaskDayBean> taskDayBeans = [];
  late TaskBean taskBeanThis;

  Map<String, Map<String, dynamic>> result = {};

  @override
  void initState() {
    taskBeanThis = widget.taskBean;
    super.initState();
    getTaskListData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getTaskListData() async {
    taskDayBeans = taskBeanThis.taskDayBean;
    getDayNum();
    setState(() {});
  }

  String getTaskProData() {
    double progess =
        (taskBeanThis.userTime / (taskBeanThis.totalTime * 60)) * 100;
    return progess.toStringAsFixed(2);
  }

  String getTaskUserData() {
    return ((taskBeanThis.userTime % 3600) / 60).toStringAsFixed(2);
  }

  void jumpToFR(TaskBean taskBean) async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => FocusRest(
            isFocus: true, timeData: taskBean.focusTime, taskId: taskBean.id)));
  }

  void jumpToAddData(TaskBean taskBean) async {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => AddTarget(taskBean: taskBean)))
        .then((value) async {
       TaskBean taskBeanFlash =  await TaskBean.getTaskById(taskBean.id);
       taskBeanThis = taskBeanFlash;
      getTaskListData();
    });
  }

  void showDiaLogMenu() {
    showBottomWithMenu(context, () {
      jumpToAddData(taskBeanThis);
    }, () {
      deleteOperationData(taskBeanThis.id);
    });
  }

  void deleteOperationData(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this data?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                deleteOperationFun();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void deleteOperationFun() async {
    if (mounted) {
      await TaskBean.deleteTaskById(taskBeanThis.id);
      LocalStorage.showToast('The deletion is successful');
      if (mounted) {
        Navigator.pop(context);
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }

  void getDayNum() {
    // 调用统计方法
    result = TaskDayBean.aggregateTaskDayData(taskDayBeans);
    // 输出结果
    result.forEach((day, data) {
      print("Day: $day, Total Time: ${data['time']}, Count: ${data['count']}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
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
                        showDiaLogMenu();
                      },
                      child: SizedBox(
                        width: 32,
                        height: 32,
                        child: Image.asset('assets/img/ic_menu.webp'),
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 22),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7F3610),
                      border: Border.all(
                        color: const Color(0xFFC45618),
                        width: 2,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
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
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: const BoxDecoration(
                            color: Color(0xFF210D04),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                taskBeanThis.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'sf',
                                  fontSize: 16,
                                  color: Color(0xFFFFDF7A),
                                ),
                              ),
                              Text(
                                "${getTaskProData()}%",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'sf',
                                  fontSize: 16,
                                  color: Color(0xFFFFDF7A),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 16, bottom: 19, left: 12, right: 12),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF682706),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
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
                                      top: 16, bottom: 19, left: 12, right: 12),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF682706),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${getTaskUserData()}/${taskBeanThis.totalTime}mins',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFFFFD757),
                                        ),
                                      ),
                                      const SizedBox(height: 28),
                                      Text(
                                        '${TimerUtils.calculateDateDifference(taskBeanThis.deadData)} days',
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
                        if (TimerUtils.calculateDateDifference(widget.taskBean.deadData) > 0 &&
                            widget.taskBean.userTime < (widget.taskBean.totalTime * 60))
                        GestureDetector(
                          onTap: () {
                            jumpToFR(taskBeanThis);
                          },
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 12),
                            padding: const EdgeInsets.symmetric(vertical: 6),
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
                                  '${taskBeanThis.focusTime} mins',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFFDCD57),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (widget.taskBean.userTime >=
                            (widget.taskBean.totalTime * 60))
                          Container(
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
                        if (TimerUtils.calculateDateDifference(widget.taskBean.deadData) <= 0)
                          Container(
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
                      ],
                    ),
                  ),
                ),
                Container(
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
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 11, horizontal: 12),
                    decoration: const BoxDecoration(
                      color: Color(0xFF210D04),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: const Text(
                      'Goal Completion Records',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFFFDF7A),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    image: DecorationImage(
                      image: AssetImage('assets/img/bg_setting.webp'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 11, horizontal: 12),
                    decoration: const BoxDecoration(
                      color: Color(0xFF210D04),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'Date',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFFFDF7A),
                              ),
                            ),
                            Text(
                              'Sessions',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFFFDF7A),
                              ),
                            ),
                            Text(
                              'Duration',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFFFDF7A),
                              ),
                            ),
                            Text(
                              'Progress',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFFFDF7A),
                              ),
                            ),
                          ],
                        ),
                        //列表
                        Column(
                          children: result.entries.map((entry) {
                            String day = entry.key;
                            Map<String, dynamic> data = entry.value;
                            int totalTime = data['time'];
                            String totalTimeData = '';
                            if (totalTime < 60) {
                              totalTimeData =
                                  "${totalTime.toStringAsFixed(2)} second";
                            } else if (totalTime < 3600) {
                              double time1 = totalTime / 60;
                              totalTimeData = "${time1.toStringAsFixed(2)} min";
                            } else {
                              double time2 = totalTime / 3600;
                              totalTimeData =
                                  "${time2.toStringAsFixed(2)} hour";
                            }
                            int count = data['count'];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  day,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFFFDF7A),
                                  ),
                                ),
                                Text(
                                  count.toStringAsFixed(2),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFFFDF7A),
                                  ),
                                ),
                                Text(
                                  totalTimeData,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFFFDF7A),
                                  ),
                                ),
                                Text(
                                  '${((totalTime / (taskBeanThis.totalTime * 60)) * 100).toStringAsFixed(2)}%',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFFFDF7A),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    ));
  }
}

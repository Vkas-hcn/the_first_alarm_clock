import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_first_alarm_clock/data/LocalStorage.dart';

import '../data/TaskBean.dart';
import '../data/TimerUtils.dart';
import '../focus/FocusRest.dart';
import '../wight/BottomSetTimeInput.dart';
import '../wight/BottomWithMenu.dart';

class AddTarget extends StatelessWidget {
  final TaskBean? taskBean;

  const AddTarget({
    super.key,
    required this.taskBean,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AddTargetScreen(taskBean: taskBean),
    );
  }
}

class AddTargetScreen extends StatefulWidget {
  final TaskBean? taskBean;

  const AddTargetScreen({
    super.key,
    required this.taskBean,
  });

  @override
  _AddTargetScreenState createState() => _AddTargetScreenState();
}

class _AddTargetScreenState extends State<AddTargetScreen>
    with SingleTickerProviderStateMixin {
  List<TaskDayBean> taskDayBeans = [];
  Map<String, Map<String, dynamic>> result = {};
  String minutesData = "00";
  String secondsData = "00";
  int focusTime = 25;
  int restTime = 5;
  final TextEditingController _timeEditingController = TextEditingController();
  final TextEditingController _nameEditingController = TextEditingController();
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  String formattedDate = '';
  final FocusNode _nameFocusNodeTime = FocusNode();
  final FocusNode _nameFocusNodeName = FocusNode();

  int deadlineDays = 1;

  @override
  void initState() {
    super.initState();
    if (widget.taskBean != null) {
      _nameEditingController.text = widget.taskBean!.name;
      focusTime = widget.taskBean!.focusTime;
      restTime = widget.taskBean!.restTime;
      _timeEditingController.text = widget.taskBean!.totalTime.toString();
      selectedDate = DateTime.now().add(Duration(days: widget.taskBean!.deadline));
      taskDayBeans = widget.taskBean!.taskDayBean;
    }
    getTaskListData();
  }

  @override
  void dispose() {
    _timeEditingController.dispose();
    _nameEditingController.dispose();
    _nameFocusNodeTime.dispose();
    _nameFocusNodeName.dispose();
    super.dispose();
  }

  void getTaskListData() async {
    if (widget.taskBean == null) {
      return;
    }
    taskDayBeans = widget.taskBean!.taskDayBean;
    setState(() {});
  }

  void showDiaLogFocusSeting() {
    showBottomSetTimeInput(context, 1, (value) {
      print("focusTime====${value}");
      setState(() {
        focusTime = value.toInt();
      });
    });
  }

  void showDiaLogRestSetting() {
    showBottomSetTimeInput(context, 2, (value) {
      print("restTime====${value}");
      setState(() {
        restTime = value.toInt();
      });
    });
  }

  void saveTask() async {
    if (_nameEditingController.text.isEmpty) {
      LocalStorage.showToast("Please add Task Name");
      return;
    }

    // 验证 _timeEditingController 的值是否大于0
    if (_timeEditingController.text.isEmpty) {
      LocalStorage.showToast("Please enter a target value");
      return;
    }
    if (_timeEditingController.text.isNotEmpty) {
      int timeValue = int.tryParse(_timeEditingController.text) ?? 0;
      if (timeValue <= 0) {
        LocalStorage.showToast("Please enter a value greater than 0");
        return;
      }
    }

    if (widget.taskBean != null) {
      // 更新现有任务
      TaskBean updatedTaskBean = TaskBean(
        taskDayBean: taskDayBeans,
        id: widget.taskBean!.id,
        name: _nameEditingController.text,
        focusTime: focusTime,
        restTime: restTime,
        totalTime: _timeEditingController.text.isEmpty
            ? 0
            : int.parse(_timeEditingController.text),
        deadline: deadlineDays,
        userTime: widget.taskBean!.userTime,
      );
      await TaskBean.updateTaskById(widget.taskBean!.id, updatedTaskBean);
    } else {
      // 创建新任务
      TaskBean taskBean = TaskBean(
        taskDayBean: [],
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameEditingController.text,
        focusTime: focusTime,
        restTime: restTime,
        totalTime: _timeEditingController.text.isEmpty
            ? 0
            : int.parse(_timeEditingController.text),
        deadline: deadlineDays,
        userTime: 0,
      );
      await TaskBean.addTask(taskBean);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
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
                  ],
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                                "Goal Name",
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
                                      left: 12, right: 12),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF682706),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: TextField(
                                    maxLength: 25,
                                    maxLines: 1,
                                    controller: _nameEditingController,
                                    focusNode: _nameFocusNodeName,
                                    buildCounter: (
                                      BuildContext context, {
                                      required int currentLength,
                                      required bool isFocused,
                                      required int? maxLength,
                                    }) {
                                      return null;
                                    },
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFFFDCD57),
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: 'Enter Name',
                                      hintStyle: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF747688),
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 22),
                  child: GestureDetector(
                    onTap: () {
                      showDiaLogFocusSeting();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF210D04),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Single Focus Duration：",
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
                          SizedBox(height: 8),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 16,
                                        bottom: 19,
                                        left: 12,
                                        right: 12),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF682706),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 80,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/img/bg_djs.webp'),
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
                                                    width: 80,
                                                    height: 26,
                                                    child: Image.asset(
                                                        'assets/img/bg_djs_t.webp'),
                                                  ),
                                                  SizedBox(
                                                    width: 80,
                                                    height: 26,
                                                    child: Image.asset(
                                                        'assets/img/bg_djs_b.webp'),
                                                  ),
                                                  SizedBox(height: 4),
                                                ],
                                              ),
                                              Text(
                                                focusTime.toString(),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13,
                                                  fontFamily: 'sf',
                                                  color: Color(0xFFFFD757),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 80,
                                                height: 12,
                                                child: Image.asset(
                                                    'assets/img/ic_line.webp'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Container(
                                          width: 80,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/img/bg_djs.webp'),
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
                                                    width: 80,
                                                    height: 26,
                                                    child: Image.asset(
                                                        'assets/img/bg_djs_t.webp'),
                                                  ),
                                                  SizedBox(
                                                    width: 80,
                                                    height: 26,
                                                    child: Image.asset(
                                                        'assets/img/bg_djs_b.webp'),
                                                  ),
                                                  SizedBox(height: 4),
                                                ],
                                              ),
                                              Text(
                                                "00",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13,
                                                  fontFamily: 'sf',
                                                  color: Color(0xFFFFD757),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 80,
                                                height: 12,
                                                child: Image.asset(
                                                    'assets/img/ic_line.webp'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0),
                  child: GestureDetector(
                    onTap: () {
                      showDiaLogRestSetting();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF210D04),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Single Break Duration：",
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
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 16,
                                        bottom: 19,
                                        left: 12,
                                        right: 12),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF682706),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 80,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/img/bg_djs.webp'),
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
                                                    width: 80,
                                                    height: 26,
                                                    child: Image.asset(
                                                        'assets/img/bg_djs_t.webp'),
                                                  ),
                                                  SizedBox(
                                                    width: 80,
                                                    height: 26,
                                                    child: Image.asset(
                                                        'assets/img/bg_djs_b.webp'),
                                                  ),
                                                  SizedBox(height: 4),
                                                ],
                                              ),
                                              Text(
                                                restTime.toString(),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13,
                                                  fontFamily: 'sf',
                                                  color: Color(0xFFFFD757),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 80,
                                                height: 12,
                                                child: Image.asset(
                                                    'assets/img/ic_line.webp'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Container(
                                          width: 80,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/img/bg_djs.webp'),
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
                                                    width: 80,
                                                    height: 26,
                                                    child: Image.asset(
                                                        'assets/img/bg_djs_t.webp'),
                                                  ),
                                                  SizedBox(
                                                    width: 80,
                                                    height: 26,
                                                    child: Image.asset(
                                                        'assets/img/bg_djs_b.webp'),
                                                  ),
                                                  SizedBox(height: 4),
                                                ],
                                              ),
                                              Text(
                                                "00",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13,
                                                  fontFamily: 'sf',
                                                  color: Color(0xFFFFD757),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 80,
                                                height: 12,
                                                child: Image.asset(
                                                    'assets/img/ic_line.webp'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0),
                  child: GestureDetector(
                    onTap: () {
                      showDiaLogRestSetting();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF210D04),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total Focus Time：",
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
                                        top: 0, bottom: 0, left: 12, right: 12),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF682706),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF682707),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                      child: TextField(
                                        maxLength: 3,
                                        maxLines: 1,
                                        controller: _timeEditingController,
                                        keyboardType: TextInputType.number,
                                        focusNode: _nameFocusNodeTime,
                                        buildCounter: (
                                          BuildContext context, {
                                          required int currentLength,
                                          required bool isFocused,
                                          required int? maxLength,
                                        }) {
                                          return null;
                                        },
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFFFDCD57),
                                        ),
                                        decoration: const InputDecoration(
                                          hintText: 'Enter time',
                                          hintStyle: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF747688),
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 12,
                                        bottom: 12,
                                        left: 12,
                                        right: 12),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF682706),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF682707),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                      child: const Text(
                                        'Minutes',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFFFFD757),
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
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0),
                  child: GestureDetector(
                    onTap: () {
                      selectDate(context);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF210D04),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Deadline",
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
                          const SizedBox(height: 8),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 12,
                                        bottom: 12,
                                        left: 12,
                                        right: 12),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF682706),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF682707),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                      child: Text(
                                        formattedDate,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFFFFD757),
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
                  ),
                ),
                const SizedBox(height: 28),
                GestureDetector(
                  onTap: () {
                    saveTask();
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 52),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC35010),
                      borderRadius: BorderRadius.circular(75),
                    ),
                    child: const Text(
                      "Complete",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 44),
              ]),
            ),
          ),
        ],
      ),
    ));
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)), // 修改: 将初始日期设置为明天
      // 初始日期为明天
      firstDate: DateTime.now().add(const Duration(days: 1)), // 修改: 将最早可选日期设置为明天
      // 将最早可选日期设置为明天，禁用今天的日期
      lastDate: DateTime(2100),
      // 设置一个合理的未来日期
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF031F3E),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF031F3E),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        // 将当前时间的时间部分重置为 00:00:00
        final DateTime now = DateTime.now();
        final DateTime today = DateTime(now.year, now.month, now.day);

        // 计算相差的天数
        final int differenceInDays = selectedDate.difference(today).inDays;

        print("pickedDate: $pickedDate");
        print("Difference in days: $differenceInDays");
        deadlineDays = differenceInDays;
      });
    }
  }
}

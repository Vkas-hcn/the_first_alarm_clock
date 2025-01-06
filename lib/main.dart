import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:the_first_alarm_clock/start/Start.dart';

import 'data/LocalStorage.dart';
import 'data/TaskBean.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalStorage().init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: LocalStorage.navigatorKey,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    print("object=================main");
    setDefaultData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageToHome();
    });
  }

  void setDefaultData() async {
    List<TaskBean> tasks = await TaskBean.loadTasks();

    if (tasks.isEmpty) {
      TaskBean task = TaskBean(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'Daily Learning',
        focusTime: 25,
        restTime: 5,
        totalTime: 500,
        deadline: 60,
        userTime: 0,
      );
      tasks.add(task);
      await TaskBean.saveTasks(tasks);
    }
    List<TaskBean> tasksFast = await TaskBean.loadTasks(isFast: true);
    if (tasksFast.isEmpty) {
      print("tasksFast.isEmpty");
      addFast();
    } else {
      DateTime now = DateTime.now();
      DateFormat formatter = DateFormat('MM-dd');
      // 格式化当前时间
      String formattedDate = formatter.format(now);
      print(
          "tasksFast[0].taskDayBean[0].day=${tasksFast[0].taskDayBean[0].day}====${formattedDate}");
      //是否和今天日期一致
      if (tasksFast[0].taskDayBean[0].day != formattedDate) {
        //如果日期不一致，则重置任务
        print("如果日期不一致，则重置任务");
        LocalStorage().setTaskFastData('');
        addFast();
      }
    }
  }

  void addFast()async{
    List<TaskBean> tasksFast = await TaskBean.loadTasks(isFast: true);
    TaskBean taskFast = TaskBean(
      id: '',
      name: 'Fast',
      focusTime: 25,
      restTime: 5,
      totalTime: 0,
      deadline: 60,
      userTime: 0,
    );
    tasksFast.add(taskFast);
    TaskBean.saveTasks(tasksFast, isFast: true);
  }

  void pageToHome() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Start()),
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
        ),
      ),
    );
  }
}

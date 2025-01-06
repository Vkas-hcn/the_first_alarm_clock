import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:the_first_alarm_clock/data/LocalStorage.dart';
import 'package:the_first_alarm_clock/data/TimerUtils.dart';

class TaskBean {
  String id;
  String name;
  int focusTime;
  int restTime;
  int totalTime;
  String deadData;
  int userTime;
  List<TaskDayBean> taskDayBean;

  TaskBean({
    required this.id,
    required this.name,
    required this.focusTime,
    required this.restTime,
    required this.totalTime,
    required this.deadData,
    required this.userTime,
    this.taskDayBean = const [],
  });

  factory TaskBean.fromJson(Map<String, dynamic> json) {
    return TaskBean(
      id: json['id'] as String,
      name: json['name'] as String,
      focusTime: json['focusTime'] as int,
      restTime: json['restTime'] as int,
      totalTime: json['totalTime'] as int,
      deadData: json['deadData'] as String,
      userTime: json['userTime'] as int,
      taskDayBean: (json['taskDayBean'] as List<dynamic>?)
              ?.map((e) => TaskDayBean.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'focusTime': focusTime,
      'restTime': restTime,
      'totalTime': totalTime,
      'deadData': deadData,
      'userTime': userTime,
      'taskDayBean': taskDayBean.map((e) => e.toJson()).toList(),
    };
  }

  static Future<void> saveTasks(List<TaskBean> tasks,
      {bool isFast = false}) async {
    final String jsonData =
        jsonEncode(tasks.map((task) => task.toJson()).toList());
    if (isFast) {
      LocalStorage().setTaskFastData(jsonData);
    } else {
      LocalStorage().setTaskData(jsonData);
    }
  }

  static Future<List<TaskBean>> loadTasks({bool isFast = false}) async {
    final String jsonData = isFast
        ? await LocalStorage().getTaskFastData()
        : await LocalStorage().getTaskData();
    if (jsonData != null && jsonData.isNotEmpty) {
      final List<dynamic> decodedData = jsonDecode(jsonData);
      List<TaskBean> tasks =
          decodedData.map((json) => TaskBean.fromJson(json)).toList();

      // 计算剩余天数并排序
      tasks.sort((a, b) {
        DateTime deadlineA = DateTime.parse(a.deadData);
        DateTime deadlineB = DateTime.parse(b.deadData);
        print("deadlineA=${deadlineA}");
        print("deadlineB=${deadlineB}");

        int remainingDaysA = TimerUtils.calculateDateDifference(a.deadData);
        int remainingDaysB = TimerUtils.calculateDateDifference(b.deadData);
        print("remainingDaysA=${remainingDaysA}");
        print("remainingDaysB=${remainingDaysB}");
        // 判断任务是否已完成或已延期
        bool isCompletedOrDelayedA =
            remainingDaysA <= 0 || a.userTime >= (a.totalTime * 60);
        bool isCompletedOrDelayedB =
            remainingDaysB <= 0 || b.userTime >= (b.totalTime * 60);

        if (isCompletedOrDelayedA && !isCompletedOrDelayedB) {
          return 1; // 已完成或已延期的任务排在后面
        } else if (!isCompletedOrDelayedA && isCompletedOrDelayedB) {
          return -1; // 未完成且未延期的任务排在前面
        } else {
          return remainingDaysA.compareTo(remainingDaysB); // 按剩余天数排序
        }
      });

      return tasks;
    }
    return [];
  }

  static Future<void> addTask(TaskBean newTask, {bool isFast = false}) async {
    try {
      // 1. 读取本地保存的任务集合
      List<TaskBean> tasks = await TaskBean.loadTasks(isFast: isFast);

      // 2. 添加新任务到集合中
      tasks.add(newTask);

      // 3. 更新本地保存的数据
      await TaskBean.saveTasks(tasks, isFast: isFast);
      LocalStorage.showToast('Success adding task');
    } catch (e) {
      // 处理可能出现的错误
      print('Error adding task: $e');
    }
  }

  static Future<void> updateUserTime(String taskId, int newUserTime,
      {bool isFast = false}) async {
    try {
      // 1. 读取本地保存的任务集合
      List<TaskBean> tasks = await TaskBean.loadTasks(isFast: isFast);
      TaskDayBean taskDayBean = TaskDayBean(day: '', time: 0);

      if (isFast) {
        TaskBean task = tasks[0];
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('MM-dd').format(now);
        task.userTime = newUserTime + task.userTime;
        taskDayBean.day = formattedDate;
        taskDayBean.time = newUserTime;
        task.taskDayBean.add(taskDayBean);
      } else {
        for (var task in tasks) {
          if (task.id == taskId) {
            DateTime now = DateTime.now();
            String formattedDate = DateFormat('MM-dd').format(now);
            task.userTime = newUserTime + task.userTime;
            taskDayBean.day = formattedDate;
            taskDayBean.time = newUserTime;
            task.taskDayBean.add(taskDayBean);
            break;
          }
        }
      }

      // 3. 保存更新后的任务集合
      await TaskBean.saveTasks(tasks, isFast: isFast);
    } catch (e) {
      // 处理可能出现的错误
      print('Error updating userTime: $e');
    }
  }

  //根据id获取TaskBean
  static Future<TaskBean> getTaskById(String taskId) async {
    try {
      // 1. 读取本地保存的任务集合
      List<TaskBean> tasks = await TaskBean.loadTasks();

      // 2. 查找需要更新的任务
      for (var task in tasks) {
        if (task.id == taskId) {
          return task;
        }
      }
      return TaskBean(
        id: '',
        name: '',
        focusTime: 0,
        restTime: 0,
        totalTime: 0,
        deadData: '',
        userTime: 0,
        taskDayBean: [],
      );
    } catch (e) {
      return TaskBean(
        id: '',
        name: '',
        focusTime: 0,
        restTime: 0,
        totalTime: 0,
        deadData: '',
        userTime: 0,
        taskDayBean: [],
      );
    }
  }

  static Future<void> deleteTaskById(String taskId) async {
    try {
      // 1. 读取本地保存的任务集合
      List<TaskBean> tasks = await TaskBean.loadTasks();

      // 2. 移除指定 ID 的任务
      tasks.removeWhere((task) => task.id == taskId);

      // 3. 保存更新后的任务集合到本地
      await TaskBean.saveTasks(tasks);
    } catch (e) {
      // 处理可能出现的错误
      print('Error deleting task: $e');
    }
  }

  static Future<void> updateTaskById(
      String taskId, TaskBean updatedTask) async {
    try {
      // 1. 读取本地保存的任务集合
      List<TaskBean> tasks = await TaskBean.loadTasks();

      // 2. 查找并更新指定 ID 的任务
      for (int i = 0; i < tasks.length; i++) {
        if (tasks[i].id == taskId) {
          tasks[i] = updatedTask; // 更新任务
          break;
        }
      }

      // 3. 保存更新后的任务集合到本地
      await TaskBean.saveTasks(tasks);
    } catch (e) {
      // 处理可能出现的错误
      print('Error updating task: $e');
    }
  }

  static int sumTotalTime(List<TaskBean> taskBeans) {
    return taskBeans.fold(0, (sum, task) => sum + task.totalTime);
  }

  static int sumUserTime(List<TaskBean> taskBeans) {
    return taskBeans.fold(0, (sum, task) => sum + task.userTime);
  }

  // 新增方法：统计当天所有 totalTime 和 userTime 的值之和，并计算 userTime 占 totalTime 的比值
  static Map<String, dynamic> calculateDailyTimeStats(
      List<TaskBean> taskBeans, List<TaskBean> taskBeansFast) {
    int totalTotalTime = 0;
    int totalUserTime = 0;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MM-dd').format(now);

    for (var task in taskBeans) {
      bool isAdded = false; // 添加布尔变量来跟踪是否已经添加过 totalTotalTime
      for (var taskDay in task.taskDayBean) {
        if (taskDay.day == formattedDate) {
          if (!isAdded) {
            totalTotalTime += task.totalTime; // 只在第一次符合条件时添加 totalTotalTime
            isAdded = true; // 设置为 true 以避免重复添加
          }
          totalUserTime += taskDay.time;
        }
      }
    }
    double timeRatioFast = totalUserTime + taskBeansFast[0].userTime > 0 &&
            (totalTotalTime + taskBeansFast[0].totalTime) > 0
        ? ((totalUserTime + taskBeansFast[0].userTime) /
            ((totalTotalTime + taskBeansFast[0].totalTime) * 60))
        : 0.0;
    print("taskBeansFast[0].userTime=${taskBeansFast[0].userTime}");
    return {
      'totalTotalTime': totalTotalTime + taskBeansFast[0].totalTime,
      'totalUserTime': totalUserTime + taskBeansFast[0].userTime,
      'timeRatio': timeRatioFast,
    };
  }
}

class TaskDayBean {
  int time;
  String day;

  TaskDayBean({
    required this.time,
    required this.day,
  });

  factory TaskDayBean.fromJson(Map<String, dynamic> json) {
    return TaskDayBean(
      time: json['time'] as int,
      day: json['day'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'day': day,
    };
  }

  static Map<String, Map<String, dynamic>> aggregateTaskDayData(
      List<TaskDayBean> taskDayList) {
    // 创建一个 Map 用于存储结果，key 是日期，value 是包含总 time 和次数的 Map
    Map<String, Map<String, dynamic>> aggregatedData = {};

    for (var task in taskDayList) {
      if (aggregatedData.containsKey(task.day)) {
        // 如果日期已经存在，累加 time 和次数
        aggregatedData[task.day]!['time'] += task.time;
        aggregatedData[task.day]!['count'] += 1;
      } else {
        // 如果日期不存在，初始化数据
        aggregatedData[task.day] = {'time': task.time, 'count': 1};
      }
    }

    return aggregatedData;
  }
}

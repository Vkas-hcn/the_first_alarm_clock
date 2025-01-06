import 'dart:async';
import 'package:intl/intl.dart';

class TimerUtils {
  /// 最大时间：120分钟（以秒为单位）
  static const int maxTime = 120 * 60;

  /// 最小时间：3秒
  static const int minTime = 3;

  late int _totalSeconds; // 总秒数
  late bool _isCountDown; // 是否倒计时
  Timer? _timer;

  /// 每次计时更新回调：小时、分钟、秒（字符串形式，个位数前补0）
  Function(String hours, String minutes, String seconds)? onTick;

  TimerUtils({
    required int initialMinutes,
    required this.onTick,
    bool isCountDown = true,
  }) {
    setInitialTime(initialMinutes);
    _isCountDown = isCountDown;
  }

  /// 设置初始时间（以分钟为单位）
  void setInitialTime(int minutes) {
    int seconds = minutes * 60;
    if (seconds < minTime) {
      throw ArgumentError("时间不能小于 $minTime 秒");
    }
    if (seconds > maxTime) {
      throw ArgumentError("时间不能大于 $maxTime 秒");
    }
    _totalSeconds = seconds;
  }

  /// 开始计时
  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isCountDown) {
        _totalSeconds--;
      } else {
        _totalSeconds++;
      }

      if (_totalSeconds <= 0 && _isCountDown) {
        stop(); // 倒计时结束
        onTick?.call("00", "00", "00"); // 输出 00, 00, 00
        return;
      }

      // 输出小时、分钟、秒
      int hours = _totalSeconds ~/ 3600;
      int minutes = (_totalSeconds % 3600) ~/ 60;
      int seconds = _totalSeconds % 60;

      onTick?.call(
        padZero(hours),
        padZero(minutes),
        padZero(seconds),
      );
    });
  }

  /// 停止计时
  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  /// 重置计时
  void reset() {
    _totalSeconds = 0;
    stop();
  }

  /// 暂停计时
  void pause() {
    _timer?.cancel();
  }

  /// 切换计时模式
  void toggleMode() {
    _isCountDown = !_isCountDown;
  }

  /// 补0方法
  static String padZero(int value) {
    return value < 10 ? "0$value" : value.toString();
  }

  static String getCurrentFormattedTime() {
    final now = DateTime.now();
    final formatter = DateFormat('MMMM dd, h:mm a');
    return formatter.format(now);
  }

  static String subtractTime({
    required int baseMinutes, // 被减数，以分钟为单位
    required String hoursData, // 小时部分的减数，字符串格式
    required String minutesData, // 分钟部分的减数，字符串格式
    required String secondsData, // 秒部分的减数，字符串格式
  }) {
    int parsedHours = int.tryParse(hoursData) ?? 0;
    int parsedMinutes = int.tryParse(minutesData) ?? 0;
    int parsedSeconds = int.tryParse(secondsData) ?? 0;
    final Duration baseDuration = Duration(minutes: baseMinutes);
    final Duration subtractDuration = Duration(
      hours: parsedHours,
      minutes: parsedMinutes,
      seconds: parsedSeconds,
    );
    final Duration resultDuration = baseDuration - subtractDuration;
    if (resultDuration.isNegative) {
      return "0:00";
    }
    final int resultHours = resultDuration.inHours;
    final int resultMinutes = resultDuration.inMinutes % 60;
    final int resultSeconds = resultDuration.inSeconds % 60;
    if (resultHours > 0) {
      return '${resultHours.toString().padLeft(2, '0')}:${resultMinutes.toString().padLeft(2, '0')}:${resultSeconds.toString().padLeft(2, '0')}';
    } else {
      return '${resultMinutes.toString().padLeft(2, '0')}:${resultSeconds.toString().padLeft(2, '0')}';
    }
  }

  static Map<String, String> getCurrentTimeFormatted() {
    final now = DateTime.now();
    final monthDayFormatter = DateFormat('MMMM d');
    final hourFormatter = DateFormat('hh');
    final minuteFormatter = DateFormat('mm');
    final secondFormatter = DateFormat('ss');
    final amPmFormatter = DateFormat('a');
    final monthDay = monthDayFormatter.format(now);
    final hour = hourFormatter.format(now);
    final minute = minuteFormatter.format(now);
    final second = secondFormatter.format(now);
    final amPm = amPmFormatter.format(now);

    return {
      'monthDay': monthDay,
      'hour': hour.padLeft(2, '0'),
      'minute': minute.padLeft(2, '0'),
      'second': second.padLeft(2, '0'),
      'amPm': amPm.toUpperCase(),
    };
  }

  static int timeStringToTimestamp(String timeString) {
    // 分割字符串，按冒号分隔成时、分、秒
    List<String> parts = timeString.split(':');
    if (parts.length != 3) {
      throw ArgumentError('Invalid time format. Expected HH:mm:ss');
    }

    // 转换每部分为整数
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);

    // 计算总秒数
    return hours * 3600 + minutes * 60 + seconds;
  }

  static int timeStringToTimestamp2(int baseMinutes,
      String hoursData, String minutesData, String secondsData) {
    int parsedHours = int.tryParse(hoursData) ?? 0;
    int parsedMinutes = int.tryParse(minutesData) ?? 0;
    int parsedSeconds = int.tryParse(secondsData) ?? 0;
    final Duration baseDuration = Duration(minutes: baseMinutes);
    final Duration subtractDuration = Duration(
      hours: parsedHours,
      minutes: parsedMinutes,
      seconds: parsedSeconds,
    );
    final Duration resultDuration = baseDuration - subtractDuration;
    if (resultDuration.isNegative) {
      return 0;
    }
    final int resultHours = resultDuration.inHours;
    final int resultMinutes = resultDuration.inMinutes % 60;
    final int resultSeconds = resultDuration.inSeconds % 60;

    // 计算总秒数
    return resultHours * 3600 + resultMinutes * 60 + resultSeconds;
  }

  static Map<String, String> timestampToTimeString(int timestamp) {
    // 计算时、分、秒
    int hours = timestamp ~/ 3600;
    int minutes = (timestamp % 3600) ~/ 60;
    int seconds = timestamp % 60;

    // 格式化为字符串，个位数用0补齐
    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return {
      'hoursStr': hoursStr,
      'minutesStr': minutesStr,
      'secondsStr': secondsStr,
    };
  }

  static int calculateDaysSince(String timestampMillis) {
    // 将时间戳字符串转换为整数
    int timestamp = int.parse(timestampMillis);

    // 从时间戳创建 DateTime 对象
    DateTime inputTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // 获取当前时间
    DateTime now = DateTime.now();

    // 计算时间差
    Duration difference = now.difference(inputTime);

    // 返回天数部分
    return difference.inDays;
  }
}

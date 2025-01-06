import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const taskJson = 'taskJson';
  static const taskJsonFast = 'taskJsonFast';

  static const clockSkin = 'clockSkin';
  static const clockFocus = 'clockFocus';
  static const clockRest = 'clockRest';

  static final LocalStorage _instance = LocalStorage._internal();
  late SharedPreferences _prefs;

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  factory LocalStorage() {
    return _instance;
  }

  LocalStorage._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Set value by key
  Future<void> setValue(String key, dynamic value) async {
    if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    }
  }

  // Get value by key
  dynamic getValue(String key) {
    return _prefs.get(key);
  }



  Future<int> getSkinData() async {
    return _prefs.getInt(clockSkin) ?? 1;
  }

  Future<void> setSkinData(int data) async {
    await _prefs.setInt(clockSkin, data);
  }

  Future<int> getFocusData() async {
    return _prefs.getInt(clockFocus) ?? 25;
  }

  Future<void> setFocusData(int data) async {
    await _prefs.setInt(clockFocus, data);
  }

  Future<int> getRestData() async {
    return _prefs.getInt(clockRest) ?? 5;
  }

  Future<void> setRestData(int data) async {
    await _prefs.setInt(clockRest, data);
  }

  Future<String> getTaskData() async {
    return _prefs.getString(taskJson) ?? '';
  }

  Future<void> setTaskData(String data) async {
    await _prefs.setString(taskJson, data);
  }

  Future<String> getTaskFastData() async {
    return _prefs.getString(taskJsonFast) ?? '';
  }


  Future<void> setTaskFastData(String data) async {
    await _prefs.setString(taskJsonFast, data);
  }
  //Toast
  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

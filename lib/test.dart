import 'package:flutter/material.dart';
import 'package:the_first_alarm_clock/wight/SliderExample.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('自定义 Slider 滑动选择器'),
        ),
        body: null
      ),
    );
  }
}




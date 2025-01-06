import 'package:flutter/material.dart';

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
        body: Center(
          child: SliderExample(),
        ),
      ),
    );
  }
}

class SliderExample extends StatefulWidget {
  @override
  _SliderExampleState createState() => _SliderExampleState();
}

class _SliderExampleState extends State<SliderExample> {
  double _value = 3.0; // 初始值为 3 分钟

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '选择时间: ${_value.toInt()} 分钟',
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 20),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.blue[300],
            inactiveTrackColor: Colors.blue[100],
            thumbColor: Colors.blue,
            thumbShape: CustomSliderThumbShape(thumbRadius: 15.0),
            overlayColor: Colors.blue.withAlpha(32),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
          ),
          child: Slider(
            value: _value,
            min: 3.0,
            max: 180.0,
            divisions: 177, // 180 - 3 + 1 = 178 个刻度
            label: _value.round().toString(),
            onChanged: (double newValue) {
              setState(() {
                _value = newValue;
              });
            },
          ),
        ),
      ],
    );
  }
}

class CustomSliderThumbShape extends SliderComponentShape {
  final double thumbRadius;

  CustomSliderThumbShape({required this.thumbRadius});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    final Canvas canvas = context.canvas;

    // 绘制自定义滑块图片
    final ImageProvider imageProvider = AssetImage('assets/img/custom_thumb.png'); // 替换为你的图片路径
    final ImageStream imageStream = imageProvider.resolve(ImageConfiguration.empty);
    imageStream.addListener(ImageStreamListener((ImageInfo imageInfo, bool synchronousCall) {
      final Paint paint = Paint();
      final Rect rect = Rect.fromCircle(center: center, radius: thumbRadius);
      canvas.drawImageRect(
        imageInfo.image,
        Rect.fromLTWH(0, 0, imageInfo.image.width.toDouble(), imageInfo.image.height.toDouble()),
        rect,
        paint,
      );
    }));
  }
}

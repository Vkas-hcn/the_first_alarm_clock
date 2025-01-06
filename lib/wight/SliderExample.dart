import 'package:flutter/material.dart';
import 'package:the_first_alarm_clock/data/LocalStorage.dart';
import 'package:the_first_alarm_clock/data/TimerUtils.dart';

class SliderExample extends StatefulWidget {
  final int jiShiState; //1:Focus,2:Rest,3:CountDown,
  final void Function(double value) onSave;

  const SliderExample(
      {Key? key, required this.onSave, required this.jiShiState})
      : super(key: key);

  @override
  _SliderExampleState createState() => _SliderExampleState();
}

class _SliderExampleState extends State<SliderExample> {
  double _value = 15.0;
  String hoursData = "00";
  String minutesData = "00";
  String secondsData = "00";
  double minTime = 0;
  double maxTime = 0;

  @override
  void initState() {
    super.initState();
    setMinMaxTIme();
  }

  String getShowTiem() {
    int time = _value.toInt();
    return TimerUtils.padZero(time);
  }

  void setMinMaxTIme() {
    setState(() {
      minTime = widget.jiShiState == 1 ? 15 : 3;
      print("widget.jiShiState=${widget.jiShiState}");
      // minTime = widget.jiShiState == 1 ? 1 : 1;
      print("minTime=${minTime}");

      maxTime = widget.jiShiState != 2 ? 120 : 30;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: widget.jiShiState == 3 ? 35 : 80),
        if (widget.jiShiState == 3)
          const Text(
            "Set the countdown time",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        if (widget.jiShiState == 3) const SizedBox(height: 28),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 80,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/img/bg_djs.webp'),
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
                              child: Image.asset('assets/img/bg_djs_t.webp'),
                            ),
                            SizedBox(
                              width: 80,
                              height: 26,
                              child: Image.asset('assets/img/bg_djs_b.webp'),
                            ),
                            SizedBox(height: 4),
                          ],
                        ),
                        Text(
                          getShowTiem(),
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
                          child: Image.asset('assets/img/ic_line.webp'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 80,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/img/bg_djs.webp'),
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
                              child: Image.asset('assets/img/bg_djs_t.webp'),
                            ),
                            SizedBox(
                              width: 80,
                              height: 26,
                              child: Image.asset('assets/img/bg_djs_b.webp'),
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
                          child: Image.asset('assets/img/ic_line.webp'),
                        ),
                        if (hoursData != "00")
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: Container(
                              width: 46,
                              height: 22,
                              decoration: BoxDecoration(
                                color: const Color(0xFF8A3E18),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(11)),
                                border: Border.all(
                                  color: Color(0xFF8A3E18),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                secondsData,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 8,
            activeTrackColor: Color(0xFFF47B23),
            inactiveTrackColor: Color(0xFFFFD234),
            thumbColor: Color(0xFFF78A25),
            thumbShape: CustomSliderThumbShape(thumbRadius: 10.0),
            overlayColor: Colors.blue.withAlpha(32),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
               Text(
                "${minTime}min",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Slider(
                  value: _value,
                  min: minTime,
                  max: maxTime,
                  divisions: 117,
                  // 120 - 3 + 1 = 118 个刻度
                  label: _value.round().toString(),
                  onChanged: (double newValue) {
                    setState(() {
                      _value = newValue;
                    });
                  },
                ),
              ),
               Text(
                "${maxTime}min",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            print("object=====_value=${_value}");
            Navigator.pop(context);
            widget.onSave(_value);
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
              "Confirm",
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

    // 绘制滑块的圆形背景，使其比进度条高出
    final Paint circlePaint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.blue;
    canvas.drawCircle(center, thumbRadius, circlePaint);

    // 如果需要添加额外的装饰，如边框或图标，可继续在此处绘制
    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;
    canvas.drawCircle(center, thumbRadius, borderPaint);
  }
}

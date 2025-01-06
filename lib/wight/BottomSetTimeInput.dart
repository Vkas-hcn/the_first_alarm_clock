import 'package:flutter/material.dart';
import 'SliderExample.dart';

class BottomSetTimeInput extends StatefulWidget {
  final int jiShiState; //1:Focus,2:Rest,3:CountDown,
  final void Function(double) onSave;

  const BottomSetTimeInput(
      {Key? key, required this.onSave, required this.jiShiState})
      : super(key: key);

  @override
  State<BottomSetTimeInput> createState() => _BottomSetTimeInputState();
}

class _BottomSetTimeInputState extends State<BottomSetTimeInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        return Container(
          decoration: BoxDecoration(
            color: Color(0xFF321204),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: keyboardHeight,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.jiShiState==3 ? "Countdown Settings" : widget.jiShiState==1?"Focus Time":"Rest Time",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: Image.asset('assets/img/ic_dialog_clone.webp'),
                        ),
                      )
                    ],
                  ),
                  Center(
                    child: SliderExample(
                        onSave: (v) {
                          widget.onSave(v);
                        },
                        jiShiState: widget.jiShiState),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

void showBottomSetTimeInput(
    BuildContext context, int jiShiState, void Function(double) onSave) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Wrap(
        children: [
          BottomSetTimeInput(onSave: onSave, jiShiState: jiShiState),
        ],
      );
    },
  );
}

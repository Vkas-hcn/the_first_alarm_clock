import 'package:flutter/material.dart';

class BottomSheetWithInput extends StatefulWidget {
  final void Function(int) onSave;

  const BottomSheetWithInput({Key? key, required this.onSave}) : super(key: key);

  @override
  State<BottomSheetWithInput> createState() => _BottomSheetWithInputState();
}

class _BottomSheetWithInputState extends State<BottomSheetWithInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose(); // 释放资源
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
                      const Text(
                        "Style:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
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
                  const SizedBox(height: 36),
                  GestureDetector(
                    onTap: () {
                      widget.onSave(1);
                      Navigator.of(context).pop();
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 84,
                      child: Image.asset('assets/img/ic_skin_1.webp'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {
                      widget.onSave(2);
                      Navigator.of(context).pop();
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 84,
                      child: Image.asset('assets/img/ic_skin_2.webp'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {
                      widget.onSave(3);
                      Navigator.of(context).pop();
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 84,
                      child: Image.asset('assets/img/ic_skin_3.webp'),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

void showBottomSheetWithInput(BuildContext context, void Function(int) onSave) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // 允许弹框动态调整高度
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Wrap(
        children: [
          BottomSheetWithInput(
            onSave: onSave,
          ),
        ],
      );
    },
  );
}

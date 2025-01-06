import 'package:flutter/material.dart';

class BottomWithMenu extends StatefulWidget {
  final void Function() onEdit;
  final void Function() onDelete;

  const BottomWithMenu({Key? key, required this.onEdit, required this.onDelete})
      : super(key: key);

  @override
  State<BottomWithMenu> createState() => _BottomWithMenuState();
}

class _BottomWithMenuState extends State<BottomWithMenu> {
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
                        "More:",
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
                  const SizedBox(height: 44),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.onEdit();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 19, horizontal: 20),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                        border: Border.all(
                          color: const Color(0xFFC45618),
                          width: 2,
                        ),
                        color: const Color(0xFF682706),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Image.asset('assets/img/ic_edit.webp'),
                          ),
                          const Text(
                            'Edit',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.onDelete();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 19, horizontal: 20),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                        color: const Color(0xFF682706),
                        border: Border.all(
                          color: const Color(0xFFC45618),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Image.asset('assets/img/ic_delete.png'),
                          ),
                          const Text(
                            'Delete',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 44),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

void showBottomWithMenu(
    BuildContext context, void Function() onEdit, void Function() onDelete) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // 允许弹框动态调整高度
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Wrap(
        children: [
          BottomWithMenu(
            onEdit: () {
              onEdit();
            },
            onDelete: () {
              onDelete();
            },
          ),
        ],
      );
    },
  );
}

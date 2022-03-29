import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mind Map',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MindMapBuilder(),
    );
  }
}

class MindMapBuilder extends StatefulWidget {
  const MindMapBuilder({Key? key}) : super(key: key);

  @override
  State<MindMapBuilder> createState() => _MindMapBuilderState();
}

class _MindMapBuilderState extends State<MindMapBuilder> {
  final tasks = [
    Task(text: "Begin Here "),
  ];
  int currentTaskId = -1;
  bool show = false;
  // bool isConnect = false;
  OffsetWithTypes currentOffset = OffsetWithTypes(
      offset: const Offset(-10000, -10000), type: EventType.unknown);
  Task getTaskById(int id) {
    return tasks.firstWhere((element) => element.id == id);
  }

  void removeTaskById(int id) {
    tasks.removeWhere((element) => element.id == id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                  child: SizedBox(
                    // width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height * 0.8,
                    child: GestureDetector(
                      behavior: HitTestBehavior.deferToChild,
                      onPanStart: (details) {
                        currentOffset = OffsetWithTypes(
                            offset: details.localPosition,
                            type: EventType.start);
                        setState(() {});
                      },
                      onPanUpdate: (details) {
                        currentOffset = OffsetWithTypes(
                            offset: details.localPosition,
                            type: EventType.updating);
                        // print("sending");

                        // if (isConnect) return;
                        if (currentTaskId != -1) {
                          setState(() {
                            getTaskById(currentTaskId).position =
                                details.localPosition;
                          });
                        }
                      },
                      onPanEnd: (details) {
                        currentOffset = OffsetWithTypes(
                          offset: currentOffset.offset,
                          type: EventType.end,
                        );
                        // if (isConnect) return;
                        setState(() {
                          currentTaskId = -1;
                          show = false;
                        });
                      },
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomPaint(
                              painter: MindMapPainter(
                                tasks: tasks,
                                currentOffset: currentOffset,
                              ),
                            ),
                          ),
                          ...tasks.map((task) {
                            return Positioned(
                              left: task.position.dx,
                              top: task.position.dy,
                              child: GestureDetector(
                                onTapDown: (details) {
                                  // if (isConnect) return;
                                  currentTaskId = task.id;
                                  show = false;
                                },
                                onTapUp: (details) {
                                  // if (isConnect) return;
                                  currentTaskId = task.id;
                                  setState(() {
                                    show = true;
                                  });
                                },
                                child: OutlinedButton(
                                  onPressed: () {
                                    // if (isConnect) return;
                                    currentTaskId = task.id;
                                    setState(() {
                                      show = true;
                                    });
                                  },
                                  child: Text(
                                    task.text,
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      width: 2.0,
                                      color: currentTaskId == task.id
                                          ? Colors.blue.shade700
                                          : Colors.blue.shade300,
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                  ),
                ),
                if (show)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final value = await Navigator.of(context)
                                  .push(PageRouteBuilder(
                                opaque: false,
                                barrierColor: Colors.black54,
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return TestInputWidget(
                                    defaultString:
                                        getTaskById(currentTaskId).text,
                                  );
                                },
                              ));
                              if (value == null) return;
                              getTaskById(currentTaskId).text = value as String;
                              setState(() {});
                            },
                            child: const Text("edit text"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                removeTaskById(currentTaskId);
                              });
                            },
                            child: const Text("delete"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              final a = getTaskById(currentTaskId).position;
                              setState(() {
                                tasks.add(
                                  Task(
                                    text: "",
                                    position: Offset(a.dx + 50, a.dy + 10),
                                    arrowTo: [
                                      currentTaskId,
                                    ],
                                  ),
                                );
                              });
                            },
                            child: const Text("add child"),
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum EventType {
  start,
  end,
  updating,
  unknown,
}

class OffsetWithTypes {
  Offset offset;
  EventType type;
  OffsetWithTypes({
    required this.offset,
    required this.type,
  });
}

class MindMapPainter extends CustomPainter {
  final List<Task> tasks;
  final OffsetWithTypes currentOffset;

  MindMapPainter({
    required this.tasks,
    required this.currentOffset,
  });

  Task getTaskById(int id) {
    return tasks.firstWhere((element) => element.id == id);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // canvas.drawPaint(Paint()..color = Colors.blue);
    for (var i = 0; i < tasks.length; i++) {
      // final padding = 8;
      // final p = PaintText(
      //   text: tasks[i].text,
      //   canvas: canvas,
      //   offset: Offset(tasks[i].position.dx, tasks[i].position.dy + 14),
      //   maxWidth: 100,
      //   padding: const EdgeInsets.all(8),
      //   fill: false,
      //   borderWidth: 3,
      //   borderColor: Colors.black,
      //   style: const TextStyle(
      //     fontSize: 18,
      //     color: Colors.black,
      //   ),
      // );
      // // p.paint();
      // var dim1 = {
      //   "x": p.offset.dx,
      //   "y": p.offset.dy,
      //   "w": p.size.width,
      //   "h": p.size.height,
      // };
      // var dim2 = {
      //   "x": currentOffset.offset.dx,
      //   "y": currentOffset.offset.dy,
      //   "w": p.size.width,
      //   "h": p.size.height,
      // };
      // if (dim1["x"]! < dim2["x"]! + dim2["w"]! &&
      //     dim1["x"]! + dim1["w"]! > dim2["x"]! &&
      //     dim1["y"]! < dim2["y"]! + dim2["h"]! &&
      //     dim1["h"]! + dim1["y"]! > dim2["y"]!) {
      //   if (currentOffset.type == EventType.start) {
      //     onTapDown(i);
      //   }
      //   if (currentOffset.type == EventType.end) {
      //     onTapUp(i);
      //   }
      //   if (currentOffset.type == EventType.updating) {
      //     onTapUpdate(i);
      //   }
      // }
      final t = tasks.elementAt(i);
      if (t.arrowTo.isNotEmpty) {
        final a = getTaskById(t.arrowTo.first);
        final b = t.position;
        canvas.drawLine(
          Offset(
            a.position.dx + 8 * 2,
            a.position.dy + (a.textStyle.fontSize ?? 14) / 2,
          ),
          Offset(b.dx + 8 * 2, b.dy + (t.textStyle.fontSize ?? 14) / 2),
          Paint()
            ..color = Colors.blue
            ..strokeWidth = 3,
        );
        // p.size.width
      }
      // canvas.drawPath(Path()..arcToPoint(arcEnd), paint)
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Task {
  static int idGlobal = 0;
  Offset position = const Offset(200 / 2, 200 / 2);
  List<int> arrowTo = [];
  Color color = Colors.black;
  TextStyle textStyle = const TextStyle();
  int id = 0;
  String text;
  Task({
    this.arrowTo = const [],
    this.color = Colors.black,
    required this.text,
    this.position = const Offset(0, 0),
    this.textStyle = const TextStyle(),
  }) {
    id = idGlobal;
    idGlobal += 1;
  }
  void dispose() {
    idGlobal -= 1;
  }
}

class TestInputWidget extends StatefulWidget {
  final String defaultString;
  const TestInputWidget({Key? key, this.defaultString = ""}) : super(key: key);

  @override
  State<TestInputWidget> createState() => _TestInputWidgetState();
}

class _TestInputWidgetState extends State<TestInputWidget> {
  final TextEditingController _c = TextEditingController();
  bool showSendButton = false;
  @override
  void initState() {
    _c.value = TextEditingValue(text: widget.defaultString);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool a = true;
        if (_c.text.isNotEmpty) {
          await showDialog(
            context: context,
            builder: (context) {
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                child: AlertDialog(
                  title: const Text("Discard?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        a = true;
                        Navigator.pop(context);
                      },
                      child: const Text("Discard"),
                    ),
                    TextButton(
                      onPressed: () {
                        a = false;
                        Navigator.pop(context);
                      },
                      child: const Text("Keep Writing"),
                    ),
                  ],
                ),
              );
            },
          );
        }
        return a;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _c,
                      autofocus: true,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          if (!showSendButton) {
                            showSendButton = true;
                            setState(() {});
                          }
                        } else {
                          setState(() {
                            showSendButton = false;
                          });
                        }
                      },
                      onSubmitted: (value) {
                        Navigator.of(context).pop(value);
                      },
                    ),
                  ),
                ),
                if (_c.text.isNotEmpty)
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context, _c.text);
                    },
                    icon: const Icon(Icons.send),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Arrow {}

class PaintText {
  String text;
  TextStyle style = const TextStyle(color: Colors.black);
  double maxWidth = 0;
  Canvas canvas;
  Offset offset;
  late TextPainter _painter;
  EdgeInsets padding;
  double borderWidth;
  bool fill;
  Color borderColor;
  PaintText({
    required this.text,
    this.style = const TextStyle(color: Colors.black),
    this.maxWidth = 0,
    this.borderWidth = 0,
    this.fill = true,
    this.padding = EdgeInsets.zero,
    required this.canvas,
    required this.offset,
    required this.borderColor,
  }) {
    final textSpan = TextSpan(
      text: text,
      style: style,
    );
    _painter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: 3,
    );
    _painter.layout(
      minWidth: 0,
      maxWidth: maxWidth,
    );
  }
  Size get size {
    return _painter.size;
  }

  void paint() {
    // canvas.translate(size.width / 4, size.height / 2);
    double width = _painter.width, height = _painter.height;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(
            width / 2 + (offset.dx + padding.left / 2 - padding.right / 2),
            height / 2 + (offset.dy + padding.top / 2 - padding.bottom / 2),
          ),
          width: width + padding.left + padding.right,
          height: height + padding.top + padding.bottom,
        ),
        const Radius.circular(5),
      ),
      Paint()
        ..color = borderColor
        ..style = fill ? PaintingStyle.fill : PaintingStyle.stroke
        ..strokeWidth = borderWidth,
    );
    // canvas.drawDRRect(
    //     RRect.fromRectAndRadius(
    //       Rect.fromCenter(
    //         center: Offset(offset.dx + 100, offset.dy + 100),
    //         width: width,
    //         height: height,
    //       ),
    //       Radius.circular(5),
    //     ),
    //     RRect.fromRectAndRadius(
    //       Rect.fromCenter(
    //         center: Offset(
    //           offset.dx + (100 + padding.left / 2 - padding.right / 2),
    //           offset.dy + (100 + padding.top / 2 - padding.bottom / 2),
    //         ),
    //         width: width - padding.left - padding.right,
    //         height: height - padding.top - padding.bottom,
    //       ),
    //       Radius.circular(5),
    //     ),
    //     Paint()
    //       ..color = Colors.deepPurpleAccent
    //       ..style = PaintingStyle.fill);

    _painter.paint(canvas, Offset(offset.dx, offset.dy));
    // canvas.translate(-size.width / 2, -size.height / 2);
  }
}

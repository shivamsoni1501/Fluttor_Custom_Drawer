import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class MusicAnim extends StatefulWidget {
  final int count;
  final double width;
  final double height;
  final Color color;
  final Function toggle;

  MusicAnim(
      {Key key, this.width, this.color, this.count, this.height, this.toggle})
      : super(key: key);

  @override
  _MusicAnimState createState() => _MusicAnimState();
}

class _MusicAnimState extends State<MusicAnim> {
  double cWidth;
  List<double> cHeights;
  bool isStart = false;

  @override
  void initState() {
    super.initState();
    cWidth = (widget.width / widget.count) * .6;
    cHeights = List.generate(widget.count, (index) => widget.height * .7);
  }

  setHeight() {
    Timer.periodic(Duration(milliseconds: 200), (t) {
      if (!widget.toggle()) {
        t.cancel();
        isStart = false;
        return;
      }
      for (int i = 0; i < widget.count; i++) {
        cHeights[i] = Random().nextDouble() * widget.height * .9;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.toggle() && !isStart) {
      setHeight();
      isStart = true;
    }
    return Container(
      width: widget.width,
      height: widget.height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          widget.count,
          (index) => AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: cWidth,
            height: cHeights[index],
            color: widget.color,
          ),
        ),
      ),
    );
  }
}

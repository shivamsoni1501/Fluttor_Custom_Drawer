import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/musicTileW.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key key}) : super(key: key);

  @override
  CustomDrawerState createState() => new CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  bool _dragStart = false;
  double screenSize;
  final double maxLeftSlide = 15.0;
  double _dragWidth = 300;

  bool isStart = false;

  String buttonT;

  musicState() {
    return isStart;
  }

  toggleMusic() {
    isStart = !isStart;
    buttonT = (isStart) ? 'Tap to Pause Music' : 'Tap to Play Music';
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggle() {
    _controller.isDismissed ? _controller.forward() : _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size.width;
    _dragWidth = screenSize * .8;
    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          return Material(
            color: Colors.grey.shade700,
            child: Stack(
              children: <Widget>[
                Transform.translate(
                  offset: Offset(
                      -screenSize + screenSize * .8 * (_animation.value), 0),
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(math.pi * .5 * (1 - _animation.value)),
                    alignment: Alignment.centerRight,
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(
                        sigmaX: (2 - 2 * _animation.value),
                      ),
                      child: CustomDrawerC(),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset((screenSize * .8) * _animation.value, 0),
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(-math.pi * _animation.value / 2),
                    alignment: Alignment.centerLeft,
                    child: HomeScreen(),
                  ),
                ),
                Positioned(
                  top: 35,
                  left: _dragWidth * _animation.value,
                  width: screenSize,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.menu,
                            size: 30,
                          ),
                          onPressed: toggle),
                      Text(
                        'Custom Drawer',
                        style: TextStyle(fontSize: 25),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ),
                Transform.translate(
                  offset: Offset((screenSize * .8) * _animation.value, 0),
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(-math.pi * _animation.value / 2),
                    alignment: Alignment.centerLeft,
                    child: Container(
                      alignment: Alignment.center,
                      child: MusicAnim(
                          color: Colors.black38,
                          width: 300,
                          height: 200,
                          count: 50,
                          toggle: musicState),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset((screenSize * .95) * _animation.value, 0),
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(-math.pi * .55 * _animation.value),
                    alignment: Alignment.centerLeft,
                    child: Container(
                      alignment: Alignment.center,
                      child: MusicAnim(
                          color: Colors.deepOrange.shade900,
                          width: 300,
                          height: 200,
                          count: 50,
                          toggle: musicState),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0 + 3 * (_animation.value), 1),
                  child: FlatButton(
                    child: Text(
                      buttonT,
                    ),
                    onPressed: () {
                      toggleMusic();
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft =
        _animation.isDismissed && details.globalPosition.dx < maxLeftSlide;
    bool isDragCloseFromRight = _animation.isCompleted;
    _dragStart = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_dragStart) {
      double delta = details.primaryDelta / _dragWidth;
      _controller.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    double _dragStartVelocity = 350;

    if (_animation.isDismissed || _animation.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx >= _dragStartVelocity) {
      _controller.forward();
    } else if (details.velocity.pixelsPerSecond.dx <= -_dragStartVelocity) {
      _controller.reverse();
    } else if (_animation.value < 0.5) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }
}

class CustomDrawerC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.brown.shade100,
      child: Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: 300,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                FlutterLogo(
                  size: 200,
                ),
                ListTile(
                  leading: Icon(Icons.ten_mp),
                  title: Text('List 1'),
                ),
                ListTile(
                  leading: Icon(Icons.twelve_mp),
                  title: Text('List 2'),
                ),
                ListTile(
                  leading: Icon(Icons.twenty_mp),
                  title: Text('List 3'),
                ),
                ListTile(
                  leading: Icon(Icons.twenty_two_mp),
                  title: Text('List 4'),
                ),
                ListTile(
                  leading: Icon(Icons.twenty_three_mp),
                  title: Text('List 5'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(50),
        alignment: Alignment.bottomCenter,
        color: Colors.brown.shade100,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class EmptyPage extends StatefulWidget {
  final icon;
  final message;
  final bool animate;
  const EmptyPage({Key key, this.icon, this.message, this.animate = false})
      : super(key: key);
  @override
  _EmptyPageState createState() => _EmptyPageState(icon, message, animate);
}

class _EmptyPageState extends State<EmptyPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final icon;
  final message;
  final bool animate;
  _EmptyPageState(this.icon, this.message, this.animate);
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    if (animate) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedBuilder(
                    builder: (BuildContext context, Widget _widget) {
                      return Transform.rotate(
                        angle: _controller.value * 6.3,
                        child: _widget,
                      );
                    },
                    animation: _controller,
                    child: Icon(
                      icon,
                      color: Colors.grey[500],
                      size: 80,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    message,
                    style: TextStyle(color: Colors.grey[500], fontSize: 16),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}

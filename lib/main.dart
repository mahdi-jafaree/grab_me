import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: ""),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  bool alienVisible = true;
  bool onTop = false;
  AnimationController _spaceController;
  Animation<Offset> _spaceAnimation;

  void initState() {
    _spaceController =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..repeat(reverse: true);
    _spaceAnimation =
        Tween<Offset>(begin: Offset(-0.1, 0.0), end: Offset(.1, 0.0)).animate(
      CurvedAnimation(
        parent: _spaceController,
        curve: Curves.easeInOutQuad,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              "assets/bg.jpg",
            ),
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: SlideTransition(
                  position: _spaceAnimation,
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                        duration: Duration(
                          seconds: 1,
                          milliseconds: 500,
                        ),
                        child: AnimatedOpacity(
                          onEnd: () {
                            if (!_spaceController.isAnimating) {
                              print("ended");
                              setState(() {
                                alienVisible = true;
                              });
                            }
                          },
                          opacity: alienVisible ? 1.0 : 0.0,
                          duration: Duration(
                            seconds: 1,
                            milliseconds: 500,
                          ),
                          child: Lottie.asset(
                            "assets/alien.json",
                            width: 100,
                            height: 100,
                          ),
                        ),
                        bottom: onTop
                            ? MediaQuery.of(context).size.height * .65
                            : 10,
                        left: MediaQuery.of(context).size.width * .4,
                      ),
                      AnimatedOpacity(
                        opacity: alienVisible ? 0.0 : 1.0,
                        duration: Duration(milliseconds: 700),
                        child: ClipPath(
                          clipper: const BeamClipper(),
                          child: Container(
                            height: 650,
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                radius: 2.0,
                                colors: [
                                  Colors.yellow[200],
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Image.asset(
                            "assets/spaceship.png",
                            width: MediaQuery.of(context).size.width * .8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _spaceController.stop();
          setState(() {
            alienVisible = !alienVisible;
            onTop = !onTop;
          });
          Timer(Duration(seconds: 2), () {
            _spaceController.repeat(reverse: true);
          });
        },
        tooltip: 'Increment',
        child: Icon(alienVisible ? Icons.arrow_upward : Icons.arrow_downward),
      ),
    );
  }

  @override
  void dispose() {
    _spaceController.dispose();
    super.dispose();
  }
}

class BeamClipper extends CustomClipper<Path> {
  const BeamClipper();

  @override
  getClip(Size size) {
    return Path()
      ..lineTo(size.width / 2, size.height / 4)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(size.width / 2, size.height / 4)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => false;
}

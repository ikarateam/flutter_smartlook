import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WireframeSingleWidgetTestScreen extends StatefulWidget {
  const WireframeSingleWidgetTestScreen({Key? key}) : super(key: key);

  @override
  State<WireframeSingleWidgetTestScreen> createState() => _WireframeSingleWidgetTestScreenState();
}

class _WireframeSingleWidgetTestScreenState extends State<WireframeSingleWidgetTestScreen>
    with TickerProviderStateMixin {
  bool switchValue = false;
  late final AnimationController _controller;
  late final AnimationController _sizeController;
  late final Animation<double> _sizeAnimation;
  late final Animation<double> _positionAnimation;
  late WebViewController _controllerWeb;
  bool isChecked = true;

  //TODO rotace okolo něčeho co rotuje a rotovat ještě okolo toho
  //TODO rozpoznaní obrázky - pokud se změní
  //TODO adaptive framerate

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();

    _sizeController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _sizeAnimation = Tween<double>(begin: 50.0, end: 150.0).animate(_controller);
    _positionAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: ListView(
            children: [
              // partial width 580
              // full width 1160
              SizedBox(height: 200),
              CupertinoSwitch(
                value: isChecked,
                onChanged: (_) {
                  setState(() {
                    isChecked = !isChecked;
                  });
                },
              ),
              Container(height: 500, child: WebViewContainer()),
              /*
              Align(
                alignment: Alignment.center,
                child: ClipRect(
                  child: Align(
                    alignment: Alignment.centerRight,
                    widthFactor: 0.4, // Only show the left 50% of the image
                    child: Image.asset(
                      'res/images/two_colors.png',
                    ),
                  ),
                ),
              ),

              Image.asset(
                'res/images/Smartlook.png',
                width: 100,
                height: 100,
                color: Colors.lightBlue.withOpacity(0.05),
                colorBlendMode: BlendMode.multiply,
              ),

              SizedBox(height: 400),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: 50,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        width: 50,
                        height: 50,
                        color: Colors.amberAccent,
                      ),
                    );
                  },
                  scrollDirection: Axis.horizontal,
                ),
              )

              const TextField(
                decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(borderSide: BorderSide(width: 30)),
                  labelText: "TextField",
                  labelStyle: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                  ),
                  alignLabelWithHint: true,
                ),
              ),
              Center(
                child: Container(
                  width: 200.0, // Size of the circle
                  height: 200.0, // Size of the circle
                  child: AnimatedBuilder(
                    animation: _controller,
                    child: Container(
                      width: 50.0, // Width of the red square
                      height: 50.0, // Height of the red square
                      color: Colors.red,
                    ),
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(75, 0).rotate(_controller.value * 2 * pi),
                        child: child,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 100),
              AnimatedBuilder(
                animation: _controller,
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  color: Colors.green,
                ),
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _controller.value * 2 * pi,
                    child: child,
                  );
                },
              ),
              UnconstrainedBox(
                child: AnimatedBuilder(
                  animation: _controller,
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    color: Colors.blue,
                  ),
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _controller.value * 2 * pi,
                      child: child,
                    );
                  },
                ),
              ),
              const SizedBox(height: 300),
              SizedBox(
                height: 300,
                width: 300,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    /*
                    Container(
                      width: 237.0,
                      height: 237.0,
                      color: Colors.green,
                    ),*/
                    Transform.rotate(
                      child: Transform.scale(
                        child: Container(
                          key: const Key("PinkContainer"),
                          width: 140.0,
                          height: 140.0,
                          color: Colors.pink,
                        ),
                        scaleX: 1.8,
                        scaleY: 0.2,
                      ),
                      angle: 0.75 * pi,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 100),
              Transform.rotate(
                child: Container(
                  key: const Key("RedContainer"),
                  width: 140.0,
                  height: 140.0,
                  color: Colors.red,
                ),
                angle: 0.25 * pi,
              ),
              Transform.rotate(
                child: Container(
                  key: const Key("PurpleContainer"),
                  width: 100.0,
                  height: 150.0,
                  color: Colors.green,
                ),
                angle: 1.4 * pi,
              ),
              SizedBox(height: 100),
              Transform.rotate(
                child: Container(
                  key: const Key("PurpleContainer"),
                  width: 100.0,
                  height: 100.0,
                  color: Colors.purple,
                ),
                angle: 0.25 * pi,
              ),
              SizedBox(height: 100),
              AnimatedBuilder(
                animation: _sizeController,
                builder: (context, child) {
                  return Align(
                    alignment: Alignment(_positionAnimation.value * 2 - 1, 0),
                    child: Container(
                      width: _sizeAnimation.value,
                      height: _sizeAnimation.value,
                      color: Colors.blue,
                    ),
                  );
                },
              ),

               */
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return const TestDialog();
      },
    );
  }
}

extension on Offset {
  Offset rotate(double angle) {
    return Offset(
      cos(angle) * dx - sin(angle) * dy,
      sin(angle) * dx + cos(angle) * dy,
    );
  }
}

class TestDialog extends StatelessWidget {
  const TestDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(6.0),
        ),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 100),
      title: const Text(
        'Premium Account',
        style: TextStyle(
          fontSize: 22.0,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      content: const SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              'In order to download this movie, you need to have premium account.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Would you like to purchase it?',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'CANCEL',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text(
            'PURCHASE',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.blue,
              fontWeight: FontWeight.w700,
            ),
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}

class Sky extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;

    const RadialGradient gradient = RadialGradient(
      center: Alignment(0.7, -0.6),
      radius: 0.2,
      colors: <Color>[Color(0xFFFFFF00), Color(0xFF0099FF)],
      stops: <double>[0.4, 1.0],
    );
    canvas.drawRect(
      rect,
      Paint()..shader = gradient.createShader(rect),
    );
  }

  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) {
      Rect rect = Offset.zero & size;
      final double width = size.shortestSide * 0.4;
      rect = const Alignment(0.8, -0.9).inscribe(Size(width, width), rect);

      return <CustomPainterSemantics>[
        CustomPainterSemantics(
          rect: rect,
          properties: const SemanticsProperties(
            label: 'Sun',
            textDirection: TextDirection.ltr,
          ),
        ),
      ];
    };
  }

  @override
  bool shouldRepaint(Sky oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(Sky oldDelegate) => false;
}

class WebViewContainer extends StatefulWidget {
  @override
  _WebViewContainerState createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            print('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
            ''');
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      );
    _loadHtmlFromAssets(); // Call the function to load HTML
  }

  _loadHtmlFromAssets() async {
    String fileText = await rootBundle.loadString('assets/canvas_test.html');
    _controller.loadRequest(
        Uri.dataFromString(fileText, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')));
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}

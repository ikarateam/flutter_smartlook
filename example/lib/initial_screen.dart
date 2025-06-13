import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:flutter_smartlook_example/test_screen.dart';
import 'package:flutter_smartlook_example/timer_widget.dart';
import 'package:flutter_smartlook_example/wireframe_test_screens/all_widgets_wireframe_test_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InitialScreen extends StatefulWidget {
  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  final Smartlook smartlook = Smartlook.instance;
  bool isSet = false;

  @override
  void initState() {
    super.initState();
    initSmartlook();
  }

  Future<void> initSmartlook() async {
    //TODO use logging if some issue occurs
    //await smartlook.log.enableLogging();
    //TODO add your project key
    await smartlook.preferences.setProjectKey('');
    await smartlook.preferences.setFrameRate(2);
    await smartlook.start();
    setState(() {
      isSet = true;
    });

    // Sets up WebView as sensitive
    smartlook.sensitivity.changeNativeClassSensitivity([
      SensitivityTuple(
        classType: SmartlookNativeClassSensitivity.WebView,
        isSensitive: false,
      ),
      SensitivityTuple(
        classType: SmartlookNativeClassSensitivity.WKWebView,
        isSensitive: false,
      ),
    ]);

    Smartlook.instance.eventListeners.registerSessionChangedListener((_) {
      print("changeSession");
    });
    Smartlook.instance.eventListeners.registerUserChangedListener((_) {
      print("changeUser");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: !isSet
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Spacer(),
                  const TimerWidget(),
                  const SizedBox(height: 15.0),
                  FutureBuilder<RecordingStatus>(
                    future: smartlook.state.getRecordingStatus(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.data == null || snapshot.data != RecordingStatus.recording) {
                        return ElevatedButton(
                          onPressed: () async {
                            await smartlook.start();
                            setState(() {});
                          },
                          child: const Text('Start recording'),
                        );
                      }

                      return ElevatedButton(
                        onPressed: () async {
                          await smartlook.stop();
                          setState(() {});
                        },
                        child: const Text('Stop recording'),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () async {
                      final Properties properties = Properties();
                      properties.putString('testKey', value: 'testValue');
                      smartlook.trackEvent(
                        'test_event',
                        properties: properties,
                      );
                      await smartlook.sensitivity.changeNativeClassSensitivity(
                        [
                          SensitivityTuple(
                            classType: SmartlookNativeClassSensitivity.WebView,
                            isSensitive: false,
                          ),
                        ],
                      );
                    },
                    child: const Text('Track event'),
                  ),
                  const SizedBox(height: 15.0),
                  Builder(builder: (context) {
                    return SmartlookTrackingWidget(
                      child: ElevatedButton(
                        onPressed: () async {
                          smartlook.trackNavigationEnter('testscreen');
                          await Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (context) => const TestScreen(),
                            ),
                          );
                          smartlook.trackNavigationExit('testscreen');
                        },
                        child: const Text('Navigate to TestScreen'),
                      ),
                      isSensitive: true,
                    );
                  }),
                  Builder(builder: (context) {
                    return ElevatedButton(
                      onPressed: () async {
                        smartlook.trackNavigationEnter('wireframe_testscreen');
                        await Navigator.push<dynamic>(
                          context,
                          PageRouteBuilder<dynamic>(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                const WireframeAllWidgetsTestScreen(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const begin = Offset(0.0, 1.0);
                              const end = Offset.zero;
                              const curve = Curves.ease;
                              final tween =
                                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                            transitionDuration: const Duration(seconds: 3),
                          ),
                        );

                        smartlook.trackNavigationExit('wireframe_testscreen');
                      },
                      child: const Text('Navigate wireframe to TestScreen'),
                    );
                  }),
                  const Spacer(),
                  const WebViewStack(),
                ],
              ),
      ),
    );
  }
}

class WebViewStack extends StatelessWidget {
  const WebViewStack();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 180,
          child: WebViewWidget(
            controller: WebViewController()
              ..loadRequest(
                Uri.parse('https://flutter.dev'),
              )
              ..setJavaScriptMode(
                JavaScriptMode.unrestricted,
              ),
          ),
        ),
        Positioned(
          bottom: 16.h,
          left: 0,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              "Text with opacity does not show",
              style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 18),
            ),
          ),
        ),
        Positioned(
          bottom: 13.h,
          left: 0,
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Text(
              "Just text gets cropped out",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ),
        Positioned(
          bottom: 5.h,
          left: 0,
          child: Container(
            height: 8.h,
            width: 60.w,
            color: Colors.black.withOpacity(0.5),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Text(
                "Partially cropped out text - parent is transparent",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            height: 5.h,
            width: 60.w,
            color: Colors.black,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Text(
                "Cropped out from sensitivity",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

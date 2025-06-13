import 'package:flutter/material.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:flutter_smartlook_example/initial_screen.dart';
import 'package:sizer/sizer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const CiscoSmartlookApp());
}

class CiscoSmartlookApp extends StatelessWidget {
  const CiscoSmartlookApp();

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return SmartlookRecordingWidget(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          //  navigatorObservers: [SmartlookObserver()],
          home: InitialScreen(),
        ),
      );
    });
  }
}

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CanvasTestScreen extends StatefulWidget {
  const CanvasTestScreen({Key? key}) : super(key: key);

  @override
  State<CanvasTestScreen> createState() => _CanvasTestScreenState();
}

class _CanvasTestScreenState extends State<CanvasTestScreen> {
  Future<ui.Image> loadImage() async {
    final ByteData data = await rootBundle.load('res/images/Smartlook.png');
    final Uint8List bytes = data.buffer.asUint8List();
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(bytes, completer.complete);

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: ListView(
            children: [
              const CircularProgressIndicator(),
              FutureBuilder<ui.Image>(
                future: loadImage(),
                builder: (context, snapshot) {
                  return (snapshot.connectionState == ConnectionState.done && snapshot.hasData)
                      ? Center(
                          child: CustomPaint(
                            size: const Size(400, 400), // You can specify your own size
                            painter: MyCustomPainter(image: snapshot.data!),
                          ),
                        )
                      : const Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  final ui.Image image;
  MyCustomPainter({required this.image});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4
      ..style = PaintingStyle.fill;

    // Draw rect
    canvas.drawRect(const Rect.fromLTWH(20, 20, 100, 100), paint);

    // Draw circle
    canvas.drawCircle(const Offset(150, 150), 50, paint);

    // Draw triangle
    final path = Path();
    path.moveTo(250, 50);
    path.lineTo(300, 150);
    path.lineTo(200, 150);
    path.close();
    canvas.drawPath(path, paint);

    // Draw RRect
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(20, 200, 100, 100), const Radius.circular(20)),
      paint,
    );

    // Draw oval
    canvas.drawOval(const Rect.fromLTWH(150, 200, 100, 50), paint);

    // Draw paragraph (text)
    final paragraphBuilder =
        ui.ParagraphBuilder(ui.ParagraphStyle(textAlign: TextAlign.center, fontSize: 18))
          ..pushStyle(ui.TextStyle(color: Colors.black))
          ..addText('Hello Flutter')
          ..pushStyle(ui.TextStyle(color: Colors.blue))
          ..addText('Different Color');
    final paragraph = paragraphBuilder.build();
    paragraph.layout(const ui.ParagraphConstraints(width: 100));
    canvas.drawParagraph(paragraph, const Offset(250, 250));

    canvas.drawImage(image, const Offset(50, 300), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

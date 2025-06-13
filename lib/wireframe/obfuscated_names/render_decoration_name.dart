import 'package:flutter/material.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/visible_descriptors/render_decoration_descriptor.dart';
import 'package:flutter_smartlook/wireframe/widget_scraper/smartlook_helper_controller.dart';

class RenderDecorationSetNameWidget extends StatefulWidget {
  const RenderDecorationSetNameWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<RenderDecorationSetNameWidget> createState() => _RenderDecorationSetNameWidgetState();
}

class _RenderDecorationSetNameWidgetState extends State<RenderDecorationSetNameWidget> {
  final GlobalKey detachedRenderDecorationKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setDecorationAndForegroundPainter();
    });
  }

  void setDecorationAndForegroundPainter() {
    if (!SmartlookHelperController.instance.isObfuscated) {
      return;
    }

    final renderObject = detachedRenderDecorationKey.currentContext?.findRenderObject();
    final dynamic _renderDecoration = (renderObject as dynamic)?.child?.child?.child?.child?.child;
    final dynamic foregroundPainter = _renderDecoration.children[3].foregroundPainter;
    SmartlookHelperController.instance.inputBorderPainterRuntimeName = foregroundPainter.runtimeType.toString();
    SmartlookHelperController.instance.descriptors[(_renderDecoration as dynamic).runtimeType.toString()] = const RenderDecorationDescriptor();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.01,
      width: 0.01,
      child: Card(
        child: TextField(
          key: detachedRenderDecorationKey,
          decoration: const InputDecoration(
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
      ),
    );
  }
}

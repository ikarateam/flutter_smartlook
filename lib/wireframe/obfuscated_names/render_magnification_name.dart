import 'package:flutter/material.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/visible_descriptors/render_magnifier_descriptor.dart';
import 'package:flutter_smartlook/wireframe/widget_scraper/smartlook_helper_controller.dart';

class RenderMagnificationNameWidget extends StatefulWidget {

  const RenderMagnificationNameWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<RenderMagnificationNameWidget> createState() =>
      _RenderMagnificationNameWidgetState();
}

class _RenderMagnificationNameWidgetState
    extends State<RenderMagnificationNameWidget> {
  final GlobalKey detachedRenderMagnificationKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setMagnification();
    });
  }

  void setMagnification() {
    final renderObject =
    detachedRenderMagnificationKey.currentContext?.findRenderObject();
    final dynamic _renderDecoration =
        (renderObject as dynamic).firstChild.child.child;

    SmartlookHelperController.instance.descriptors[
    (_renderDecoration as dynamic).runtimeType.toString()] =
    const RenderMagnifierDescriptor();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.01,
      child: RawMagnifier(
        key: detachedRenderMagnificationKey,
        size: const Size(0.01,0.01),
        //decoration:  const MagnifierDecoration( ),
      ),
    );
  }
}

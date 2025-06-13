import 'package:flutter/material.dart';

class RenderColoredBoxSetNameWidget extends StatefulWidget {
  final Function() setRenderColoredBox;

  const RenderColoredBoxSetNameWidget({
    required this.setRenderColoredBox,
    Key? key,
  }) : super(key: key);

  @override
  State<RenderColoredBoxSetNameWidget> createState() =>
      _RenderColoredBoxSetNameWidgetState();
}

class _RenderColoredBoxSetNameWidgetState
    extends State<RenderColoredBoxSetNameWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.setRenderColoredBox();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.01,
      height: 0.01,
      color: Colors.red,
    );
  }
}

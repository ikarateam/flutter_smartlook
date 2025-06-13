import 'package:flutter/cupertino.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/visible_descriptors/render_cupertino_switch_descriptor.dart';
import 'package:flutter_smartlook/wireframe/widget_scraper/smartlook_helper_controller.dart';

class RenderCupertinoSwitchNameWidget extends StatefulWidget {
  const RenderCupertinoSwitchNameWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<RenderCupertinoSwitchNameWidget> createState() => _RenderCupertinoSwitchNameWidgetState();
}

class _RenderCupertinoSwitchNameWidgetState extends State<RenderCupertinoSwitchNameWidget> {
  final GlobalKey detachedCupertinoSwitchKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setCupertinoSwitch();
    });
  }

  void setCupertinoSwitch() {
    final renderObject = detachedCupertinoSwitchKey.currentContext?.findRenderObject();

    final cupertinoSwitchRenderObject = (renderObject as dynamic).child.child.child.child;

    SmartlookHelperController
            .instance.descriptors[cupertinoSwitchRenderObject.runtimeType.toString()] =
        const RenderCupertinoSwitchDescriptor();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
        height: 0.01,
        width: 0.01,
        child: Opacity(
            opacity: 0.01,
            child:
                CupertinoSwitch(key: detachedCupertinoSwitchKey, value: true, onChanged: (_) {})),
      ),
    );
  }
}

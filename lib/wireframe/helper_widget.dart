import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smartlook/wireframe/obfuscated_names/custom_material_delegate.dart';
import 'package:flutter_smartlook/wireframe/obfuscated_names/render_colored_box_name.dart';
import 'package:flutter_smartlook/wireframe/obfuscated_names/render_decoration_name.dart';
import 'package:flutter_smartlook/wireframe/obfuscated_names/render_magnification_name.dart';
import 'package:flutter_smartlook/wireframe/widget_scraper/smartlook_helper_controller.dart';

import 'element_descriptors/visible_descriptors/render_colored_box_descriptor.dart';
import 'obfuscated_names/render_cupertino_switch_name.dart';

/// Widget for tracking wireframe
class SmartlookRecordingWidget extends StatelessWidget {
  final GlobalKey detachedRenderColoredBoxKey = GlobalKey();

  SmartlookRecordingWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: SmartlookHelperController.instance.containerKey,
      child: SmartlookHelperController.instance.isObfuscated
          ? Column(
              children: [
                Expanded(child: Container(child: child)),
                Localizations(
                  locale: Locale.fromSubtags(languageCode: "en"),
                  delegates: [
                    GlobalWidgetsLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    CustomWidgetsLocalizationsDelegate(),
                  ],
                  child: const RenderDecorationSetNameWidget(),
                ),
                RenderColoredBoxSetNameWidget(
                  setRenderColoredBox: setRenderColoredBox,
                  key: detachedRenderColoredBoxKey,
                ),
                const RenderMagnificationNameWidget(),
                const RenderCupertinoSwitchNameWidget(),
              ],
            )
          : Container(child: child),
    );
  }

  void setRenderColoredBox() {
    final RenderBox renderObject =
        detachedRenderColoredBoxKey.currentContext?.findRenderObject() as RenderBox;
    SmartlookHelperController
            .instance.descriptors[(renderObject as dynamic).child.runtimeType.toString()] =
        const RenderColoredBoxDescriptor();
  }
}

/// Used to identify [Widget] or mark as [sensitive]
class SmartlookTrackingWidget extends StatelessWidget {
  final Widget child;
  final bool isSensitive;

  ///with [doNotRecordWireframe] the wireframe for this element wont be rendered
  ///the element will be marked as sensitive by design because
  ///some sensitive data could be leaked without wireframe
  final bool doNotRecordWireframe;

  const SmartlookTrackingWidget({
    required this.child,
    this.isSensitive = false,
    this.doNotRecordWireframe = false,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_smartlook/src/const_channels.dart';
import 'package:flutter_smartlook/wireframe/element_data.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/abstract_descriptors/default_element_descriptor.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/descriptors_const.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/visible_descriptors/render_colored_box_descriptor.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/visible_descriptors/render_decoration_descriptor.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/visible_descriptors/render_magnifier_descriptor.dart';

import '../element_descriptors/visible_descriptors/render_cupertino_switch_descriptor.dart';
import 'abstract_widget_scraper.dart';
import 'abstract_widget_scraper_factory.dart';

class SmartlookHelperController {
  late final Map<String, DefaultElementDescriptor> descriptors;
  late final bool isObfuscated;

  final GlobalKey containerKey = GlobalKey();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final AbstractWidgetScraper _widgetScraper = createWidgetScraper();

  String? inputBorderPainterRuntimeName = "_InputBorderPainter";

  SmartlookHelperController._privateConstructor() {
    descriptors = DescriptorsConst().descriptorsMap;
    isObfuscated = Container().runtimeType.toString() != "Container";
    if (!isObfuscated) {
      descriptors["_RenderColoredBox"] = const RenderColoredBoxDescriptor();
      descriptors["_RenderDecoration"] = const RenderDecorationDescriptor();
      descriptors["_RenderMagnification"] = const RenderMagnifierDescriptor();
      descriptors["_RenderCupertinoSwitch"] = const RenderCupertinoSwitchDescriptor();
    }
  }

  static final SmartlookHelperController instance = SmartlookHelperController._privateConstructor();

  static bool isTransitioningState = false;

  static void changeTransitioningState(bool isTransitioning) {
    if (isTransitioning == SmartlookHelperController.isTransitioningState) {
      return;
    }

    SmartlookHelperController.isTransitioningState = isTransitioning;
    Channels.channel.invokeMethod<void>(
      "changeTransitioningState",
      {"transitioningState": isTransitioning},
    );
  }

  Future<ElementData?> getWireframeTree(
    Map<Type, bool> sensitiveWidgetsTypes,
  ) async {
    final BuildContext? context = containerKey.currentContext;

    if (context == null) {
      return null;
    }

    return _widgetScraper.scrapeRenderTree(context, sensitiveWidgetsTypes);
  }
}

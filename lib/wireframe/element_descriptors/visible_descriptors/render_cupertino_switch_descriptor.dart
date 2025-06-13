import 'package:flutter/material.dart';
import 'package:flutter_smartlook/wireframe/element_data.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/abstract_descriptors/visible_element_descriptor.dart';

class RenderCupertinoSwitchDescriptor extends VisibleElementDescriptor {
  const RenderCupertinoSwitchDescriptor();

  @override
  List<Skeleton> createSkeletons(
    Element element,
    Rect elementRect,
    Rect? parentRect,
  ) {
    const double trackWidth = 49.0;
    const double trackHeight = 29.0;
    const double switchWidth = 51.0;
    const double switchHeight = 31.0;
    const double thumbRadius = 13;
    const double thumbPadding = 1.0;
    const double thumbDiameter = thumbRadius * 2;

    final renderObject = element.renderObject as dynamic;
    final activeColor = renderObject.activeColor;
    final trackColor = renderObject.trackColor;
    final thumbColor = renderObject.thumbColor;
    final value = renderObject.value;
    final isFocused = renderObject.isFocused;
    final offset = createSwitchOffset(renderObject, switchWidth, switchHeight);
    final double thumbPosition =
        value ? (trackWidth - thumbDiameter - thumbPadding * 2) : thumbPadding;

    final List<Skeleton> skeletons = [];

    // Track skeleton
    skeletons.add(Skeleton(
      rect: Rect.fromLTWH(
        offset.dx + (switchWidth - trackWidth) / 2,
        offset.dy + (switchHeight - trackHeight) / 2,
        trackWidth,
        trackHeight,
      ),
      color: trackColor,
    ));

    if (value) {
      // Focus border skeleton
      skeletons.add(Skeleton(
        rect: Rect.fromLTWH(
          offset.dx + (switchWidth - trackWidth) / 2 - 2,
          offset.dy + (switchHeight - trackHeight) / 2 - 2,
          trackWidth + 4,
          trackHeight + 4,
        ),
        color: activeColor.withOpacity(0.5),
      ));
    }

    // Thumb skeleton
    skeletons.add(Skeleton(
      rect: Rect.fromLTWH(
        offset.dx + (switchWidth - trackWidth) / 2 + thumbPosition,
        offset.dy + (switchHeight - thumbDiameter) / 2,
        thumbDiameter,
        thumbDiameter,
      ),
      color: thumbColor,
    ));

    return skeletons;
  }

  Offset createSwitchOffset(RenderBox renderBox, double width, double height) {
    final offset = renderBox.localToGlobal(Offset.zero);
    final top = offset.dy;
    final left = offset.dx;

    return Offset(
      -(width / 2) + left + renderBox.size.width / 2,
      -(height / 2) + top + renderBox.size.height / 2,
    );
  }
}

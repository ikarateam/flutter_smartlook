import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smartlook/wireframe/element_data.dart';

abstract class DefaultElementDescriptor {
  const DefaultElementDescriptor();

  ElementDataNullable describe(
    Element element,
    ElementData parentElementData,
  ) {
    final Rect? elementRect = createIntersectedRect(element, parentElementData);
    if (elementRect == null) {
      return const ElementDataNullable(doNotRecordWireframeChildren: false);
    }
    if (elementRect.height < 0.0 || elementRect.width < 0.0) {
      return const ElementDataNullable(doNotRecordWireframeChildren: true);
    }

    final thisElementData = ElementData(
      id: "_${element.hashCode.toString()}",
      type: element.widget.runtimeType.toString(),
      rect: elementRect,
    );

    return ElementDataNullable(elementData: thisElementData);
  }

  /// Create rect from RenderBox
  Rect? createElementRect(Element element, Rect? parentRect) {
    final RenderBox renderBox = element.renderObject as RenderBox;
    if (!renderBox.hasSize) {
      return null;
    }

    final offset = renderBox.localToGlobal(Offset.zero);
    final top = offset.dy;
    final left = offset.dx;

    return Rect.fromLTWH(
      left,
      top,
      renderBox.size.width,
      renderBox.size.height,
    );
  }

  /// Intersect with parent rect
  Rect? createIntersectedRect(Element element, ElementData? parentElementData) {
    var elementRect = createElementRect(element, parentElementData?.rect);

    if (parentElementData != null && parentElementData.matrix == null) {
      elementRect = elementRect?.intersect(parentElementData.rect);
    }

    return elementRect;
  }
}

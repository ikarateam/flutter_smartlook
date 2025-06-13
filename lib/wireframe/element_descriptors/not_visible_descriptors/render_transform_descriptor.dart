import 'package:flutter/material.dart';
import 'package:flutter_smartlook/wireframe/element_data.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/abstract_descriptors/not_visible_element_descriptor.dart';

class RenderTransformDescriptor extends NotVisibleElementDescriptor {
  const RenderTransformDescriptor();

  @override
  ElementDataNullable describe(Element element, ElementData parentElementData) {
    final elementRect = createIntersectedRect(element, parentElementData);
    if (elementRect == null) {
      return const ElementDataNullable();
    }
    if (elementRect.height < 0.0 || elementRect.width < 0.0) {
      return const ElementDataNullable(doNotRecordWireframeChildren: true);
    }

    final thisElementData = ElementData(
      id: "_${element.hashCode.toString()}",
      type: element.widget.runtimeType.toString(),
      rect: elementRect,
      matrix: getValidMatrix(element),
    );

    return ElementDataNullable(elementData: thisElementData);
  }

  Matrix4? getValidMatrix(Element element) {
    final isTransformWidget = element.widget is Transform;

    if (!isTransformWidget) {
      return null;
    }

    final matrix = (element.widget as Transform).transform;
    if (isNonEffectiveTransformation(matrix)) {
      return null;
    }

    return matrix;
  }

  bool isNonEffectiveTransformation(Matrix4 matrix) {
    final storage = matrix.storage;

    for (int i = 0; i < 4; i++) {
      final diagonalElement = storage[i * 5];
      if (diagonalElement != 0.0 && diagonalElement != 1.0) {
        return false;
      }
    }

    for (int i = 0; i < 16; i++) {
      if (i % 5 == 0) continue;

      if (storage[i] != 0.0) {
        return false;
      }
    }

    return true;
  }
}

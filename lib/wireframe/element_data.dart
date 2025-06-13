import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class ElementData {
  String id;
  String type;
  List<ElementData>? children;
  List<Skeleton>? skeletons;
  Rect rect;
  double opacity;
  Matrix4? matrix;
  bool isSensitive;
  bool doNotRecordWireframe;
  int? nativeViewId;

  ElementData({
    required this.id,
    required this.type,
    this.children,
    this.skeletons,
    required this.rect,
    this.opacity = 1.0,
    this.isSensitive = false,
    this.doNotRecordWireframe = false,
    this.matrix,
    this.nativeViewId,
  });

  void printElementData({int level = 0}) {
    if (level == 0) {
      debugPrint("--------------------");
    }
    debugPrint(
      "\nElementData- id:$id, type:$type, $rect $opacity $isSensitive $doNotRecordWireframe",
    );
    if (children != null) {
      for (final child in children!) {
        child.printElementData(level: level + 1);
      }
    }
  }

  void printSkeletons() {
    debugPrint("Skeletons--------------------");
    if (skeletons != null) {
      for (final skeleton in skeletons!) {
        debugPrint("Skeleton:");
        debugPrint("color: ${skeleton.color.toString()}");
        debugPrint("opacity: ${skeleton.opacity.toString()}");
        debugPrint("rect: ${rect.toString()}");
      }
    }
  }

  void applyAncestorMatrix(Matrix4? ancestorMatrix) {
    if (ancestorMatrix != null) {
      if (skeletons?.isNotEmpty == true) {
        // _transformRect can occur just here because the [RenderTransform] has no skeletons -> the transform for skeletons is always from ancestor
        for (int i = 0; i < skeletons!.length; i++) {
          skeletons![i].rect = _transformRect(ancestorMatrix, skeletons![i].rect!);
        }
        final newRect = _transformRect(ancestorMatrix, this.rect);
        this.rect = newRect;
      }

      if (this.matrix == null) {
        this.matrix = ancestorMatrix;
      } else {
        //Order of matrices matter
        this.matrix = ancestorMatrix * this.matrix;
      }
    }
  }

  void addChildren(ElementData elementData) {
    if (this.children == null) {
      this.children = [];
    }
    this.children!.add(elementData);
  }

  Rect _transformRect(Matrix4 theMatrix, Rect rect) {
    final vector4 = Vector4(0, 0, 0, 1);
    final center = Vector4(rect.width / 2, rect.height / 2, 0, 1);
    final shift = vector4 - center;
    shift.applyMatrix4(theMatrix);
    final newOrigin = center + shift;
    final originOffset = vector4 - newOrigin;
    final offset = rect.topLeft + Offset(originOffset.x, originOffset.y);
    final boundingBoxRect = transformRectAroundCenter(theMatrix, Rect.fromLTWH(offset.dx, offset.dy, rect.width, rect.height));

    return boundingBoxRect;
  }

  Rect transformRectAroundCenter(Matrix4 matrix, Rect rect) {
    final center = rect.center;

    final translateToOrigin = Matrix4.translationValues(-center.dx, -center.dy, 0.0);
    final translateBack = Matrix4.translationValues(center.dx, center.dy, 0.0);

    final combinedMatrix = translateBack * matrix * translateToOrigin;
    final topLeft = combinedMatrix.transform3(Vector3(rect.left, rect.top, 0.0));
    final topRight = combinedMatrix.transform3(Vector3(rect.right, rect.top, 0.0));
    final bottomLeft = combinedMatrix.transform3(Vector3(rect.left, rect.bottom, 0.0));
    final bottomRight = combinedMatrix.transform3(Vector3(rect.right, rect.bottom, 0.0));

    final minX = min(min(min(topLeft.x, topRight.x), bottomLeft.x), bottomRight.x);
    final maxX = max(max(max(topLeft.x, topRight.x), bottomLeft.x), bottomRight.x);
    final minY = min(min(min(topLeft.y, topRight.y), bottomLeft.y), bottomRight.y);
    final maxY = max(max(max(topLeft.y, topRight.y), bottomLeft.y), bottomRight.y);

    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  double min(double a, double b) => a < b ? a : b;

  double max(double a, double b) => a > b ? a : b;

  Map<String, dynamic> toMap() => <String, dynamic>{
        "id": id,
        if (nativeViewId != null) "nativeViewId": nativeViewId,
        "type": type,
        if (children != null) "children": children?.map((e) => e.toMap()).toList(),
        if (skeletons != null) "skeletons": skeletons?.map((e) => e.toMap()).toList(),
        "top": rect.top,
        "left": rect.left,
        "width": rect.width,
        "height": rect.height,
        if (opacity != 1.0) "opacity": opacity,
        if (isSensitive) "isSensitive": isSensitive,
      };
}

class ElementDataNullable {
  final ElementData? elementData;
  final bool doNotRecordWireframeChildren;

  const ElementDataNullable({
    this.elementData,
    this.doNotRecordWireframeChildren = false,
  });
}

class Skeleton {
  Rect? rect;
  late final Color color;
  late final double opacity;
  late final bool? isText;

  Skeleton({
    required this.rect,
    required this.color,
    this.opacity = 1.0,
    this.isText,
  });

  Skeleton.withOffsetAndCrop(
    Skeleton skeleton,
    Rect? parentRect,
    Offset offset,
  ) {
    if (parentRect != null)
      this.rect = skeleton.rect!.shift(offset).intersect(parentRect);
    else
      this.rect = skeleton.rect!.shift(offset);

    this.isText = skeleton.isText;
    this.color = skeleton.color;
    this.opacity = skeleton.opacity;
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        "top": rect!.top,
        "left": rect!.left,
        "width": rect!.width,
        "height": rect!.height,
        "color": color.toHex(),
        if (opacity != 1.0) "opacity": opacity,
        if (isText != null) "isText": isText,
      };
}

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));

    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

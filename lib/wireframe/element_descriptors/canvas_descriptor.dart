import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart' as material;
import 'package:flutter_smartlook/wireframe/element_data.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/wireframe_utils.dart';

class CustomCanvas implements Canvas {
  final Function(Rect, Color?) addSkeleton;

  CustomCanvas(
    this.addSkeleton,
  );

  @override
  void clipRSuperellipse(RSuperellipse rrect, {bool doAntiAlias = true}) {
    // TODO: implement clipRSuperellipse
  }

  @override
  void draw(Canvas canvas) {
    // TODO: implement draw
  }

  @override
  void drawRSuperellipse(RSuperellipse rsuperellipse, Paint paint) {
    // TODO: implement drawRSuperellipse
  }

  @override
  void paint(Paint paint) {
    // TODO: implement paint
  }

  @override
  void drawRect(Rect rect, Paint paint) async {
    addSkeleton(rect, paint.color);
    if (paint.shader is Gradient) {
      final Color? color = await getColorFromPaint(paint);
      addSkeleton(rect, color);
    }
  }

  @override
  void drawCircle(Offset c, double radius, Paint paint) {
    addSkeleton(Rect.fromLTWH(c.dx - radius, c.dy - radius, radius * 2, radius * 2), paint.color);
  }

  @override
  void drawArc(
    Rect rect,
    double startAngle,
    double sweepAngle,
    bool useCenter,
    Paint paint,
  ) {
    addSkeleton(rect, paint.color);
  }

  @override
  void drawPath(Path path, Paint paint) {
    if (paint.style == PaintingStyle.fill) {
      addSkeleton(path.getBounds(), paint.color);
    } else {
      final List<Skeleton>? skeletons = WireframeUtils.skeletonsFromBorderRect(
        path.getBounds(),
        paint.color,
        paint.strokeWidth,
      );
      if (skeletons == null) {
        return;
      }
      for (final Skeleton skeleton in skeletons) {
        addSkeleton(skeleton.rect!, skeleton.color);
      }
    }
  }

  @override
  void drawLine(Offset p1, Offset p2, Paint paint) {
    addSkeleton(
      Rect.fromLTWH(
        0,
        0,
        max(p1.dx, p2.dx) - min(p1.dx, p2.dx),
        max(p1.dy, p2.dy) -
            min(
              p1.dy,
              p2.dy,
            ),
      ),
      paint.color,
    );
  }

  Color mixColors(List<Color> colors) {
    final int colorCount = colors.length;

    double red = 0;
    double green = 0;
    double blue = 0;
    double alpha = 0;

    for (final Color color in colors) {
      red += color.red;
      green += color.green;
      blue += color.blue;
      alpha += color.alpha;
    }

    return Color.fromARGB(
      (alpha / colorCount).round(),
      (red / colorCount).round(),
      (green / colorCount).round(),
      (blue / colorCount).round(),
    );
  }

  Future<Color?> getColorFromPaint(Paint paint) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    canvas.save();
    canvas.drawPaint(paint);
    canvas.restore();
    final picture = pictureRecorder.endRecording();
    final Image image = await picture.toImage(2, 2);
    final byteData = await image.toByteData();

    if (byteData == null) {
      return null;
    }

    return WireframeUtils.createColorFromByteData(
      byteData,
      image.height,
      image.width,
    );
  }

  @override
  void clipPath(Path path, {bool doAntiAlias = true}) {}

  @override
  void clipRRect(RRect rrect, {bool doAntiAlias = true}) {}

  @override
  void clipRect(Rect rect, {ClipOp clipOp = ClipOp.intersect, bool doAntiAlias = true}) {}

  @override
  void drawAtlas(Image atlas, List<RSTransform> transforms, List<Rect> rects, List<Color>? colors,
      BlendMode? blendMode, Rect? cullRect, Paint paint) {}

  @override
  void drawColor(Color color, BlendMode blendMode) {}

  @override
  void drawDRRect(RRect outer, RRect inner, Paint paint) {
    addSkeleton(outer.outerRect, paint.color);
  }

  @override
  void drawImage(Image image, Offset offset, Paint paint) {
    addSkeleton(
      Rect.fromLTWH(
        offset.dx,
        offset.dy,
        image.width.toDouble(),
        image.height.toDouble(),
      ),
      paint.color,
    );
  }

  @override
  void drawImageNine(Image image, Rect center, Rect dst, Paint paint) {
    addSkeleton(dst, paint.color);
  }

  @override
  void drawImageRect(Image image, Rect src, Rect dst, Paint paint) {
    addSkeleton(dst, paint.color);
  }

  @override
  void drawOval(Rect rect, Paint paint) {
    addSkeleton(rect, paint.color);
  }

  @override
  void drawPaint(Paint paint) {}

  // _NativeParagraph cant get the data out of C++
  @override
  void drawParagraph(Paragraph paragraph, Offset offset) {
    addSkeleton(
      Rect.fromLTWH(offset.dx, offset.dy, paragraph.width, paragraph.height),
      material.Colors.black,
    );
  }

  @override
  void drawPicture(Picture picture) {
    // TODO: implement drawPicture
  }

  @override
  void drawPoints(PointMode pointMode, List<Offset> points, Paint paint) {
    // TODO: implement drawPoints
  }

  @override
  void drawRRect(RRect rrect, Paint paint) {
    addSkeleton(rrect.outerRect, paint.color);
  }

  @override
  void drawRawAtlas(Image atlas, Float32List rstTransforms, Float32List rects, Int32List? colors,
      BlendMode? blendMode, Rect? cullRect, Paint paint) {
    // TODO: implement drawRawAtlas
  }

  @override
  void drawRawPoints(PointMode pointMode, Float32List points, Paint paint) {
    // TODO: implement drawRawPoints
  }

  @override
  void drawShadow(Path path, Color color, double elevation, bool transparentOccluder) {
    // TODO: implement drawShadow
  }

  @override
  void drawVertices(Vertices vertices, BlendMode blendMode, Paint paint) {
    // TODO: implement drawVertices
  }

  @override
  Rect getDestinationClipBounds() {
    // TODO: implement getDestinationClipBounds
    return Rect.zero;
  }

  @override
  Rect getLocalClipBounds() {
    // TODO: implement getLocalClipBounds
    return Rect.zero;
  }

  @override
  int getSaveCount() {
    // TODO: implement getSaveCount
    return 0;
  }

  @override
  Float64List getTransform() {
    // TODO: implement getTransform
    return Float64List.fromList([]);
  }

  @override
  void restore() {
    // TODO: implement restore
  }

  @override
  void restoreToCount(int count) {
    // TODO: implement restoreToCount
  }

  @override
  void rotate(double radians) {
    // TODO: implement rotate
  }

  @override
  void save() {
    // TODO: implement save
  }

  @override
  void saveLayer(Rect? bounds, Paint paint) {
    // TODO: implement saveLayer
  }

  @override
  void scale(double sx, [double? sy]) {
    // TODO: implement scale
  }

  @override
  void skew(double sx, double sy) {
    // TODO: implement skew
  }

  @override
  void transform(Float64List matrix4) {
    // TODO: implement transform
  }

  @override
  void translate(double dx, double dy) {
    // TODO: implement translate
  }
}

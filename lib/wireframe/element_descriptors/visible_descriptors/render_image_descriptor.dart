import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/abstract_descriptors/visible_element_descriptor.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/blend_utils.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/wireframe_utils.dart';

class RenderImageDescriptor extends VisibleElementDescriptor {
  final Map<String?, CachedImageInfo?> cachedImagesInfo = {};
  final blendUtils = BlendUtils();

  RenderImageDescriptor();

  @override
  Color? createColor(Element element) {
    final Color? color =
        cachedImagesInfo[(element.renderObject as RenderImage).debugImageLabel]?.color;

    return color;
  }

  @override
  Rect? createElementRect(Element element, Rect? parentRect) {
    final RenderImage renderImage = element.renderObject as RenderImage;
    if (!renderImage.hasSize) {
      return null;
    }

    final CachedImageInfo? imageInfo = cachedImagesInfo[renderImage.debugImageLabel];
    if (imageInfo?.color == null) {
      final offset = renderImage.localToGlobal(Offset.zero);

      calculateImageColor(renderImage, parentRect, offset);

      return null;
    }

    final offset = renderImage.localToGlobal(Offset.zero);

    final BoxFit fit = renderImage.fit ?? BoxFit.scaleDown;
    final Size size = getScaledSize(
      imageInfo!.widthPixels.toDouble(),
      imageInfo.heightPixels.toDouble(),
      renderImage,
      fit,
    );

    double? top = offset.dy;
    double? left = offset.dx;

    final AlignmentGeometry alignment = renderImage.alignment;

    left = _calculateLeftPosition(alignment, offset, renderImage, size.width);
    top = _calculateTopPosition(alignment, offset, renderImage, size.height);

    return Rect.fromLTWH(
      left,
      top,
      size.width,
      size.height,
    );
  }

  Size getScaledSize(
    double originalWidth,
    double originalHeight,
    RenderImage renderImage,
    BoxFit fit,
  ) {
    final double targetWidth = renderImage.size.width;
    final double targetHeight = renderImage.size.height;

    final double aspectRatio = originalWidth / originalHeight;
    switch (fit) {
      case BoxFit.fill:
        return Size(targetWidth, targetHeight);
      case BoxFit.contain:
        if (targetWidth / aspectRatio <= targetHeight) {
          return Size(targetWidth, targetWidth / aspectRatio);
        }
        return Size(targetHeight * aspectRatio, targetHeight);
      case BoxFit.cover:
        if (targetWidth / aspectRatio >= targetHeight) {
          return Size(targetWidth, targetWidth / aspectRatio);
        }
        return Size(targetHeight * aspectRatio, targetHeight);
      case BoxFit.fitWidth:
        return Size(targetWidth, targetWidth / aspectRatio);
      case BoxFit.fitHeight:
        return Size(targetHeight * aspectRatio, targetHeight);
      case BoxFit.none:
        return Size(originalWidth, originalHeight);
      case BoxFit.scaleDown:
        if (originalWidth > targetWidth || originalHeight > targetHeight) {
          return getScaledSize(
            originalWidth,
            originalHeight,
            renderImage,
            BoxFit.contain,
          );
        }
        return Size(originalWidth, originalHeight);
    }
  }

  double _calculateLeftPosition(
    AlignmentGeometry alignment,
    Offset offset,
    RenderImage renderImage,
    double renderBoxWidth,
  ) {
    if (alignment == Alignment.centerLeft ||
        alignment == Alignment.bottomLeft ||
        alignment == Alignment.topLeft) {
      return offset.dx;
    } else if (alignment == Alignment.bottomRight ||
        alignment == Alignment.centerRight ||
        alignment == Alignment.topRight) {
      return offset.dx + renderImage.size.width - renderBoxWidth;
    }

    return offset.dx + (renderImage.size.width - renderBoxWidth) / 2;
  }

  double _calculateTopPosition(
    AlignmentGeometry alignment,
    Offset offset,
    RenderImage renderImage,
    double renderBoxHeight,
  ) {
    if (alignment == Alignment.topLeft ||
        alignment == Alignment.topCenter ||
        alignment == Alignment.topRight) {
      return offset.dy;
    } else if (alignment == Alignment.bottomRight ||
        alignment == Alignment.bottomLeft ||
        alignment == Alignment.bottomCenter) {
      return offset.dy + renderImage.size.height - renderBoxHeight;
    }

    return offset.dy + (renderImage.size.height - renderBoxHeight) / 2;
  }

  Future<CachedImageInfo?> calculateImageColor(
      RenderImage renderImage, Rect? parentRect, Offset imageOffset) async {
    if (renderImage.image == null) {
      return null;
    }

    if (cachedImagesInfo.containsKey(renderImage.debugImageLabel)) {
      return cachedImagesInfo[renderImage.debugImageLabel];
    }

    cachedImagesInfo[renderImage.debugImageLabel] = null;
    final imgWidth = renderImage.image!.width;
    final imgHeight = renderImage.image!.height;
    final downscaledImage = await downscaleAndCropImage(
      renderImage.image!,
      8,
      8,
      parentRect,
      Rect.fromLTWH(imageOffset.dx, imageOffset.dy, imgWidth.toDouble(), imgHeight.toDouble()),
    );

    downscaledImage.toByteData().then((byteData) {
      if (byteData == null || byteData.lengthInBytes == 0) {
        return null;
      }

      var calculatedColor = WireframeUtils.createColorFromByteData(
        byteData,
        downscaledImage.height,
        downscaledImage.width,
      );

      if (renderImage.color != null) {
        calculatedColor = blendUtils.blendColorsDirectly(
            calculatedColor, renderImage.color!, renderImage.colorBlendMode ?? BlendMode.srcIn);
      }

      cachedImagesInfo[renderImage.debugImageLabel] = CachedImageInfo(
        calculatedColor,
        imgWidth,
        imgHeight,
      );

      return cachedImagesInfo[renderImage.debugImageLabel];
    });

    return null;
  }

  Future<ui.Image> downscaleAndCropImage(
    ui.Image image,
    int maxWidth,
    int maxHeight,
    Rect? parentRect,
    Rect imageRect,
  ) async {
    Rect cropRect;
    if (parentRect != null) {
      cropRect = imageRect.overlaps(parentRect) ? imageRect.intersect(parentRect) : Rect.zero;
    } else {
      cropRect = imageRect;
    }

    final cropWidthPercent = cropRect.width / imageRect.width;
    final cropHeightPercent = cropRect.height / imageRect.height;

    final croppedWidth = image.width.toDouble() * cropWidthPercent;
    final croppedHeight = image.height.toDouble() * cropHeightPercent;

    final double aspectRatio = croppedWidth / croppedHeight;

    int newWidth = croppedWidth.toInt();
    int newHeight = croppedHeight.toInt();

    if (croppedWidth > maxWidth || croppedHeight > maxHeight) {
      if (aspectRatio > 1) {
        // Landscape
        newWidth = maxWidth;
        newHeight = maxWidth ~/ aspectRatio;
      } else {
        // Portrait or Square
        newHeight = maxHeight;
        newWidth = (maxHeight * aspectRatio).toInt();
      }
    }

    newWidth = max(1, min(newWidth, newHeight));
    newHeight = max(1, min(newHeight, newWidth));

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(
      recorder,
      Rect.fromLTRB(0, 0, newWidth.toDouble(), newHeight.toDouble()),
    );
    final Paint paint = Paint()..isAntiAlias = false;

    final sx = (cropRect.left - imageRect.left) / imageRect.width * image.width;
    final sy = (cropRect.top - imageRect.top) / imageRect.height * image.height;
    final sWidth = image.width * cropWidthPercent;
    final sHeight = image.height * cropHeightPercent;

    canvas.drawImageRect(
      image,
      Rect.fromLTRB(sx, sy, sx + sWidth, sy + sHeight),
      Rect.fromLTRB(0, 0, newWidth.toDouble(), newHeight.toDouble()),
      paint,
    );

    final ui.Image scaledAndCroppedImage =
        await recorder.endRecording().toImage(newWidth, newHeight);

    return scaledAndCroppedImage;
  }
}

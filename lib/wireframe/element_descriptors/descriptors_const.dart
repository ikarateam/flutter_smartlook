import 'package:flutter/rendering.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/abstract_descriptors/default_element_descriptor.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/not_visible_descriptors/render_clip_rect_descriptor.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/not_visible_descriptors/render_opacity_descriptor.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/not_visible_descriptors/render_padding_descriptor.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/not_visible_descriptors/render_transform_descriptor.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/visible_descriptors/render_android_view_descriptor.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/visible_descriptors/render_custom_paint_descriptor.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/visible_descriptors/render_decorated_box_descriptor.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/visible_descriptors/render_image_descriptor.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/visible_descriptors/render_paragraph_descriptor.dart';
import 'package:flutter_smartlook/wireframe/element_descriptors/visible_descriptors/render_physical_model_descriptor.dart';

class DescriptorsConst {
  String? renderColoredBox;

  final descriptorsMap = <String, DefaultElementDescriptor>{
    getRuntimeType<RenderDecoratedBox>(): const RenderDecoratedBoxDescriptor(),
    getRuntimeType<RenderImage>(): RenderImageDescriptor(),
    getRuntimeType<RenderParagraph>(): RenderParagraphDescriptor(),
    getRuntimeType<RenderPhysicalModel>(): const RenderPhysicalModelDescriptor(),
    getRuntimeType<RenderPhysicalShape>(): const RenderPhysicalModelDescriptor(),
    getRuntimeType<RenderEditable>(): RenderParagraphDescriptor(),
    getRuntimeType<RenderCustomPaint>(): RenderCustomPaintDescriptor(),
    getRuntimeType<RenderPadding>(): const RenderPaddingDescriptor(),
    getRuntimeType<RenderOpacity>(): const RenderOpacityDescriptor(),
    getRuntimeType<RenderTransform>(): const RenderTransformDescriptor(),
    getRuntimeType<RenderClipRect>(): const RenderClipRectDescriptor(),
    getRuntimeType<RenderAndroidView>(): const RenderAndroidViewDescriptor(),
  };

  static String getRuntimeType<T>() => T.toString();
}

import 'dart:math';

import 'package:flutter/material.dart';

class BlendUtils {
  Color blendColorsDirectly(Color baseColor, Color blendColor, BlendMode blendMode) {
    switch (blendMode) {
      case BlendMode.clear:
        return Colors.transparent;
      case BlendMode.src:
        return blendColor;
      case BlendMode.dst:
        return blendColor;
      case BlendMode.srcOver:
        return _blendSrcOver(baseColor, blendColor);
      case BlendMode.dstOver:
        return _blendDstOver(baseColor, blendColor);
      case BlendMode.srcIn:
        return Color.fromRGBO(blendColor.red, blendColor.green, blendColor.blue, baseColor.opacity * blendColor.opacity);
      case BlendMode.dstIn:
        return Color.fromRGBO(baseColor.red, baseColor.green, baseColor.blue, baseColor.opacity * blendColor.opacity);
      case BlendMode.srcOut:
        return Color.fromRGBO(blendColor.red, blendColor.green, blendColor.blue, baseColor.opacity * (1 - baseColor.opacity));
      case BlendMode.dstOut:
        return Color.fromRGBO(baseColor.red, baseColor.green, baseColor.blue, baseColor.opacity * (1 - blendColor.opacity));
      case BlendMode.srcATop:
        return _blendSrcATop(baseColor, blendColor);
      case BlendMode.dstATop:
        return _blendDstATop(baseColor, blendColor);
      case BlendMode.xor:
        return _blendXor(baseColor, blendColor);
      case BlendMode.plus:
        return Color.fromRGBO(
          min(255, baseColor.red + blendColor.red),
          min(255, baseColor.green + blendColor.green),
          min(255, baseColor.blue + blendColor.blue),
          1,
        );
      case BlendMode.modulate:
        return _blendMultiply(baseColor, blendColor);
      case BlendMode.screen:
        return _blendScreen(baseColor, blendColor);
      case BlendMode.overlay:
        return _blendOverlay(baseColor, blendColor);
      case BlendMode.darken:
        return _blendDarken(baseColor, blendColor);
      case BlendMode.lighten:
        return _blendLighten(baseColor, blendColor);
      case BlendMode.colorDodge:
        return _blendColorDodge(baseColor, blendColor);
      case BlendMode.colorBurn:
        return _blendColorBurn(baseColor, blendColor);
      case BlendMode.hardLight:
        return _blendHardLight(baseColor, blendColor);
      case BlendMode.softLight:
        return _blendSoftLight(baseColor, blendColor);
      case BlendMode.difference:
        return _blendDifference(baseColor, blendColor);
      case BlendMode.exclusion:
        return _blendExclusion(baseColor, blendColor);
      case BlendMode.multiply:
        return _blendMultiply(baseColor, blendColor);
      case BlendMode.hue:
        return _blendHue(baseColor, blendColor);
      case BlendMode.saturation:
        return _blendSaturation(baseColor, blendColor);
      case BlendMode.color:
        return _blendTheColor(baseColor, blendColor);
      case BlendMode.luminosity:
        return _blendLuminosity(baseColor, blendColor);

      default:
        return baseColor;
    }
  }

  Color _blendSrcOver(Color baseColor, Color blendColor) {
    final alpha = blendColor.opacity + baseColor.opacity * (1 - blendColor.opacity);
    final red = ((blendColor.red * blendColor.opacity) + (baseColor.red * baseColor.opacity * (1 - blendColor.opacity))) ~/ alpha;
    final green = ((blendColor.green * blendColor.opacity) + (baseColor.green * baseColor.opacity * (1 - blendColor.opacity))) ~/ alpha;
    final blue = ((blendColor.blue * blendColor.opacity) + (baseColor.blue * baseColor.opacity * (1 - blendColor.opacity))) ~/ alpha;

    return Color.fromRGBO(red, green, blue, alpha);
  }

  Color _blendDstOver(Color baseColor, Color blendColor) {
    final alpha = baseColor.opacity + blendColor.opacity * (1 - baseColor.opacity);
    final red = ((baseColor.red * baseColor.opacity) + (blendColor.red * blendColor.opacity * (1 - baseColor.opacity))) ~/ alpha;
    final green = ((baseColor.green * baseColor.opacity) + (blendColor.green * blendColor.opacity * (1 - baseColor.opacity))) ~/ alpha;
    final blue = ((baseColor.blue * baseColor.opacity) + (blendColor.blue * blendColor.opacity * (1 - baseColor.opacity))) ~/ alpha;

    return Color.fromRGBO(red, green, blue, alpha);
  }

  Color _blendSrcATop(Color baseColor, Color blendColor) {
    final alpha = baseColor.opacity;
    final red = (blendColor.red * blendColor.opacity * baseColor.opacity + baseColor.red * (1 - blendColor.opacity)) ~/ alpha;
    final green = (blendColor.green * blendColor.opacity * baseColor.opacity + baseColor.green * (1 - blendColor.opacity)) ~/ alpha;
    final blue = (blendColor.blue * blendColor.opacity * baseColor.opacity + baseColor.blue * (1 - blendColor.opacity)) ~/ alpha;

    return Color.fromRGBO(red, green, blue, alpha);
  }

  Color _blendDstATop(Color baseColor, Color blendColor) {
    final alpha = blendColor.opacity;
    final red = (baseColor.red * baseColor.opacity * blendColor.opacity + blendColor.red * (1 - baseColor.opacity)) ~/ alpha;
    final green = (baseColor.green * baseColor.opacity * blendColor.opacity + blendColor.green * (1 - baseColor.opacity)) ~/ alpha;
    final blue = (baseColor.blue * baseColor.opacity * blendColor.opacity + blendColor.blue * (1 - baseColor.opacity)) ~/ alpha;

    return Color.fromRGBO(red, green, blue, alpha);
  }

  Color _blendXor(Color baseColor, Color blendColor) {
    final alpha = baseColor.opacity + blendColor.opacity - 2 * baseColor.opacity * blendColor.opacity;
    final red = (baseColor.red * baseColor.opacity * (1 - blendColor.opacity) + blendColor.red * blendColor.opacity * (1 - baseColor.opacity)).toInt();
    final green = (baseColor.green * baseColor.opacity * (1 - blendColor.opacity) + blendColor.green * blendColor.opacity * (1 - baseColor.opacity)).toInt();
    final blue = (baseColor.blue * baseColor.opacity * (1 - blendColor.opacity) + blendColor.blue * blendColor.opacity * (1 - baseColor.opacity)).toInt();

    return Color.fromRGBO(red, green, blue, alpha);
  }

  Color _blendMultiply(Color baseColor, Color blendColor) {
    final blendAlpha = blendColor.opacity;

    final blendedRed = (baseColor.red * blendColor.red) ~/ 255;
    final blendedGreen = (baseColor.green * blendColor.green) ~/ 255;
    final blendedBlue = (baseColor.blue * blendColor.blue) ~/ 255;

    final finalRed = ((blendedRed * blendAlpha) + (baseColor.red * (1 - blendAlpha))).toInt();
    final finalGreen = ((blendedGreen * blendAlpha) + (baseColor.green * (1 - blendAlpha))).toInt();
    final finalBlue = ((blendedBlue * blendAlpha) + (baseColor.blue * (1 - blendAlpha))).toInt();

    return Color.fromRGBO(
      finalRed,
      finalGreen,
      finalBlue,
      baseColor.opacity,
    );
  }

  Color _blendScreen(Color baseColor, Color blendColor) {
    final blendAlpha = blendColor.opacity;

    final screenRed = 255 - (((255 - baseColor.red) * (255 - blendColor.red)) ~/ 255);
    final screenGreen = 255 - (((255 - baseColor.green) * (255 - blendColor.green)) ~/ 255);
    final screenBlue = 255 - (((255 - baseColor.blue) * (255 - blendColor.blue)) ~/ 255);

    final finalRed = ((screenRed * blendAlpha) + (baseColor.red * (1 - blendAlpha))).toInt();
    final finalGreen = ((screenGreen * blendAlpha) + (baseColor.green * (1 - blendAlpha))).toInt();
    final finalBlue = ((screenBlue * blendAlpha) + (baseColor.blue * (1 - blendAlpha))).toInt();

    return Color.fromRGBO(finalRed, finalGreen, finalBlue, baseColor.opacity);
  }

  Color _blendOverlay(Color baseColor, Color blendColor) {
    int overlayChannel(int baseC, int blendC) {
      return baseC < 128 ? 2 * baseC * blendC ~/ 255 : 255 - 2 * (255 - baseC) * (255 - blendC) ~/ 255;
    }

    final alpha = blendColor.opacity;

    final overlayRed = overlayChannel(baseColor.red, blendColor.red);
    final overlayGreen = overlayChannel(baseColor.green, blendColor.green);
    final overlayBlue = overlayChannel(baseColor.blue, blendColor.blue);

    final finalRed = ((overlayRed * alpha) + (baseColor.red * (1 - alpha))).toInt();
    final finalGreen = ((overlayGreen * alpha) + (baseColor.green * (1 - alpha))).toInt();
    final finalBlue = ((overlayBlue * alpha) + (baseColor.blue * (1 - alpha))).toInt();

    return Color.fromRGBO(finalRed, finalGreen, finalBlue, baseColor.opacity);
  }

  Color _blendDarken(Color baseColor, Color blendColor) {
    final alpha = blendColor.opacity;

    final finalRed = min((blendColor.red * alpha + baseColor.red * (1 - alpha)).toInt(), baseColor.red);
    final finalGreen = min((blendColor.green * alpha + baseColor.green * (1 - alpha)).toInt(), baseColor.green);
    final finalBlue = min((blendColor.blue * alpha + baseColor.blue * (1 - alpha)).toInt(), baseColor.blue);

    return Color.fromRGBO(finalRed, finalGreen, finalBlue, baseColor.opacity);
  }

  Color _blendLighten(Color baseColor, Color blendColor) {
    final alpha = blendColor.opacity;

    final finalRed = max((blendColor.red * alpha + baseColor.red * (1 - alpha)).toInt(), baseColor.red);
    final finalGreen = max((blendColor.green * alpha + baseColor.green * (1 - alpha)).toInt(), baseColor.green);
    final finalBlue = max((blendColor.blue * alpha + baseColor.blue * (1 - alpha)).toInt(), baseColor.blue);

    return Color.fromRGBO(finalRed, finalGreen, finalBlue, baseColor.opacity);
  }

  Color _blendColorDodge(Color baseColor, Color blendColor) {
    final alpha = blendColor.opacity;

    int colorDodgeChannel(int baseC, int blendC, double alpha) {
      blendC = (blendC * alpha).toInt();

      return blendC == 255 ? 255 : min(255, (baseC << 8) ~/ (255 - blendC));
    }

    final finalRed = colorDodgeChannel(baseColor.red, blendColor.red, alpha);
    final finalGreen = colorDodgeChannel(baseColor.green, blendColor.green, alpha);
    final finalBlue = colorDodgeChannel(baseColor.blue, blendColor.blue, alpha);

    return Color.fromRGBO(finalRed, finalGreen, finalBlue, baseColor.opacity);
  }

  Color _blendColorBurn(Color baseColor, Color blendColor) {
    final alpha = blendColor.opacity;

    int colorBurnChannel(int baseC, int blendC, double alpha) {
      blendC = (blendC * alpha).toInt();

      return blendC == 0 ? 0 : max(0, 255 - ((255 - baseC) << 8) ~/ blendC);
    }

    final finalRed = colorBurnChannel(baseColor.red, blendColor.red, alpha);
    final finalGreen = colorBurnChannel(baseColor.green, blendColor.green, alpha);
    final finalBlue = colorBurnChannel(baseColor.blue, blendColor.blue, alpha);

    return Color.fromRGBO(finalRed, finalGreen, finalBlue, baseColor.opacity);
  }

  Color _blendHardLight(Color baseColor, Color blendColor) {
    final alpha = blendColor.opacity;

    int hardLightChannel(int baseC, int blendC, double alpha) {
      blendC = (blendC * alpha).toInt();

      return blendC < 128 ? 2 * baseC * blendC ~/ 255 : 255 - 2 * (255 - baseC) * (255 - blendC) ~/ 255;
    }

    final finalRed = hardLightChannel(baseColor.red, blendColor.red, alpha);
    final finalGreen = hardLightChannel(baseColor.green, blendColor.green, alpha);
    final finalBlue = hardLightChannel(baseColor.blue, blendColor.blue, alpha);

    return Color.fromRGBO(finalRed, finalGreen, finalBlue, baseColor.opacity);
  }

  Color _blendSoftLight(Color baseColor, Color blendColor) {
    final alpha = blendColor.opacity;

    num _softLightDodge(int c) {
      return c < 64 ? (16 * c - 12) * c + 4 * c : sqrt(c / 255) * 255;
    }

    int softLightChannel(int baseC, int blendC, double alpha) {
      blendC = (blendC * alpha).toInt();

      return blendC < 128
          ? baseC - (255 - 2 * blendC) * baseC * (255 - baseC) ~/ 255 ~/ 255
          : baseC + (2 * blendC - 255) * (baseC < 128 ? _softLightDodge(baseC) : sqrt(baseC / 255)) ~/ 255;
    }

    final finalRed = softLightChannel(baseColor.red, blendColor.red, alpha);
    final finalGreen = softLightChannel(baseColor.green, blendColor.green, alpha);
    final finalBlue = softLightChannel(baseColor.blue, blendColor.blue, alpha);

    return Color.fromRGBO(finalRed, finalGreen, finalBlue, baseColor.opacity);
  }

  Color _blendDifference(Color baseColor, Color blendColor) {
    final alpha = blendColor.opacity;

    int differenceChannel(int baseC, int blendC, double alpha) {
      blendC = (blendC * alpha).toInt();

      return (baseC - blendC).abs();
    }

    final finalRed = differenceChannel(baseColor.red, blendColor.red, alpha);
    final finalGreen = differenceChannel(baseColor.green, blendColor.green, alpha);
    final finalBlue = differenceChannel(baseColor.blue, blendColor.blue, alpha);

    return Color.fromRGBO(finalRed, finalGreen, finalBlue, baseColor.opacity);
  }

  Color _blendExclusion(Color baseColor, Color blendColor) {
    final alpha = blendColor.opacity;

    int exclusionChannel(int baseC, int blendC, double alpha) {
      blendC = (blendC * alpha).toInt();

      return baseC + blendC - 2 * baseC * blendC ~/ 255;
    }

    final finalRed = exclusionChannel(baseColor.red, blendColor.red, alpha);
    final finalGreen = exclusionChannel(baseColor.green, blendColor.green, alpha);
    final finalBlue = exclusionChannel(baseColor.blue, blendColor.blue, alpha);

    return Color.fromRGBO(finalRed, finalGreen, finalBlue, baseColor.opacity);
  }

  Color _blendHue(Color baseColor, Color blendColor) {
    final baseHSL = _rgbToHsl(baseColor);
    final blendHSL = _rgbToHsl(blendColor);
    final blendOpacity = blendColor.opacity;

    final blendedRGB = _hslToRgb(blendHSL[0], baseHSL[1], baseHSL[2]);

    return _applyOpacity(baseColor, blendedRGB, blendOpacity);
  }

  Color _blendSaturation(Color baseColor, Color blendColor) {
    final baseHSL = _rgbToHsl(baseColor);
    final blendHSL = _rgbToHsl(blendColor);
    final blendOpacity = blendColor.opacity;

    final blendedRGB = _hslToRgb(baseHSL[0], blendHSL[1], baseHSL[2]);

    return _applyOpacity(baseColor, blendedRGB, blendOpacity);
  }

  Color _blendTheColor(Color baseColor, Color blendColor) {
    final baseHSL = _rgbToHsl(baseColor);
    final blendHSL = _rgbToHsl(blendColor);
    final blendOpacity = blendColor.opacity;

    final blendedRGB = _hslToRgb(blendHSL[0], blendHSL[1], baseHSL[2]);

    return _applyOpacity(baseColor, blendedRGB, blendOpacity);
  }

  Color _blendLuminosity(Color baseColor, Color blendColor) {
    final baseHSL = _rgbToHsl(baseColor);
    final blendHSL = _rgbToHsl(blendColor);
    final blendOpacity = blendColor.opacity;

    final blendedRGB = _hslToRgb(baseHSL[0], baseHSL[1], blendHSL[2]);
    final appliedOpacityRGB = Color.fromRGBO(
      ((blendedRGB.red * blendOpacity) + (baseColor.red * (1 - blendOpacity))).round(),
      ((blendedRGB.green * blendOpacity) + (baseColor.green * (1 - blendOpacity))).round(),
      ((blendedRGB.blue * blendOpacity) + (baseColor.blue * (1 - blendOpacity))).round(),
      1,
    );

    return appliedOpacityRGB;
  }

  Color _applyOpacity(Color baseColor, Color blendedColor, double blendOpacity) {
    return Color.fromRGBO(
      ((blendedColor.red * blendOpacity) + (baseColor.red * (1 - blendOpacity))).round(),
      ((blendedColor.green * blendOpacity) + (baseColor.green * (1 - blendOpacity))).round(),
      ((blendedColor.blue * blendOpacity) + (baseColor.blue * (1 - blendOpacity))).round(),
      baseColor.opacity,
    );
  }

  List<double> _rgbToHsl(Color color) {
    final r = color.red / 255.0;
    final g = color.green / 255.0;
    final b = color.blue / 255.0;
    final maxColor = max(r, max(g, b));
    final minColor = min(r, min(g, b));
    double h = 0.0, s;
    final l = (maxColor + minColor) / 2.0;

    if (maxColor == minColor) {
      h = s = 0.0;
    } else {
      final d = maxColor - minColor;
      s = l > 0.5 ? d / (2.0 - maxColor - minColor) : d / (maxColor + minColor);
      if (maxColor == r) {
        h = (g - b) / d + (g < b ? 6.0 : 0.0);
      } else if (maxColor == g) {
        h = (b - r) / d + 2.0;
      } else if (maxColor == b) {
        h = (r - g) / d + 4.0;
      }
      h /= 6.0;
    }

    return [h, s, l];
  }

  Color _hslToRgb(double h, double s, double l) {
    double r, g, b;

    if (s == 0.0) {
      r = g = b = l;
    } else {
      final q = l < 0.5 ? l * (1.0 + s) : l + s - l * s;
      final p = 2.0 * l - q;
      r = _hue2rgb(p, q, h + 1.0 / 3.0);
      g = _hue2rgb(p, q, h);
      b = _hue2rgb(p, q, h - 1.0 / 3.0);
    }

    return Color.fromRGBO((r * 255).round(), (g * 255).round(), (b * 255).round(), 1);
  }

  double _hue2rgb(double p, double q, double t) {
    if (t < 0.0) t += 1.0;
    if (t > 1.0) t -= 1.0;
    if (t < 1.0 / 6.0) return p + (q - p) * 6.0 * t;
    if (t < 1.0 / 2.0) return q;
    if (t < 2.0 / 3.0) return p + (q - p) * (2.0 / 3.0 - t) * 6.0;

    return p;
  }
}

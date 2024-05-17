import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LimitedAspectRatio extends SingleChildRenderObjectWidget {
  final double aspectRatio;
  final double? minHeight;
  final double? maxHeight;
  final double? minWidth;
  final double? maxWidth;

  const LimitedAspectRatio({
    super.key,
    required this.aspectRatio,
    this.minHeight,
    this.maxHeight,
    this.minWidth,
    this.maxWidth,
    super.child,
  })  : assert(aspectRatio > 0.0),
        assert((maxHeight ?? 0) >= 0),
        assert((minHeight ?? 0) >= 0),
        assert((maxWidth ?? 0) >= 0),
        assert((minWidth ?? 0) >= 0);

  /// The aspect ratio to attempt to use.
  ///
  /// The aspect ratio is expressed as a ratio of width to height. For example,
  /// a 16:9 width:height aspect ratio would have a value of 16.0/9.0.

  @override
  RenderLimitedAspectRatio createRenderObject(BuildContext context) => RenderLimitedAspectRatio(
    aspectRatio: aspectRatio,
    maxHeight: maxHeight,
    maxWidth: maxWidth,
    minHeight: minHeight,
    minWidth: minWidth,
  );

  @override
  void updateRenderObject(
      BuildContext context,
      RenderLimitedAspectRatio renderObject,
      ) {
    renderObject
      ..aspectRatio = aspectRatio
      ..maxWidth = maxWidth
      ..minWidth = minWidth
      ..maxHeight = maxHeight
      ..minHeight = minHeight;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('aspectRatio', aspectRatio))
      ..add(DoubleProperty('minWidth', minWidth))
      ..add(DoubleProperty('maxWidth', maxWidth))
      ..add(DoubleProperty('minHeight', minHeight))
      ..add(DoubleProperty('maxHeight', maxHeight));
  }
}

class RenderLimitedAspectRatio extends RenderProxyBox {
  double _aspectRatio;
  double? _minHeight;
  double? _maxHeight;
  double? _minWidth;
  double? _maxWidth;

  RenderLimitedAspectRatio({
    RenderBox? child,
    required double aspectRatio,
    double? maxHeight,
    double? minHeight,
    double? maxWidth,
    double? minWidth,
  })  : assert(aspectRatio > 0.0),
        assert(aspectRatio.isFinite),
        assert((maxHeight ?? 0) >= 0),
        assert((minHeight ?? 0) >= 0),
        assert((maxWidth ?? 0) >= 0),
        assert((minWidth ?? 0) >= 0),
        _aspectRatio = aspectRatio,
        _maxHeight = maxHeight,
        _minHeight = minHeight,
        _maxWidth = maxWidth,
        _minWidth = minWidth,
        super(child);

  double get aspectRatio => _aspectRatio;

  double? get maxHeight => _maxHeight;

  double? get minHeight => _minHeight;

  double? get maxWidth => _maxWidth;

  double? get minWidth => _minWidth;

  set aspectRatio(double value) {
    assert(value > 0.0);
    assert(value.isFinite);
    if (_aspectRatio == value) {
      return;
    }
    _aspectRatio = value;
    markNeedsLayout();
  }

  set maxHeight(double? value) {
    assert((value ?? 0) >= 0.0);
    assert(value?.isFinite ?? true);
    if (_maxHeight == value) {
      return;
    }
    _maxHeight = value;
    markNeedsLayout();
  }

  set minHeight(double? value) {
    assert((value ?? 0) >= 0.0);
    assert(value?.isFinite ?? true);
    if (_minHeight == value) {
      return;
    }
    _minHeight = value;
    markNeedsLayout();
  }

  set maxWidth(double? value) {
    assert((value ?? 0) >= 0.0);
    assert(value?.isFinite ?? true);
    if (_maxWidth == value) {
      return;
    }
    _maxWidth = value;
    markNeedsLayout();
  }

  set minWidth(double? value) {
    assert((value ?? 0) >= 0.0);
    assert(value?.isFinite ?? true);
    if (_minWidth == value) {
      return;
    }
    _minWidth = value;
    markNeedsLayout();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    if (height.isFinite) {
      return max(height * _aspectRatio, _minWidth ?? 0);
    }
    if (child != null) {
      return child!.getMinIntrinsicWidth(height);
    }
    return _minWidth ?? 0.0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    if (height.isFinite) {
      return min(height * _aspectRatio, _maxWidth ?? double.maxFinite);
    }
    if (child != null) {
      return child!.getMaxIntrinsicWidth(height);
    }
    return _maxWidth ?? 0.0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    if (width.isFinite) {
      return max(width / _aspectRatio, _minHeight ?? 0);
    }
    if (child != null) {
      return child!.getMinIntrinsicHeight(width);
    }
    return _minHeight ?? 0.0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    if (width.isFinite) {
      return min(width / _aspectRatio, _maxHeight ?? double.maxFinite);
    }
    if (child != null) {
      return child!.getMaxIntrinsicHeight(width);
    }
    return _maxHeight ?? 0.0;
  }

  Size _applyAspectRatio(BoxConstraints constraints) {
    assert(constraints.debugAssertIsValid());
    assert(() {
      if (!constraints.hasBoundedWidth && !constraints.hasBoundedHeight) {
        throw FlutterError(
          '$runtimeType has unbounded constraints.\n'
              'This $runtimeType was given an aspect ratio of $aspectRatio but was given '
              'both unbounded width and unbounded height constraints. Because both '
              "constraints were unbounded, this render object doesn't know how much "
              'size to consume.',
        );
      }
      return true;
    }());

    if (constraints.isTight) {
      return constraints.smallest;
    }

    var width = constraints.maxWidth;
    double height;

    // We default to picking the height based on the width, but if the width
    // would be infinite, that's not sensible so we try to infer the height
    // from the width.
    if (width.isFinite) {
      height = width / _aspectRatio;
    } else {
      height = constraints.maxHeight;
      width = height * _aspectRatio;
    }

    // Similar to RenderImage, we iteratively attempt to fit within the given
    // constraints while maintaining the given aspect ratio. The order of
    // applying the constraints is also biased towards inferring the height
    // from the width.
    if (width > constraints.maxWidth) {
      width = constraints.maxWidth;
      height = width / _aspectRatio;
    }

    if (height > constraints.maxHeight) {
      height = constraints.maxHeight;
      width = height * _aspectRatio;
    }

    if (width < constraints.minWidth) {
      width = constraints.minWidth;
      height = width / _aspectRatio;
    }

    if (height < constraints.minHeight) {
      height = constraints.minHeight;
      width = height * _aspectRatio;
    }

    height = height.clamp(_minHeight ?? 0, _maxHeight ?? double.maxFinite);
    width = width.clamp(_minWidth ?? 0, _maxWidth ?? double.maxFinite);
    return constraints.constrain(Size(width, height));
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) => _applyAspectRatio(constraints);

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
    if (child != null) {
      child!.layout(BoxConstraints.tight(size));
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('aspectRatio', aspectRatio))
      ..add(DoubleProperty('minWidth', minWidth))
      ..add(DoubleProperty('maxWidth', maxWidth))
      ..add(DoubleProperty('minHeight', minHeight))
      ..add(DoubleProperty('maxHeight', maxHeight));
  }
}
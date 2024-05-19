import 'dart:math';

import 'package:flutter/material.dart';
import 'package:weather_nearby/core/app_colors.dart';
import 'package:weather_nearby/core/localization/translation_service.dart';
import 'package:weather_nearby/core/localization/translations_keys.dart';
import 'package:weather_nearby/core/utils/scroll_behavior.dart';
import 'package:weather_nearby/core/widgets/decoration/card_decoration.dart';
import 'package:weather_nearby/core/widgets/layout/limited_aspect_ratio.dart';
import 'package:weather_nearby/core/widgets/simple/basic_text.dart';

class CountrySearchField extends StatefulWidget {
  final FocusNode? focusNode;
  final List<String> options;
  final void Function(String value)? onSearch;
  final VoidCallback? onUpdate;
  final String? initValue;
  final bool isLoading;

  const CountrySearchField({
    super.key,
    this.focusNode,
    this.options = const [],
    this.onSearch,
    this.onUpdate,
    this.initValue,
    this.isLoading = false,
  });

  @override
  State<CountrySearchField> createState() => _CountrySearchFieldState();
}

class _CountrySearchFieldState extends State<CountrySearchField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initValue ?? '';
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => RawAutocomplete<String>(
                focusNode: widget.focusNode ?? FocusNode(),
                textEditingController: _controller,
                fieldViewBuilder: (
                  context,
                  textEditingController,
                  focusNode,
                  onFieldSubmitted,
                ) =>
                    TextFormField(
                  focusNode: focusNode,
                  controller: textEditingController,
                  onFieldSubmitted: widget.onSearch,
                  enabled: !widget.isLoading,
                  decoration: InputDecoration(
                    hintText: context.translate(TranslationsKeys.city),
                    hintStyle: TextStyle(
                      color: AppColors.textPrimary.withAlpha(50),
                    ),
                  ),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                  ),
                ),
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return widget.options.toList();
                  }
                  return widget.options.where(
                    (option) =>
                        option.toLowerCase().contains(textEditingValue.text.toLowerCase()) &&
                        option.toLowerCase() != textEditingValue.text.toLowerCase(),
                  );
                },

                onSelected: (selection) {
                  widget.focusNode?.unfocus();
                  widget.onSearch?.call(selection);
                },
                optionsViewBuilder: (
                  context,
                  onSelected,
                  options,
                ) =>
                    Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    color: Colors.transparent,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(4.0)),
                    ),
                    child: SizedBox(
                      width: constraints.biggest.width,
                      height: min(225, options.length * 50),
                      child: CardDecoration(
                        topLeftCorner: false,
                        topRightCorner: false,
                        child: ScrollConfiguration(
                          behavior: CustomScrollBehavior(),
                          child: ListView.separated(
                            itemCount: options.length,
                            separatorBuilder: (context, index) => const Divider(
                              thickness: 1,
                              height: 1,
                            ),
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                onSelected(options.elementAt(index));
                              },
                              child: Container(
                                height: 50,
                                color: AppColors.main,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: BasicText(
                                    options.elementAt(index),
                                    textScaleFactor: 1.3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (widget.onSearch != null)
            LimitedAspectRatio(
              aspectRatio: 1,
              maxWidth: 40,
              child: FittedBox(
                child: MouseRegion(
                  cursor: widget.isLoading ? MouseCursor.defer : SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: widget.isLoading
                        ? null
                        : () {
                            if (_controller.text.isEmpty) {
                              if (!(widget.focusNode?.hasPrimaryFocus ?? false)) {
                                widget.focusNode?.requestFocus();
                              }
                              return;
                            }
                            widget.onSearch?.call(_controller.text);
                          },
                    child: const Icon(
                      Icons.search_outlined,
                      color: AppColors.textPrimary,
                      size: 100,
                    ),
                  ),
                ),
              ),
            ),
          if (widget.onUpdate != null)
            LimitedAspectRatio(
              aspectRatio: 1,
              maxWidth: 40,
              child: FittedBox(
                child: MouseRegion(
                  cursor: widget.isLoading ? MouseCursor.defer : SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: widget.isLoading ? null : widget.onUpdate,
                    child: _Rotation(
                      doAnimation: widget.isLoading,
                      child: const Icon(
                        Icons.refresh,
                        color: AppColors.textPrimary,
                        size: 100,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _Rotation extends StatefulWidget {
  final Widget child;
  final bool doAnimation;

  const _Rotation({
    required this.child,
    this.doAnimation = true,
  });

  @override
  State<_Rotation> createState() => _RotationState();
}

class _RotationState extends State<_Rotation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    if (widget.doAnimation) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant _Rotation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.doAnimation && !_controller.isAnimating) {
      _controller.repeat();
    }
    if (!widget.doAnimation && _controller.isAnimating) {
      _controller
        ..stop()
        ..animateTo(_controller.upperBound, duration: const Duration(milliseconds: 300));
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.rotate(
          angle: pi * 2 * _controller.value,
          child: widget.child,
        ),
      );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

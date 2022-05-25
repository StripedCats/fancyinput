import 'dart:io';

import 'package:fancyinput/fancyinput.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class _FancyInput extends State<FancyInput> {
  late final focusNode = widget.focusNode ?? FocusNode();
  late final controller = widget.controller ?? TextEditingController();
  late final style = widget.style ?? _generateStyle();

  late final ValueNotifier<bool> _showSuffix;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.vertical(
        top: Radius.circular(style.topBorderRadius),
        bottom: Radius.circular(style.bottomBorderRadius));
    const border = InputBorder.none;

    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: style.backgroundColor,
        ),
        child: Container(
          decoration: style.includeUnderline
              ? BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                  color: style.underlineColor,
                )))
              : null,
          padding: EdgeInsets.zero,
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: style.padding.left),
                if (widget.prefix != null) ...[
                  DefaultTextStyle(
                    style: style.prefixStyle,
                    textAlign: TextAlign.left,
                    child: widget.prefix!,
                  ),
                  const SizedBox(width: 12),
                  if (style.includeDivider) ...[
                    Container(
                      height: double.infinity,
                      width: 1.0,
                      color: const Color.fromRGBO(134, 134, 134, 1.0),
                      margin: EdgeInsets.symmetric(vertical: style.dividerGap),
                    ),
                    const SizedBox(width: 12),
                  ]
                ],
                Expanded(
                  child: TextField(
                    autofocus: widget.autofocus,
                    focusNode: focusNode,
                    controller: controller,
                    onChanged: widget.onChanged,
                    inputFormatters: widget.formatters,
                    keyboardType: widget.keyboardType,
                    onEditingComplete: widget.onEditingCompleted,
                    onSubmitted: widget.onCompleted,
                    decoration: InputDecoration(
                      border: border,
                      errorBorder: border,
                      enabledBorder: border,
                      focusedBorder: border,
                      disabledBorder: border,
                      focusedErrorBorder: border,
                      isDense: true,
                      contentPadding: EdgeInsets.only(
                          top: style.padding.top, bottom: style.padding.bottom),
                      hintMaxLines: 1,
                      hintText: widget.placeholder,
                    ),
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.top,
                    style: style.contentStyle,
                  ),
                ),
                if (widget.suffix != null)
                  _MomentalCrossFade(
                    duration: widget.suffixFadeDuration,
                    valueNotifier: _showSuffix,
                    trueChild: _Clickable(
                      enableFeedback: widget.enableSuffixFeedback,
                      onTap: _onSuffixTap,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 5),
                        margin: const EdgeInsets.only(right: 16),
                        child: widget.suffix!,
                      ),
                    ),
                    falseChild: const SizedBox.shrink(),
                  )
              ],
            ),
          ),
        ),
      ),
      onTap: () => focusNode.requestFocus(),
    );
  }

  FancyInputStyle _generateStyle() {
    if (Platform.isAndroid) {
      return const FancyInputStyle.android();
    }

    return const FancyInputStyle.iOS();
  }

  bool get isSuffixShown =>
      focusNode.hasFocus ||
      widget.suffixShowCondition == IconShowCondition.always;

  void _onSuffixTap() => (widget.onSuffixTap ?? controller.clear)();

  @override
  void initState() {
    focusNode.addListener(_focusHandler);
    _showSuffix = ValueNotifier<bool>(isSuffixShown);
    controller.text = widget.initialValue ?? "";

    super.initState();
  }

  void _focusHandler() => _showSuffix.value = isSuffixShown;

  @override
  void dispose() {
    focusNode.removeListener(_focusHandler);
    super.dispose();
  }
}

class FancyInput extends StatefulWidget {
  final FancyInputStyle? style;

  final FocusNode? focusNode;
  final TextEditingController? controller;

  final IconShowCondition suffixShowCondition;

  final bool autofocus;
  final bool enableSuffixFeedback;

  final Widget? prefix;
  final Widget? suffix;

  final TextInputType? keyboardType;

  final String? placeholder;
  final String? initialValue;

  final Duration suffixFadeDuration;

  final void Function()? onSuffixTap;
  final void Function()? onEditingCompleted;

  final void Function(String)? onCompleted;
  final void Function(String)? onChanged;

  final List<TextInputFormatter> formatters;

  const FancyInput(
      {Key? key,
      this.style,
      this.autofocus = false,
      this.suffixShowCondition = IconShowCondition.focused,
      this.formatters = const [],
      this.focusNode,
      this.initialValue,
      this.prefix,
      this.keyboardType,
      this.suffix,
      this.onChanged,
      this.onCompleted,
      this.onEditingCompleted,
      this.placeholder,
      this.onSuffixTap,
      this.controller,
      this.enableSuffixFeedback = true,
      this.suffixFadeDuration = const Duration(milliseconds: 300)})
      : super(key: key);

  @override
  createState() => _FancyInput();
}

class _Clickable extends StatelessWidget {
  final void Function()? onTap;
  final bool enableFeedback;

  final Widget child;

  const _Clickable({
    Key? key,
    required this.child,
    required this.onTap,
    this.enableFeedback = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      enableFeedback: enableFeedback,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      canRequestFocus: false,
      child: child,
    );
  }
}

class _MomentalCrossFadeState extends State<_MomentalCrossFade>
    with TickerProviderStateMixin {
  late final controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final animation =
      CurvedAnimation(parent: controller, curve: Curves.linear);

  final key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: widget.valueNotifier,
        builder: (_, value, __) {
          if (value) {
            controller.forward();
          } else {
            controller.reverse();
          }

          return FadeTransition(
            opacity: animation,
            key: key,
            child: value ? widget.trueChild : widget.falseChild,
          );
        });
  }
}

class _MomentalCrossFade extends StatefulWidget {
  final Duration duration;
  final ValueNotifier<bool> valueNotifier;

  final Widget trueChild;
  final Widget falseChild;

  const _MomentalCrossFade({
    Key? key,
    required this.duration,
    required this.valueNotifier,
    required this.trueChild,
    required this.falseChild,
  }) : super(key: key);

  @override
  createState() => _MomentalCrossFadeState();
}

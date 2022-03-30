import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum FancyInputCondition { focused, alwaysShown }

class _FancyInput extends State<FancyInput> {
  final node = FocusNode();
  late final TextEditingController controller;

  late bool focused;

  @override
  void initState() {
    controller = widget.controller ?? TextEditingController();
    focused = widget.autofocus || node.hasFocus;

    node.addListener(() {
      if (focused == node.hasFocus) {
        return;
      }

      focused = node.hasFocus;
      setState(() {});
    });

    super.initState();
  }

  bool checkCondition(FancyInputCondition condition) =>
      condition == FancyInputCondition.alwaysShown || focused;

  Widget _buildPrefix() {
    if (widget.prefix == null || !checkCondition(widget.prefixShowCondition)) {
      return const SizedBox();
    }

    const divider = SizedBox(width: 12);
    final color = widget.prefixDividerColor ?? const Color(0xffBEBEBE);

    return Row(
      children: [
        DefaultTextStyle(style: widget.prefixStyle, child: widget.prefix!),
        divider,
        VerticalDivider(width: 0, color: color),
        divider,
      ],
    );
  }

  Widget _buildSuffix() {
    if (widget.suffix == null || !checkCondition(widget.suffixShowCondition)) {
      return const SizedBox();
    }

    const divider = SizedBox(width: 8);

    return Row(
      children: [
        divider,
        widget.suffix!,
        divider,
      ],
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: _build(context),
      onTap: () => node.requestFocus(),
    );
  }

  Widget _build(BuildContext context) {
    return Container(
      child: Container(
        child: IntrinsicHeight(
          child: Row(
            children: [
              _buildPrefix(),
              Expanded(
                child: Padding(
                  child: TextField(
                    focusNode: node,
                    cursorColor: widget.cursorColor,
                    inputFormatters: widget.formatters,
                    onEditingComplete: widget.onEditingComplete,
                    onChanged: widget.onChanged,
                    onSubmitted: widget.onSubmitted,
                    onTap: widget.onTap,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                    ),
                    style: widget.contentStyle,
                    controller: controller,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 9),
                ),
              ),
              _buildSuffix(),
            ],
          ),
        ),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: const Color(0xff263238).withOpacity(0.38),
        ))),
        width: widget.width,
        padding: widget.padding,
      ),
      decoration: BoxDecoration(
        color: widget.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
      ),
    );
  }
}

class FancyInput extends StatefulWidget {
  final Color background;
  final Color? cursorColor;
  final Color? prefixDividerColor;

  final EdgeInsets padding;
  final EdgeInsets suffixPadding;

  /* `FancyInput`'s with, by default this field is double.infinity */
  final double width;
  final bool autofocus;

  final TextEditingController? controller;

  /* Widget before the user text */
  final Widget? prefix;

  /* Widget after the user text */
  final Widget? suffix;

  /* prefix/suffix show conditions */
  final FancyInputCondition prefixShowCondition;
  final FancyInputCondition suffixShowCondition;

  /* Prefix/suffix text styles */
  final TextStyle prefixStyle;
  final TextStyle contentStyle;

  /* Input text formatters */
  final List<TextInputFormatter>? formatters;

  /* Input callbacks */
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;

  final void Function()? onTap;
  final void Function()? onEditingComplete;

  const FancyInput({
    Key? key,
    this.background = const Color(0xffF0F0F0),
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
    this.suffixPadding = const EdgeInsets.symmetric(horizontal: 8),
    this.width = double.infinity,
    this.autofocus = false,
    this.controller,
    this.cursorColor,
    this.prefix,
    this.suffix,
    this.prefixDividerColor,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.formatters,
    this.prefixShowCondition = FancyInputCondition.alwaysShown,
    this.suffixShowCondition = FancyInputCondition.focused,
    this.prefixStyle = const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16,
        letterSpacing: 0.44,
        color: Color(0xff868686)),
    this.contentStyle = const TextStyle(
      color: Color(0xff333333),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.44,
    ),
  }) : super(key: key);

  @override
  createState() => _FancyInput();
}

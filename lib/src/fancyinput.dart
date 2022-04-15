import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class _FancyInput extends State<FancyInput> {
  late FocusNode node;
  late TextEditingController controller;

  bool isSuffixShown()
      => widget.suffix != null && (widget.suffixShowCondition == IconShowCondition.always || node.hasFocus);

  @override
  void initState() {
    node = widget.focusNode ?? FocusNode();
    controller = widget.controller ?? TextEditingController();

    var lastValue = widget.autofocus;
    node.addListener(() {
      // Add state checking to reduce number of updates
      if (node.hasFocus != lastValue) {
        lastValue = node.hasFocus;
        setState(() {});
      }
    });

    controller.text = widget.initialValue ?? "";

    super.initState();
  }

  Widget _buildSuffix() {
    final style = widget.style;

    return InkWell(
      child: SizedBox(
        child: Container(
          child: widget.suffix!,
          alignment: Alignment.center,

          width: style.iconSize.width,
          height: style.iconSize.height,
        ),
        height: double.infinity,
        width: style.iconSize.width + style.padding.right + style.padding.left,
      ),
      enableFeedback: widget.enableSuffixFeedback,

      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,

      onTap: widget.onTap ?? () {
        controller.text = "";
        if (widget.onChanged != null) {
          widget.onChanged!("");
        }
      },
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
    final style = widget.style;
    final doubleRadius = style.borderRadius;

    final radius = Radius.circular(doubleRadius);
    final bottomRadius = Radius.circular(style.onlyTopRadius ? 0 : doubleRadius);

    var inputInsets = EdgeInsets.only(
      top: style.padding.top,
      bottom: style.padding.bottom,
    );
    final showDivider = widget.prefix != null && style.includeDivider;
    final rightPadding = isSuffixShown() ? 0.0 : style.padding.right;

    if (widget.prefix != null) {
      inputInsets = inputInsets.copyWith(
        left: style.dividerGap.width,
        right: rightPadding
      );
    } else {
      inputInsets = inputInsets.copyWith(
        left: 16,
        right: rightPadding
      );
    }

    return Container(
      child: IntrinsicHeight(
        child: Container(
          child: Row(
            children: [
              if (widget.prefix != null) Container(
                child: DefaultTextStyle(
                  child: widget.prefix!,
                  style: style.contentStyle.copyWith(color: style.prefixColor)
                ),
                margin: EdgeInsets.only(left: style.padding.left),
              ),
              if (showDivider) SizedBox(width: style.padding.left),
              if (showDivider) Padding(
                child: VerticalDivider(
                  color: style.dividerColor,
                  width: style.dividerWeight,
                ),

                padding: EdgeInsets.symmetric(vertical: style.dividerGap.height),
              ),

              Expanded(
                child: TextField(
                  focusNode: node,
                  controller: controller,
                  autofocus: widget.autofocus,

                  inputFormatters: widget.formatters,
                  keyboardType: widget.keyboardType,
                  
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  onEditingComplete: widget.onEditingComplete,

                  cursorColor: style.cursorColor,

                  decoration: InputDecoration(
                    contentPadding: inputInsets,
                    isDense: true,

                    hintText: widget.placeholder,
                    hintStyle: style.contentStyle.copyWith(color: style.placeholderColor),

                    border: InputBorder.none
                  ),

                  style: style.contentStyle,
                  textAlignVertical: TextAlignVertical.center,
                ),
              ),

              if (isSuffixShown()) _buildSuffix()
            ],
          ),
          
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: style.underlineColor,
                width: 1
              )
            )
          ),
        ),
      ),

      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.only(
          topLeft: radius,
          topRight: radius,

          bottomLeft: bottomRadius,
          bottomRight: bottomRadius
        )
      ),
    );
  }
}

enum IconShowCondition {
  focus,
  always
}

class FancyInputStyle {
  final EdgeInsets padding;

  final Color underlineColor;
  final Color dividerColor;
  final Color placeholderColor;
  final Color background;

  final Color cursorColor;
  final Color prefixColor;

  final bool onlyTopRadius;
  final bool includeDivider;

  final double borderRadius;
  final double dividerWeight;
  final double leftPrefixGap;

  final Size dividerGap;
  final Size iconSize;

  final TextStyle contentStyle;

  FancyInputStyle({
    required this.padding,
    required this.borderRadius,
    required this.dividerGap,

    required this.dividerColor,
    required this.background,
    required this.underlineColor,
    required this.prefixColor,
    required this.dividerWeight,
    required this.leftPrefixGap,
    required this.cursorColor,

    required this.placeholderColor,
    required this.contentStyle,
    required this.iconSize,

    this.onlyTopRadius = true,
    this.includeDivider = true,
  });

  FancyInputStyle.android({
    this.padding = const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
    this.background = const Color(0xffF0F0F0),
    this.underlineColor = const Color.fromRGBO(38, 50, 56, 0.36),
    this.dividerColor = const Color(0xffBEBEBE),
    this.cursorColor = Colors.blue,

    this.placeholderColor = const Color(0xff868686),

    this.onlyTopRadius = true,
    this.includeDivider = true,
    this.borderRadius = 4,
    this.leftPrefixGap = 0,

    this.iconSize = const Size(14, 14),

    this.contentStyle = const TextStyle(
      color: Color(0xff333333),
      fontSize: 16,
      letterSpacing: 0.44
    ),
    this.prefixColor = const Color(0xff868686),

    this.dividerGap = const Size(12, 9),
    this.dividerWeight = 2
  });

  FancyInputStyle.iOS({
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    this.leftPrefixGap = 4,
    this.background = const Color(0xffF8F8F8),
    this.underlineColor = Colors.transparent,
    this.dividerColor = const Color(0xffBEBEBE),
    this.cursorColor = Colors.blue,

    this.onlyTopRadius = false,
    this.includeDivider = true,
    this.borderRadius = 18,

    this.placeholderColor = const Color(0xff868686),

    this.contentStyle = const TextStyle(
      color: Color(0xff333333),
      fontSize: 24,
      letterSpacing: 0.37,
      fontFamily: '.SF UI Display'
    ),
    this.prefixColor = const Color(0xff868686),

    this.iconSize = const Size(13.35, 13.35),

    this.dividerGap = const Size(12, 10),
    this.dividerWeight = 2
  });
}

class FancyInput extends StatefulWidget {
  final FocusNode? focusNode;
  final FancyInputStyle style;

  final Widget? prefix;
  final Widget? suffix;

  final bool autofocus;
  final bool autocorrect;

  final String? initialValue;
  final String? placeholder;

  final TextEditingController? controller;

  /* Input text formatters */
  final List<TextInputFormatter>? formatters;

  /* Input keyboard type */
  final TextInputType? keyboardType;

  /* Input callbacks */
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;

  final void Function()? onTap;
  final void Function()? onEditingComplete;

  final void Function()? onSuffixTap;
  final bool enableSuffixFeedback;

  final IconShowCondition suffixShowCondition;

  const FancyInput({
    Key? key,

    required this.style,

    this.prefix,
    this.suffix,

    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onSuffixTap,
    this.onTap,

    this.placeholder,

    this.formatters,
    this.keyboardType,

    this.controller,
    this.focusNode,
    this.initialValue,

    this.autocorrect = false,
    this.autofocus = false,
    this.enableSuffixFeedback = true,

    this.suffixShowCondition = IconShowCondition.focus
  }) : super(key: key);

  @override
  createState() => _FancyInput();
}


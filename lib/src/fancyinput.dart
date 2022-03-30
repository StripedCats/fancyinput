import 'package:flutter/material.dart';

enum FancyInputCondition {
  focused,
  alwaysShown
}

class _FancyInput extends State<FancyInput> {
  final node = FocusNode();
  late final TextEditingController controller;

  @override
  void initState() {
    controller = widget.controller ?? TextEditingController();

    super.initState();
  }

  Widget _buildPrefix() {
    if (widget.prefix == null) {
      return const SizedBox();
    }

    const divider = SizedBox(width: 12);
    final color = widget.prefixDividerColor ?? const Color(0xffBEBEBE);

    return Row(
      children: [
        widget.prefix!,
        divider,
        VerticalDivider(width: 0, color: color),
        divider,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Container(
        child: IntrinsicHeight(
          child: Row(
            children: [
              _buildPrefix(),

              Expanded(
                child: Padding(
                  child: TextField(
                    cursorColor: widget.cursorColor,

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

                    controller: controller,
                  ),

                  padding: EdgeInsets.symmetric(vertical: 6),
                ),
              ),

              Text("123"),
            ],
          ),
        ),
        decoration: BoxDecoration(

          border: Border(
            bottom: BorderSide(
              color: const Color(0xff263238).withOpacity(0.38),
            )
          )
        ),

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

  final double width;
  final bool autofocus;

  final TextEditingController? controller;

  final Widget? prefix;
  final Widget? suffix;

  final FancyInputCondition prefixShowCondition;
  final FancyInputCondition suffixShowCondition;

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

    this.prefixShowCondition = FancyInputCondition.alwaysShown,
    this.suffixShowCondition = FancyInputCondition.focused,
  }) : super(key: key);

  @override
  createState() => _FancyInput();
}

import 'package:flutter/material.dart';

extension TextFunctions on TextEditingController {
  void clear() {
    text = "";
    selection = TextSelection.fromPosition(const TextPosition(
        offset: 0));
  }
}

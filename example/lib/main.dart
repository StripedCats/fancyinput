import 'package:flutter/material.dart';
import 'package:fancyinput/fancyinput.dart';


class ExampleInput extends StatelessWidget {
  const ExampleInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FancyInput test"),
      ),

      body: const Padding(
        child: FancyInput(
          prefix: Text("+7"),
        ),

        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      ),
    );
  }
}


void main() {
  runApp(const MaterialApp(
    home: ExampleInput(),
  ));
}


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
      body: Padding(
        child: Column(
          children: const [
            FancyInput(
              prefix: Text("void"),
              suffix: Text("{}"),
            ),
            SizedBox(
              height: 16,
            ),
            FancyInput(
              prefix: Text("Rust"),
              suffix: Text("!"),
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ExampleInput(),
  ));
}
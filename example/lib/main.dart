import 'package:flutter/material.dart';
import 'package:fancyinput/fancyinput.dart';

void main() {
  runApp(MaterialApp(
    home: Example(),
  ));
}

class Example extends StatelessWidget {
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();

  Example({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FancyInput example"),
      ),
      body: Padding(
        child: Column(children: [
          FancyInput(
            style: FancyInputStyle.iOS(),
            prefix: const Text("+7"),
            suffix: const Icon(Icons.clear),
            controller: controller1,
            keyboardType: TextInputType.number,
            placeholder: "Hello iOS",
            autofocus: true,
          ),
          const SizedBox(height: 16),
          FancyInput(
            style: FancyInputStyle.android(),
            prefix: const Text("Test"),
            suffix: const Icon(Icons.clear),
            controller: controller2,
            placeholder: "Hello Android",
          )
        ]),
        padding: const EdgeInsets.all(16),
      ),
      backgroundColor: const Color(0xffFFFFFF),
    );
  }
}

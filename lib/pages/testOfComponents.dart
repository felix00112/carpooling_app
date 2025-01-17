import 'package:flutter/material.dart';
import 'package:carpooling_app/constants/button.dart';
import 'package:carpooling_app/constants/textField.dart';

class TestPage extends StatelessWidget {
  TestPage({super.key});

  final TextEditingController _inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TextField Widget
            CustomTextField(
              labelText: 'Enter your email',
              svgIconPath: 'assets/icons/user.svg',
              backgroundColor: Colors.grey[200]!,
              labelTextStyle: const TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Button to print input
            CustomButton(
              label: 'Submit',
              onPressed: () {
                final inputText = _inputController.text;
                if (inputText.isNotEmpty) {
                  print('Input: $inputText');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Submitted: $inputText')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter some text!')),
                  );
                }
              },
              color: Colors.blue,
              textColor: Colors.white,
              borderRadius: 12,
              height: 50,
            ),

            const SizedBox(height: 16),

            // Another button to clear the text
            CustomButton(
              label: 'Clear',
              onPressed: () {
                _inputController.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Input cleared')),
                );
              },
              color: Colors.red,
              textColor: Colors.white,
              borderRadius: 12,
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

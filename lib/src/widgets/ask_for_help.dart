import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AskAssistantButton extends StatelessWidget {
  final Function() onPressed;

  const AskAssistantButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60.0,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.help),
            ),
            Text('ask_assistant'.tr),
          ],
        ),
      ),
    );
  }
}

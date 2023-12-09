import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AskAssistantButton extends StatelessWidget {
  final Function() onPressed;

  const AskAssistantButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        'ask_assistant'.tr,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}

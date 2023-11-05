import 'package:flutter/material.dart';

class PlusButton extends StatelessWidget {
  final onPress;
  PlusButton({
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 75,
          width: 75,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade400,
          ),
          child: const Center(
            child: Text(
              '+',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        ),
      ),
    );
  }
}

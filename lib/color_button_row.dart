// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class ColorButtonsRow extends StatefulWidget {
  final String selectedColor;
  final Function(String) onColorSelected;

  const ColorButtonsRow({super.key, required this.selectedColor, required this.onColorSelected});

  @override
  _ColorButtonsRowState createState() => _ColorButtonsRowState();
}

class _ColorButtonsRowState extends State<ColorButtonsRow> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(width: 5),
          _buildColorButton('Black'),
          const SizedBox(width: 20), // Adjust the width between buttons as needed
          _buildColorButton('White'),
          const SizedBox(width: 20), // Adjust the width between buttons as needed
          _buildColorButton('Gray'),
          const SizedBox(width: 20), // Adjust the width between buttons as needed
          _buildColorButton('Green'),
          const SizedBox(width: 20), // Adjust the width between buttons as needed
          _buildColorButton('Blue'),
          const SizedBox(width: 20), // Adjust the width between buttons as needed
          _buildColorButton('Yellow'),
          const SizedBox(width: 20), // Adjust the width between buttons as needed
          _buildColorButton('Red'),
          const SizedBox(width: 5),
        ],
      ),
    );
  }

  Widget _buildColorButton(String colorOption) {
    bool isSelected = colorOption == widget.selectedColor;

    return GestureDetector(
      onTap: () => widget.onColorSelected(colorOption),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black),
        ),
        child: Text(
          colorOption,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ColorButtonsRow extends StatefulWidget {
  final String selectedColor;
  final Function(String) onColorSelected;

  const ColorButtonsRow({Key? key, required this.selectedColor, required this.onColorSelected}) : super(key: key);

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
          SizedBox(width: 5),
          _buildColorButton('Black'),
          SizedBox(width: 20), // Adjust the width between buttons as needed
          _buildColorButton('White'),
          SizedBox(width: 20), // Adjust the width between buttons as needed
          _buildColorButton('Gray'),
          SizedBox(width: 20), // Adjust the width between buttons as needed
          _buildColorButton('Green'),
          SizedBox(width: 20), // Adjust the width between buttons as needed
          _buildColorButton('Blue'),
          SizedBox(width: 20), // Adjust the width between buttons as needed
          _buildColorButton('Yellow'),
          SizedBox(width: 20), // Adjust the width between buttons as needed
          _buildColorButton('Red'),
          SizedBox(width: 5),
        ],
      ),
    );
  }

  Widget _buildColorButton(String colorOption) {
    bool isSelected = colorOption == widget.selectedColor;

    return GestureDetector(
      onTap: () => widget.onColorSelected(colorOption),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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

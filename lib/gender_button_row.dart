import 'package:flutter/material.dart';

class GenderButtonsRow extends StatefulWidget {
  final String selectedGender;
  final Function(String) onGenderSelected;

  const GenderButtonsRow({Key? key, required this.selectedGender, required this.onGenderSelected}) : super(key: key);

  @override
  _GenderButtonsRowState createState() => _GenderButtonsRowState();
}

class _GenderButtonsRowState extends State<GenderButtonsRow> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(width: 5),
          _buildGenderButton('man'),
          SizedBox(width: 20), // Adjust the width between buttons as needed
          _buildGenderButton('woman'),
          SizedBox(width: 20), // Adjust the width between buttons as needed
          _buildGenderButton('unisex'),
          SizedBox(width: 5),
        ],
      ),
    );
  }

  Widget _buildGenderButton(String genderOption) {
    bool isSelected = genderOption == widget.selectedGender;

    return GestureDetector(
      onTap: () => widget.onGenderSelected(genderOption),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black),
        ),
        child: Text(
          genderOption,
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

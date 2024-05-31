import 'package:flutter/material.dart';

class GenderButtonsRow extends StatefulWidget {
  final String selectedGender;
  final Function(String) onGenderSelected;

  const GenderButtonsRow({super.key, required this.selectedGender, required this.onGenderSelected});

  @override
  // ignore: library_private_types_in_public_api
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
          const SizedBox(width: 5),
          _buildGenderButton('man'),
          const SizedBox(width: 20), // Adjust the width between buttons as needed
          _buildGenderButton('woman'),
          const SizedBox(width: 20), // Adjust the width between buttons as needed
          _buildGenderButton('unisex'),
          const SizedBox(width: 5),
        ],
      ),
    );
  }

  Widget _buildGenderButton(String genderOption) {
    bool isSelected = genderOption == widget.selectedGender;

    return GestureDetector(
      onTap: () => widget.onGenderSelected(genderOption),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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

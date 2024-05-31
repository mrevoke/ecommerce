// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class SortButtonsRow extends StatefulWidget {
  final String selectedSort;
  final Function(String) onSortSelected;

  const SortButtonsRow({super.key, required this.selectedSort, required this.onSortSelected});

  @override
  _SortButtonsRowState createState() => _SortButtonsRowState();
}

class _SortButtonsRowState extends State<SortButtonsRow> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
           const SizedBox(width: 5),
          _buildSortButton('Ratings'),
          const SizedBox(width: 20), // Adjust the width between buttons as needed
          _buildSortButton('Highest Prices'),
          const SizedBox(width: 20), // Adjust the width between buttons as needed
          _buildSortButton('Lower Price'),
           const SizedBox(width: 5),
        ],
      ),
    );
  }

  Widget _buildSortButton(String sortOption) {
    bool isSelected = sortOption == widget.selectedSort;

    return GestureDetector(
      onTap: () => widget.onSortSelected(sortOption),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black),
        ),
        child: Text(
          sortOption,
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

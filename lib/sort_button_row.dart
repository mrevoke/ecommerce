import 'package:flutter/material.dart';

class SortButtonsRow extends StatefulWidget {
  final String selectedSort;
  final Function(String) onSortSelected;

  const SortButtonsRow({Key? key, required this.selectedSort, required this.onSortSelected}) : super(key: key);

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
           SizedBox(width: 5),
          _buildSortButton('Ratings'),
          SizedBox(width: 20), // Adjust the width between buttons as needed
          _buildSortButton('Highest Prices'),
          SizedBox(width: 20), // Adjust the width between buttons as needed
          _buildSortButton('Lower Price'),
           SizedBox(width: 5),
        ],
      ),
    );
  }

  Widget _buildSortButton(String sortOption) {
    bool isSelected = sortOption == widget.selectedSort;

    return GestureDetector(
      onTap: () => widget.onSortSelected(sortOption),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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

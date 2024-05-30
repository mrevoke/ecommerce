import 'package:flutter/material.dart';

class SortButtonsRow extends StatelessWidget {
  final String selectedSort;
  final Function(String) onSortSelected;

  const SortButtonsRow({Key? key, required this.selectedSort, required this.onSortSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSortButton('Ratings', selectedSort, onSortSelected),
        _buildSortButton('Highest Prices', selectedSort, onSortSelected),
        _buildSortButton('Lower Price', selectedSort, onSortSelected),
      ],
    );
  }

  Widget _buildSortButton(String sortOption, String selectedSort, Function(String) onSortSelected) {
    bool isSelected = sortOption == selectedSort;

    return GestureDetector(
      onTap: () => onSortSelected(sortOption),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,border: Border.all(width: 1),
              color: isSelected ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(255, 255, 255, 255).withOpacity(0.3),
            ),
            child: Center(
              child: Text(
                sortOption.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            sortOption,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

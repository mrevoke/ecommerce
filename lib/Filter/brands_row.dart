import 'package:flutter/material.dart';

class BrandsRow extends StatelessWidget {
  final String selectedBrand;
  final Function(String) onBrandSelected;

  const BrandsRow({super.key, required this.selectedBrand, required this.onBrandSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildBrandOption('All', selectedBrand, onBrandSelected),
        _buildBrandOption('Nike', selectedBrand, onBrandSelected),
        _buildBrandOption('Adidas', selectedBrand, onBrandSelected),
        _buildBrandOption('Jordan', selectedBrand, onBrandSelected),
      ],
    );
  }

  Widget _buildBrandOption(String brand, String selectedBrand, Function(String) onBrandSelected) {
    String brandInitial = brand.substring(0, 1).toUpperCase();
    bool isSelected = brand == selectedBrand;

    return GestureDetector(
      onTap: () => onBrandSelected(brand),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.black : Colors.grey.withOpacity(0.3),
            ),
            child: Center(
              child: Text(
                brandInitial,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            brand,
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

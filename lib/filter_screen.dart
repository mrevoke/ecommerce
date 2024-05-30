import 'package:ecommerce/sort_button_row.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'brands_row.dart';
import 'price_range_row.dart'; // Import SortButtonsRow widget

class FilterScreen extends StatefulWidget {
  final Function(String, RangeValues,String) onFilterApplied;

  const FilterScreen({Key? key, required this.onFilterApplied}) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String _selectedBrand = 'All';
  RangeValues _priceRange = const RangeValues(0, 1000);
  late SharedPreferences _prefs;
  String _selectedSort = ''; // Define _selectedSort variable

  @override
  void initState() {
    super.initState();
    _loadFilters();
  }

  Future<void> _loadFilters() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedBrand = _prefs.getString('selectedBrand') ?? 'All';
      double start = _prefs.getDouble('priceStart') ?? 0;
      double end = _prefs.getDouble('priceEnd') ?? 1000;
      _priceRange = RangeValues(start, end);
      _selectedSort = _prefs.getString('selectedSort') ?? ''; // Load selected sort option
    });
  }

  Future<void> _saveFilters() async {
    await _prefs.setString('selectedBrand', _selectedBrand);
    await _prefs.setDouble('priceStart', _priceRange.start);
    await _prefs.setDouble('priceEnd', _priceRange.end);
    await _prefs.setString('selectedSort', _selectedSort); // Save selected sort option
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 50.0, right: 16, left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        _saveFilters();
                        Navigator.pop(context);
                      },
                    ),
                    const Spacer(),
                    const Text(
                      "Filter",
                      style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w400),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.shopping_bag_outlined),
                      onPressed: () {
                        // Handle shopping bag button press
                      },
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 20),
                  child: Text(
                    "Brands",
                    style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(height: 10),
                BrandsRow(selectedBrand: _selectedBrand, onBrandSelected: _onBrandSelected),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 20),
                  child: Text(
                    "Price Range",
                    style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(height: 20),
                PriceRangeRow(priceRange: _priceRange, onRangeChanged: _onRangeChanged),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 20),
                  child: Text(
                    "Sort By",
                    style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    SortButtonsRow(
                      selectedSort: _selectedSort,
                      onSortSelected: _handleSortButtonPressed,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _saveFilters();
                    widget.onFilterApplied(_selectedBrand, _priceRange,_selectedSort);
                  },
                  child: const Text('Apply Filter'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onBrandSelected(String brand) {
    setState(() {
      _selectedBrand = brand;
    });
    _saveFilters();
  }

  void _onRangeChanged(RangeValues values) {
    setState(() {
      _priceRange = values;
    });
    _saveFilters();
  }

  void _handleSortButtonPressed(String buttonText) {
    setState(() {
      _selectedSort = buttonText; // Update _selectedSort with the pressed button text
    });
    _saveFilters();
  }
}

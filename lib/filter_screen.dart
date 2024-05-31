// ignore_for_file: use_super_parameters, library_private_types_in_public_api, unnecessary_const

import 'package:ecommerce/cart_page.dart';
import 'package:ecommerce/color_button_row.dart';
import 'package:ecommerce/gender_button_row.dart';
import 'package:ecommerce/sort_button_row.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'brands_row.dart';
import 'price_range_row.dart';

class FilterScreen extends StatefulWidget {
  final Function(String, RangeValues, String, String, String) onFilterApplied;

  const FilterScreen({Key? key, required this.onFilterApplied}) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String _selectedBrand = 'All';
  RangeValues _priceRange = const RangeValues(0, 1000);
  late SharedPreferences _prefs;
  String _selectedSort = '';
  String _selectedGender = '';
  String _selectedColor = '';

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
      _selectedSort = _prefs.getString('selectedSort') ?? '';
      _selectedGender = _prefs.getString('selectedGender') ?? '';
      _selectedColor = _prefs.getString('selectedColor') ?? '';
    });
  }

  Future<void> _saveFilters() async {
    await _prefs.setString('selectedBrand', _selectedBrand);
    await _prefs.setDouble('priceStart', _priceRange.start);
    await _prefs.setDouble('priceEnd', _priceRange.end);
    await _prefs.setString('selectedSort', _selectedSort);
    await _prefs.setString('selectedGender', _selectedGender);
    await _prefs.setString('selectedColor', _selectedColor);
  }

  Future<void> _resetFilters() async {
    setState(() {
      _selectedBrand = 'All';
      _priceRange = const RangeValues(0, 1000);
      _selectedSort = 'Ratings';
      _selectedGender = 'All';
      _selectedColor = 'All';
    });
    await _saveFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CartPage()));

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
                BrandsRow(
                  selectedBrand: _selectedBrand,
                  onBrandSelected: _onBrandSelected,
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 20),
                  child: Text(
                    "Price Range",
                    style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(height: 20),
                PriceRangeRow(
                  priceRange: _priceRange,
                  onRangeChanged: _onRangeChanged,
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 20),
                  child: Text(
                    "Sort By",
                    style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SortButtonsRow(
                      selectedSort: _selectedSort,
                      onSortSelected: _handleSortButtonPressed,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 20),
                  child: Text(
                    "Gender",
                    style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: GenderButtonsRow(
                      selectedGender: _selectedGender,
                      onGenderSelected: _handleGenderButtonPressed,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 20),
                  child: Text(
                    "Color",
                    style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ColorButtonsRow(
                      selectedColor: _selectedColor,
                      onColorSelected: _handleColorButtonPressed,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(153, 223, 222, 222),
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
           
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.width * 0.15,
              child: ElevatedButton(
                onPressed: _resetFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                    side: const BorderSide(color: Colors.black),
                  ),
                ),
                child: const Text(
                  'Reset',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
             SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.width * 0.15,
              child: ElevatedButton(
                onPressed: () {
                  widget.onFilterApplied(
                    _selectedBrand,
                    _priceRange,
                    _selectedSort,
                    _selectedGender,
                    _selectedColor,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
          ],
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
      _selectedSort = buttonText;
    });
    _saveFilters();
  }

  void _handleGenderButtonPressed(String buttonText) {
    setState(() {
      _selectedGender = buttonText;
    });
    _saveFilters();
  }

  void _handleColorButtonPressed(String buttonText) {
    setState(() {
      _selectedColor = buttonText;
    });
    _saveFilters();
  }
}

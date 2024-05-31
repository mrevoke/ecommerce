import 'package:ecommerce/cart_page.dart';
import 'package:ecommerce/shoe_detail_file.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'shoe_card.dart';
import 'filter_screen.dart'; // Import the new ShoeDetailPage

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _shoes = [];
  String _selectedCategory = 'All';
  RangeValues _selectedPriceRange = RangeValues(0, 1000);
  String _selectedSort = 'Ratings';
  String _selectedGender = 'All';
  String _selectedColor = 'All';

  @override
  void initState() {
    super.initState();
    _fetchShoesDetails(); // Fetching shoe details
  }

  Future<void> _fetchShoesDetails() async {
    DatabaseReference ref = FirebaseDatabase.instance.reference().child('shoes');
    try {
      DataSnapshot snapshot = await ref.get();
      if (snapshot.value != null) {
        var shoesData = snapshot.value as Map<dynamic, dynamic>;
        for (var key in shoesData.keys) {
          var shoeData = shoesData[key] as Map<dynamic, dynamic>;

          for (var i = 1; shoeData['photo_urls'].containsKey('img$i'); i++) {
            String imageUrl = shoeData['photo_urls']['img$i'];
            Image? shoeImage = await _fetchImage(imageUrl);

            setState(() {
              _shoes.add({
                'imageUrl':imageUrl,
                'name': shoeData['name'] ?? '',
                'price': shoeData['price'] ?? 0,
                'gender': shoeData['gender'] ?? '',
                'rating': shoeData['rating'] ?? 0,
                'num_reviews': shoeData['num_reviews'] ?? 0,
                'image': shoeImage,
                'brand': shoeData['brand'] ?? '',
                'colors': shoeData['colors'],
                'available_sizes': shoeData['available_sizes'],
                'description':shoeData['description'],
                'reviews':shoeData['reviews'],
              });
            });
          }
        }
      }
    } catch (e) {
      print('Failed to fetch shoes details: $e');
    }
  }

  Future<Image?> _fetchImage(String imageUrl) async {
    try {
      http.Response response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return Image.memory(response.bodyBytes);
      } else {
        print('Failed to load image: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Failed to load image: $e');
      return null;
    }
  }

  List<Map<String, dynamic>> _getFilteredShoes() {
    var filteredShoes = _shoes.where((shoe) {
      final matchesCategory = _selectedCategory == 'All' || shoe['brand'] == _selectedCategory;
      final matchesPriceRange = shoe['price'] >= _selectedPriceRange.start && shoe['price'] <= _selectedPriceRange.end;

      // Check if the shoe colors contain the selected color
      final matchesColor = _selectedColor == 'All' || (shoe['colors']?.contains(_selectedColor) ?? false);

      final matchesGender = _selectedGender == 'All' || (shoe['gender'] == _selectedGender);

      return matchesCategory && matchesPriceRange && matchesColor && matchesGender;
    }).toList();

    if (_selectedSort == 'Ratings') {
      filteredShoes.sort((a, b) => b['rating'].compareTo(a['rating']));
    } else if (_selectedSort == 'Highest Prices') {
      filteredShoes.sort((a, b) => b['price'].compareTo(a['price']));
    } else if (_selectedSort == 'Lower Price') {
      filteredShoes.sort((a, b) => a['price'].compareTo(b['price']));
    }

    return filteredShoes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Discover',
                        style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.shopping_bag_outlined),
                        onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartPage()));

                          // Handle shopping bag button press
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCategoryButton('All'),
                    _buildCategoryButton('Nike'),
                    _buildCategoryButton('Adidas'),
                    _buildCategoryButton('Jordan'),
                  ],
                ),
                Expanded(
                  child: _shoes.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8.0,
                              crossAxisSpacing: 8.0,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: _getFilteredShoes().length,
                            itemBuilder: (context, index) {
                              var shoe = _getFilteredShoes()[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ShoeDetailPage(shoe: shoe),
                                    ),
                                  );
                                },
                                child: ShoeCard(
                                  shoeName: shoe['name'],
                                  shoePrice: shoe['price'],
                                  shoeGender: shoe['gender'],
                                  shoeRating: shoe['rating'],
                                  reviewCount: shoe['num_reviews'],
                                  firstImage: shoe['image'],
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
            Positioned(
              bottom: 16.0,
              left: 0,
              right: 0,
              child: Center(
                child: FloatingActionButton.extended(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return FilterScreen(
                          onFilterApplied: (selectedBrand, selectedPriceRange, selectedSort, selectedGender, selectedColor) {
                            setState(() {
                              _selectedCategory = selectedBrand;
                              _selectedPriceRange = selectedPriceRange;
                              _selectedSort = selectedSort;
                              _selectedGender = selectedGender;
                              _selectedColor = selectedColor;
                            });
                            Navigator.pop(context); // Close the modal
                          },
                        );
                      },
                    );
                  },
                  label: const Text(
                    'Filter',
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: const Icon(
                    Icons.filter_list,
                    color: Colors.white,
                  ),
                  backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    final isSelected = category == _selectedCategory;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.grey,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

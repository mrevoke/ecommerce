// shoe_detail_page.dart

// ignore_for_file: deprecated_member_use

import 'package:ecommerce/Cart/cart_page.dart';
import 'package:ecommerce/Reviews/all_review_page.dart';
import 'package:ecommerce/Shoe_detail/color_button_widget.dart';
import 'package:ecommerce/Shoe_detail/review_widget.dart';
import 'package:ecommerce/Shoe_detail/size_button_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ShoeDetailPage extends StatefulWidget {
  final Map<String, dynamic> shoe;

  const ShoeDetailPage({super.key, required this.shoe});

  @override
  // ignore: library_private_types_in_public_api
  _ShoeDetailPageState createState() => _ShoeDetailPageState();
}

class _ShoeDetailPageState extends State<ShoeDetailPage> {
  int? _selectedSize;
  int _quantity = 1; // Initial quantity

  // Predefined list of colors
  static const List<String> predefinedColors = [
    'Black',
    'White',
    'Gray',
    'Green',
    'Blue',
    'Yellow',
    'Red',
  ];
  static const List<int> predefinedSizes = [7, 8, 9, 10, 11];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CartPage()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: widget.shoe['image'] ?? Container(), // Display the shoe image
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Wrap(
                    children: [
                      for (var colorName in predefinedColors)
                        ColorButton(
                          colorName: colorName,
                          isSelected: widget.shoe['selected_color'] == colorName,
                          onTap: () {
                            setState(() {
                              widget.shoe['selected_color'] = colorName;
                            });
                          },
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                widget.shoe['name'],
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Rating(
                    rating: widget.shoe['rating'],
                  ),
                  const SizedBox(width: 5),
                  Text(
                    widget.shoe['rating'].toString(),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '(${widget.shoe['num_reviews']} reviews)',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Size',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Wrap(
                    children: [
                      for (var shoesize in predefinedSizes)
                        SizeButton(
                          size: shoesize,
                          isSelected: _selectedSize == shoesize,
                          onTap: () {
                            setState(() {
                              _selectedSize = shoesize;
                            });
                          },
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Description',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                widget.shoe['description'],
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Text(
                'Reviews (${widget.shoe['num_reviews']})',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ReviewWidget(reviews: widget.shoe['reviews']),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllReviewsPage(reviews: widget.shoe['reviews']),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(color: Colors.black),
                    ),
                  ),
                  child: const Text(
                    'SEE ALL REVIEWS',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(77, 199, 199, 199),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Price',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Text(
                    '\$${widget.shoe['price']}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
              _buildAddToCartButton(context)
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton _buildAddToCartButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _showAddToCartDialog(context);
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: const Text(
        'ADD TO CART',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  void _showAddToCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: double.maxFinite,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Text(
                      'Add to cart',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: _quantity.toString(),
                  onChanged: (value) {
                    setState(() {
                      _quantity = int.tryParse(value) ?? 1;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Price',
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        Text(
                          '\$${widget.shoe['price']}',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_selectedSize != null) {
                          FirebaseDatabase.instance
                              .reference()
                              .child('cart')
                              .push()
                              .set({
                            'shoe': widget.shoe['name'],
                            'size': _selectedSize,
                            'quantity': _quantity,
                            'price': widget.shoe['price'] * _quantity,
                          }).then((_) {
                            Navigator.of(context).pop();
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please select a size.')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'ADD TO CART',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

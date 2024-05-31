// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, avoid_print, deprecated_member_use

import 'package:ecommerce/all_review_page.dart';
import 'package:ecommerce/cart_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ShoeDetailPage extends StatefulWidget {
  final Map<String, dynamic> shoe;

  const ShoeDetailPage({super.key, required this.shoe});

  @override
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
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartPage()));

              // Handle shopping bag button press
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
                        _buildColorButton(colorName),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                widget.shoe['name'],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Rating(
                    rating: widget.shoe['rating'],
                  ),
                  SizedBox(width: 5),
                  Text(
                    widget.shoe['rating'].toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(width: 5),
                  Text(
                    '(${widget.shoe['num_reviews']} reviews)',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Size',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Wrap(
                    children: [
                      for (var shoesize in predefinedSizes)
                        _buildSizeButton(shoesize),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Description',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                widget.shoe['description'],
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                'Reviews (${widget.shoe['num_reviews']})',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildReviewCards(),
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
                    foregroundColor: Color.fromARGB(255, 0, 0, 0),
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(color: Colors.black),
                    ),
                  ),
                  child: Text(
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
                  Text(
                    'Price',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Text(
                    '\$${widget.shoe['price']}',
                    style: TextStyle(fontSize: 20),
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
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
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
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    'Add to cart',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                initialValue: _quantity.toString(),
                onChanged: (value) {
                  setState(() {
                    _quantity = int.tryParse(value) ?? 1;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Price',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      Text(
                        '\$${widget.shoe['price']}',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_selectedSize == null) {
                        _showErrorDialog(context, "Size not chosen");
                        return;
                      }

                      if (widget.shoe['selected_color'] == null) {
                        _showErrorDialog(context, "Color not chosen");
                        return;
                      }

                      // Construct the cart item
                      Map<String, dynamic> cartItem = {
                        'name': widget.shoe['name'],
                        'price': widget.shoe['price'],
                        'quantity': _quantity,
                        'size': _selectedSize,
                        'color': widget.shoe['selected_color'],
                        'image': widget.shoe['imageUrl'],
                        'brand':widget.shoe['brand']
                        // Add any additional properties if needed
                      };

                      // Get a reference to the 'cart' node in the database
                      DatabaseReference cartRef = FirebaseDatabase.instance.reference().child('cart');

                      // Push the cart item data to the database
                      cartRef.push().set(cartItem).then((_) {
                        print("Added item to cart");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added to cart')),
                        );
                        
      
                        Navigator.of(context).pop();
                        _showSuccessDialog(context); // Close the dialog
                      }).catchError((error) {
                        print("Error adding item to cart: $error");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to add to cart')),
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
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

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(backgroundColor: Colors.white,
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSizeButton(int size) {
    bool isSelected = _selectedSize == size;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedSize = size;
          });
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? Colors.black : Colors.white,
            border: Border.all(color: Colors.black),
          ),
          child: Center(
            child: Text(
              '$size',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
 void _showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.maxFinite,
                
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black),
                  ),
                ),
                Icon(
                  Icons.check_circle_outline_outlined,
                  size: 200,
                  color: Colors.black,
                ),
              ],
            ),
            SizedBox(height: 5),
            Text(
              "Added to Cart",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
             SizedBox(height: 20),
           
            Text("$_quantity items Total")
          ],
        ),
      actions: [
  Row(
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ButtonStyle(
            side: WidgetStateProperty.all<BorderSide>(
              BorderSide(color: Colors.black),
            ),
          ),
          child: Text(
            "BACK EXPLORE",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      Spacer(),
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: TextButton(
          onPressed: () {
                  // Close the current dialog
      Navigator.of(context).pop();
      // Navigate to the cart page
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartPage()));
 
            // Navigate to cart page
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
          ),
          child: Text(
            " GO TO CART ",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ],
  ),
],


      );
    },
  );
}




  Widget _buildColorButton(String colorName) {
    bool isSelected = widget.shoe['selected_color'] == colorName;

    if (widget.shoe['colors'].contains(colorName)) {
      return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SizedBox(
              width: 26, // Adjust the width to match the size of the stars
              height: 26, // Adjust the height to match the size of the stars
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.shoe['selected_color'] = colorName;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getColor(colorName), // Get color for the button
                  padding: EdgeInsets.zero, // Remove padding to make button fit snugly around content
                  shape: CircleBorder(),
                ),
                child: SizedBox.shrink(),
              ),
            ),
          ),
          if (isSelected && colorName == "White")
            Positioned(
              top: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.check,
                  color: const Color.fromARGB(255, 0, 0, 0),
                  size: 24,
                ),
              ),
            ),
          if (isSelected && colorName != "White")
            Positioned(
              top: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
        ],
      );
    } else {
      // If the color is not available for the shoe, return a gray circle as an indication
      return SizedBox(
        width: 0,
        height: 0,
      );
    }
  }

  Color _getColor(String colorName) {
    switch (colorName) {
      case 'Black':
        return Colors.black;
      case 'White':
        return Colors.white;
      case 'Gray':
        return Colors.grey;
      case 'Green':
        return Colors.green;
      case 'Blue':
        return Colors.blue;
      case 'Yellow':
        return Colors.yellow;
      case 'Red':
        return Colors.red;
      default:
        return Colors.black; // Default color
    }
  }

  Widget _buildReviewCards() {
    List<Widget> reviewCards = [];
    if (widget.shoe['reviews'] != null) {
      // Only display the first review initially
      var reviewId = widget.shoe['reviews'].keys.first;
      var review = widget.shoe['reviews'][reviewId];
      
      reviewCards.add(
        Card(
          color: Colors.white,
          elevation: 0,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 27,
              backgroundColor: Colors.grey,
              child: Icon(Icons.account_circle),
            ),
            title: Row(
              children: [
                Text(
                  review['user'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(review['date']),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Rating(rating: review['rating'].toDouble()),
                SizedBox(height: 5),
                Text(review['review_text']),
                SizedBox(height: 5),
              ],
            ),
          ),
        ),
      );
    }
    return Column(
      children: reviewCards,
    );
  }
}

class Rating extends StatelessWidget {
  final double rating;

  const Rating({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    int numberOfStars = rating.floor(); // Get the integer part of the rating
    bool hasHalfStar =
        rating - numberOfStars >= 0.5; // Check if there's a half star

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) {
          if (index < numberOfStars) {
            return Icon(
              Icons.star,
              color: Colors.amber,
            );
          } else if (hasHalfStar && index == numberOfStars) {
            return Icon(
              Icons.star_half,
              color: Colors.amber,
            );
          } else {
            return Icon(
              Icons.star_border,
              color: Colors.amber,
            );
          }
        },
      ),
    );
  }
}

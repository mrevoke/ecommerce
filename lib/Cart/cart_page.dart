// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:ecommerce/Checkoutpage/checkout_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> _cartItems = []; // Placeholder for cart items
  final Map<String, String> _itemIds = {}; // Map to store item IDs

  @override
  void initState() {
    super.initState();
    _fetchCartData();
  }

  Future<void> _fetchCartData() async {
  final response = await http.get(Uri.parse(
      'https://ecommerce-3ea9f-default-rtdb.firebaseio.com/cart.json'));

  print("Response status code: ${response.statusCode}"); // Debug print

  if (response.statusCode == 200) {
    final Map<String, dynamic>? data = jsonDecode(response.body);
    print("Response body: $data"); // Debug print

    if (data != null) {
      setState(() {
        _cartItems = data.entries.map((entry) {
          final Map<String, dynamic> item = entry.value;
          _itemIds[entry.value['name']] = entry.key; 
          return item;
        }).toList();
      });
    } else {
      print("No data available");
    }
  } else {
    throw Exception('Failed to fetch cart data');
  }
}

  @override
  Widget build(BuildContext context) {
    double totalCost = _calculateTotalCost();

    return Scaffold(
      drawerScrimColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(color: Colors.black), // Optional: To set the title color
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white, // Set background color to white
      body: _cartItems.isEmpty
          ? const Center(
              child: Text('Your cart is empty'),
            )
          : ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                return _buildCartItemCard(_cartItems[index]);
              },
            ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(border: Border(top: BorderSide())),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Grand Total:',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 4), // Adding some space between the two text widgets
                Text(
                  '\$${totalCost.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 8), // Adding some space between the total cost and the button
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Implement navigation to the checkout page
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CheckoutPage()));
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.black),
                foregroundColor: WidgetStateProperty.all(Colors.white),
              ),
              child: const Text(
                'CHECK OUT',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItemCard(Map<String, dynamic> item) {
    int quantity = item['quantity'] ?? 0; // Get quantity value

    return Dismissible(
      key: UniqueKey(), // Ensures each Dismissible has a unique key
      direction: DismissDirection.endToStart, // Allow swipe from right to left
      onDismissed: (direction) {
        // Remove the item from the list when dismissed
        setState(() {
          _cartItems.remove(item);
        });

        // Make an HTTP DELETE request to delete the item from the database
        _deleteItemFromDatabase(item);
      },
      background: Container(
        color: const Color.fromARGB(255, 223, 121, 113),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
        ),
      ),
      child: Card(
        color: Colors.white,
        elevation: 0, // Remove elevation
        margin: const EdgeInsets.symmetric(
            vertical: 12.0, horizontal: 16.0), // Adjust margin
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
              vertical: 8.0, horizontal: 16.0), // Adjust padding
          leading: Container(
            width: 100, // Adjust width
            height: 100, // Adjust height
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0), // Adjust border radius
              image: DecorationImage(
                image: NetworkImage(item['image']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4.0),
              Text(
                '${item['brand']}, ${item['color']}, ${item['size']}',
                style: const TextStyle(
                    fontSize: 14.0, color: Colors.grey), // Adjust font size
              ),
            ],
          ),
          subtitle: Row(
            children: [
              Text(
                '\$${(item['price'] ?? 0).toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16.0), // Adjust font size
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () {
                  if (quantity > 0) {
                    setState(() {
                      quantity--;
                      _updateItemQuantity(
                          item, quantity); // Update quantity in _cartItems list
                    });
                  }
                },
              ),
              Text(
                '$quantity',
                style: const TextStyle(fontSize: 16.0), // Adjust font size
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {
                  setState(() {
                    quantity++;
                    _updateItemQuantity(
                        item, quantity); // Update quantity in _cartItems list
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateTotalCost() {
    double total = 0;
    for (var item in _cartItems) {
      total += (item['price'] ?? 0) * (item['quantity'] ?? 0);
    }
    return total;
  }

  Future<void> _deleteItemFromDatabase(Map<String, dynamic> item) async {
    final itemId = _itemIds[item['name']]; // Get the Firebase key of the item

    try {
      final response = await http.delete(
        Uri.parse(
            'https://ecommerce-3ea9f-default-rtdb.firebaseio.com/cart/$itemId.json'),
      );

      if (response.statusCode == 200) {
        print('Item deleted successfully from the database.');
      } else {
        print('Failed to delete item from the database.');
      }
    } catch (error) {
      print('Error deleting item from the database: $error');
    }
  }

  Future<void> _updateItemQuantity(Map<String, dynamic> item, int quantity) async {
    final itemId = _itemIds[item['name']]; // Get the Firebase key of the item

    try {
      final response = await http.patch(
        Uri.parse(
            'https://ecommerce-3ea9f-default-rtdb.firebaseio.com/cart/$itemId.json'),
        body: jsonEncode({'quantity': quantity}),
      );

      if (response.statusCode == 200) {
        setState(() {
          item['quantity'] = quantity; // Update local state
        });
        print('Item quantity updated successfully.');
      } else {
        print('Failed to update item quantity.');
      }
    } catch (error) {
      print('Error updating item quantity: $error');
    }
  }
}
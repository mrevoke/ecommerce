import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  List<Map<String, dynamic>> _cartItems = []; // Placeholder for cart items

  @override
  void initState() {
    super.initState();
    _fetchCartData();
  }

  Future<void> _fetchCartData() async {
    final response = await http.get(Uri.parse(
        'https://ecommerce-3ea9f-default-rtdb.firebaseio.com/cart.json'));

    if (response.statusCode == 200) {
      final Map<String, dynamic>? data = jsonDecode(response.body);
      if (data != null) {
        setState(() {
          _cartItems = data.values
              .map<Map<String, dynamic>>(
                  (value) => value as Map<String, dynamic>)
              .toList();
        });
      }
    } else {
      throw Exception('Failed to fetch cart data');
    }
  }

  Future<void> _placeOrder() async {
    final response = await http.post(
      Uri.parse('https://ecommerce-3ea9f-default-rtdb.firebaseio.com/orders.json'),
      body: jsonEncode(_cartItems),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placed successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to place order. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double subtotal = _calculateSubtotal();
    double shippingCost = 20;
    double grandTotal = subtotal + shippingCost;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: _cartItems.isEmpty
          ? const Center(
              child: Text('Your cart is empty'),
            )
          : ListView.builder(
              itemCount: _cartItems.length +
                  5, // Adding 4 for Information, Order Details, Subtotal, and Delivery
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Information section
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Information',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Payment Method',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          Text(
                            'CREDIT CARD',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
                          Divider(thickness: 0.5),
                          Text(
                            'Location',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          Text(
                            'INDIA',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (index == 1) {
                  // Order Details section
                  return const Padding(
                    padding:
                        EdgeInsets.only(left: 26.0, right: 16, bottom: 5),
                    child: Text(
                      'Order Details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                } else if (index == _cartItems.length + 2) {
                  // Payment Detail section
                  return ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Payment Detail",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 24),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              const Text(
                                'Sub Total',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '\$${subtotal.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (index == _cartItems.length + 3) {
                  // Shipping section
                  return ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Row(
                        children: [
                          const Text(
                            'Shipping ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '\$${shippingCost.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (index == _cartItems.length + 4) {
                  // Total Order section
                  return ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10, bottom: 20),
                      child: Column(
                        children: [
                          const Divider(
                            thickness: 0.5,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              const Text(
                                'Total Order ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '\$${grandTotal.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  // Cart item card
                  final item = _cartItems[index - 2];
                  return _buildCartItemCard(item);
                }
              },
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Grand Total',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
               
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${grandTotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _placeOrder,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'PAYMENT',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItemCard(Map<String, dynamic> item) {
    int quantity = item['quantity'] ?? 0; // Get quantity value

    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: .0, horizontal: 16.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4.0),
            Row(
              children: [
                Text(
                  '${item['brand']}, ${item['color']}, ${item['size']}, Qty$quantity',
                  style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
                const Spacer(),
                Text(
                  '\$${item['price'].toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _calculateSubtotal() {
    double subtotal = 0;
    for (var item in _cartItems) {
      subtotal += item['price'] * item['quantity'];
    }
    return subtotal;
  }
}

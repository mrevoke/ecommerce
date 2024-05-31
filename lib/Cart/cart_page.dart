// ignore_for_file: library_private_types_in_public_api

import 'package:ecommerce/Cart/car_item_card.dart';
import 'package:ecommerce/Cart/cart_service.dart';
import 'package:ecommerce/Checkoutpage/checkout_page.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> _cartItems = [];
  final Map<String, String> _itemIds = {};

  @override
  void initState() {
    super.initState();
    _fetchCartData();
  }

  Future<void> _fetchCartData() async {
    final data = await CartService.fetchCartData();

    setState(() {
      _cartItems = data['cartItems'];
      _itemIds.addAll(data['itemIds']);
    });
  }

  double _calculateTotalCost() {
    double total = 0;
    for (var item in _cartItems) {
      total += (item['price'] ?? 0) * (item['quantity'] ?? 0);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    double totalCost = _calculateTotalCost();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: _cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                return CartItemCard(
                  item: _cartItems[index],
                  onDelete: () => setState(() {
                    _cartItems.removeAt(index);
                  }),
                  onUpdate: (updatedItem) => setState(() {
                    _cartItems[index] = updatedItem;
                  }),
                );
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
                const Text('Grand Total:', style: TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  '\$${totalCost.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 8),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CheckoutPage()));
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.black),
                foregroundColor: WidgetStateProperty.all(Colors.white),
              ),
              child: const Text('CHECK OUT', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

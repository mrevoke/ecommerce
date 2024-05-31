// ignore_for_file: library_private_types_in_public_api

import 'package:ecommerce/Cart/cart_page.dart';
import 'package:flutter/material.dart';

class AllReviewsPage extends StatefulWidget {
  final dynamic reviews;

  const AllReviewsPage({super.key, required this.reviews});

  @override
  _AllReviewsPageState createState() => _AllReviewsPageState();
}

class _AllReviewsPageState extends State<AllReviewsPage> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
    drawerScrimColor: Colors.white,
      appBar: AppBar(
  backgroundColor: Colors.white,
  actions: [
    IconButton(
      icon: const Icon(Icons.shopping_bag_outlined),
      onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CartPage()));

        // Handle shopping bag button press
      },
    ),
  ],
),

      body: Column(
        children: [
          _buildFilterOptions(),
          Expanded(
            child: ListView.builder(
              itemCount: widget.reviews.length,
              itemBuilder: (context, index) {
                var reviewId = widget.reviews.keys.toList()[index];
                var review = widget.reviews[reviewId];
                if (_selectedFilter == 'All' ||
                    review['rating'] ==
                        int.parse(_selectedFilter.split(' ')[0])) {
                  return Card(
                    color: Colors.white,
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15.0,left: 15),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(
                          radius: 27,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.account_circle),
                        ),
                        title: Row(
                          children: [
                            Text(
                              review['user'],
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Text(review['date']),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Rating(rating: review['rating'].toDouble()),
                            const SizedBox(height: 5),
                            Text(review['review_text']),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox(); // Empty container if not matching the filter
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOptions() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          _buildFilterOption('All'),
          _buildFilterOption('5 Stars'),
          _buildFilterOption('4 Stars'),
          _buildFilterOption('3 Stars'),
          _buildFilterOption('2 Stars'),
          _buildFilterOption('1 Star'),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = label;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            label,
            style: TextStyle(fontSize: 20,
              color: label == _selectedFilter ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ),
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
            return const Icon(
              Icons.star,
              color: Colors.amber,
            );
          } else if (hasHalfStar && index == numberOfStars) {
            return const Icon(
              Icons.star_half,
              color: Colors.amber,
            );
          } else {
            return const Icon(
              Icons.star_border,
              color: Colors.amber,
            );
          }
        },
      ),
    );
  }
}

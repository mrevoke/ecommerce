// review_widget.dart

import 'package:flutter/material.dart';

class ReviewWidget extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;

  const ReviewWidget({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: reviews.map((review) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 20),
                const SizedBox(width: 5),
                Text(
                  review['rating'].toString(),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                Text(
                  review['reviewer'],
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              review['comment'],
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
          ],
        );
      }).toList(),
    );
  }
}

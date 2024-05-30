import 'package:flutter/material.dart';

class ShoeCard extends StatelessWidget {
  final String shoeName;
  final double shoePrice;
  final String shoeGender;
  final double shoeRating;
  final int reviewCount;
  final Image? firstImage;

  const ShoeCard({
    Key? key,
    required this.shoeName,
    required this.shoePrice,
    required this.shoeGender,
    required this.shoeRating,
    required this.reviewCount,
    this.firstImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    double baseFontSize = 16; // Base font size to scale
    double scaledFontSize(double size) {
      return size *
          (screenWidth /
              400); // Adjust the divisor to your desired reference width
    }

    return Card(
      color: Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0,
      child: Container(
        width: screenWidth * 0.45,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (firstImage != null)
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Container(
                      width: screenWidth * 0.4,
                      height: screenWidth *
                          0.28, // Ensures the aspect ratio is maintained
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: firstImage,
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  shoeName,
                  style: TextStyle(
                      fontSize: scaledFontSize(18),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.star,
                        color: Colors.amber, size: scaledFontSize(16)),
                    SizedBox(width: 4),
                    Text(
                      '$shoeRating',
                      style: TextStyle(fontSize: scaledFontSize(16)),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '($reviewCount Reviews)',
                      style: TextStyle(
                          fontSize: scaledFontSize(14), color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Text(
                  '\$${shoePrice.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: scaledFontSize(16),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

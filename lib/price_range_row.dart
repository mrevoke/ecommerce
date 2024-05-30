import 'package:flutter/material.dart';

class PriceRangeRow extends StatelessWidget {
  final RangeValues priceRange;
  final Function(RangeValues) onRangeChanged;

  const PriceRangeRow({Key? key, required this.priceRange, required this.onRangeChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.black,
            inactiveTrackColor: Colors.black.withOpacity(0.3),
            thumbColor: Colors.black,
            overlayColor: Colors.black.withOpacity(0.2),
            valueIndicatorColor: Colors.black,
            activeTickMarkColor: Colors.black,
            inactiveTickMarkColor: Colors.black.withOpacity(0.3),
          ),
          child: RangeSlider(
            values: priceRange,
            min: 0,
            max: 1000,
            divisions: 100,
            onChanged: onRangeChanged,
            labels: RangeLabels(
              priceRange.start.toString(),
              priceRange.end.toString(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left:20.0,right:20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text( priceRange.start.toString(),),
            Text( priceRange.end.toString(),)
          ],),
        )
      ],
    );
  }
}

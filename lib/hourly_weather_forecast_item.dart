import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final String temperature;
  final String time;
  final IconData icon;
  const HourlyForecastItem(
      {super.key,
      required this.temperature,
      required this.icon,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 8,
            ),
            Icon(
              icon,
              size: 40,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              temperature,
              // style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

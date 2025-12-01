import 'package:flutter/material.dart';

class TripCard extends StatelessWidget {
  final String title;
  final String dateRange;
  final VoidCallback? onTap;

  const TripCard({
    super.key,
    required this.title,
    required this.dateRange,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF5E9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8D5C4), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: Colors.black87,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    dateRange,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Exemple d'utilisation :
class ExampleUsage extends StatelessWidget {
  const ExampleUsage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TripCard(
                title: 'Porto',
                dateRange: 'From 20 december to 3 january',
                onTap: () {
                  print('Carte Porto cliquée');
                },
              ),
              const SizedBox(height: 16),
              TripCard(
                title: 'Paris',
                dateRange: 'From 5 january to 12 january',
                onTap: () {
                  print('Carte Paris cliquée');
                },
              ),
              const SizedBox(height: 16),
              TripCard(title: 'Tokyo', dateRange: 'From 1 march to 15 march'),
            ],
          ),
        ),
      ),
    );
  }
}

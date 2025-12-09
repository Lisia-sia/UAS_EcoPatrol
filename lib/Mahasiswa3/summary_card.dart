import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final int total;
  final int selesai;

  const SummaryCard({super.key, required this.total, required this.selesai});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green.shade50,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(children: [Text("$total", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), const Text("Total")]),
            Column(children: [Text("$selesai", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)), const Text("Selesai")]),
          ],
        ),
      ),
    );
  }
}
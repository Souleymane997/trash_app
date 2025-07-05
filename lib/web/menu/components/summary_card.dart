import 'package:flutter/material.dart';
import 'package:trash_app/shared/colors.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key, required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: vert(),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title , style: TextStyle(color: blanc()),),
              Text(
                value,
                style: TextStyle(color: blanc(), fontSize: 24),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

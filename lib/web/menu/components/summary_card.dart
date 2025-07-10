// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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


class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final String icon;
  final Color color;
  final VoidCallback onTap;

  const DashboardCard({super.key,
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/$icon',
                    height: 32,
                    width: 32,
                    color: blanc(),
                    semanticsLabel: icon,
                  ),
                  const SizedBox(height: 10),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      value,
                      style: TextStyle(color: blanc(), fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: blanc(), fontSize: 20),
                    )
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}



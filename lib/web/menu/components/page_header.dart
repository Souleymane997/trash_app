import 'package:flutter/material.dart';
import 'package:trash_app/shared/colors.dart';

import '../../../shared/custom_text.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title,
          color: noir(),
          tex: TailleText(context).titre,
          fontWeight: FontWeight.w700,
        ),
        CustomText(description , color: noir(),),
      ],
    );
  }
}

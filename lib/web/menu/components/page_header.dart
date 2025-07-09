import 'package:flutter/material.dart';
import 'package:trash_app/shared/colors.dart';

import '../../../shared/custom_text.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: CustomText(
        title,
        color: noir(),
        tex: TailleText(context).titre,
        textAlign: TextAlign.start,
        fontWeight: FontWeight.w700,
      ),
      subtitle:   CustomText(description , color: noir(),  textAlign: TextAlign.start,),
    );
  }
}

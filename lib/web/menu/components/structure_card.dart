import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../models/structure_model.dart';

class StructureCard extends StatelessWidget {
  const StructureCard({super.key, required this.structure});

  final StructureModel  structure;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: SvgPicture.asset(
                  'assets/icons/structure.svg',
                  height: 40,
                  width:40,
                  semanticsLabel: 'structure',
                ),
              ),
              Text(structure.nom, style:TextStyle(fontSize: 20 , fontWeight: FontWeight.w700),),
              Text(
                '${structure.tel} , ${structure.idArrondissement.toString()}',
              ),

            ],
          ),
        ),
      ),
    );
  }
}

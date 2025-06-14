// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:trash_app/shared/colors.dart';

import '../../../../shared/custom_text.dart';

class AppInfos extends StatefulWidget {
  const AppInfos({super.key});

  @override
  State<AppInfos> createState() => _AppInfosState();
}

class _AppInfosState extends State<AppInfos> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SvgPicture.asset(
                      'assets/icons/exit.svg',
                      height: 30,
                      width: 30,
                      color: redFonce(),
                      semanticsLabel: 'person',
                    ),
                  ),
                ),
              ],),
            CircleAvatar(
              radius: 45,
              backgroundImage: AssetImage('assets/logos/logo1.png'),
            ),
            CustomText(
              'Trash Track',
              tex: 2.0,
              color: vert(),
              textAlign: TextAlign.center,
              family: 'Lobster',
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: 15,),
            CustomText(
              'Trash Track est une solution innovante dédiée à la gestion du ramassage des ordures dans les arrondissements de Ouagadougou. \n\nGrâce à une plateforme intelligente, Trash Track optimise les tournées de collecte, assure un suivi en temps réel et améliore la propreté urbaine. \n',
              color: noir(),
            ),
            CustomText(
                'Trash Track vise à rendre la ville plus propre, plus saine et plus agréable pour tous.', color: noir(),),
            Gap(30),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomText(
                'Contactez-nous \n Téléphone : +226 70 00 00 00 \nEmail : contact@trashtrack.bf\n Adresse : Ouagadougou, Burkina Faso', color: noir(),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 15,),
          ],
    )) ;
  }
}

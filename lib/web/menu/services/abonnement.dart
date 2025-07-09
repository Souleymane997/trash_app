// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:intersperse/intersperse.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../controllers/abonnement.dart';
import '../../../models/abonn_model.dart';
import '../../../shared/colors.dart';
import '../../../shared/custom_text.dart';
import '../components/content_view.dart';
import '../components/page_header.dart';
import '../components/summary_card.dart';

class Abonnement extends StatefulWidget {
  const Abonnement({super.key});

  @override
  State<Abonnement> createState() => _AbonnementState();
}

class _AbonnementState extends State<Abonnement> {

  bool isLoad = false ;
  late List<AbonnUserModel> list = [];
  int nbre = 0 ;
  int nbreStructure = 0 ;
  String idStructure = '' ;

  getListAbonn({int? idArrond}) async {

    List<AbonnUserModel?> listUsers = await AbonnementController().getAllAbonn();

    if (listUsers.isNotEmpty) {
      setState(() {
          list = listUsers.whereType<AbonnUserModel>().toList();
      });
      Timer(Duration(seconds: 2), () {
        setState(() {
          isLoad = true ;
          nbre = list.length ;
        });
      });
    }else{
      setState(() {
        isLoad = true ;
        nbre = 0 ;
      });
      return;
        
    }
  }

  @override
  void initState() {
    super.initState();
    getListAbonn() ;

  }


  
  
  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveBreakpoints.of(context);
    var summaryCards = [
      SummaryCard(title: "Nombre d'Abonnés ", value: '$nbre')
    ];

    return ContentView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeader(
              title: 'Abonnement',
              description: "Mes Abonnés",
            ),
            const Gap(16),
            if (responsive.isMobile)
              ...summaryCards
            else
              Row(
                children: summaryCards
                    .map<Widget>((card) => Expanded(child: card))
                    .intersperse(const Gap(16))
                    .toList(),
              ),
            const Gap(16),

            isLoad?
            listView(list) : Center(child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
              child: CircularProgressIndicator(),
            )),
          ],
        ));
  }
}


Widget listView( List<AbonnUserModel> listUsers ){

  if(listUsers.isEmpty)
  {
    return Center(child:Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 100.0, bottom: 3.0, left: 3.0, right: 3.0),
          child: SvgPicture.asset(
            'assets/icons/empty.svg',
            height: 100,
            width:100,
            color: noir(),
            semanticsLabel: 'structure',
          ),
        ),
        CustomText("Liste vide !!", color: noir(),) ,
      ],
    ) ,) ;
  }

  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: vert(),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(12) , topRight: Radius.circular(12)  ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Text('Nº', style: TextStyle(fontWeight: FontWeight.bold , color: blanc())),
              ),
              Expanded(
                flex: 2,
                child: Text('Nom', style: TextStyle(fontWeight: FontWeight.bold , color: blanc()), textAlign: TextAlign.center,),
              ),
              Expanded(
                flex: 2,
                child: Text('Telephone', style: TextStyle(fontWeight: FontWeight.bold , color: blanc()), textAlign: TextAlign.center,),
              ),
              Expanded(
                flex: 2,
                child: Text('Service', style: TextStyle(fontWeight: FontWeight.bold , color: blanc()), textAlign: TextAlign.center,),
              ),
              Expanded(
                flex: 2,
                child: Text('Actif', style: TextStyle(fontWeight: FontWeight.bold, color: blanc()), textAlign: TextAlign.end,),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: listUsers.length,
          separatorBuilder: (context, index) => const SizedBox(height: 6),
          itemBuilder: (context, index) {
            AbonnUserModel item = listUsers[index];
            return GestureDetector(
              onTap: () {

              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${index+1}',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            item.nom,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        Expanded(
                          flex: 2,
                          child: Text(
                            item.tel,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            item.nom_service,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            (item.actif) ? 'oui' : 'non',
                            textAlign: TextAlign.end,
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),

                      ],
                    ),
                    Divider(),
                  ],
                ),
              ),
            );

          },
        ),
      ],
    ),
  );

}

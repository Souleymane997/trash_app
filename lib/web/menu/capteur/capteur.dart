
// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intersperse/intersperse.dart';
import 'package:responsive_framework/responsive_framework.dart' show ResponsiveBreakpoints;
import 'package:trash_app/controllers/capteur_controller.dart';
import 'package:trash_app/models/capteur_model.dart';


import '../../../shared/colors.dart';
import '../../../shared/custom_text.dart';
import '../components/content_view.dart';
import '../components/page_header.dart';
import '../components/summary_card.dart';
import 'map_position.dart';

class CapteurPage extends StatefulWidget {
  const CapteurPage({super.key});

  @override
  State<CapteurPage> createState() => _CapteurPageState();
}

class _CapteurPageState extends State<CapteurPage> {

  List<CapteurModel?> listCapteur = [] ;
  bool isLoad = false ;
  int nbre = 0 ;



  getList() async{
    List<CapteurModel?> list = await CapteurController().getList();

    if(list.isNotEmpty){
      setState(() {
        listCapteur = list ;
      });
      Timer(Duration(seconds: 2), () {
        setState(() {
          isLoad = true ;
          nbre = listCapteur.length ;
        });
      });
    }
    else{
      Timer(Duration(seconds: 2), () {
        setState(() {
          isLoad = true ;
          nbre = listCapteur.length ;
        });
      });
    }
  }


  @override
  void initState() {
    super.initState();
    getList() ;
  }



  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveBreakpoints.of(context);
    var summaryCards = [
      SummaryCard(title: "Nombre de Poubelles remplies ", value: '$nbre'),
    ];
    return ContentView(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageHeader(
          title: 'Gestion des Capteurs',
          description: "liste des poubelles Remplies ",
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
        listView( listCapteur,)
            : Center(child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
          child: CircularProgressIndicator(),
        )),

      ],
    ));
  }







  Widget listView(List<CapteurModel?> list){

    if(list.isEmpty)
    {
      return Center(child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
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

    return ListView.separated(
      itemCount: list.length,
      shrinkWrap: true, // ✅ important
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        CapteurModel? item = list[index] ;
        return GestureDetector(
          onTap:() => showMapPopup(context, item.latitude, item.longitude),
          child: SizedBox(
            width: double.infinity,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: SvgPicture.asset(
                                'assets/icons/prochain.svg',
                                height: 24,
                                width: 24,
                                color: vert(),
                                semanticsLabel: 'structure',
                              ),
                            ),
                            title: Center(
                              child: Text(
                                'Etat de la Poubelle : ${item!.fill_state}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  item.time.toString().split(' ').first,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(),
    ) ;
  }
}

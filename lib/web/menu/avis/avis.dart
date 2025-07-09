
// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intersperse/intersperse.dart';
import 'package:responsive_framework/responsive_framework.dart' show ResponsiveBreakpoints;

import '../../../controllers/avis_controller.dart';
import '../../../models/avis_model.dart';
import '../../../shared/colors.dart';
import '../../../shared/custom_text.dart';
import '../components/content_view.dart';
import '../components/page_header.dart';
import '../components/summary_card.dart';

class AvisPage extends StatefulWidget {
  const AvisPage({super.key});

  @override
  State<AvisPage> createState() => _AvisPageState();
}

class _AvisPageState extends State<AvisPage> {

  List<AvisModel?> listAvis = [] ;
  bool isLoad = false ;
  int nbre = 0 ;



  getList() async{

    List<AvisModel?> list = await AvisController().getAvisByStructure();

    if(list.isNotEmpty){
      setState(() {
        listAvis = list ;

      });
      Timer(Duration(seconds: 2), () {
        setState(() {
          isLoad = true ;
          nbre = listAvis.length ;
        });
      });
    }
    else{
      Timer(Duration(seconds: 2), () {
        setState(() {
          isLoad = true ;
          nbre = listAvis.length ;
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
      SummaryCard(title: "Nombre d'avis ", value: '$nbre'),
    ];
    return ContentView(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageHeader(
          title: 'Gestion des Avis',
          description: "Lisez les commentaires de vos clients",
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
        listView( listAvis,)
            : Center(child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
          child: CircularProgressIndicator(),
        )),

      ],
    ));
  }





  Widget star(){
    return  InkWell(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: SvgPicture.asset(
          'assets/icons/star1.svg',
          height: 20,
          width: 20,
          semanticsLabel: 'Logo',
        ),
      ),
    ) ;
  }





  Widget listView(List<AvisModel?> list){

    if(list.isEmpty)
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

    return ListView.separated(
      itemCount: list.length,
      shrinkWrap: true, // ✅ important
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        AvisModel? item = list[index] ;
        return GestureDetector(
          onTap:(){
          } ,
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
                                'assets/icons/person.svg',
                                height: 24,
                                width: 24,
                                color: vert(),
                                semanticsLabel: 'structure',
                              ),
                            ),
                            title: Center(
                              child: Text(
                                item!.nom,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            subtitle: Center(
                              child: Text(
                                item.comment,
                                style: TextStyle(
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  item.date,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(
                                    item.notes,
                                        (_) => star(), // ton widget étoile
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

// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intersperse/intersperse.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:trash_app/controllers/secteur_controllers.dart';
import 'package:trash_app/models/secteur.dart';
import 'package:trash_app/web/menu/settings/secteur/add_secteur.dart';

import '../../../../shared/colors.dart';
import '../../../../shared/custom_text.dart';
import '../../components/content_view.dart';
import '../../components/page_header.dart';
import '../../components/summary_card.dart';
import 'edit_secteur.dart';

class SecteurPage extends StatefulWidget {
  const SecteurPage({super.key});

  @override
  State<SecteurPage> createState() => _SecteurPageState();
}

class _SecteurPageState extends State<SecteurPage> {


  late List<SecteurModel> listSecteur = [];
  bool isLoad = false ;
  int nbre = 0 ;


  Future<void> openAddSecteurDialog() async {
    final success = await showDialog<bool>(
      context: context,
      builder: (context) =>AddSecteurDialog(),
    );
    if (success == true) {
      getList();
    }
  }

  Future<void> openEditSecteurDialog(SecteurModel item) async {
    final success = await showDialog<bool>(
      context: context,
      builder: (context) => EditSecteurDialog(item: item,),
    );
    if (success == true) {
      getList();
    }
  }

  getList() async {
    List<SecteurModel> list = await SecteurController().getSecteursWithArrondissement() ;
    setState(() {
      listSecteur= list ;
    });
    Timer(Duration(seconds: 2), () {
      setState(() {
        isLoad = true ;
        nbre = listSecteur.length ;
      });
    });
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
      SummaryCard(title: "Nombre de Secteurs", value: '$nbre'),
    ];
    return ContentView(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageHeader(
          title: 'Gestion des Secteurs',
          description: "Vue d'ensemble des structures",
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
        const Gap(32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text("Liste", style: TextStyle(
                  fontSize: 22
              ),),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: ElevatedButton(
                onPressed: openAddSecteurDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: vert(),
                  foregroundColor: blanc(),
                  padding: EdgeInsets.symmetric(horizontal: 35, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: vert(), width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: CustomText("Ajouter", family: 'Inter', fontWeight: FontWeight.w500,),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Icon(Icons.add_circle),
                    )
                  ],
                ),
              ),
            ),

          ],
        ),
        const Gap(16),
        isLoad?
        Expanded(
          child:  listView(listSecteur),
        ) : Center(child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
          child: CircularProgressIndicator(),
        )),

      ],
    ));
  }


  Widget listView(List<SecteurModel> list){

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
      itemBuilder: (context, index) {
        SecteurModel item = list[index] ;
        return GestureDetector(
          onTap:(){
            if (kDebugMode) {
              print(item.id.toString()) ;
            }
            openEditSecteurDialog(item) ;
          } ,
          child: SizedBox(
            width: double.infinity,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${index+1}', style:TextStyle(fontSize: 20 , fontWeight: FontWeight.w700),),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(item.secteur, style:TextStyle(fontSize: 18 , fontWeight: FontWeight.w700),),
                          Text(item.arrondissement, style:TextStyle(fontSize: 12 , fontWeight: FontWeight.w300),)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: SvgPicture.asset(
                        'assets/icons/sect.svg',
                        height: 40,
                        width:40,
                        color: noir(),
                        semanticsLabel: 'structure',
                      ),
                    ),
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

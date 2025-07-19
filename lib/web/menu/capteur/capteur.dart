
// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intersperse/intersperse.dart';
import 'package:responsive_framework/responsive_framework.dart' show ResponsiveBreakpoints;
import 'package:trash_app/controllers/capteur_controller.dart';
import 'package:trash_app/models/capteur_model.dart';
import 'package:trash_app/web/menu/capteur/edit.dart';


import '../../../shared/colors.dart';
import '../../../shared/custom_text.dart';
import '../components/content_view.dart';
import '../components/page_header.dart';
import '../components/summary_card.dart';
import 'add_capteur.dart';
import 'map_position.dart';

class CapteurPage extends StatefulWidget {
  const CapteurPage({super.key});

  @override
  State<CapteurPage> createState() => _CapteurPageState();
}

class _CapteurPageState extends State<CapteurPage> {

  List<CapteurModel?> listCapteurData = [] ;
  List<CapteurStringModel?> listCapteur = [] ;
  bool isLoad = false ;
  bool isLoading = false ;
  bool onClick = false ;
  int nbre = 0 ;

  Future<void> openAddCapteurDialog() async {
    final success = await showDialog<bool>(
      context: context,
      builder: (context) => AddCapteurDialog(),
    );
    if (success == true) {
      getList();
    }
  }

  Future<void> openEditCapteurDialog(CapteurStringModel capteur) async {
    final success = await showDialog<bool>(
      context: context,
      builder: (context) => EditCapteurDialog(capteur: capteur),
    );
    if (success == true) {
      getList();
    }
  }

  getList() async{
    List<CapteurStringModel?> list = await CapteurController().getListCapteur();

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



  getListCapteurData(String id) async{
    List<CapteurModel?> list = await CapteurController().getList(id);

    if(list.isNotEmpty){
      setState(() {
        listCapteurData = list ;
      });
      Timer(Duration(seconds: 2), () {
        setState(() {
          isLoading = true ;
        });
      });
    }
    else{
      Timer(Duration(seconds: 2), () {
        setState(() {
          isLoading = true ;
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
      SummaryCard(title: "Nombre de Capteurs ", value: '$nbre'),
    ];
    return Stack(
      children:
      [
        ContentView(child:
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageHeader(
                title: 'Gestion des Capteurs',
                description: "liste des Capteurs ",
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
                      onPressed:openAddCapteurDialog,
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
              listViewCapteur( listCapteur,)
                  : Center(child: Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
                child: CircularProgressIndicator(),
              )),

            ],
          )
        ),

       onClick? Container(
          color: grisLight(),
          width: double.infinity,
          height: double.infinity,
        ): Container(),
        onClick? ContentView(child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text("Liste des donnees", style: TextStyle(
                      fontSize: 22
                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: ElevatedButton(
                    onPressed:(){
                      setState(() {
                        onClick = false ;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: vert(),
                      foregroundColor: blanc(),
                      padding: EdgeInsets.symmetric(horizontal: 35, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(color: vert(), width: 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Icon(Icons.close),
                        )
                      ],
                    ),
                  ),
                ),

              ],
            ),
            const Gap(32),

            isLoading?
            listView( listCapteurData,)
                : Center(child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
              child: CircularProgressIndicator(),
            )),

          ],
        )
        ): Container(),
    ]
    );
  }




  Widget listViewCapteur(List<CapteurStringModel?> list){

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
        CapteurStringModel? item = list[index] ;
        return GestureDetector(
          onTap:() {
            setState(() {
              setState(() {
                onClick = true ;
                getListCapteurData(item!.sensor_id) ;
              });
            });
          },
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
                                'assets/icons/sensor.svg',
                                height: 30,
                                width: 30,
                                color: vert(),
                                semanticsLabel: 'sensor',
                              ),
                            ),
                            title: Center(
                              child: Text(
                                'ID Capteur ${index+1} : ${item?.sensor_id}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            trailing: IconButton(icon: Icon(Icons.edit, color: vert(),), onPressed:(){
                              if(item!=null){
                                openEditCapteurDialog(item) ;
                              }
                            }
                            )
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







Widget listView(List<CapteurModel?> list){

    if(list.isEmpty)
    {
      return Center(child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10 , right: 10, bottom: 10, top: MediaQuery.of(context).size.height * 0.3),
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
                                semanticsLabel: 'prochain',
                              ),
                            ),
                            title: Center(
                              child: Text(
                                '${item!.fill_state} à ${item.pourcent.toStringAsFixed(2)} %',
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

// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intersperse/intersperse.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:trash_app/controllers/service_controllers.dart';
import 'package:trash_app/models/service_model.dart';

import '../../../controllers/structures_controller.dart';
import '../../../models/structure_model.dart';
import '../../../shared/colors.dart';
import '../../../shared/custom_text.dart';
import '../components/content_view.dart';
import '../components/page_header.dart';
import '../components/summary_card.dart';
import 'add_service.dart';
import 'edit_service.dart';

class ServicesPages extends StatefulWidget {
  const ServicesPages({super.key});

  @override
  State<ServicesPages> createState() => _ServicesPagesState();
}

class _ServicesPagesState extends State<ServicesPages> {

  late List<ServiceModel> list= [];
  String idStructure = '';
  bool isLoad = false ;
  bool isDelete = true ;
  int nbre = 0 ;



  Future<void> openAddServiceDialog() async {
    final success = await showDialog<bool>(
      context: context,
      builder: (context) =>AddService(idStructure: idStructure,)
    );
    if (success == true) {
      getList();
    }
  }



  Future<void> openEditServiceDialog(ServiceModel item) async {
    final success = await showDialog<bool>(
      context: context,
      builder: (context) => EditService(item: item,),
    );
    if (success == true) {
      getList();
    }
  }



  getList() async {

    StructureModel? item = await  StructureController().getStructureDetails() ;
    if(item !=  null){
      setState(() {
        idStructure = item.id ;
      });

      List<ServiceModel> listItem = await ServiceController().getList(item.id);
      setState(() {
        list = listItem ;
      });
      Timer(Duration(seconds: 2), () {
        setState(() {
          isLoad = true ;
          nbre = list.length ;
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
      SummaryCard(title: "Nombre de Services", value: '$nbre'),
    ];


    return ContentView(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageHeader(
          title: 'Gestion des Services',
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
                onPressed:  openAddServiceDialog,
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
          child:  listView(list),
        ) : Center(child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
          child: CircularProgressIndicator(),
        )),


      ],
    ));
  }



  Widget listView(List<ServiceModel> list){

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
                  flex: 3,
                  child: Text('Nom du service', style: TextStyle(fontWeight: FontWeight.bold , color: blanc())),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Fréquence', style: TextStyle(fontWeight: FontWeight.bold , color: blanc()), textAlign: TextAlign.center,),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Tarif (Fcfa/mois)', style: TextStyle(fontWeight: FontWeight.bold, color: blanc()), textAlign: TextAlign.end,),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          Expanded(
            child: ListView.separated(
              itemCount: list.length,
              separatorBuilder: (context, index) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                ServiceModel item = list[index];
      
                return GestureDetector(
                  onTap: () {
                    openEditServiceDialog(item);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/serv.svg',
                                    height: 24,
                                    width: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      item.nom_service,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Expanded(
                              flex: 2,
                              child: Text(
                                '${item.nbre} fois/semaine',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),

                            Expanded(
                              flex: 2,
                              child: Text(
                                '${item.tarif} Fcfa',
                                textAlign: TextAlign.end,
                                style: const TextStyle(fontSize: 14),
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
          ),
        ],
      ),
    );

  }
}

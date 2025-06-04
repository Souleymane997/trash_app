// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intersperse/intersperse.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:trash_app/models/structure_model.dart';
import 'package:trash_app/web/menu/components/content_view.dart';

import '../../../controllers/structures_controller.dart';
import '../../../shared/colors.dart';
import '../../../shared/custom_text.dart';
import '../components/page_header.dart';
import '../components/summary_card.dart';
import 'add_structure.dart';
import 'edit_structure.dart';

class StructuresPage extends StatefulWidget {
  const StructuresPage({super.key});

  @override
  State<StructuresPage> createState() => _StructuresPageState();
}

class _StructuresPageState extends State<StructuresPage> {

 late List<StructureModel> listStructure = [];

  bool isLoad = false ;
  int nbre = 0 ;

 Future<void> openAddStructureDialog() async {
   final success = await showDialog<bool>(
     context: context,
     builder: (context) =>AddStructureDialog(),
   );
   if (success == true) {
     getList();
   }
 }


 Future<void> openEditStructureDialog(StructureModel item) async {
   final success = await showDialog<bool>(
     context: context,
     builder: (context) => EditStructureDialog(item: item,),
   );
   if (success == true) {
     getList();
   }
 }



  getList() async {
    List<StructureModel> list = await  StructureController().getStructureWithArrondissement();
    setState(() {
      listStructure= list ;
    });
    Timer(Duration(seconds: 2), () {
      setState(() {
        isLoad = true ;
        nbre = listStructure.length ;
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
      SummaryCard(title: "Nombre de Structures", value: '$nbre'),
    ];

    return ContentView(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageHeader(
          title: 'Gestion des Structures',
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
                onPressed:  openAddStructureDialog,
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
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: Divider(
            color: Colors.grey,
            thickness: 1.0,
            indent: 16.0,
            endIndent: 16.0,
          ),
        ),
        const Gap(4),
        isLoad?
        Expanded(child: gridView( listStructure,))
            : Center(child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
          child: CircularProgressIndicator(),
        )),
      ],
    ));
  }

 Widget gridView(List<StructureModel> listStructure){

   return LayoutBuilder(
     builder: (context, constraints) {
       int crossAxisCount;
       if (constraints.maxWidth >= 1200) {
         crossAxisCount = 5;
       } else if (constraints.maxWidth >= 800) {
         crossAxisCount = 4;
       } else if (constraints.maxWidth >= 600) {
         crossAxisCount = 3;
       } else {
         crossAxisCount = 2;
       }

       if(listStructure.isEmpty)
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
       }else{
         return GridView.builder(
           padding: const EdgeInsets.all(16),
           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
             crossAxisCount: crossAxisCount,
             crossAxisSpacing: 16,
             mainAxisSpacing: 16,
             childAspectRatio: 1,
           ),
           itemCount: listStructure.length,
           itemBuilder: (context, index) {
             StructureModel structure = listStructure[index] ;
             return  GestureDetector(
               onTap: () {
                 openEditStructureDialog(structure) ;
               },
               child: SizedBox(
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
                         Text(structure.nomStructure, style:TextStyle(fontSize: 20 , fontWeight: FontWeight.w700), textAlign: TextAlign.center,),
                         Text(
                           '${structure.tel}\n${structure.arrondissement}\n${structure.email}', textAlign: TextAlign.center,
                           style:TextStyle(fontSize: 13),
                         ),

                       ],
                     ),
                   ),
                 ),
               ),
             );
           },
         );
       }

     },
   );
 }


}


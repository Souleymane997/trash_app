
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
        Expanded(child: gridView( listAvis,))
            : Center(child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
          child: CircularProgressIndicator(),
        )),

      ],
    ));
  }




  Widget gridView(List<AvisModel?> list){

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        if (constraints.maxWidth >= 1200) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth >= 800) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth >= 600) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 1;
        }

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
        }else{
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
            ),
            itemCount: list.length,
            itemBuilder: (context, index) {
              AvisModel? item= list[index] ;
              return  SizedBox(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: SvgPicture.asset(
                                'assets/icons/person.svg',
                                height: 50,
                                width: 50,
                                color: vert(),
                                semanticsLabel: 'person',
                              ),
                            ),
                            Expanded(child: Text(item!.comment, style:TextStyle(fontSize: 15 , fontWeight: FontWeight.w500), textAlign: TextAlign.center,)),
                          ],
                        ),
                        Gap(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 0; i < item.notes; i++)
                              star(),
                          ],
                        ),
                      ],
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


  Widget star(){
    return  InkWell(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SvgPicture.asset(
          'assets/icons/star1.svg',
          height: 30,
          width: 30,
          semanticsLabel: 'Logo',
        ),
      ),
    ) ;


  }

}

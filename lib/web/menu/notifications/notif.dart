// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intersperse/intersperse.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:trash_app/controllers/notif_controller.dart';
import 'package:trash_app/models/notif_model.dart';
import 'package:oktoast/oktoast.dart';

import '../../../shared/colors.dart';
import '../../../shared/custom_text.dart';
import '../components/content_view.dart';
import '../components/page_header.dart';
import '../components/summary_card.dart';

class NotifPage extends StatefulWidget {
  const NotifPage({super.key});

  @override
  State<NotifPage> createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {

  late List<NotifModel> list = [];
  bool isLoad = false ;
  int nbre = 0 ;



  getList() async {
    List<NotifModel> lists = await  NotifController().getListNotifStructure();
    setState(() {
      list = lists ;
    });
    Timer(Duration(seconds: 2), () {
      setState(() {
        isLoad = true ;
        nbre = list.length ;
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
      SummaryCard(title: "Nombre de Notifcations", value: '$nbre'),
    ];

    return ContentView(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageHeader(
          title: 'Gestion des Notifications',
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
        Expanded(child: gridView( list,))
            : Center(child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
          child: CircularProgressIndicator(),
        )),
      ],
    ));
  }

  Widget gridView(List<NotifModel> list){

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
              childAspectRatio: 0.8,
            ),
            itemCount: list.length,
            itemBuilder: (context, index) {
              NotifModel item = list[index] ;
              bool lu = item.lecture ;
              return  GestureDetector(
                onTap: () async {
                  bool res = await NotifController().lecture(id: item.notification_id, lu: true) ;
                  if(res){
                    setState(() {
                      lu = true ;
                    });
                    showToast("Marqué comme lu",
                      duration: Duration(seconds: 1),
                      position: ToastPosition.bottom,
                    );
                  }
                  getList() ;

                },
                child: SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 4,
                    shape:(lu)?null: RoundedRectangleBorder(
                      side:BorderSide(color: Colors.red, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(icon: Icon(Icons.delete, color: red(),),
                              onPressed: () async {
                                bool res = await NotifController().delete(item.notification_id) ;
                                if(res){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Notification supprimé') , backgroundColor: vert(),),
                                  );

                                  getList() ;
                                }
                                else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Erreur') , backgroundColor: red(),),
                                  );
                                }

                            },),
                          ),
                          lu ?
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: SvgPicture.asset(
                              'assets/icons/notif.svg',
                              height: 30,
                              width:30,
                              semanticsLabel: 'structure',
                            ),
                          ): Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: SvgPicture.asset(
                              'assets/icons/notifs.svg',
                              height: 30,
                              width:30,
                              semanticsLabel: 'structure',
                            ),
                          ),
                          Text(item.type_notification, style:TextStyle(fontSize: 20 , fontWeight: FontWeight.w500), textAlign: TextAlign.center,),
                          Text(
                            '${item.description}\n\n${item.date_envoi}\n', textAlign: TextAlign.center,
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

// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intersperse/intersperse.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:trash_app/controllers/user_controller.dart';
import 'package:trash_app/models/users_model.dart';
import 'package:trash_app/web/menu/components/content_view.dart';

import '../../../controllers/abonnement.dart';
import '../../../controllers/notif_controller.dart';
import '../../../controllers/structures_controller.dart';
import '../../../models/abonn_model.dart';
import '../../../models/notif_model.dart';
import '../../../models/structure_model.dart';
import '../../../shared/colors.dart';
import '../../../shared/custom_text.dart';
import '../components/page_header.dart';
import '../components/summary_card.dart';
import 'add_user.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key, required this.idRole});
  final int idRole ;

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  late List<UserModel> list = [];
  late List<StructureModel> listStructure = [];
  late List<String> listStringStructure = [];
  bool isLoad = false ;
  int nbre = 0 ;
  int nbreAbon = 0 ;
  int nbreNotifs = 0 ;
  int nbreStructure = 0 ;
  StructureModel? structure ;
  int idArrond = 0 ;



  getListAbonn() async {
    List<AbonnUserModel?> listUsers = await AbonnementController().getAllAbonnUsers();

    if (listUsers.isNotEmpty) {
      Timer(Duration(seconds: 2), () {
        setState(() {
          nbreAbon = list.length ;
        });
      });
    }else{
      setState(() {
        nbreAbon = 0 ;
      });
      return;
    }


    List<NotifModel> lists = await  NotifController().getList();

    Timer(Duration(seconds: 2), () {
      setState(() {
        isLoad = true ;
        nbreNotifs = lists.length ;
      });
    });
  }

  getList({int? idArrond}) async {

    List<UserModel> listUsers = await UserController().getUserWithArrondissement(idArrond: idArrond);
    setState(() {
      list = listUsers ;
    });
    Timer(Duration(seconds: 2), () {
      setState(() {
        isLoad = true ;
        nbre = list.length ;
      });
    });


    List<StructureModel> lists = await  StructureController().getStructureWithArrondissement();
    setState(() {
      listStructure= lists ;
    });
    Timer(Duration(seconds: 2), () {
      setState(() {
        isLoad = true ;
        nbreStructure = listStructure.length ;
      });
    });


    for (var item in list) {
      for (var structure in listStructure) {
        if (item.arrondissement_id == structure.arrondissement_id) {
          listStringStructure.add(structure.nomStructure);
        }
      }
    }

    getListAbonn() ;

  }

  getUserData() async {
      StructureModel? item = await StructureController().getStructureDetails() ;
      if(item != null){
        setState(() {
          structure = item;
          idArrond = structure!.arrondissement_id ;
        });
      }

      Timer(Duration(seconds: 2), () {
        if(widget.idRole == 2){
          getList(idArrond: structure?.arrondissement_id) ;
        }else{
          getList() ;
        }

      });


  }



  Future<void> openAddUser() async {
    final success = await showDialog<bool>(
        context: context,
        builder: (context) =>AddUser(idArrond: structure?.arrondissement_id ?? 0,)
    );
    if (success == true) {
      getList(idArrond: idArrond);
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData() ;
    if (kDebugMode) {
      print(widget.idRole) ;
    }
  }


  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveBreakpoints.of(context);
    var summaryCards = [
      SummaryCard(title: "Nombre d'utilisateurs", value: '$nbre'),
    ];

    return ContentView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeader(
              title:(widget.idRole == 2) ? 'Bienvenue, ${structure?.nomStructure.toString()} ' : 'Bienvenue, Administrateur ',
              description: " Vue d'ensemble sur vos données ",
            ),
            const Gap(10),
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
                  child: Text("Liste des Utilisateurs" , style: TextStyle(fontSize: 22),),
                ),
                (widget.idRole == 2)?
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: ElevatedButton(
                    onPressed: openAddUser,
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
                          child: CustomText("Ajouter un utilisateur", family: 'Inter', fontWeight: FontWeight.w500,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Icon(Icons.add_circle),
                        )
                      ],
                    ),
                  ),
                ) : Container(),

              ],
            ),
            const Gap(8),

            isLoad?
            listView(list,listStringStructure) : Center(child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
              child: CircularProgressIndicator(),
            )),
          ],
        ));
  }
}


Widget listView( List<UserModel> listUsers , List<String> listStringStructure ){

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
                flex: 2,
                child: Text('Nom', style: TextStyle(fontWeight: FontWeight.bold , color: blanc())),
              ),
              Expanded(
                flex: 3,
                child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold , color: blanc()), textAlign: TextAlign.center,),
              ),
              Expanded(
                flex: 2,
                child: Text('Telephone', style: TextStyle(fontWeight: FontWeight.bold , color: blanc()), textAlign: TextAlign.center,),
              ),
              Expanded(
                flex: 2,
                child: Text('Secteur', style: TextStyle(fontWeight: FontWeight.bold , color: blanc()), textAlign: TextAlign.center,),
              ),
              Expanded(
                flex: 2,
                child: Text('Structure', style: TextStyle(fontWeight: FontWeight.bold, color: blanc()), textAlign: TextAlign.end,),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: listUsers.length,
          separatorBuilder: (context, index) => const SizedBox(height: 3),
          itemBuilder: (context, index) {
            UserModel item = listUsers[index];
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
                          flex: 2,
                          child: Text(
                            item.nom,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        Expanded(
                          flex: 3,
                          child: Text(
                            '${item.email}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 11),
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
                            item.secteur,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            listStringStructure[index],
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



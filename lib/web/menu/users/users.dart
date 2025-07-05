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
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import '../../../controllers/abonnement.dart';
import '../../../controllers/notif_controller.dart';
import '../../../controllers/structures_controller.dart';
import '../../../models/abonn_model.dart';
import '../../../models/notif_model.dart';
import '../../../models/structure_model.dart';
import '../../../shared/colors.dart';
import '../../../shared/custom_text.dart';
import '../components/page_header.dart';
import '../services/abonnement.dart';
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

    getListAbonn() ;

    for (var item in list) {
      for (var structure in listStructure) {
        if (item.arrondissement_id == structure.arrondissement_id) {
          listStringStructure.add(structure.nomStructure);
        }
      }
    }

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
    var data = [
      StatCard(title: 'Nombre d\'Utilisateurs', nbre: nbre, color: vert(), icon: 'users.svg', page: null,),
      StatCard(title: 'Nombre d\'Abonnés', nbre: nbreAbon, color: red(), icon: 'user.svg', page: Abonnement(),),

    ];
    var data1 = [
      StatCard(title: 'Nombre de Structure', nbre: nbreStructure, color: red(), icon: 'structure.svg', page: null),
      StatCard(title: 'Notifications', nbre: nbreNotifs, color: vert(), icon: 'notifs.svg', page: null,)
    ];

    var data2 = [
      StatCard(title: 'Nombre de Capteurs', nbre: 0, color: vert(), icon: 'sensor.svg', page: null,),
      StatCard(title: 'Nombre de Collecte realisés', nbre:0, color: red(), icon: 'prochain.svg', page: null,)
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
              ...data
            else
              Row(
                children: data
                    .map<Widget>((card) => Expanded(child:  card))
                    .intersperse(const Gap(16))
                    .toList(),
              ),
            const Gap(5),
            if (responsive.isMobile)
              ...data1
            else
              Row(
                children: data1
                    .map<Widget>((card) => Expanded(child:  card))
                    .intersperse(const Gap(16))
                    .toList(),
              ),
            const Gap(5),
            if (responsive.isMobile)
              ...data2
            else
              Row(
                children: data2
                    .map<Widget>((card) => Expanded(child:  card))
                    .intersperse(const Gap(16))
                    .toList(),
              ),
            const Gap(32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(" Liste des Utilisateurs" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
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
            Expanded(
              child: _TableView(list,listStringStructure),
            ): Center(child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
              child: CircularProgressIndicator(),
            )),
          ],
        ));
  }
}



class _TableView extends StatelessWidget {
  const _TableView(this.listUsers, this.listStringStructure);
  final List<UserModel> listUsers ;
  final List<String> listStringStructure ;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ScrollController _verticalController = ScrollController();
    final colorScheme = theme.colorScheme;
    final decoration = TableSpanDecoration(
      border: TableSpanBorder(
        trailing: BorderSide(color: theme.dividerColor),
      ),
    );

    if(listUsers.isEmpty) {
      return Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: SvgPicture.asset(
              'assets/icons/empty.svg',
              height: 100,
              width: 100,
              color: noir(),
              semanticsLabel: 'structure',
            ),
          ),
          CustomText("Liste d'Utilisateurs vide !!", color: noir(),),
        ],
      ),);
    }

    return Scrollbar(
      thumbVisibility: true,
      thickness: 3,
      radius: const Radius.circular(8),
        controller: _verticalController,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: TableView.builder(
          columnCount: 6,
          rowCount:listUsers.length+1,
          pinnedRowCount: 1,
          pinnedColumnCount: 1,
          columnBuilder: (index) {
            return TableSpan(
              foregroundDecoration: index == 0 ? decoration : null,
              extent: const FractionalTableSpanExtent(1 / 6),
            );
          },
          rowBuilder: (index) {
            return TableSpan(
              foregroundDecoration: index == 0 ? decoration : null,
              extent: const FixedTableSpanExtent(50),
            );
          },
          cellBuilder: (context, vicinity) {
            final isStickyHeader = vicinity.xIndex == 0 || vicinity.yIndex == 0;
            var label = '';

            final rowIndex = vicinity.yIndex ; // ← important
            final columnIndex = vicinity.xIndex;

            if (vicinity.yIndex == 0) {
              switch (columnIndex) {
                case 0:
                  label = 'Nº';
                case 1:
                  label = 'Nom';
                case 2:
                  label = 'Email';
                case 3:
                  label = 'Telephone';
                case 4:
                  label = 'Secteur';
                case 5:
                  label = 'Structure';
              }
            } else {
              final user = listUsers[rowIndex-1];
              final structure = listStringStructure[rowIndex-1];
              switch (columnIndex) {
                case 0:
                  label = rowIndex.toString() ;
                case 1:
                  label = user.nom.toString();
                case 2:
                  label = user.email.toString();
                case 3:
                  label = user.tel.toString();
                case 4:
                  label = user.secteur.toString();
                case 5:
                  label = structure;
              }
            }
            return TableViewCell(
              child: ColoredBox(
                color:
                isStickyHeader ? Colors.transparent : colorScheme.surface,
                child: Center(
                  child: FittedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontWeight: isStickyHeader ? FontWeight.w600 : null,
                          color: isStickyHeader ? null : colorScheme.outline,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.title , required this.nbre , required this.color , required this.icon, required this.page});

  final String title;
  final int nbre;
  final Color color;
  final String icon;
  final Widget? page ;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if (page != null) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => page!),
          );
        } else {
          if (kDebugMode) {
            print("Aucune page !");
          }
        }
      },
      child: SizedBox(
        width: double.infinity,
        child: Card(
          color: color,
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/$icon',
                      height: 20,
                      width: 20,
                      color: blanc(),
                      semanticsLabel: icon,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      title,
                      style: TextStyle(
                          color: blanc()
                      ),
                    ),
                  ],
                ),
                Text(
                  "$nbre",
                  style: TextStyle(
                    color: blanc(),
                    fontSize: 24
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
}

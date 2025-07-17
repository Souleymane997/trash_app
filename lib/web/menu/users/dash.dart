// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:trash_app/controllers/user_controller.dart';
import 'package:trash_app/models/users_model.dart';
import 'package:trash_app/shared/loading.dart';
import 'package:trash_app/web/menu/components/content_view.dart';
import 'package:trash_app/web/menu/components/summary_card.dart';


import '../../../controllers/abonnement.dart';
import '../../../controllers/arrond_controllers.dart';
import '../../../controllers/capteur_controller.dart';
import '../../../controllers/notif_controller.dart';
import '../../../controllers/photo_controller.dart';
import '../../../controllers/secteur_controllers.dart';
import '../../../controllers/structures_controller.dart';
import '../../../models/abonn_model.dart';
import '../../../models/arrondissement.dart';
import '../../../models/capteur_model.dart';
import '../../../models/notif_model.dart';
import '../../../models/photo_model.dart';
import '../../../models/secteur.dart';
import '../../../models/structure_model.dart';
import '../../../shared/colors.dart';
import '../components/page_header.dart';
import '../home.dart';
import 'add_user.dart';

class DashPage extends StatefulWidget {
  const DashPage({super.key, required this.idRole});
  final int idRole ;

  @override
  State<DashPage> createState() => _DashPageState();
}

class _DashPageState extends State<DashPage> {

  late List<UserModel> list = [];
  late List<StructureModel> listStructure = [];
  late List<String> listStringStructure = [];
  bool isLoad = false ;
  bool isLoading = false ;
  int nbre = 0 ;
  int nbreP = 0 ;
  int nbreSect = 0 ;
  int nbreAbon = 0 ;
  int nbreArrond = 0 ;
  int nbreNotifs = 0 ;
  int nbreCapteur = 0 ;
  int nbreStructure = 0 ;
  StructureModel? structure ;
  int idArrond = 0 ;



  getListAbonn() async {
    List<AbonnUserModel?> listUsers = await AbonnementController().getAllAbonnUsers();

    if (listUsers.isNotEmpty) {
      Timer(Duration(milliseconds:300), () {
        setState(() {
          nbreAbon = listUsers.length ;
        });
      });
    }else{
      setState(() {
        nbreAbon = 0 ;
      });
      return;
    }


    List<NotifModel> lists = await  NotifController().getList();

    Timer(Duration(milliseconds:300), () {
      setState(() {
        nbreNotifs = lists.length ;
      });
    });


    List<ArrondissementModel> list = await ArrondController().getListArrondissement();

    Timer(Duration(milliseconds:300), () {
      setState(() {
        nbreArrond = list.length ;
      });
    });

    List<SecteurModel> listSect = await SecteurController().getSecteursWithArrondissement() ;

    Timer(Duration(milliseconds:300), () {
      setState(() {
        nbreSect = listSect.length ;
      });
    });

    List<PhotoModel?> listP = await PhotoController().getListPhotos() ;
    Timer(Duration(milliseconds:300 ), () {
      setState(() {
        nbreP = listP.length ;
      });
    });

    List<CapteurStringModel?> listC = await CapteurController().getListCapteur();

    if(list.isNotEmpty){
      Timer(Duration(milliseconds: 300), () {
        setState(() {
          nbreCapteur = listC.length ;
        });
      });
    }

    Timer(Duration(seconds: 2), () {
      setState(() {
        isLoading = true ;
      });
    });



  }

  getList({int? idArrond}) async {

    List<UserModel> listUsers = await UserController().getUserWithArrondissement(idArrond: idArrond);
    setState(() {
      list = listUsers ;
    });
    Timer(Duration(milliseconds:500), () {
      setState(() {
        isLoad = true ;
        nbre = list.length ;
      });
    });


    List<StructureModel> lists = await  StructureController().getStructureWithArrondissement();
    setState(() {
      listStructure= lists ;
    });
    Timer(Duration(milliseconds:500), () {
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
    return Stack(
      children:[ ContentView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeader(
              title:(widget.idRole == 2) ? 'Bienvenue  ${structure?.nomStructure.toString()} ' : 'Bienvenue, Administrateur ',
              description: " Vue d'ensemble sur vos données ",
            ),
            const Gap(10),
            LayoutBuilder(
              builder: (context, constraints) {
                return ResponsiveGridRow(
                  children: [
                    ResponsiveGridCol(
                      lg: 6,
                      xs: 6,
                      md: 6,
                      child: DashboardCard(
                        title: 'Nombre d\'utilisateurs',
                        value: '$nbre',
                        color: vert(),
                        icon: 'users.svg',
                        onTap: () => _navigateTo(context, 1),
                      ),
                    ),
                    if (widget.idRole == 2)
                    ResponsiveGridCol(
                      lg: 6,
                      xs: 6,
                      md: 6,
                      child: DashboardCard(
                        title: 'Nombre d\'abonnés',
                        value: '$nbreAbon',
                        color: red(),
                        icon: 'abonne.svg',
                        onTap: () {
                          ( widget.idRole==2)? _navigateTo(context, 4) : null ;
                        },
                      ),
                    ),
                    if (widget.idRole != 2)
                    ResponsiveGridCol(
                      lg: 6,
                      xs: 6,
                      md: 6,
                      child: DashboardCard(
                        title: 'Nombre de structures',
                        value: '$nbreStructure',
                        color: red(),
                        icon: 'structure.svg',
                        onTap: () => _navigateTo(context, 2),
                      ),
                    ),
                    if (widget.idRole == 2)
                    ResponsiveGridCol(
                      lg: 6,
                      xs: 6,
                      md: 6,
                      child: DashboardCard(
                        title: 'Notifications',
                        value: '$nbreNotifs',
                        color: (widget.idRole == 2) ? red():  vert(),
                        icon: 'notif.svg',
                        onTap: () {
                          ( widget.idRole==2)? _navigateTo(context, 2) : null ;
                        },
                      ),
                    ),
                    if (widget.idRole == 2)
                    ResponsiveGridCol(
                      lg: 6,
                      xs: 6,
                      md: 6,
                      child: DashboardCard(
                        title: 'Nombre de Capteurs installés',
                        value: '$nbreCapteur',
                        color: vert(),
                        icon: 'sensor.svg',
                        onTap: () {
                          ( widget.idRole==2)? _navigateTo(context, 6) : null ;
                        },
                      ),
                    ),
                    if (widget.idRole == 2)
                    ResponsiveGridCol(
                      lg: 6,
                      xs: 6,
                      md: 6,
                      child: DashboardCard(
                        title: 'Nombre de Collecte realisés',
                        value: '0',
                        color: (widget.idRole == 2) ? vert() : red(),
                        icon: 'prochain.svg',
                        onTap: () {},
                      ),
                    ),
                    if (widget.idRole != 2)
                    ResponsiveGridCol(
                      lg: 6,
                      xs: 6,
                      md: 6,
                      child: DashboardCard(
                        title: 'Nombre de Violations',
                        value: '$nbreP',
                        color: red(),
                        icon: 'violation.svg',
                        onTap: () {
                          _navigateTo(context, 3) ;
                        },
                      ),
                    ),
                    if (widget.idRole != 2)
                    ResponsiveGridCol(
                      lg: 6,
                      xs: 6,
                      md: 6,
                      child: DashboardCard(
                        title: 'Nombre d\'arrondissements',
                        value: '$nbreArrond',
                        color: vert(),
                        icon: 'arrond.svg',
                        onTap: () {
                          _navigateTo(context, 4) ;
                        },
                      ),
                    ),
                    if (widget.idRole != 2)
                    ResponsiveGridCol(
                      lg: 6,
                      xs: 6,
                      md: 6,
                      child: DashboardCard(
                        title: 'Nombre de Secteurs',
                        value: '$nbreSect',
                        color: vert(),
                        icon: 'sect.svg',
                        onTap: () {
                          _navigateTo(context, 5) ;
                        },
                      ),
                    ),
                  ],
                );
              },
            ),

            const Gap(24),

          ],
                    )),
        isLoading? Container():LoadingExtend()
    ]
    );
  }

  void _navigateTo(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<AccueilPageState>();
    state?.onDestinationSelected(index);
  }

}

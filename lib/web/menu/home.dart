// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trash_app/shared/colors.dart';
import 'package:trash_app/web/menu/notifications/notif.dart';
import 'package:trash_app/web/menu/photos/photo.dart';
import 'package:trash_app/web/menu/services/abonnement.dart';
import 'package:trash_app/web/menu/services/services.dart';
import 'package:trash_app/web/menu/structure/structure.dart';
import 'package:trash_app/web/menu/users/admin.dart';
import 'package:trash_app/web/menu/users/users.dart';
import 'package:trash_app/web/menu/settings/arrondissement/arrond.dart';
import 'package:trash_app/web/menu/settings/role/role.dart';
import 'package:trash_app/web/menu/settings/secteur/secteur.dart';

import '../../shared/custom_text.dart';
import 'components/appbar.dart';


class AccueilPage extends StatefulWidget {
  const AccueilPage({super.key, required this.idRole});
  final int idRole ;

  @override
  State<AccueilPage> createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  int _selectedIndex = 0;

  late final List<String> titles;
  late final List<String> path;
  late final List<Widget> pages ;

  getListPages() async {

    if(widget.idRole == 2){

      setState(() {
        pages = [
          UsersPage(idRole: widget.idRole,),
          NotifPage(),
          ServicesPages(),
          Abonnement()
        ];

        titles = [
          'Dashbord',
          'Notifications',
          'Services',
          'Abonnement',
        ];

        path = [
          'dash.svg',
          'notif.svg' ,
          'setting.svg',
          'abonne.svg'
        ];
      });

    }
    else{

      if(widget.idRole == 3){
        setState(() {
          pages = [
            UsersPage(idRole: widget.idRole,),
            StructuresPage(),
            ViolationPhotoPage(),
            ArrondPage(),
            SecteurPage(),
          ];

          titles = [
            'Dashbord',
            'Structures',
            'Violations',
            'Arrondissement',
            'Secteur',
          ];

          path = [
            'dash.svg',
            'structure.svg',
            'violation.svg',
            'arrond.svg',
            'sect.svg',
          ];
        });
      }else{
          setState(() {
            pages = [
              UsersPage(idRole: widget.idRole,),
              StructuresPage(),
              ViolationPhotoPage(),
              ArrondPage(),
              SecteurPage(),
              RolePage(),
              AdminPage(),
            ];


            titles = [
              'Dashbord',
              'Structures',
              'Violations',
              'Arrondissement',
              'Secteur',
              'Role',
              'Admin',
            ];
            path = [
              'dash.svg',
              'structure.svg',
              'violation.svg',
              'arrond.svg',
              'sect.svg',
              'role.svg',
              'admin.svg',
            ];
          });



      }
    }
  }


  @override
  initState(){
    super.initState();

    getListPages() ;
    if (kDebugMode) {
      print('home') ;
      print(widget.idRole) ;
    }

  }



  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).maybePop(); // Ferme le drawer si ouvert (mobile)
  }






  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    final double size = 25 ;
    final double sizeDrawer = 15 ;
    return Scaffold(
      appBar: NavigationAppBar(roleUser:widget.idRole),
      drawer: isMobile
          ? Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                  color: vert(),
                ),
                child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage('assets/logos/logo1.png'),
                    ),
                  ),
                  CustomText('TrashApp',),
                ],
              ),
            )),

            for (int i = 0; i < pages.length; i++)
              ListTile(
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    'assets/icons/${path[i]}',
                    height: sizeDrawer,
                    width: sizeDrawer,
                    semanticsLabel:  path[i],
                  ),
                ),
                title: Text(titles[i]),
                selected: i == _selectedIndex,
                onTap: () {
                  _onDestinationSelected(i);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      )
          : null,
      body: Row(
        children: [
          if (!isMobile)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onDestinationSelected,
              labelType: NavigationRailLabelType.all,
              destinations: [
                for (int i = 0; i < pages.length; i++)
                  NavigationRailDestination(
                    icon: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: SvgPicture.asset(
                        'assets/icons/${path[i]}',
                        height: size,
                        width: size,
                        color:noir(),
                        semanticsLabel: path[i],
                      ),
                    ),
                    label: Text(titles[i]),
                  ),
              ],
            ),
          const VerticalDivider(width: 1),
          Expanded(child:  pages[_selectedIndex]) ,
        ],
      ),

    );
  }
}


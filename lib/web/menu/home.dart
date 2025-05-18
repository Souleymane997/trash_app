// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trash_app/shared/colors.dart';
import 'package:trash_app/web/menu/dash/dashbord.dart';
import 'package:trash_app/web/menu/structure/structure.dart';
import 'package:trash_app/web/menu/users/users.dart';
import 'package:trash_app/web/menu/settings/arrondissement/arrond.dart';
import 'package:trash_app/web/menu/settings/role/role.dart';
import 'package:trash_app/web/menu/settings/secteur/secteur.dart';

import '../../shared/custom_text.dart';
import 'components/appbar.dart';


class AccueilPage extends StatefulWidget {
  const AccueilPage({super.key});

  @override
  State<AccueilPage> createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashbordPage(),
    UsersPage(),
    StructuresPage(),
    ArrondPage(),
    SecteurPage(),
    RolePage()
  ];

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
      appBar: NavigationAppBar(),
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
            ListTile(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  'assets/icons/dash.svg',
                  height: sizeDrawer,
                  width: sizeDrawer,
                  semanticsLabel: 'dash',
                ),
              ),
              title: const Text('Dashbord'),
              selected: _selectedIndex == 0,
              onTap: () => _onDestinationSelected(0),
            ),
            ListTile(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  'assets/icons/users.svg',
                  height: sizeDrawer,
                  width: sizeDrawer,
                  semanticsLabel: 'users',
                ),
              ),
              title: const Text('Users'),
              selected: _selectedIndex == 1,
              onTap: () => _onDestinationSelected(1),
            ),
            ListTile(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  'assets/icons/structure.svg',
                  height: sizeDrawer,
                  width: sizeDrawer,
                  semanticsLabel: 'structure',
                ),
              ),
              title: const Text('Structure'),
              selected: _selectedIndex == 2,
              onTap: () => _onDestinationSelected(2),
            ),
            ListTile(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  'assets/icons/arrond.svg',
                  height: sizeDrawer,
                  width: sizeDrawer,
                  semanticsLabel: 'arrond',
                ),
              ),
              title: const Text('Arrondissement'),
              selected: _selectedIndex == 3,
              onTap: () => _onDestinationSelected(3),
            ),
            ListTile(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  'assets/icons/sect.svg',
                  height: sizeDrawer,
                  width: sizeDrawer,
                  semanticsLabel: 'secteur',
                ),
              ),
              title: const Text('Secteur'),
              selected: _selectedIndex == 4,
              onTap: () => _onDestinationSelected(4),
            ),
            ListTile(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  'assets/icons/role.svg',
                  height: sizeDrawer,
                  width: sizeDrawer,
                  semanticsLabel: 'role',
                ),
              ),
              title: const Text('role'),
              selected: _selectedIndex == 5,
              onTap: () => _onDestinationSelected(5),
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
              labelType: NavigationRailLabelType.selected,
              elevation: 8,
              destinations: [
                NavigationRailDestination(
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: SvgPicture.asset(
                      'assets/icons/dash.svg',
                      height: size,
                      width: size,
                      color: noir(),
                      semanticsLabel: 'dash',
                    ),
                  ),
                  label: Text('Dashbord'),
                ),

                NavigationRailDestination(
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: SvgPicture.asset(
                      'assets/icons/users.svg',
                      height: size,
                      width: size,
                      color: noir(),
                      semanticsLabel: 'users',
                    ),
                  ),
                  label: Text('Users'),
                ),
                NavigationRailDestination(
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: SvgPicture.asset(
                      'assets/icons/structure.svg',
                      height: size,
                      width: size,
                      color: noir(),
                      semanticsLabel: 'structure',
                    ),
                  ),
                  label: Text('Structure'),
                ),
                NavigationRailDestination(
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: SvgPicture.asset(
                      'assets/icons/arrond.svg',
                      height: size,
                      width: size,
                      color: noir(),
                      semanticsLabel: 'arrond',
                    ),
                  ),
                  label: Text('Arrondissement'),
                ),
                NavigationRailDestination(
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: SvgPicture.asset(
                      'assets/icons/sect.svg',
                      height: size,
                      width: size,
                      color: noir(),
                      semanticsLabel: 'sect',
                    ),
                  ),
                  label: Text('Secteur'),
                ),
                NavigationRailDestination(
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: SvgPicture.asset(
                      'assets/icons/role.svg',
                      height: size,
                      width: size,
                      color: noir(),
                      semanticsLabel: 'role',
                    ),
                  ),
                  label: Text('Role'),
                ),
              ],
            ),
          const VerticalDivider(width: 1),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),

    );
  }
}


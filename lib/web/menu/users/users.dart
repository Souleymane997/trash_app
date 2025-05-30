import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intersperse/intersperse.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:trash_app/controllers/user_controller.dart';
import 'package:trash_app/models/users_model.dart';
import 'package:trash_app/web/menu/components/content_view.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import '../../../controllers/structures_controller.dart';
import '../../../models/structure_model.dart';
import '../../../shared/colors.dart';
import '../../../shared/custom_text.dart';
import '../components/page_header.dart';
import '../components/summary_card.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  late List<UserModel> list = [];
  late List<StructureModel> listStructure = [];
  bool isLoad = false ;
  int nbre = 0 ;
  int nbreStructure = 0 ;

  getList() async {
    List<UserModel> listUsers = await UserController().getUserWithArrondissement();
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
      SummaryCard(title: "Nombre d'Utilisateurs ", value: '$nbre'),
      SummaryCard(title: 'Nombre de Structure', value: '$nbreStructure'),
    ];

    return ContentView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeader(
              title: 'Dashboard',
              description: "Vue d'ensemble sur votre projet",
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
            Expanded(
              child: _TableView(list),
            ): Center(child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
              child: CircularProgressIndicator(),
            )),
          ],
        ));
  }
}



class _TableView extends StatelessWidget {
  const _TableView(this.listUsers);
  final List<UserModel> listUsers ;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
          CustomText("Liste vide !!", color: noir(),),
        ],
      ),);
    }

    return Card(
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
                label = 'Arrondissement';
              case 5:
                label = 'Adresse';
            }
          } else {
            final user = listUsers[rowIndex-1];
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
                label = user.arrondissement.toString();
              case 5:
                label = user.adresse.toString();
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
    );
  }
}


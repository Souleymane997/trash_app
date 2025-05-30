// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intersperse/intersperse.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:trash_app/controllers/role_controllers.dart';
import 'package:trash_app/models/role.dart';

import '../../../../shared/colors.dart';
import '../../../../shared/custom_text.dart';
import '../../components/content_view.dart';
import '../../components/page_header.dart';
import '../../components/summary_card.dart';
import 'add_role.dart';
import 'edit_role.dart';

class RolePage extends StatefulWidget {
  const RolePage({super.key});

  @override
  State<RolePage> createState() => _RolePageState();
}

class _RolePageState extends State<RolePage> {

  late List<RoleModel> listRoles = [];
  bool isLoad = false ;
  int nbre = 0 ;


  Future<void> openAddRoleDialog() async {
    final success = await showDialog<bool>(
      context: context,
      builder: (context) => AddRoleDialog(),
    );
    if (success == true) {
      getList();
    }
  }

  Future<void> openEditRoleDialog(RoleModel role) async {
    final success = await showDialog<bool>(
      context: context,
      builder: (context) => EditRoleDialog(role: role,),
    );
    if (success == true) {
      getList();
    }
  }

  getList() async {
    List<RoleModel> list = await RoleController().getListRoles() ;
    setState(() {
      listRoles = list ;
    });
    Timer(Duration(seconds: 2), () {
      setState(() {
        isLoad = true ;
        nbre = listRoles.length ;
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
      SummaryCard(title: "Nombre de Role", value: "$nbre"),
    ];
    return ContentView(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageHeader(
          title: 'Gestion des Roles',
          description: "Vue d'ensemble des Roles",
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
                onPressed: openAddRoleDialog ,
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
          child:  listView(listRoles),
        ) : Center(child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
          child: CircularProgressIndicator(),
        )),
      ],
    ));
  }

  Widget listView(List<RoleModel> listRoles){
    if(listRoles.isEmpty)
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
    return ListView.separated(
      itemCount: listRoles.length,
      itemBuilder: (context, index) {
        RoleModel role = listRoles[index] ;
        return GestureDetector(
          onTap:(){
            if (kDebugMode) {
              print(role.id.toString()) ;
            }
            openEditRoleDialog(role) ;
          } ,
          child: SizedBox(
            width: double.infinity,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${index+1}', style:TextStyle(fontSize: 20 , fontWeight: FontWeight.w700),),
                    Text(role.role, style:TextStyle(fontSize: 20 , fontWeight: FontWeight.w700),),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: SvgPicture.asset(
                        'assets/icons/role.svg',
                        height: 40,
                        width:40,
                        semanticsLabel: 'structure',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(),
    ) ;
  }
}




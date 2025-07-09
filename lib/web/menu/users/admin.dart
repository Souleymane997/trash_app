// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:trash_app/controllers/user_controller.dart';

import '../../../models/users_model.dart';
import '../../../shared/colors.dart';
import '../../../shared/custom_text.dart';
import '../components/content_view.dart';
import '../components/page_header.dart';
import 'add_admin.dart';
import 'edit_admin.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {


  late List<UserModel> listUsers = [];

  bool isLoad = false ;
  int nbre = 0 ;

  Future<void> openAddAdminDialog() async {
    final success = await showDialog<bool>(
      context: context,
      builder: (context) =>AddAdminDialog()
    );
    if (success == true) {
      getList();
    }
  }

  Future<void> openEditAdminDialog(UserModel item) async {
    final success = await showDialog<bool>(
      context: context,
      builder: (context) => EditAdminDialog(item: item,),
    );
    if (success == true) {
      getList();
    }
  }



  getList() async {
    List<UserModel> list = await  UserController().getAdminWithArrondissement() ;
    setState(() {
      listUsers = list ;
    });
    Timer(Duration(seconds: 2), () {
      setState(() {
        isLoad = true ;
        nbre = listUsers.length ;
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
    return ContentView(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageHeader(
          title: 'Gestion des Administrateurs',
          description: "Vue d'ensemble des Administrateurs",
        ),
        const Gap(16),
        
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
                onPressed:  openAddAdminDialog,
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
        listView(listUsers) : Center(child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
          child: CircularProgressIndicator(),
        )),

      ],
    ));
  }



  Widget listView(List<UserModel> list){
    if(list.isEmpty)
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
              semanticsLabel: 'empty',
            ),
          ),
          CustomText("Liste vide !!", color: noir(),) ,
        ],
      ) ,) ;
    }
    return ListView.separated(
      itemCount: list.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        UserModel user = list[index] ;
        return GestureDetector(
          onTap:(){
            if (kDebugMode) {
              print(user.id.toString()) ;
            }
            openEditAdminDialog(user) ;
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
                    Text(user.nom, style:TextStyle(fontSize: 20 , fontWeight: FontWeight.w700),),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: SvgPicture.asset(
                        'assets/icons/admin.svg',
                        height: 40,
                        width:40,
                        semanticsLabel: 'admin',
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

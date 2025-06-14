// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:trash_app/mobilephone/widgets/screens/home/app_infos.dart';
import 'package:trash_app/mobilephone/widgets/screens/home/user_infos.dart';



import '../../../../controllers/user_controller.dart';
import '../../../../models/users_model.dart';
import '../../../../shared/colors.dart';
import '../../../../shared/custom_text.dart';
import '../../../../shared/slidepage.dart';
import '../calendar/calendar.dart';
import '../infos/infos.dart';
import '../structure/structure.dart';
import '../violation/violation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key,});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool showMenu = false;
  bool showUser = false;
  UserModel user = UserModel(id: '', nom: "default", tel:'' , email: 'email', password: 'password', adresse: 'adresse', role: 'role', role_id: 1, arrondissement: 'arrondissement', arrondissement_id: 1 , secteur: "", secteur_id: 1);



  getUserData() async {
    UserModel? item = await UserController().getUserDetails();

    if(item!= null){
      setState(() {
        user = item;
        if (kDebugMode) {
          print(user.nom);
        }
      });
    }

  }

  Future<void> openUserBottomSheet() async {
    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: grisLight(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child:  UserInfos(user: user,),
      ),
    );
  }

  Future<void> openAppInfosBottomSheet() async {
    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: grisLight(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child:  AppInfos(),
      ),
    );
  }



  @override
  void initState() {
    super.initState();
    getUserData();
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: grisLight(),
      body: Stack(
          children: [
            homeContain(),
          ]
      ),
    );
  }


  Widget homeContain() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery
                .of(context)
                .size
                .height * 0.325,
            decoration: ShapeDecoration(
              color: const Color(0xFF009C7B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.04,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          openAppInfosBottomSheet() ;
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: SvgPicture.asset(
                            'assets/icons/Menu.svg',
                            height: 35,
                            width: 35,
                            semanticsLabel: 'Logo',
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          openUserBottomSheet() ;
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: SvgPicture.asset(
                            'assets/icons/person.svg',
                            height: 35,
                            width: 35,
                            semanticsLabel: 'person',
                          ),
                        ),
                      ),
                    ],),
                ),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/logos/logo1.png'),
                ),
                CustomText(
                  'Trash Track',
                  tex: 2.1,
                  textAlign: TextAlign.center,
                  family: 'Lobster',
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                   'Bienvenue ${user.nom} !!',
                  tex: 1.7,
                  color: noir(),
                  family: 'Lobster',
                  fontWeight: FontWeight.w400,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SvgPicture.asset(
                    'assets/icons/emoji.svg',
                    height: 33,
                    width: 33,
                    semanticsLabel: 'Logo',
                  ),
                ),
              ],
            ),
          ),

          Gap(30),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    cardMenu('Ma structure', 'structure.svg', StructurePage(idArrond: user.arrondissement_id,)),
                    cardMenu('Violation', 'violation.svg', ViolationPage())
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    cardMenu('Calendrier', 'calendar.svg', CalendarPage(idArrond: user.arrondissement_id,)),
                    cardMenu('Informations', 'infos.svg', InfosPage())
                  ],
                ),
              ),
            ],)


        ],
      ),
    );
  }

  Widget cardMenu(String title, String path, Widget x) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            SlideRightRoute(
                child: x,
                page: x,
                direction: AxisDirection.right)
        );
      },
      child: Container(
        width: 140,
        height: 120,
        decoration: ShapeDecoration(
          color: blanc(),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 0,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
            borderRadius: BorderRadius.circular(26),
          ),
          shadows: [
            BoxShadow(
              color: noir().withValues(alpha: 0.4),
              blurRadius: 4,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: SvgPicture.asset(
                'assets/icons/$path',
                height: 50,
                width: 50,
                semanticsLabel: 'Logo',
              ),
            ),

            CustomText(
              title,
              color: noir(),
              fontWeight: FontWeight.w500,
            ),

          ],),
      ),
    );
  }


}

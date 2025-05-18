import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


import '../../../../shared/colors.dart';
import '../../../../shared/custom_text.dart';
import '../../../../shared/slidepage.dart';
import '../../sign/login.dart';
import '../calendar/calendar.dart';
import '../infos/infos.dart';
import '../structure/structure.dart';
import '../violation/violation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final TextEditingController _searchController = TextEditingController();
  bool showMenu = false ;
  bool showUser = false ;


  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(Icons.search),
      filled: true,
      hintStyle: TextStyle(color: grisLight()),
      fillColor: blanc(),
      contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: noir()),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: vert(), width: 2),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty =  _searchController.text.trim().isEmpty;


    return Scaffold(
      backgroundColor: grisLight(),
      body: Stack(
        children: [
          homeContain(isEmpty) ,
          showUser ? Center(
            child:userPage()
          ) : Container(),
          showMenu ? Center(
              child: menuPage()
          ) : Container(),
  ]
      ),
    );
  }


  Widget homeContain(bool isEmpty){
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.325,
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {
                                showMenu = !showMenu ;
                              });
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
                            onTap: (){
                              setState(() {
                                showUser = !showUser ;
                              });

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
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  'Bienvenue !!   ',
                  tex: 2.1,
                  color: noir(),
                  family: 'Lobster',
                  fontWeight: FontWeight.w400,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SvgPicture.asset(
                    'assets/icons/emoji.svg',
                    height: 35,
                    width: 35,
                    semanticsLabel: 'Logo',
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30 , top: 20, bottom: 20),
            child: TextFormField(
              controller: _searchController,
              decoration: _inputDecoration("Rechercher une structure"),
              keyboardType:TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) return '';
                return null;
              },
            ),
          ),


          isEmpty ?  Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    cardMenu('Ma structure' , 'structure.svg', StructurePage()),
                    cardMenu('Violation' , 'violation.svg', ViolationPage())
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    cardMenu('Calendrier' , 'calendar.svg', CalendarPage()),
                    cardMenu('Informations' , 'infos.svg', InfosPage())
                  ],
                ),
              ),
            ],) :

          Container(
            width:  MediaQuery.of(context).size.width * 0.9,
            height: 80,
            decoration: ShapeDecoration(
              color: blanc(),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0xFF000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 5,),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CustomText(
                          'WendPanga Clean ',
                          color: noir(),
                          tex: TailleText(context).titre,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      CustomText(
                        'Ouagadougou , Zone 1',
                        color: noir(),
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w300,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 39,
                  height: 39,
                  decoration: ShapeDecoration(
                    color: vert(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(5),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SvgPicture.asset(
                      'assets/icons/reload.svg',
                      height: 50,
                      width: 50,
                      semanticsLabel: 'Logo',
                    ),
                  ),
                ),
              ],
            ),
          ) ,
        ],
      ),
    ) ;
  }



  Widget menuPage(){
      return Center(
        child: Container(
          decoration: ShapeDecoration(
            color: noir().withValues(alpha: 0.8) ,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.85,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: (){
                      setState(() {
                        showMenu = false ;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SvgPicture.asset(
                        'assets/icons/exit.svg',
                        height: 30,
                        width: 30,
                        semanticsLabel: 'person',
                      ),
                    ),
                  ),
                ],),
              CircleAvatar(
                radius: 45,
                backgroundImage: AssetImage('assets/logos/logo1.png'),
              ),
              CustomText(
                'Trash Track',
                tex: 2.0,
                textAlign: TextAlign.center,
                family: 'Lobster',
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 20,) ,

              CustomText('Trash Track est une solution innovante dédiée à la gestion du ramassage des ordures dans les arrondissements de Ouagadougou. \n\nGrâce à une plateforme intelligente, Trash Track optimise les tournées de collecte, assure un suivi en temps réel et améliore la propreté urbaine. \n\n',
              ),
              CustomText('Trash Track vise à rendre la ville plus propre, plus saine et plus agréable pour tous.'),
              Spacer() ,

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomText('Contactez-nous \n Téléphone : +226 70 00 00 00 \nEmail : contact@trashtrack.bf\n Adresse : Ouagadougou, Burkina Faso',
                  fontWeight: FontWeight.w700,
                ),
              ),



            ],
          ),
        ),
      );
  }

  Widget userPage() {
    TextEditingController phoneController = TextEditingController();
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    InputDecoration inputDecorationUser(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: blanc()),
        filled: true,
        hintStyle: TextStyle(color: blanc()),
        fillColor: vert(),
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: vert()),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: vert(), width: 2),
        ),
      );
    }


    return Center(
      child: Container(
        decoration: ShapeDecoration(
          color: noir().withValues(alpha: 0.8) ,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.85,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: (){
                    setState(() {
                      showUser = false ;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SvgPicture.asset(
                      'assets/icons/exit.svg',
                      height: 30,
                      width: 30,
                      semanticsLabel: 'person',
                    ),
                  ),
                ),
              ],),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: SvgPicture.asset(
                'assets/icons/person.svg',
                height: 100,
                width: 100,
                semanticsLabel: 'person',
              ),
            ),
            SizedBox(height: 20,) ,
            Padding(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.07, ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SvgPicture.asset(
                      'assets/icons/user.svg',
                      height: 15,
                      width: 15,
                      semanticsLabel: 'person',
                    ),
                  ),
                  CustomText("Username"),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextFormField(
                  controller: usernameController,
                  readOnly: true,
                  decoration: inputDecorationUser("Rasma 223"),
                  keyboardType:TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'lieu requis';
                    return null;
                  },
                ),
              ),
            ),

            SizedBox(height: 20,) ,
            Padding(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.07, ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SvgPicture.asset(
                      'assets/icons/pass.svg',
                      height: 15,
                      width: 15,
                      semanticsLabel: 'person',
                    ),
                  ),
                  CustomText("Mot de passe"),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextFormField(
                  controller: passwordController,
                  readOnly: true,
                  decoration: inputDecorationUser("*************"),
                  keyboardType:TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'pass requis';
                    return null;
                  },
                ),
              ),
            ),

            SizedBox(height: 20,) ,
            Padding(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.07, ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SvgPicture.asset(
                      'assets/icons/phone.svg',
                      height: 15,
                      width: 15,
                      semanticsLabel: 'person',
                    ),
                  ),
                  CustomText("Telephone"),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextFormField(
                  controller: phoneController,
                  readOnly: true,
                  decoration: inputDecorationUser("+226 45689559"),
                  keyboardType:TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'telephone requis';
                    return null;
                  },
                ),
              ),
            ),
            Spacer(),

            Container(
              padding: const EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width * 0.65,
              child: ElevatedButton(
                onPressed: (){

                  Navigator.pushReplacement(
                      context,
                      SlideRightRoute(
                          child: LoginPage(),
                          page: LoginPage(),
                          direction: AxisDirection.left)
                  );

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: redFonce(),
                  foregroundColor: blanc(),
                  padding: EdgeInsets.symmetric(horizontal: 45, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: redFonce(), width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText("Deconnexion", family: 'Inter', fontWeight: FontWeight.w500,),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SvgPicture.asset(
                        'assets/icons/logout.svg',
                        height:  MediaQuery.of(context).size.width * 0.05,
                        width: 20,
                        semanticsLabel: 'person',
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }



  Widget cardMenu(String title, String path, Widget x){
    return InkWell(
      onTap: (){
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
              width: 1,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
            borderRadius: BorderRadius.circular(26),
          ),
          shadows: [
            BoxShadow(
              color: noir(),
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

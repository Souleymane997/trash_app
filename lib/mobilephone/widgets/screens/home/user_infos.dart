// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trash_app/models/users_model.dart';

import '../../../../controllers/user_controller.dart';
import '../../../../shared/colors.dart';
import '../../../../shared/custom_text.dart';
import '../../../../shared/dialoguetoast.dart';
import '../../sign/login.dart';

class UserInfos extends StatefulWidget {
  const UserInfos({super.key, required this.user});
  final UserModel user ;

  @override
  State<UserInfos> createState() => _UserInfosState();
}

class _UserInfosState extends State<UserInfos> {

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


  @override
  void initState() {
    super.initState();
    phoneController.text = widget.user.tel;
    usernameController.text = widget.user.nom;
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SvgPicture.asset(
                    'assets/icons/exit.svg',
                    height: 30,
                    width: 30,
                    color: redFonce(),
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
              color: vert(),
              semanticsLabel: 'person',
            ),
          ),
          SizedBox(height: 20,),

          Padding(
            padding: EdgeInsets.only(left: MediaQuery
                .of(context)
                .size
                .width * 0.07,),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SvgPicture.asset(
                    'assets/icons/user.svg',
                    height: 15,
                    width: 15,
                    color: vert(),
                    semanticsLabel: 'person',
                  ),
                ),
                CustomText("Nom & Prenom" , color: vert(),),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.7,
              child: TextFormField(
                controller: usernameController,
                readOnly: true,
                style: TextStyle(
                  color:blanc(), // Couleur du texte
                ),
                decoration: inputDecorationUser(""),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) return '';
                  return null;
                },
              ),
            ),
          ),

          SizedBox(height: 15,),
          Padding(
            padding: EdgeInsets.only(left: MediaQuery
                .of(context)
                .size
                .width * 0.07,),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SvgPicture.asset(
                    'assets/icons/pass.svg',
                    height: 15,
                    width: 15,
                    color: vert(),
                    semanticsLabel: 'person',
                  ),
                ),
                CustomText("Mot de passe" , color: vert(),),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.7,
              child: TextFormField(
                controller: passwordController,
                readOnly: true,
                decoration: inputDecorationUser("*************"),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'pass requis';
                  return null;
                },
              ),
            ),
          ),

          SizedBox(height: 15,),
          Padding(
            padding: EdgeInsets.only(left: MediaQuery
                .of(context)
                .size
                .width * 0.07,),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SvgPicture.asset(
                    'assets/icons/phone.svg',
                    height: 15,
                    width: 15,
                    color: vert(),
                    semanticsLabel: 'person',
                  ),
                ),
                CustomText("Telephone",color: vert(),),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.7,
              child: TextFormField(
                controller: phoneController,
                readOnly: true,
                style: TextStyle(
                  color:blanc(), // Couleur du texte
                ),
                decoration: inputDecorationUser(""),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'telephone requis';
                  }
                  return null;
                },
              ),
            ),
          ),

         Gap(30),
          Container(
            padding: const EdgeInsets.all(10.0),
            width: MediaQuery
                .of(context)
                .size
                .width * 0.65,
            child: ElevatedButton(
              onPressed: () async {
                showLoadingDialog(context) ;

                bool res = await UserController().logout();
                final prefs = await SharedPreferences.getInstance();
                if (res) {
                  await prefs.setInt('idRole', 0);

                  DInfo.toastError("vous êtes deconnecté");
                  Navigator.pop(context, true);
                  Timer(Duration(milliseconds: 500), () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (
                          context) => const LoginPage()),
                          (Route<dynamic> route) => false,
                    );
                  });
                } else {
                  Navigator.pop(context, true);
                  DInfo.toastError("erreur");
                }
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
                  CustomText("Deconnexion", family: 'Inter',
                    fontWeight: FontWeight.w500,),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SvgPicture.asset(
                      'assets/icons/logout.svg',
                      height: MediaQuery
                          .of(context)
                          .size
                          .width * 0.05,
                      width: 20,
                      semanticsLabel: 'person',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(height: 20,)

        ],
      ),
    ) ;
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return  AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Center(
            child: SpinKitCircle(
              color: vert(),
              size: 50.0,
            ),
          ),
        );
      },
    );
  }
}

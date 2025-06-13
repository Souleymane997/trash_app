// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:trash_app/controllers/user_controller.dart';
import 'package:trash_app/models/users_model.dart';

import '../../../../shared/colors.dart';
import '../../../../shared/custom_text.dart';
import '../../../controllers/arrond_controllers.dart';
import '../../../models/arrondissement.dart';

class AddAdminDialog extends StatefulWidget {
  const AddAdminDialog({super.key});


  @override
  State<AddAdminDialog > createState() => _AddAdminDialogState();
}

class _AddAdminDialogState extends State<AddAdminDialog> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _adresseController = TextEditingController();

  bool isLoad = true ;


  late List<ArrondissementModel> listArrond = [] ;
  ArrondissementModel? selectedArrondissement;




  getListArrond() async {
    List<ArrondissementModel> list = await ArrondController().getListArrondissement();
    setState(() {
      listArrond= list ;
    });
  }

  @override
  void initState() {
    super.initState();
    getListArrond() ;
  }


  _submit() async {
    setState(() {
      isLoad = false ;
    });

    int idArrond = selectedArrondissement?.id ?? 0 ;

    UserModel item = UserModel(id: "1", nom: _usernameController.text, tel: _phoneController.text, email: _emailController.text, password: _passwordController.text, adresse: _adresseController.text, role: '', role_id:3, arrondissement:'', arrondissement_id: idArrond , secteur: "",
      secteur_id: 1) ;

    bool res = await UserController().signUpUser(item: item , email: _emailController.text ,) ;

    if (kDebugMode) {
      print(res.toString()) ;
    }

    if(res){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nouvel Admin Ajouté') , backgroundColor: vert(),),
      );
      Timer(Duration(seconds: 2), () {
        setState(() {
          isLoad = true ;
        });
        Navigator.pop(context, true);
      });

    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur') , backgroundColor: red(),),
      );
    }
  }



  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      hintText: label,
      filled: true,
      hintStyle: TextStyle(color: gris(),),
      fillColor: blanc(),
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
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
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: CustomText('Ajouter un Administrateur', color: vert(),fontWeight: FontWeight.w700,tex: 1.5,)),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: (MediaQuery.of(context).size.width > 500 )?MediaQuery.of(context).size.height * 0.35 : 300,
                  child: TextFormField(
                    textAlign: TextAlign.start,
                    controller: _usernameController,
                    decoration: _inputDecoration("username"),
                    keyboardType:TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'username requis';
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: (MediaQuery.of(context).size.width > 500 )?MediaQuery.of(context).size.height * 0.35 : 300,
                  child: TextFormField(
                    textAlign: TextAlign.start,
                    controller: _adresseController,
                    decoration: _inputDecoration("adresse"),
                    keyboardType:TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'adresse requis';
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: (MediaQuery.of(context).size.width > 500 )?MediaQuery.of(context).size.height * 0.35 : 300,
                  child: TextFormField(
                    textAlign: TextAlign.start,
                    controller: _emailController,
                    decoration: _inputDecoration("email"),
                    keyboardType:TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'email requis';
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: (MediaQuery.of(context).size.width > 500 )?MediaQuery.of(context).size.height * 0.35 : 300,
                  child: TextFormField(
                    textAlign: TextAlign.start,
                    controller: _passwordController,
                    obscureText: true,
                    decoration: _inputDecoration("password"),
                    keyboardType:TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'password requis';
                      if (value.length < 6) return '6 caractères minimum';
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                IntlPhoneField(
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Téléphone',
                    contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: vert()),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: vert(), width: 2),
                    ),
                    filled: true,
                    fillColor: blanc(),
                  ),
                  initialCountryCode: 'BF', // Code pays par défaut
                  onSaved: (phone) {
                    _phoneController.text = phone!.number;
                    if (kDebugMode) {
                      print('Numéro complet : ${_phoneController.text}');
                    }
                  },
                ),
                SizedBox(height: 8),
                CustomDropdown<ArrondissementModel>(
                  hintText: 'Arrondissement',
                  decoration: CustomDropdownDecoration(
                    closedBorder: Border.all(
                      color: vert(),
                      width: 1.0,
                    ),
                  ),
                  items: listArrond,
                  initialItem: selectedArrondissement,
                  onChanged: (value) {
                    setState(() {
                      selectedArrondissement = value;
                    });
                    debugPrint("Arrondissement sélectionné : ${value?.arrondissement}");
                  },
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
      actions: [
        isLoad ?
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            Gap(8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: vert(),
                foregroundColor: blanc(),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: vert(), width: 1),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()  && selectedArrondissement!.arrondissement.isNotEmpty && _phoneController.text.isNotEmpty) {
                  _submit() ;
                }
              },
              child: const Text('valider'),
            ),
          ],
        ) : Center(
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: CircularProgressIndicator(),
          ),
        ),

      ],
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:trash_app/controllers/arrond_controllers.dart';
import 'package:trash_app/controllers/structures_controller.dart';
import 'package:trash_app/models/arrondissement.dart';
import 'package:trash_app/models/structure_model.dart';


import '../../../../shared/colors.dart';
import '../../../../shared/custom_text.dart';

class AddStructureDialog extends StatefulWidget {
  const AddStructureDialog({super.key});


  @override
  State<AddStructureDialog> createState() => _AddStructureDialogState();
}

class _AddStructureDialogState extends State<AddStructureDialog> {
  final _formKey = GlobalKey<FormState>();
  final nomStructureController = TextEditingController() ;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();


  bool isLoad = true ;
  bool valid = false ;
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

      StructureModel item = StructureModel(id: "1",nomStructure: nomStructureController.text, tel: phoneController.text, arrondissement_id: idArrond, arrondissement:"", email: emailController.text, password: passwordController.text, role_id: 2) ;
      bool res = await StructureController().addAStructure(item);

      if (kDebugMode) {
        print(res.toString()) ;
      }


      if(res){

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Structure Ajouté') , backgroundColor: vert(),),
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
      title: Center(child: CustomText('Ajouter Structure ', color: vert(),fontWeight: FontWeight.w700,tex: 1.5,)),
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
                    controller: nomStructureController,
                    decoration: _inputDecoration("structure"),
                    keyboardType:TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'structure requis';
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: (MediaQuery.of(context).size.width > 500 )?MediaQuery.of(context).size.height * 0.35 : 300,
                  child: TextFormField(
                    textAlign: TextAlign.start,
                    controller: emailController,
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
                    controller: passwordController,
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
                  controller: phoneController,
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
                      phoneController.text = phone!.number;
                    if (kDebugMode) {
                      print('Numéro complet : ${phoneController.text}');
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
                if (_formKey.currentState!.validate() && selectedArrondissement!.arrondissement.isNotEmpty && phoneController.text.isNotEmpty ) {
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

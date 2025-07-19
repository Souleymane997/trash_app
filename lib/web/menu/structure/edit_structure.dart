// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trash_app/controllers/structures_controller.dart';
import 'package:trash_app/controllers/user_controller.dart';
import 'package:trash_app/models/structure_model.dart';

import '../../../../controllers/arrond_controllers.dart';
import '../../../../models/arrondissement.dart';
import '../../../../shared/colors.dart';
import '../../../../shared/custom_text.dart';
import '../../../models/users_model.dart';

class EditStructureDialog extends StatefulWidget {
  const EditStructureDialog({super.key, required this.item});
  final StructureModel item ;


  @override
  State<EditStructureDialog > createState() => _EditStructureDialogState();
}

class _EditStructureDialogState extends State<EditStructureDialog> {

  final _formKey = GlobalKey<FormState>();
  final nomStructureController = TextEditingController() ;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();


  int idArrond = 0 ;
  bool _obscureText = true;
  bool isLoad = true ;
  bool isDelete = false ;

  late List<ArrondissementModel> listArrond = [] ;
  ArrondissementModel? selectedArrondissement;

  getListArrond() async {
    List<ArrondissementModel> list = await ArrondController().getListArrondissement();
    setState(() {
      listArrond= list ;
    });

    for (int i = 0; i < listArrond.length; i++) {
      if(listArrond[i].id == widget.item.arrondissement_id){
        setState(() {
          selectedArrondissement = listArrond[i] ;
          idArrond = listArrond[i].id! ;
        });
        break ;

      }
    }
  }


  @override
  void initState() {
    super.initState();
    nomStructureController.text = widget.item.nomStructure;
    emailController.text = widget.item.email;
    phoneController.text = widget.item.tel;
    passwordController.text = widget.item.password;

    getListArrond() ;
  }

  _delete(String id) async {
    setState(() {
      isLoad = false ;
    });

    final supabase = Supabase.instance.client;
    await supabase.from('programme').delete().eq('structure_id',widget.item.id );


    List<UserModel> listUsers = await UserController().getUserWithArrondissement(idArrond: widget.item.arrondissement_id);




      for(int i = 0 ; i<listUsers.length; i++){
        await UserController().deleteUserByStruct(listUsers[i].id) ;
      }

      await UserController().deleteUserByStructure(widget.item.arrondissement_id) ;

      bool res = await StructureController().deleteStructure(id);
      if (kDebugMode) {
        print(res.toString()) ;
      }

      if(res){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Structure Supprimé') , backgroundColor: vert(),),
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


  _submit( String id) async {
    setState(() {
      isLoad = false ;
    });

    idArrond = selectedArrondissement?.id ?? 0 ;

    StructureModel item = StructureModel( id:"1" ,nomStructure: nomStructureController.text, tel: phoneController.text, arrondissement_id: idArrond, arrondissement:"", email: emailController.text, password: passwordController.text, role_id: 2) ;

    bool res = await StructureController().editStructure(id: id, item: item) ;
    if (kDebugMode) {
      print(res.toString()) ;
    }

    if(res){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Structure modifié') , backgroundColor: vert(),),
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
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isDelete?Center(child: CustomText('Supprimer Structure', color: vert(),fontWeight: FontWeight.w700,tex: 1.5,)): Center(child: CustomText('Modifier Structure', color: vert(),fontWeight: FontWeight.w700,tex: 1.5,)),
          SizedBox(width: 10,) ,
          IconButton(onPressed: (){ setState(() {
            isDelete = !isDelete ;
          });  },icon: Icon(Icons.delete , color:isDelete? grisFonce(): redFonce() ,))
        ],
      ),
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
                    decoration: _inputDecoration("Structure"),
                    keyboardType:TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Structure requis';
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
                    obscureText: _obscureText,
                    decoration: _inputDecoration("password").copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed:
                            () => setState(
                              () => _obscureText = !_obscureText,
                        ),
                      ),
                    ),
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
                  onChanged: (phone) {
                    phoneController.text = phone.number;
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
        ( isLoad )?

        isDelete?
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: red(),
                  foregroundColor: blanc(),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: red(), width: 1),
                  ),
                ),
                onPressed: () {

                    _delete(widget.item.id) ;

                },
                child: const Text('Confirmer suppression'),
              ),
              Gap(8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),

            ],
          ),
        ) :
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
                if (_formKey.currentState!.validate()) {
                  _submit(widget.item.id) ;
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

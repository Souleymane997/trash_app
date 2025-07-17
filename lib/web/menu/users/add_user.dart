// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../controllers/arrond_controllers.dart';
import '../../../controllers/secteur_controllers.dart';
import '../../../controllers/user_controller.dart';
import '../../../models/arrondissement.dart';
import '../../../models/secteur.dart';
import '../../../models/users_model.dart';
import '../../../shared/colors.dart';
import '../../../shared/custom_text.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key, required this.idArrond,});
  final int idArrond ;

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _adresseController = TextEditingController();

  bool _obscureText = true;
  late List<ArrondissementModel> listArrond = [];
  ArrondissementModel? selectedArrondissement;

  late List<SecteurModel> listSecteurs = [];
  late List<SecteurModel> listSecteursWithArrond = [];
  SecteurModel? selectedSecteur;

  bool isLoad = true ;

  getListArrond() async {
    List<ArrondissementModel> list =
    await ArrondController().getListArrondissement();
    setState(() {
      listArrond = list;
    });

    for(int i=0 ; i< listArrond.length; i++){
      if(widget.idArrond == listArrond[i].id){
        setState(() {
          selectedArrondissement = listArrond[i] ;
        });

      }
    }
    getListSecteur();
  }

  getListSecteur() async {
    List<SecteurModel> list = await SecteurController().getListSecteur();
    setState(() {
      listSecteurs = list;
    });

    if (selectedArrondissement != null) {
      listSecteursWithArrond =
          listSecteurs
              .where(
                (secteur) =>
            secteur.arrondissement_id ==
                selectedArrondissement!.id,
          )
              .toList();
    } else {
      listSecteursWithArrond = [];
    }

  }

  @override
  void initState() {
    super.initState();
    getListArrond();
  }

  _submit() async {
    setState(() {
      isLoad = false;
    });

    int idArrond = selectedArrondissement?.id ?? 0;
    int idSecteur = selectedSecteur?.id ?? 0;
    String email = "user${_phoneController.text.trim()}@exemple.com";

    UserModel item = UserModel(
        id: "1",
        nom: _usernameController.text,
        tel: _phoneController.text.trim(),
        email: email,
        password: _passwordController.text,
        adresse: _adresseController.text,
        role: '',
        role_id: 1,
        arrondissement: '',
        arrondissement_id: idArrond,
        secteur: "",
        secteur_id: idSecteur
    );

    bool res = await UserController().signUpUser(item: item, email: email);

    if (kDebugMode) {
      print(res.toString());
    }

    if (res) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nouvel Utilisateur Ajouté') , backgroundColor: vert(),),
      );
      Timer(Duration(seconds: 2), () {
        setState(() {
          isLoad = true ;
        });
        Navigator.pop(context, true);
      });

    } else {
      setState(() {
        isLoad = true ;
      });
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
      title: Center(child: CustomText('Ajouter Utilisateur ', color: vert(),fontWeight: FontWeight.w700,tex: 1.5,)),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _usernameController,
                    decoration: _inputDecoration("Nom & prenoms"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'nom & prenoms requis';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _adresseController,
                    decoration: _inputDecoration("Adresse"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Adresse requis';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  IntlPhoneField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Téléphone',
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
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
                      if (kDebugMode) {
                        print('Numéro complet : ${phone.completeNumber}');
                      }
                    },
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: "Mot de passe",
                      filled: true,
                      hintStyle: TextStyle(color: grisLight()),
                      fillColor: blanc(),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: vert()),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: vert(), width: 2),
                      ),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Mot de passe requis';
                      }
                      if (value.length < 6) return '6 caractères minimum';
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  CustomDropdown<ArrondissementModel>(
                    hintText: 'Arrondissement',
                    decoration: CustomDropdownDecoration(
                      closedBorder: Border.all(color: vert(), width: 1.0),
                    ),
                    items: listArrond,
                    initialItem: selectedArrondissement,
                    onChanged: (value) {
                      setState(() {
                        selectedArrondissement = value;
                        selectedSecteur =
                        null; // Reset selected secteur when arrondissement changes
                        if (selectedArrondissement != null) {
                          listSecteursWithArrond =
                              listSecteurs
                                  .where(
                                    (secteur) =>
                                secteur.arrondissement_id ==
                                    selectedArrondissement!.id,
                              )
                                  .toList();
                        } else {
                          listSecteursWithArrond = [];
                        }
                      });
                      debugPrint(
                        "Arrondissement sélectionné : ${value?.arrondissement}",
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  CustomDropdown<SecteurModel>(
                    hintText: 'Secteur',
                    enabled:
                    selectedArrondissement !=
                        null, // Enable only if arrondissement is selected
                    decoration: CustomDropdownDecoration(
                      closedBorder: Border.all(color: vert(), width: 1.0),
                    ),
                    items: listSecteursWithArrond,
                    initialItem: selectedSecteur,
                    onChanged: (value) {
                      setState(() {
                        selectedSecteur = value;
                      });
                      debugPrint(
                        "Secteur sélectionné : ${value?.secteur}",
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        isLoad ?
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                if (_formKey.currentState!.validate() &&
                    selectedArrondissement!.arrondissement.isNotEmpty && selectedSecteur!.secteur.isNotEmpty &&
                    _phoneController.text.isNotEmpty) {
                  _submit();
                }
              },
              child: const Text('valider'),
            ),
            Gap(8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
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

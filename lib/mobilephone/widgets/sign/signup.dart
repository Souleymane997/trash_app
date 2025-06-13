import 'dart:async';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../controllers/arrond_controllers.dart';
import '../../../controllers/secteur_controllers.dart';
import '../../../controllers/user_controller.dart';
import '../../../models/arrondissement.dart';
import '../../../models/secteur.dart';
import '../../../models/users_model.dart';
import '../../../shared/colors.dart';
import '../../../shared/custom_text.dart';
import '../../../shared/dialoguetoast.dart';
import '../../../shared/loading.dart';
import '../../../shared/slidepage.dart';
import 'login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _adresseController = TextEditingController();

  bool _obscureText = true;
  bool isLoad = false;
  late List<ArrondissementModel> listArrond = [];
  ArrondissementModel? selectedArrondissement;

  late List<SecteurModel> listSecteurs = [];
  late List<SecteurModel> listSecteursWithArrond = [];
  SecteurModel? selectedSecteur;

  getListArrond() async {
    List<ArrondissementModel> list =
        await ArrondController().getListArrondissement();
    setState(() {
      listArrond = list;
    });
  }

  getListSecteur() async {
    List<SecteurModel> list = await SecteurController().getListSecteur();
    setState(() {
      listSecteurs = list;
    });
    
  }

  @override
  void initState() {
    super.initState();
    getListArrond();
    getListSecteur();
  }

  _submit() async {
    setState(() {
      isLoad = true;
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
      DInfo.toastSuccess("Enregistrement éffectué");
      Timer(Duration(seconds: 2), () {
        setState(() {
          isLoad = false;
        });
        Navigator.pushReplacement(
          context,
          SlideRightRoute(
            child: LoginPage(),
            page: LoginPage(),
            direction: AxisDirection.right,
          ),
        );
      });
    } else {
      DInfo.toastError("une erreur survenue");
      setState(() {
        isLoad = false;
      });
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      hintStyle: TextStyle(color: grisLight()),
      fillColor: blanc(),
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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: grisLight(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              left: 16,
              right: 16,
              top: MediaQuery.of(context).size.height * 0.12,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/logos/logo1.png'),
                ),
                SizedBox(height: 14),
                Center(
                  child: CustomText(
                    "S'enregistrer ",
                    family: 'Inter',
                    tex: 1.5,
                    color: vert(),
                    fontWeight: FontWeight.w700,
                  ),
                ),

                Padding(
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

                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        selectedArrondissement!.arrondissement.isNotEmpty && selectedSecteur!.secteur.isNotEmpty &&
                        _phoneController.text.isNotEmpty) {
                      _submit();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: vert(),
                    foregroundColor: blanc(),
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: vert(), width: 1),
                    ),
                  ),
                  child: CustomText(
                    "S'enregistrer",
                    family: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText('Pas de compte ?', color: vert()),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          SlideRightRoute(
                            child: LoginPage(),
                            page: LoginPage(),
                            direction: AxisDirection.left,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomText(
                          ' Se connecter ',
                          color: vert(),
                          tex: 1.2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          isLoad ? Loading() : Container(),
        ],
      ),
    );
  }
}

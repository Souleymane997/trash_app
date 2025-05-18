import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../shared/colors.dart';
import '../../../shared/custom_text.dart';
import '../../../shared/slidepage.dart';
import 'login.dart';
import 'secteur.dart';

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
  final _confirmController = TextEditingController();


  final List<String> listArrond = [
    'Arrondissement 1',
    'Arrondissement 2',
    'Arrondissement 3',
  ];

  final List<String> listSecteur = [
    'Secteur 1',
    'Secteur 2',
    'Secteur 3',
  ];

  String? selectedArrondissement ;
  String? selectedSecteur ;

  void _submit() {
    if (_formKey.currentState!.validate()) {


      if (kDebugMode) {
        print("Email : ${_usernameController.text}");
        print("Mot de passe : ${_passwordController.text}");
        print("confirm Mot de passe : ${_confirmController.text}");
        print("telephone : ${_phoneController.text}");
      }

      Navigator.pushReplacement(
          context,
          SlideRightRoute(
              child: SecteurPage(),
              page: SecteurPage(),
              direction: AxisDirection.left)
      );
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
      body: SingleChildScrollView(
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
            SizedBox(height: 14,),
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
                      decoration: _inputDecoration("Username"),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Username requis';
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    IntlPhoneField(
                      controller: _phoneController,
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
                        if (kDebugMode) {
                          print('Numéro complet : ${phone.completeNumber}');
                        }
                      },
                    ),
                    SizedBox(height: 8),
                    CustomDropdown<String>(
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
                          selectedArrondissement = value ;
                          debugPrint('changing value to: $selectedArrondissement');
                        });
                      },
                    ),
                    SizedBox(height: 8),
                    CustomDropdown<String>(
                      hintText: 'Secteur',
                      decoration: CustomDropdownDecoration(
                        closedBorder: Border.all(
                          color: vert(),
                          width: 1.0,
                        ),
                      ),
                      items: listSecteur,
                      initialItem: selectedSecteur,
                      onChanged: (value) {
                        setState(() {
                          selectedSecteur = value ;
                          debugPrint('changing value to: $selectedSecteur');
                        });
                      },
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: _inputDecoration("Mot de passe"),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Mot de passe requis';
                        if (value.length < 6) return '6 caractères minimum';
                        return null;
                      },
                    ),
                    // SizedBox(height: 20),
                    // TextFormField(
                    //   controller: _confirmController,
                    //   obscureText: true,
                    //   decoration: _inputDecoration("Confirme le mot de passe"),
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) return 'Mot de passe requis';
                    //     if (value.length < 6) return '6 caractères minimum';
                    //     return null;
                    //   },
                    // ),
                  ],
                ),
        
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomText(
                  'Mot de passe oublié ?',
                  family: 'Poppins',
                  color: vert(),
                ),
                SizedBox(width: 13),
              ],
            ),
        
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: vert(),
                foregroundColor: blanc(),
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: vert(), width: 1),
                ),
              ),
              child: CustomText("S'enregistrer", family: 'Inter', fontWeight: FontWeight.w500,),
            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  'Pas de compte ?',
                  color: vert(),
                ),
                InkWell(
                  onTap:(){
                      Navigator.pushReplacement(
                          context,
                          SlideRightRoute(
                              child: LoginPage(),
                              page: LoginPage(),
                              direction: AxisDirection.left)
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
    ) ;
  }
}

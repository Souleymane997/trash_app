import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../shared/colors.dart';
import '../../../shared/custom_text.dart';
import '../../../shared/slidepage.dart';
import 'login.dart';

class Forget extends StatefulWidget {
  const Forget({super.key});

  @override
  State<Forget> createState() => _ForgetState();
}

class _ForgetState extends State<Forget> {

  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (kDebugMode) {
        print("phone : ${_phoneController.text}");
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grisLight(),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 16,
          right: 16,
          top: MediaQuery.of(context).size.height * 0.2,
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
                'Mot de Passe Oublié ',
                family: 'Inter',
                tex: 1.5,
                color: vert(),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  ' Renitialiser votre mot de passe ici ',
                  tex: TailleText(context).contenu  ,
                  color: vert(),
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                    SizedBox(height: 20),
                  ],
                ),

              ),
            ),


            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: vert(),
                    foregroundColor: blanc(),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: vert(), width: 1),
                    ),
                  ),
                  child: CustomText("Suivant", family: 'Inter', fontWeight: FontWeight.w500,),
                ),
                SizedBox(width: 30,),

                ElevatedButton(
                  onPressed: (){
                    Navigator.pushReplacement(
                        context,
                        SlideRightRoute(
                            child: LoginPage(),
                            page: LoginPage(),
                            direction: AxisDirection.right)
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gris(),
                    foregroundColor: blanc(),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: noir(), width: 1),
                    ),
                  ),
                  child: CustomText("Retour", color: noir(),family: 'Inter', fontWeight: FontWeight.w500,),
                ),
              ],
            ),
            SizedBox(height: 30,),
          ],
        ),
      ),
    ) ;
  }
}

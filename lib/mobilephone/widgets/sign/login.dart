import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../shared/colors.dart';
import '../../../shared/custom_text.dart';
import '../../../shared/slidepage.dart';
import '../screens/home/home.dart';
import 'forget.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {

      if (kDebugMode) {
        print("Mot de passe : ${_passwordController.text}");
        print("Email : ${_usernameController.text}");
      }

      Navigator.pushReplacement(
          context,
          SlideRightRoute(
              child: HomePage(),
              page: HomePage(),
              direction: AxisDirection.right)
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
                'Se Connecter ',
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
                      keyboardType:TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Username requis';
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      keyboardType:TextInputType.text,
                      decoration: _inputDecoration("Mot de passe"),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Mot de passe requis';
                        if (value.length < 6) return '6 caractères minimum';
                        return null;
                      },
                    ),
                  ],
                ),

              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.pushReplacement(
                        context,
                        SlideRightRoute(
                            child: Forget(),
                            page: Forget(),
                            direction: AxisDirection.right)
                    );
                  },
                  child: CustomText(
                    'Mot de passe oublié ?',
                    family: 'Poppins',
                    color: vert(),
                  ),
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
              child: CustomText("Se connecter", family: 'Inter', fontWeight: FontWeight.w500,),
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
                            child: SignupPage(),
                            page: SignupPage(),
                            direction: AxisDirection.right)
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomText(
                      ' S’enregistrer ',
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

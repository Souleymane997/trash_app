import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../shared/colors.dart';
import '../../shared/custom_text.dart';
import '../../shared/slidepage.dart';
import '../menu/home.dart';



class LoginWeb extends StatefulWidget {
  const LoginWeb({super.key});

  @override
  State<LoginWeb> createState() => _LoginWebState();
}

class _LoginWebState extends State<LoginWeb> {

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscureText = true;
  bool change = false ;
  int _seconds = 3;
  late Timer _timer;

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      hintStyle: TextStyle(color: grisLight()),
      fillColor: blanc(),
      contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: vert()),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: vert(), width: 2),
      ),
    );
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      setState(() {
        change = true ;
      });

      if (kDebugMode) {
        print('Email: $email | Password: $password');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connexion en cours...') , backgroundColor: vert(),),
      );

      _startCountdown() ;


    }
  }


  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 1) {
          _seconds--;
        } else {
          _timer.cancel();
          _navigateToNextPage();
        }
      });
    });
  }

  void _navigateToNextPage() {
    Navigator.pushReplacement(
        context,
        SlideRightRoute(
            child: AccueilPage(),
            page:AccueilPage(),
            direction: AxisDirection.left)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grisLight(),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
          child: Card(
            elevation: 20,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _emailController,
                      decoration: _inputDecoration("Email"),
                      keyboardType:TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Email requis';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    // Email
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      keyboardType:TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        filled: true,
                        hintStyle: TextStyle(color: grisLight()),
                        fillColor: blanc(),
                        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: vert()),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: vert(), width: 2),
                        ),
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                            _obscureText ? Icons.visibility : Icons.visibility_off),
                        onPressed: () =>
                            setState(() => _obscureText = !_obscureText),
                      ),
                    ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Mot de passe requis';
                        if (value.length < 6) return '6 caractères minimum';
                        return null;
                      },
                    ),

                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: vert(),
                        foregroundColor: blanc(),
                        padding: EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(color: vert(), width: 1),
                        ),
                      ),
                      child:change ? CircularProgressIndicator(color: blanc()) : CustomText("Se connecter", family: 'Inter', fontWeight: FontWeight.w500,),
                    ),
                    SizedBox(height: 30,),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


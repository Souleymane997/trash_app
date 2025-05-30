// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


import '../../shared/colors.dart';
import '../../shared/custom_text.dart';
import '../../shared/slidepage.dart';
import 'sign/login.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool showLoading = false;


  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        showLoading = true;
      });

      Future.delayed(Duration(seconds: 5), () {
        Navigator.pushReplacement(
          context,
            SlideRightRoute(
                child: LoginPage(),
                page: LoginPage(),
                direction: AxisDirection.right)
        );
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 428,
        height: 926,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: const Color(0xFF009C7B)),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/logos/logo2.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                CustomText(
                  'Trash Track',
                  tex: 2.1,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                  family: "Lobster",
                ),
              ],
            ),

            SizedBox(height: 20),
            if (showLoading)
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: SpinKitCircle(
                      color: blanc(),
                      size: 30.0,
                    ),
                  ),
                  Container(
                    height: 40,
                  )
                ],
              )

          ],
        ),
      ),
    ) ;
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../shared/colors.dart';
import '../../../../shared/custom_text.dart';
import '../../../../shared/slidepage.dart';
import '../home/home.dart';

class SendPage extends StatefulWidget {
  const SendPage({super.key});

  @override
  State<SendPage> createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  int _seconds = 5;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
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
            child: HomePage(),
            page:HomePage(),
            direction: AxisDirection.left)
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grisLight(),
      appBar: AppBar(
        title: CustomText(""),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: vert(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(height: MediaQuery.of(context).size.height * 0.15,),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: SvgPicture.asset(
                'assets/icons/structure.svg',
                height: 80,
                width: 80,
                semanticsLabel: 'str',
              ),
            ),
            CustomText(
              'Requête envoyée avec Succès   ',
                color: vert(),
                family: 'Poppins',
                fontWeight: FontWeight.w700,

            ),
            Container(height: MediaQuery.of(context).size.height * 0.05,),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SvgPicture.asset(
                'assets/icons/check.svg',
                height: 150,
                width: 150,
                semanticsLabel: 'str',
              ),
            ),

            CustomText(
              'Vous serez  rediriger  vers une \nautre page  dans $_seconds...\n',
              textAlign: TextAlign.center,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),


          ],
        ),
      ),
    );
  }
}

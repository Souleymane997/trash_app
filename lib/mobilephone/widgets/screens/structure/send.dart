import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trash_app/controllers/requete_controller.dart';
import 'package:trash_app/shared/dialoguetoast.dart';
import '../../../../shared/colors.dart';
import '../../../../shared/custom_text.dart';
import '../../../../shared/loading.dart';
import '../../../../shared/slidepage.dart';
import '../home/home.dart';

class SendPage extends StatefulWidget {
  const SendPage({super.key, required this.idStructure, required this.dateRequete});
  final String idStructure ;
  final String dateRequete ;

  @override
  State<SendPage> createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  int _seconds = 5;
  late Timer _timer;
  bool isLoad = true ;

  @override
  void initState() {
    super.initState();
    submit() ;
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


  submit() async {
    bool res = await RequeteController().askRequete(widget.idStructure , widget.dateRequete) ;


    if (kDebugMode) {
      print(res.toString()) ;
    }
    if(res){
      DInfo.toastSuccess('Requete envoyé avec succes') ;
      Timer(Duration(seconds: 2), () {
        setState(() {
          isLoad = false ;
        });
        _startCountdown();
      });
    }
    else{
      DInfo.toastError('Erreur') ;
      setState(() {
        isLoad = false ;
      });
      _startCountdown();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[ Scaffold(
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
      ),
        isLoad? Loading() : Container()
    ]
    );
  }
}

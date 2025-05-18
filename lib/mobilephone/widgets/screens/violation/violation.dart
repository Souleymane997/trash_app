import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../shared/colors.dart';
import '../../../../shared/custom_text.dart';
import '../../../../shared/slidepage.dart';
import 'violationsend.dart';

class ViolationPage extends StatefulWidget {
  const ViolationPage({super.key});

  @override
  State<ViolationPage> createState() => _ViolationPageState();
}

class _ViolationPageState extends State<ViolationPage> {

  final _violationController = TextEditingController();
  final _lieuController = TextEditingController();
  final _dateController = TextEditingController();


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
      appBar: AppBar(
        title: CustomText("Violation"),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: vert(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 16,
          right: 16,
          top: MediaQuery.of(context).size.height * 0.02,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: SvgPicture.asset(
                'assets/icons/violation.svg',
                height: 80,
                width: 80,
                semanticsLabel: 'str',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: CustomText(
                'Violation',
                color: noir(),
                fontWeight: FontWeight.w700,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 334,
                child: CustomText(
                    "Si vous êtes témoin d' une violation, nous vous encourageons à la signaler immédiatement. Votre signalement permet de maintenir un environnement sûr et respectueux pour tous. Veuillez fournir autant de détails que possible, notamment la nature de la violation, les personnes impliquées, ainsi que la date, l'heure et le lieu de l'incident. ",
                  color: noir(),
                  tex: TailleText(context).contenu,
                  textAlign: TextAlign.center,
                  family: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CustomText(
                    'Formulaire de Signalement',
                    color: noir(),
                    textAlign: TextAlign.left,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  CustomText(
                    'Nature de la violation',
                    tex: TailleText(context).contenu,
                    color: noir(),
                    fontWeight: FontWeight.w300,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextFormField(
                controller: _violationController,
                maxLines: 4,
                decoration: _inputDecoration(""),
                keyboardType:TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'violation requis';
                  return null;
                },
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextFormField(
                      controller: _lieuController,
                      decoration: _inputDecoration("Lieu"),
                      keyboardType:TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'lieu requis';
                        return null;
                      },
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextFormField(
                      controller: _dateController,
                      decoration: _inputDecoration("date"),
                      keyboardType:TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'date requis';
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: (){

                  Navigator.pushReplacement(
                      context,
                      SlideRightRoute(
                          child: ViolationSendPage(),
                          page: ViolationSendPage(),
                          direction: AxisDirection.left)
                  );

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
                child: CustomText("Soumettre", family: 'Inter', fontWeight: FontWeight.w500,),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: (){

                  Navigator.pushReplacement(
                      context,
                      SlideRightRoute(
                          child: ViolationSendPage(),
                          page: ViolationSendPage(),
                          direction: AxisDirection.left)
                  );

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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText("Prendre une photo", family: 'Inter', fontWeight: FontWeight.w500,),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Icon(Icons.camera),
                    )
                    // prendre une photo et envoyer a l'administrateur ..
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ) ;
  }
}





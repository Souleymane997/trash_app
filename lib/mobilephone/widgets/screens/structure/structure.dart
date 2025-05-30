import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:switcher_button/switcher_button.dart';


import '../../../../shared/colors.dart';
import '../../../../shared/custom_text.dart';
import '../../../../shared/slidepage.dart';
import 'feedback.dart';
import 'send.dart';

class StructurePage extends StatefulWidget {
  const StructurePage({super.key});

  @override
  State<StructurePage> createState() => _StructurePageState();
}

class _StructurePageState extends State<StructurePage> {

  bool urgence = false ;
  final _adresseController = TextEditingController();
  String? selectionOption = "1" ;

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
        title: CustomText("Ma structure"),
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
                'assets/icons/structure.svg',
                height: 80,
                width: 80,
                semanticsLabel: 'str',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: CustomText(
                'Wend Panga clean',
                color: noir(),
                fontWeight: FontWeight.w700,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: 334,
                child: CustomText(
                  'Responsable : Mr TIENDREBEOGO LASSANE\n'
                      'Tel : 77 90 66 68 / 68 74 51 07\n'
                      'Email : tlassane7@gmail.com',
                    color: noir(),
                    family: 'Poppins',
                    fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 15.0 , bottom: 0.0 , right: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 8,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SvgPicture.asset(
                      'assets/icons/heure.svg',
                      height: 20,
                      width: 20,
                      semanticsLabel: 'h',
                    ),
                  ),

                  CustomText(
                    'Programme de Ramassage',
                      color:noir(),
                      fontWeight: FontWeight.w700,
                    ),

                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.all(2),
                  margin: const EdgeInsets.only(bottom: 5),
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.16, 0.23),
                      end: Alignment(0.86, 0.79),
                      colors: [vert(), vertLight()],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomText(
                      '1 fois/semaine : 1000 F / mois',
                      family: 'Poppins',
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
                  child:Radio(value: '1', groupValue: selectionOption, onChanged:(value){
                    setState(() {
                      selectionOption = value ;
                    });
                  }),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.all(2),
                  margin: const EdgeInsets.only(bottom: 5),
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.16, 0.23),
                      end: Alignment(0.86, 0.79),
                      colors: [vert(), vertLight()],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomText(
                      '2 fois/semaine  :  1500 F / mois',
                      family: 'Poppins',
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child:Radio(value: '2', groupValue: selectionOption, onChanged:(value){
                    setState(() {
                      selectionOption = value ;
                    });
                  }),
                ),
              ],
            ),

            SizedBox(height: 15),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(5),
              decoration: ShapeDecoration(
                color: red(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        "Requête d'urgence\nde Ramassage",
                        textAlign: TextAlign.left,
                        color: blanc(),
                        fontWeight: FontWeight.w700,
                      ),
                      SwitcherButton(
                        value: urgence,
                        offColor: gris(),
                        onColor: vert(),
                        onChange: (value) {
                          setState(() {
                            urgence = !urgence ;
                          });

                          if (kDebugMode) {
                            print(urgence) ;
                          }
                        },
                      )

                    ],
                  ),
                  urgence ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          controller: _adresseController,
                          decoration: _inputDecoration("indiquez Votre adresse"),
                          keyboardType:TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'adresse requis';
                            return null;
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: (){

                          Navigator.pushReplacement(
                              context,
                              SlideRightRoute(
                                  child: SendPage(),
                                  page: SendPage(),
                                  direction: AxisDirection.right)
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: vert(),
                          foregroundColor: blanc(),
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: vert(), width: 1),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText("envoyer", family: 'Inter', fontWeight: FontWeight.w500,),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: SvgPicture.asset(
                                'assets/icons/send.svg',
                                height: 20,
                                width: 20,
                                semanticsLabel: 'Logo',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ): Container(),
                ],
              ),
            ),

            SizedBox(height: 20),

            SizedBox(height: 30),
            ElevatedButton(
              onPressed: (){
                Navigator.pushReplacement(
                    context,
                    SlideRightRoute(
                        child: FeedbackPage(),
                        page: FeedbackPage(),
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
                  CustomText("Donner un Avis", family: 'Inter', fontWeight: FontWeight.w500,),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SvgPicture.asset(
                      'assets/icons/avis.svg',
                      height: 20,
                      width: 20,
                      semanticsLabel: 'Logo',
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
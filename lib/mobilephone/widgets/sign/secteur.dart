import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trash_app/mobilephone/widgets/screens/home/home.dart';

import '../../../shared/colors.dart';
import '../../../shared/custom_text.dart';
import '../../../shared/slidepage.dart';


class SecteurPage extends StatefulWidget {
  const SecteurPage({super.key});

  @override
  State<SecteurPage> createState() => _SecteurPageState();
}

class _SecteurPageState extends State<SecteurPage> {
  final _formKey = GlobalKey<FormState>();

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
    if (_formKey.currentState!.validate() ) {


      if (kDebugMode) {
       print(selectedArrondissement) ;
       print(selectedSecteur) ;
      }

      Navigator.pushReplacement(
          context,
          SlideRightRoute(
              child: HomePage(),
              page: HomePage(),
              direction: AxisDirection.left)
      );
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
        top: MediaQuery.of(context).size.height * 0.15,
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
              "Selectionnez votre Zone ",
              family: 'Inter',
              tex: 1.5,
              color: vert(),
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.05),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child:  Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CustomText(
                          "Selectionnez votre Arrondissement ",
                          textAlign: TextAlign.left,
                          tex: TailleText(context).contenu * 1.2,
                          color: noir(),
                        ),
                      ),
                    ],
                  ),
                  CustomDropdown<String>(
                    hintText: 'Arrondissement',
                    decoration: CustomDropdownDecoration(
                      closedBorder: Border.all(
                        color: vert(),
                        width: 1.0,
                      ),
                    ),
                    items: listArrond,
                    initialItem: listArrond[0],
                    onChanged: (value) {

                      setState(() {
                        selectedArrondissement = value ;
                        debugPrint('changing value to: $selectedArrondissement');
                      });
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CustomText(
                          "Selectionnez votre Secteur ",
                          textAlign: TextAlign.left,
                          tex: TailleText(context).contenu * 1.2,
                          color: noir(),
                        ),
                      ),
                    ],
                  ),
                  CustomDropdown<String>(
                    hintText: 'Secteur',
                    decoration: CustomDropdownDecoration(
                      closedBorder: Border.all(
                        color: vert(),
                        width: 1.0,
                      ),
                    ),
                    items: listSecteur,
                    initialItem: listSecteur[0],
                    onChanged: (value) {
                      setState(() {
                        selectedSecteur = value ;
                        debugPrint('changing value to: $selectedSecteur');
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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
            child: CustomText("Suivant", family: 'Inter', fontWeight: FontWeight.w500,),
          ),
        ],
      ),
    )
    ) ;
  }
}




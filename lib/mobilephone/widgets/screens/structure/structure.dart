import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:switcher_button/switcher_button.dart';
import 'package:trash_app/controllers/abonnement.dart';


import '../../../../controllers/structures_controller.dart';
import '../../../../models/service_model.dart';
import '../../../../models/structure_model.dart';
import '../../../../shared/colors.dart';
import '../../../../shared/custom_text.dart';
import '../../../../shared/loading.dart';
import '../../../../shared/slidepage.dart';
import 'edit_service_user.dart';
import 'feedback.dart';
import 'send.dart';

class StructurePage extends StatefulWidget {
  const StructurePage({super.key, required this.idArrond});
  final int idArrond ;

  @override
  State<StructurePage> createState() => _StructurePageState();
}

class _StructurePageState extends State<StructurePage> {

  bool urgence = false ;
  final _adresseController = TextEditingController();
  bool  isLoad = true ;
  int idService = 0 ;
  String idStructure = "" ;


  StructureModel structure = StructureModel(id: 'id', nomStructure: 'nomStructure', tel: 'tel', arrondissement_id:0, arrondissement: 'arrondissement', email: 'email', password: 'password', role_id: 0) ;

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

  ServiceModel selected = ServiceModel(service_id: 1, structure_id: 'structure_id', nom_service: 'nom_service', nbre: 0, tarif: 0, description: 'description');


  getListService() async {
    ServiceModel? item = await AbonnementController().getAbonnementService() ;
    if(item != null){
      setState(() {
        selected = item ;
      });
    }
  }


  getStructureData() async {
    StructureModel? item = await StructureController().getStructureDetails(idArrond: widget.idArrond) ;
    if(item != null){
      setState(() {
        structure = item;
        idStructure = structure.id ;
      });
    }

    setState(() {
      isLoad = false;
    });

    getListService() ;
  }


  @override
  void initState() {
    super.initState();
    getStructureData() ;
  }

  Future<void> open() async {
    final success = await showDialog<bool>(
      context: context,
      builder: (context) =>EditServiceUser(item: selected, idStructure: idStructure,),
    );

    if (success == true) {
      getListService() ;
    }
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
      body: Stack(
        children: [

          SingleChildScrollView(
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
                  structure.nomStructure.toUpperCase(),
                  tex: 1.4,
                  color: noir(),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 334,
                  child: CustomText(
                        'Email : ${structure.email}\n'
                        'Tel : ${structure.tel}',
                      color: noir(),
                      family: 'Poppins',
                      fontWeight: FontWeight.w400,
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

              GestureDetector(
                onTap: (){
                  open() ;
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.all(5),
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
                      '${selected.nbre} fois/semaine : ${selected.tarif} F / mois',
                      family: 'Poppins',
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
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
          isLoad? Loading() : Container()
    ]
      ),
    );
  }
}
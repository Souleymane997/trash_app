// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:switcher_button/switcher_button.dart';
import 'package:trash_app/controllers/abonnement.dart';
import 'package:trash_app/controllers/requete_controller.dart';
import 'package:trash_app/models/requete.dart';
import 'package:trash_app/shared/dialoguetoast.dart';

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
  final int idArrond;

  @override
  State<StructurePage> createState() => _StructurePageState();
}

class _StructurePageState extends State<StructurePage> {
  bool urgence = false;
  bool isLoad = true;
  int idService = 0;
  String idStructure = "";
  bool isAbonned = false;
  bool requeteAlreadySend = false ;

  List<RequeteModel> listRequete = [] ;
  late RequeteModel requete  ;

  StructureModel structure = StructureModel(
    id: 'id',
    nomStructure: 'nomStructure',
    tel: 'tel',
    arrondissement_id: 0,
    arrondissement: 'arrondissement',
    email: 'email',
    password: 'password',
    role_id: 0,
  );


  ServiceModel selected = ServiceModel(
    service_id: 1,
    structure_id: 'structure_id',
    nom_service: 'nom_service',
    nbre: 0,
    tarif: 0,
    description: 'description',
  );

  getListMyRequete() async {
    List<RequeteModel?> list = await RequeteController().getListRequetebyUser(idStructure) ;
    if (list.isNotEmpty) {
      setState(() {
        requeteAlreadySend = true ;
        requete = list.first! ;
      });
    }
  }


  getListService() async {
    ServiceModel? item = await AbonnementController().getAbonnementService();
    if (item != null) {
      setState(() {
        selected = item;
        isAbonned = true;
      });
    }
  }

  getStructureData() async {
    StructureModel? item = await StructureController().getStructureDetails(
      idArrond: widget.idArrond,
    );
    if (item != null) {
      setState(() {
        structure = item;
        idStructure = structure.id;
      });
    }

    setState(() {
      isLoad = false;
    });

    getListService();
    getListMyRequete();
  }

  @override
  void initState() {
    super.initState();
    getStructureData();
  }

  Future<void> open(bool isAbonned) async {
    final success = await showDialog<bool>(
      context: context,
      builder:
          (context) => EditServiceUser(
            item: selected,
            idStructure: idStructure,
            isAbonned: isAbonned,
          ),
    );
    if (success == true) {
      getListService();
    }
  }

  DateTime? selectedDate;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
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
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    top: 15.0,
                    bottom: 0.0,
                    right: 0.0,
                  ),
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
                        color: noir(),
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    if (isAbonned) {
                      open(isAbonned);
                    } else {
                      DInfo.toastNetral(
                        'Veuillez vous abonner d\'abord à un service',
                      );
                      open(isAbonned);
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: ShapeDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.16, 0.23),
                        end: Alignment(0.86, 0.79),
                        colors:
                            isAbonned
                                ? [vert(), vertLight()]
                                : [grisFonce(), gris()],
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

                requeteAlreadySend?

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(5),
                  decoration: ShapeDecoration(
                  color:  (requete.statut == 'En attente') ? red() : jaune(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: CustomText("Votre requete est deja en cours de Traitement...\n statut : ${requete.statut}"),
                ):
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
                                urgence = !urgence;
                              });

                              if (kDebugMode) {
                                print(urgence);
                              }
                            },
                          ),
                        ],
                      ),
                      urgence
                          ? Column(
                            children: [
                              GestureDetector(
                                onTap: () => selectDate(context),
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  padding: const EdgeInsets.all(10.0),
                                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                                  decoration: ShapeDecoration(
                                    color: blanc(),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: (selectedDate != null) ? CustomText('${selectedDate!.day}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.year.toString().padLeft(2, '0')}',color: vert(),) : CustomText('choisir la date',color: vert(),),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if(selectedDate != null){
                                    String date = '${selectedDate!.day}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.year.toString().padLeft(2, '0')}' ;

                                    Navigator.pushReplacement(
                                      context,
                                      SlideRightRoute(
                                        child: SendPage(idStructure: idStructure, dateRequete: date),
                                        page: SendPage(idStructure: idStructure, dateRequete: date),
                                        direction: AxisDirection.right,
                                      ),
                                    );

                                  }else{
                                    DInfo.toastError('selectionner la date svp ?') ;
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: vert(),
                                  foregroundColor: blanc(),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(color: vert(), width: 1),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomText(
                                      "envoyer",
                                      family: 'Inter',
                                      fontWeight: FontWeight.w500,
                                    ),
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
                          )
                          : Container(),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      SlideRightRoute(
                        child: FeedbackPage(idStructure: idStructure,),
                        page: FeedbackPage(idStructure: idStructure,),
                        direction: AxisDirection.left,
                      ),
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
                      CustomText(
                        "Donner un Avis",
                        family: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
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
          isLoad ? Loading() : Container(),
        ],
      ),
    );
  }
}

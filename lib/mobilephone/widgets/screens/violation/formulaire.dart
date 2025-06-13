import 'package:flutter/material.dart';
import 'package:trash_app/controllers/photo_controller.dart';
import 'package:trash_app/models/photo_model.dart';

import '../../../../shared/colors.dart';
import '../../../../shared/custom_text.dart';
import '../../../../shared/dialoguetoast.dart';
import '../../../../shared/loading.dart';
import '../../../../shared/slidepage.dart';
import 'violationsend.dart';



class FormulairePage extends StatefulWidget {
  const FormulairePage({super.key});

  @override
  State<FormulairePage> createState() => _FormulairePageState();
}

class _FormulairePageState extends State<FormulairePage> {

  late TextEditingController violationController = TextEditingController();
  late TextEditingController lieuController = TextEditingController();

  DateTime? selectedDate;
  bool isLoad = false ;

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

  submit() async {
    setState(() {
      isLoad = true ;
    });

    String date = '${selectedDate!.day}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.year.toString().padLeft(2, '0')}' ;

    PhotoModel photo = PhotoModel(id: '1', user_id: '', image_path: 'uploads/default.png', date_upload: date, description: violationController.text , lieu: lieuController.text) ;

    bool res = await PhotoController().addPhotoViolation(photo) ;

    if (res) {
      debugPrint("photo envoyé!");
      DInfo.toastSuccess('informations envoyé') ;

      Navigator.push(
          context,
          SlideRightRoute(
              child: ViolationSendPage(),
              page: ViolationSendPage(),
              direction: AxisDirection.left)
      );
    } else {
      debugPrint("Erreur lors de l'envoi.");
      setState(() {
        isLoad = false ;
      });
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
    return Stack(
      children: [Scaffold(
        backgroundColor: grisLight(),
        appBar: AppBar(
          title: CustomText("Formulaire"),
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
              Container(height: 20,),
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
              Container(height: 10,) ,
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
                  controller: violationController,
                  maxLines: 4,
                  decoration: _inputDecoration(""),
                  keyboardType:TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'violation requis';
                    return null;
                  },
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextFormField(
                    controller: lieuController,
                    decoration: _inputDecoration("Lieu"),
                    keyboardType:TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'lieu requis';
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () => selectDate(context),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.all(15.0),
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

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: (){
                    submit() ;
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
            ],
          ),
        ),
      ),
        isLoad ? Loading() : Container()
    ]
    ) ;
  }
}

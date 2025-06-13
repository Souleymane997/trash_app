// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:trash_app/controllers/service_controllers.dart';
import 'package:trash_app/models/service_model.dart';

import '../../../shared/colors.dart';
import '../../../shared/custom_text.dart';

class AddService extends StatefulWidget {
  const AddService({super.key, required this.idStructure});
  final String idStructure ;

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomOptionController = TextEditingController() ;
  final TextEditingController nbreController = TextEditingController() ;
  final TextEditingController tarifController = TextEditingController() ;
  final TextEditingController descController = TextEditingController() ;

  bool isLoad = true ;

  @override
  void initState() {
    super.initState();
  }

  _submit(String idStructure) async {
    setState(() {
      isLoad = false ;
    });

    ServiceModel item = ServiceModel(service_id: 1, structure_id: idStructure, nom_service: nomOptionController.text, nbre: int.parse(nbreController.text) , tarif: double.parse(tarifController.text), description: descController.text) ;

    bool res = await ServiceController().addService(item) ;

    if (kDebugMode) {
      print(res.toString()) ;
    }
    if(res){

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Service Ajouté') , backgroundColor: vert(),),
      );
      Timer(Duration(seconds: 2), () {
        setState(() {
          isLoad = true ;
        });
        Navigator.pop(context, true);
      });

    }
    else{

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur') , backgroundColor: red(),),
      );
    }
  }



  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      hintText: label,
      filled: true,
      hintStyle: TextStyle(color: gris(),),
      fillColor: blanc(),
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
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
    return AlertDialog(
      title: Center(child: CustomText('Ajouter Service ', color: vert(),fontWeight: FontWeight.w700,tex: 1.5,)),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: (MediaQuery.of(context).size.width > 500 )?MediaQuery.of(context).size.height * 0.35 : 300,
                  child: TextFormField(
                    textAlign: TextAlign.start,
                    controller: nomOptionController,
                    decoration: _inputDecoration("nom de l'option "),
                    keyboardType:TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'nom requis';
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  width: (MediaQuery.of(context).size.width > 500 )?MediaQuery.of(context).size.height * 0.35 : 300,
                  child: TextFormField(
                    textAlign: TextAlign.start,
                    controller: nbreController,
                    decoration: _inputDecoration("nombre"),
                    keyboardType:TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'nombre requis';
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  width: (MediaQuery.of(context).size.width > 500 )?MediaQuery.of(context).size.height * 0.35 : 300,
                  child: TextFormField(
                    textAlign: TextAlign.start,
                    controller: tarifController,
                    decoration: _inputDecoration("tarif"),
                    keyboardType:TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'tarif requis';
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  width: (MediaQuery.of(context).size.width > 500 )?MediaQuery.of(context).size.height * 0.35 : 300,
                  child: TextFormField(
                    textAlign: TextAlign.start,
                    controller: descController,
                    decoration: InputDecoration(
                      hintText: "description",
                      filled: true,
                      hintStyle: TextStyle(color: gris(),),
                      fillColor: blanc(),
                      contentPadding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: vert()),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: vert(), width: 2),
                      ),
                    ),
                    keyboardType:TextInputType.multiline,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'description requis';
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
      actions: [
        isLoad ?
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            Gap(8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: vert(),
                foregroundColor: blanc(),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: vert(), width: 1),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _submit(widget.idStructure) ;
                }
              },
              child: const Text('valider'),
            ),
          ],
        ) : Center(
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: CircularProgressIndicator(),
          ),
        ),

      ],
    );
  }
}

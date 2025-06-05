// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:trash_app/controllers/service_controllers.dart';

import '../../../../shared/colors.dart';
import '../../../../shared/custom_text.dart';
import '../../../models/service_model.dart';

class EditService extends StatefulWidget {
  const EditService({super.key, required this.item});
  final ServiceModel item ;


  @override
  State<EditService > createState() => _EditServiceState();
}

class _EditServiceState extends State<EditService> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomOptionController = TextEditingController() ;
  final TextEditingController nbreController = TextEditingController() ;
  final TextEditingController tarifController = TextEditingController() ;
  final TextEditingController descController = TextEditingController() ;


  bool isLoad = true ;
  bool isDelete = false ;




  @override
  void initState() {
    super.initState();
    nomOptionController.text = widget.item.nom_service ;
    nbreController.text = widget.item.nbre.toString() ;
    tarifController.text = widget.item.tarif.toString() ;
    descController.text = widget.item.description ;
  }

  _delete(int id) async {
    setState(() {
      isLoad = false ;
    });

    bool res = await ServiceController().deleteService(id);
    if (kDebugMode) {
      print(res.toString()) ;
    }

    if(res){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Service Supprimé') , backgroundColor: vert(),),
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


  _submit( int idStructure) async {
    setState(() {
      isLoad = false ;
    });

    ServiceModel item = ServiceModel(service_id: 1, structure_id: widget.item.structure_id, nom_service:nomOptionController.text, nbre: int.parse(nbreController.text) , tarif: double.parse(tarifController.text), description: descController.text) ;


    bool res = await ServiceController().editService(id: idStructure, item: item) ;
    if (kDebugMode) {
      print(res.toString()) ;
    }

    if(res){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Service modifié') , backgroundColor: vert(),),
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
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isDelete?Center(child: CustomText('Supprimer Secteur', color: vert(),fontWeight: FontWeight.w700,tex: 1.5,)): Center(child: CustomText('Modifier Secteur', color: vert(),fontWeight: FontWeight.w700,tex: 1.5,)),
          SizedBox(width: 10,) ,
          IconButton(onPressed: (){ setState(() {
            isDelete = !isDelete ;
          });  },icon: Icon(Icons.delete , color:isDelete? grisFonce(): redFonce() ,))
        ],
      ),
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
                    decoration: _inputDecoration("description"),
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
        ( isLoad )?

        isDelete?
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: red(),
                  foregroundColor: blanc(),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: red(), width: 1),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _delete(widget.item.service_id) ;
                  }
                },
                child: const Text('Confirmer suppression'),
              ),
              Gap(8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),

            ],
          ),
        ) :
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
                  _submit(widget.item.service_id) ;
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

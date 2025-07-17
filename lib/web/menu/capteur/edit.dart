// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:trash_app/controllers/capteur_controller.dart';
import 'package:trash_app/models/capteur_model.dart';

import '../../../../shared/colors.dart';
import '../../../../shared/custom_text.dart';

class EditCapteurDialog extends StatefulWidget {
  const EditCapteurDialog({super.key, required this.capteur});
  final CapteurStringModel capteur ;


  @override
  State<EditCapteurDialog > createState() => _EditCapteurDialogState();
}

class _EditCapteurDialogState extends State<EditCapteurDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController capteurController = TextEditingController() ;

  bool isLoad = true ;
  bool isDelete = false ;


  @override
  void initState() {
    super.initState();
    capteurController.text = widget.capteur.sensor_id ;
  }

  _delete(int id) async {
    setState(() {
      isLoad = false ;
    });
    bool res1 = await CapteurController().deleteCapteurData(widget.capteur.sensor_id) ;

    if(res1){

      bool res = await CapteurController().deleteCapteur(id) ;
      if (kDebugMode) {
        print(res.toString()) ;
      }

      if(res){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Capteur Supprimé') , backgroundColor: vert(),),
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
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur') , backgroundColor: red(),),
      );
    }


  }


  _submit( int id) async {
    setState(() {
      isLoad = false ;
    });

    bool res = await CapteurController().editCapteur(id: id, newCapteur: capteurController.text) ;
    if (kDebugMode) {
      print(res.toString()) ;
    }

    if(res){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Capteur modifié') , backgroundColor: vert(),),
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
          isDelete?Center(child: CustomText('Supprimer Role', color: vert(),fontWeight: FontWeight.w700,tex: 1.5,)): Center(child: CustomText('Modifier Role', color: vert(),fontWeight: FontWeight.w700,tex: 1.5,)),
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
                    controller: capteurController,
                    decoration: _inputDecoration("id capteur"),
                    keyboardType:TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'capteur requis';
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10),
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
                    _delete(widget.capteur.id??0) ;
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
                  _submit(widget.capteur.id??0) ;
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

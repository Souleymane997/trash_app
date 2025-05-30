// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:trash_app/controllers/arrond_controllers.dart';
import 'package:trash_app/models/arrondissement.dart';

import '../../../../shared/colors.dart';
import '../../../../shared/custom_text.dart';

class EditArrondDialog extends StatefulWidget {
  const EditArrondDialog({super.key, required this.item});
  final ArrondissementModel item ;


  @override
  State<EditArrondDialog > createState() => _EditArrondDialogState();
}

class _EditArrondDialogState extends State<EditArrondDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController arrondController = TextEditingController() ;

  bool isLoad = true ;
  bool isDelete = false ;


  @override
  void initState() {
    super.initState();
    arrondController.text = widget.item.arrondissement;
  }

  _delete(int id) async {
    setState(() {
      isLoad = false ;
    });

    bool res = await ArrondController().deleteArrondissement(id) ;
    if (kDebugMode) {
      print(res.toString()) ;
    }

    if(res){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Arrondissement Supprimé') , backgroundColor: vert(),),
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


  _submit( int idArrondissement) async {
    setState(() {
      isLoad = false ;
    });

    int id = idArrondissement ;

    bool res = await ArrondController().editArrondissement(id: id, newArrondissementName: arrondController.text) ;
    if (kDebugMode) {
      print(res.toString()) ;
    }

    if(res){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Arrondissement modifié') , backgroundColor: vert(),),
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
          isDelete?Center(child: CustomText('Supprimer Arrondissement', color: vert(),fontWeight: FontWeight.w700,tex: 1.5,)): Center(child: CustomText('Modifier Arrondissement', color: vert(),fontWeight: FontWeight.w700,tex: 1.5,)),
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
                    controller: arrondController,
                    decoration: _inputDecoration("Arrondissement"),
                    keyboardType:TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Arrondissement requis';
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
                    _delete(widget.item.id??0) ;
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
                  _submit(widget.item.id??0) ;
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

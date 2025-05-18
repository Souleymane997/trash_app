// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:trash_app/controllers/secteur_controllers.dart';
import 'package:trash_app/models/secteur.dart';

import '../../../../controllers/arrond_controllers.dart';
import '../../../../models/arrondissement.dart';
import '../../../../shared/colors.dart';
import '../../../../shared/custom_text.dart';

class EditSecteurDialog extends StatefulWidget {
  const EditSecteurDialog({super.key, required this.item});
  final SecteurModel item ;


  @override
  State<EditSecteurDialog > createState() => _EditSecteurDialogState();
}

class _EditSecteurDialogState extends State<EditSecteurDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController secteurController = TextEditingController() ;


  int idArrond = 0 ;
  bool isLoad = true ;
  bool isDelete = false ;

  late List<ArrondissementModel> listArrond = [] ;
  ArrondissementModel? selectedArrondissement;

  getListArrond() async {
    List<ArrondissementModel> list = await ArrondController().getListArrondissement();
    setState(() {
      listArrond= list ;
    });

    for (int i = 0; i < listArrond.length; i++) {
      if(listArrond[i].id == widget.item.arrondissement_id){
        setState(() {
          selectedArrondissement = listArrond[i] ;
          idArrond = listArrond[i].id! ;
        });
        break ;

      }
    }
  }


  @override
  void initState() {
    super.initState();
    secteurController.text = widget.item.secteur;
    getListArrond() ;
  }

  _delete(int id) async {
    setState(() {
      isLoad = false ;
    });

    bool res = await SecteurController().deleteSecteur(id);
    if (kDebugMode) {
      print(res.toString()) ;
    }

    if(res){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Secteur Supprimé') , backgroundColor: vert(),),
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


  _submit( int idSecteur) async {
    setState(() {
      isLoad = false ;
    });

    int id = idSecteur ;
    print(idArrond.toString()) ;

    bool res = await SecteurController().editSecteur(id: idSecteur, secteur: secteurController.text, idArrond: idArrond) ;
    if (kDebugMode) {
      print(res.toString()) ;
    }

    if(res){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Secteur modifié') , backgroundColor: vert(),),
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
                    controller: secteurController,
                    decoration: _inputDecoration("Secteur"),
                    keyboardType:TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Secteur requis';
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                CustomDropdown<ArrondissementModel>(
                  hintText: 'Arrondissement',
                  decoration: CustomDropdownDecoration(
                    closedBorder: Border.all(
                      color: vert(),
                      width: 1.0,
                    ),
                  ),
                  items: listArrond,
                  initialItem: selectedArrondissement,
                  onChanged: (value) {
                    setState(() {
                      selectedArrondissement = value;
                      idArrond = selectedArrondissement?.id ?? 0;
                    });
                    debugPrint("Arrondissement sélectionné : ${value?.arrondissement}");
                  },
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

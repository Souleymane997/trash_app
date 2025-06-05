// ignore_for_file: use_build_context_synchronously


import 'dart:async';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:trash_app/controllers/abonnement.dart';
import 'package:trash_app/models/service_model.dart';

import '../../../../controllers/service_controllers.dart';
import '../../../../shared/colors.dart';
import '../../../../shared/custom_text.dart';
import '../../../../shared/dialoguetoast.dart';

class EditServiceUser extends StatefulWidget {
  const EditServiceUser({super.key, required this.item, required this.idStructure});
  final ServiceModel item ;
  final String idStructure ;


  @override
  State<EditServiceUser> createState() => _EditServiceUserState();
}

class _EditServiceUserState extends State<EditServiceUser> {

  final _formKey = GlobalKey<FormState>();

  int idService = 0 ;
  bool isLoad = true ;


  late List<ServiceModel> listService = [] ;
  ServiceModel? selected;

  getListService(String idStructure) async {
    List<ServiceModel> list = await ServiceController().getList(idStructure);
    setState(() {
      listService= list ;
    });


    for (int i = 0; i < listService.length; i++) {
      if(listService[i].service_id == widget.item.service_id){
        setState(() {
          selected = listService[i];
          idService = listService[i].service_id ;
        });
        break ;

      }
    }
  }




  @override
  void initState() {
    super.initState();
    getListService(widget.idStructure) ;
  }

  _submit() async {
    setState(() {
      isLoad = false ;
    });

    int id = selected?.service_id ?? 0;

    bool res = await AbonnementController().editAbonn(idService: id) ;

    if(res){

      Timer(Duration(seconds: 1), () {
        DInfo.toastSuccess("Service modifié");
      });

      Navigator.pop(context, true);
    }
    else{
      DInfo.toastError("Erreur de connexion");
      setState(() {
        isLoad = true;
      });
    }


  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(child: CustomText("Modifier le service", color: vert(),fontWeight: FontWeight.w700,tex: 1.5,)),
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
                CustomDropdown<ServiceModel>(
                  hintText: 'Service',
                  decoration: CustomDropdownDecoration(
                    closedBorder: Border.all(
                      color: vert(),
                      width: 1.0,
                    ),
                  ),
                  items: listService,
                  initialItem: selected,
                  onChanged: (value) {
                    setState(() {
                      selected = value;
                    });
                    debugPrint("Service sélectionné : ${value?.nom_service}");
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
                  _submit() ;
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

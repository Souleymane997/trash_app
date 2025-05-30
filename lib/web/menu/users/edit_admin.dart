// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:trash_app/controllers/role_controllers.dart';
import 'package:trash_app/controllers/user_controller.dart';
import 'package:trash_app/models/role.dart';

import '../../../../shared/colors.dart';
import '../../../../shared/custom_text.dart';
import '../../../models/users_model.dart';

class EditAdminDialog extends StatefulWidget {
  const EditAdminDialog({super.key, required this.item});
  final UserModel item ;


  @override
  State<EditAdminDialog > createState() => _EditAdminDialogState();
}

class _EditAdminDialogState extends State<EditAdminDialog> {

  final _formKey = GlobalKey<FormState>();

  int idRole = 0 ;
  bool isLoad = true ;


  late List<RoleModel> listRole= [] ;
  RoleModel? selectedRole;

  getListRole() async {
    List<RoleModel> list = await RoleController().getListRoles();
    setState(() {
      listRole = list ;
    });

    for (int i = 0; i < listRole.length; i++) {
      if(listRole[i].id == widget.item.role_id){
        setState(() {
          selectedRole = listRole[i];
          idRole = listRole[i].id! ;
        });
        break ;

      }
    }
  }


  @override
  void initState() {
    super.initState();
    getListRole() ;
  }


  _submit(String id) async {
    setState(() {
      isLoad = false ;
    });

    idRole = selectedRole?.id ?? 0 ;

    bool res = await UserController().updateAdminRole(id: id, roleId: idRole) ;

    if (kDebugMode) {
      print(res.toString()) ;
    }

    if(res){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Role modifié') , backgroundColor: vert(),),
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


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         Center(child: CustomText("Modifier Role de l'administrateur", color: vert(),fontWeight: FontWeight.w700,tex: 1.5,)),
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
                CustomDropdown<RoleModel>(
                  hintText: 'Role',
                  decoration: CustomDropdownDecoration(
                    closedBorder: Border.all(
                      color: vert(),
                      width: 1.0,
                    ),
                  ),
                  items: listRole,
                  initialItem: selectedRole,
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value;
                    });
                    debugPrint("Role sélectionné : ${value?.role}");
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
                  _submit(widget.item.id) ;
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

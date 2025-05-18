// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:trash_app/controllers/role_controllers.dart';

import '../../../../shared/colors.dart';
import '../../../../shared/custom_text.dart';

class AddRoleDialog extends StatefulWidget {
  const AddRoleDialog({super.key});


  @override
  State<AddRoleDialog > createState() => _AddRoleDialogState();
}

class _AddRoleDialogState extends State<AddRoleDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController roleController = TextEditingController() ;

  bool isLoad = true ;


  _submit() async {
      setState(() {
        isLoad = false ;
      });

      bool res = await RoleController().addRole(roleController.text);

      if (kDebugMode) {
        print(res.toString()) ;
      }

      if(res){

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Role Ajouté') , backgroundColor: vert(),),
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
      title: Center(child: CustomText('Ajouter Role', color: vert(),fontWeight: FontWeight.w700,tex: 1.5,)),
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
                    controller: roleController,
                    decoration: _inputDecoration("role"),
                    keyboardType:TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'role requis';
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

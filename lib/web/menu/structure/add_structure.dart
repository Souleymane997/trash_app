import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../shared/colors.dart';
import '../../../shared/custom_text.dart';

class PersonFormDialog extends StatefulWidget {
  const PersonFormDialog({super.key});

  @override
  State<PersonFormDialog> createState() => _PersonFormDialogState();
}

class _PersonFormDialogState extends State<PersonFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomController = TextEditingController() ;
  final TextEditingController telController = TextEditingController() ;
  final TextEditingController villeController = TextEditingController() ;
  final TextEditingController zoneController = TextEditingController() ;

  String nom = '';
  String tel = '';
  String ville = '';
  List<String> zones = [];
  final List<String> allZones = ['Nord', 'Sud', 'Est', 'Ouest', 'Centre'];

  final List<String> listZone= [
    'Arrondissement 1',
    'Arrondissement 2',
    'Arrondissement 3',
  ];

  final List<String> listVille = [
    'Ouagadougou',
    'Bobo Dioulasso',
    'Koudougou',
    'Fada',
  ];
  String? selectedVille ;
  String? selectedZone ;


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
      title: Center(child: CustomText('Ajouter Structure', color: vert(),fontWeight: FontWeight.w700,tex: 1.5,)),
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
                    controller: nomController,
                    decoration: _inputDecoration("nom de la structure"),
                    keyboardType:TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'nom requis';
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  textAlign: TextAlign.start,
                  controller: telController,
                  decoration: _inputDecoration("Telephone"),
                  keyboardType:TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'telephone requis';
                    return null;
                  },
                ),
                SizedBox(height: 10),
                CustomDropdown<String>(
                  hintText: 'Ville',
                  decoration: CustomDropdownDecoration(
                    closedBorder: Border.all(
                      color: vert(),
                      width: 1.0,
                    ),
                  ),
                  items: listVille,
                  initialItem: selectedVille,
                  onChanged: (value) {
                    setState(() {
                      selectedVille = value ;
                      debugPrint('changing value to: $selectedVille');
                    });
                  },
                ),
                SizedBox(height: 15),
                CustomDropdown<String>(
                  hintText: 'Zone',
                  decoration: CustomDropdownDecoration(
                    closedBorder: Border.all(
                      color: vert(),
                      width: 1.0,
                    ),
                  ),
                  items: listZone,
                  initialItem: selectedZone,
                  onChanged: (value) {
                    setState(() {
                      selectedZone = value ;
                      debugPrint('changing value to: $selectedZone');
                    });
                  },
                ),

              ],
            ),
          ),
        ),
      ),
      actions: [
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

                  Navigator.pop(context);
                }
              },
              child: const Text('ajouter'),
            ),
          ],
        ),

      ],
    );
  }
}

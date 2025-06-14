// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:trash_app/controllers/programme_controller.dart';
import 'package:trash_app/models/programme_model.dart';

import '../../../shared/colors.dart';
import '../../../shared/custom_text.dart';
import '../components/content_view.dart';
import '../components/page_header.dart';


class ProgrammeDay extends StatefulWidget {
  const ProgrammeDay({super.key});

  @override
  State<ProgrammeDay> createState() => _ProgrammeDayState();
}

class _ProgrammeDayState extends State<ProgrammeDay> {

  List<String> joursChoisis = [];
  List<ProgrammeModel?> prog = [] ;
  final List<String> jours = [
    'Lundi',
    'Mardi',
    'Mercredi',
    'Jeudi',
    'Vendredi',
    'Samedi',
    'Dimanche',
  ];

  final Map<String, bool> selections = {};
  bool isSend = false ;
  bool progAlreadyDefined = false ;
  bool isLoad = false ;

  getProgramme() async{

    List<ProgrammeModel?> list = await ProgrammeController().getProgrammeByStructure() ;
    if(list.isNotEmpty){
      setState(() {
        prog = list ;

        joursChoisis.clear() ;
        joursChoisis = [ prog.first!.jour1.toString() ,  prog.first!.jour2.toString() ] ;
        for (var jour in joursChoisis) {
          selections[jour] = true;
        }
       progAlreadyDefined = true ;
      });

    }

    Timer(Duration(seconds: 2), () {
      setState(() {
        isLoad = true ;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    for (var jour in jours) {
      selections[jour] = false;
    }

    getProgramme() ;
  }

  int get totalSelectionnes =>
      selections.values.where((selected) => selected).length;


  void toggleSelection(String jour, bool? selected) {
    if (selected == true && totalSelectionnes >= 2) return;

    setState(() {
      selections[jour] = selected ?? false;
      joursChoisis = selections.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();
    });
  }

  submit() async {
    setState(() {
      isSend = true ;
    });
    bool res = await ProgrammeController().addProgramme(joursChoisis) ;

    if(res){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Programme enregistré') , backgroundColor: vert(),),
      );
      Timer(Duration(seconds: 2), () {
        setState(() {
          isSend = false ;
        });

        getProgramme() ;
      });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur') , backgroundColor: red(),),
      );
      setState(() {
        isSend = false ;
      });
    }

  }

  edit() async {
    setState(() {
      isSend = true ;
    });
    bool res = await ProgrammeController().editProgramme(joursChoisis , prog.first!.id) ;

    if(res){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Programme Modifié') , backgroundColor: vert(),),
      );
      Timer(Duration(seconds: 2), () {
        setState(() {
          isSend = false ;
        });
      });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur') , backgroundColor: red(),),
      );
      setState(() {
        isSend = false ;
      });
    }

  }



  @override
  Widget build(BuildContext context) {
    return ContentView(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageHeader(
          title: 'Gestion du Programme',
          description: " Jour de Passage ",
        ),
        const Gap(16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text("Liste des Jours de la semaine", style: TextStyle(
                  fontSize: 22
              ),),
            ),
          ],
        ),

      isLoad?

      Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sélectionne 2 jours maximum',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Divider(),
              ...jours.map((jour) {
                final bool estCoche = selections[jour] ?? false;
                final bool desactive = !estCoche && totalSelectionnes >= 2;
                return CheckboxListTile(
                  title: Text(jour),
                  value: estCoche,
                  onChanged: desactive ? null : (val) => toggleSelection(jour, val),
                );
              }),
            ],
          ),
        ),
      ) : Center(child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
        child: CircularProgressIndicator(),
      )),
        ( totalSelectionnes >= 2 && progAlreadyDefined == false) ?
        Center(
          child: Container(
            padding: const EdgeInsets.only(right: 16.0),
            width: 300,
            child: ElevatedButton(
              onPressed: (){
                submit() ;
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: vert(),
                foregroundColor: blanc(),
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: vert(), width: 1),
                ),
              ),
              child: isSend ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: CircularProgressIndicator(),
                ),
              ) : Padding(
                padding: const EdgeInsets.all(2.0),
                child: CustomText("Enregister", family: 'Inter', fontWeight: FontWeight.w500,),
              ),
            ),
          ),
        ) : Container(),

        ( totalSelectionnes >= 2 && progAlreadyDefined && isLoad) ?
        Center(
          child: Container(
            padding: const EdgeInsets.only(right: 16.0),
            width: 300,
            child: ElevatedButton(
              onPressed: (){
               edit() ;
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: vert(),
                foregroundColor: blanc(),
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: vert(), width: 1),
                ),
              ),
              child: isSend ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: CircularProgressIndicator(),
                ),
              ) : Padding(
                padding: const EdgeInsets.all(2.0),
                child: CustomText("Modifier", family: 'Inter', fontWeight: FontWeight.w500,),
              ),
            ),
          ),
        ) : Container(),

      ],
    ));
  }

}



import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intersperse/intersperse.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:trash_app/models/structure_model.dart';
import 'package:trash_app/web/menu/components/content_view.dart';

import '../../../shared/colors.dart';
import '../../../shared/custom_text.dart';
import '../components/page_header.dart';
import '../components/structure_card.dart';
import '../components/summary_card.dart';
import 'add_structure.dart';

class StructuresPage extends StatefulWidget {
  const StructuresPage({super.key});

  @override
  State<StructuresPage> createState() => _StructuresPageState();
}

class _StructuresPageState extends State<StructuresPage> {

  final List<StructureModel> listStructure = [
    StructureModel(
      id: 1,
      nom: 'Alice Dupont',
      tel: '0601010101',
      idArrondissement: 1
    ),
    StructureModel(
      id: 2,
      nom: 'Bob Martin',
      tel: '0602020202',
        idArrondissement: 1
    ),
    StructureModel(
      id: 3,
      nom: 'Chloé Bernard',
      tel: '0603030303',
        idArrondissement: 1
    ),
    StructureModel(
      id: 4,
      nom: 'David Moreau',
      tel: '0604040404',
        idArrondissement: 1
    ),
    StructureModel(
      id: 5,
      nom: 'Emma Petit',
      tel: '0605050505',
        idArrondissement: 1
    ),
    StructureModel(
      id: 6,
      nom: 'François Garnier',
      tel: '0606060606',
        idArrondissement: 1
    ),
    StructureModel(
      id: 7,
      nom: 'Gabrielle Lefevre',
      tel: '0607070707',
        idArrondissement: 1
    ),
    StructureModel(
      id: 8,
      nom: 'Hugo Laurent',
      tel: '0608080808',
        idArrondissement: 1
    ),
    StructureModel(
      id: 9,
      nom: 'Isabelle Noël',
      tel: '0609090909',
        idArrondissement: 1
    ),
    StructureModel(
      id: 10,
      nom: 'Jean Dubois',
      tel: '0610101010',
        idArrondissement: 1
    ),
  ];






  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveBreakpoints.of(context);
    const summaryCards = [
      SummaryCard(title: "Nombre de Structures", value: '12'),
    ];

    return ContentView(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageHeader(
          title: 'Gestion des Structures',
          description: "Vue d'ensemble des structures",
        ),
        const Gap(16),
        if (responsive.isMobile)
          ...summaryCards
        else
          Row(
            children: summaryCards
                .map<Widget>((card) => Expanded(child: card))
                .intersperse(const Gap(16))
                .toList(),
          ),
        const Gap(32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text("Liste des Structures", style: TextStyle(
                fontSize: 22
              ),),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => const PersonFormDialog(),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: vert(),
                  foregroundColor: blanc(),
                  padding: EdgeInsets.symmetric(horizontal: 35, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: vert(), width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: CustomText("Ajouter", family: 'Inter', fontWeight: FontWeight.w500,),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Icon(Icons.add_circle),
                    )
                  ],
                ),
              ),
            ),

          ],
        ),
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: Divider(
            color: Colors.grey,
            thickness: 1.0,
            indent: 16.0,
            endIndent: 16.0,
          ),
        ),
        const Gap(4),
        Expanded(child: ResponsiveGrid(listStructure: listStructure,))
      ],
    ));
  }
}

class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({super.key, required this.listStructure});
  final List<StructureModel> listStructure ;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        if (constraints.maxWidth >= 1200) {
          crossAxisCount = 5;
        } else if (constraints.maxWidth >= 800) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth >= 600) {
          crossAxisCount = 3;
        } else {
          crossAxisCount = 2;
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemCount: listStructure.length,
          itemBuilder: (context, index) {
            StructureModel item = listStructure[index] ;
            return StructureCard(structure: item,) ;
          },
        );
      },
    );
  }
}


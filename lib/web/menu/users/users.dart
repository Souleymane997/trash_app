import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intersperse/intersperse.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:trash_app/models/users_model.dart';
import 'package:trash_app/web/menu/components/content_view.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import '../components/page_header.dart';
import '../components/summary_card.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveBreakpoints.of(context);
    const summaryCards = [
      SummaryCard(title: "Nombre d'Utilisateurs ", value: '125'),
    ];

    List<UserModel> listUsers = [
      UserModel(
        id: 1,
        nom: 'Alice Dupont',
        tel: '0601020304',
        email: 'alice@example.com',
        password: 'pass123',
        adresse: '123 Rue de Paris',
        role: 'admin',
        arrondissement: '1er',
      ),
      UserModel(
        id: 2,
        nom: 'Bob Martin',
        tel: '0602030405',
        email: 'bob@example.com',
        password: 'secret',
        adresse: '45 Avenue Lyon',
        role: 'utilisateur',
        arrondissement: '2e',
      ),
      UserModel(
        id: 3,
        nom: 'Chloé Bernard',
        tel: '0603040506',
        email: 'chloe@example.com',
        password: 'azerty',
        adresse: '5 Rue Marseille',
        role: 'moderateur',
        arrondissement: '3e',
      ),
      UserModel(
        id: 4,
        nom: 'David Moreau',
        tel: '0604050607',
        email: 'david@example.com',
        password: 'david2023',
        adresse: '88 Rue Toulouse',
        role: 'utilisateur',
        arrondissement: '4e',
      ),
      UserModel(
        id: 5,
        nom: 'Emma Petit',
        tel: '0605060708',
        email: 'emma@example.com',
        password: 'emma@123',
        adresse: '10 Allée Nice',
        role: 'admin',
        arrondissement: '5e',
      ),
      UserModel(
        id: 6,
        nom: 'François Garnier',
        tel: '0606070809',
        email: 'francois@example.com',
        password: 'pass456',
        adresse: '34 Boulevard Lille',
        role: 'utilisateur',
        arrondissement: '6e',
      ),
      UserModel(
        id: 7,
        nom: 'Gabrielle Lefevre',
        tel: '0607080910',
        email: 'gabrielle@example.com',
        password: 'securePass',
        adresse: '77 Rue Dijon',
        role: 'moderateur',
        arrondissement: '7e',
      ),
      UserModel(
        id: 8,
        nom: 'Hugo Laurent',
        tel: '0608091011',
        email: 'hugo@example.com',
        password: 'hugo321',
        adresse: '12 Rue Reims',
        role: 'utilisateur',
        arrondissement: '8e',
      ),
      UserModel(
        id: 9,
        nom: 'Isabelle Noël',
        tel: '0609101112',
        email: 'isabelle@example.com',
        password: 'noel@2023',
        adresse: '5 Chemin Caen',
        role: 'admin',
        arrondissement: '9e',
      ),
      UserModel(
        id: 10,
        nom: 'Jean Dubois',
        tel: '0610111213',
        email: 'jean@example.com',
        password: 'jeanpass',
        adresse: '98 Rue Bordeaux',
        role: 'utilisateur',
        arrondissement: '10e',
      ),
    ];



    return ContentView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeader(
              title: 'Gestion des Utilisateurs',
              description: "Vue d'ensemble sur vos utilisateurs",
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
            const Gap(16),
            Expanded(
              child: _TableView(listUsers),
            ),
          ],
        ));
  }
}



class _TableView extends StatelessWidget {
  const _TableView(this.listUsers);
  final List<UserModel> listUsers ;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final decoration = TableSpanDecoration(
      border: TableSpanBorder(
        trailing: BorderSide(color: theme.dividerColor),
      ),
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: TableView.builder(
        columnCount: 6,
        rowCount:listUsers.length,
        pinnedRowCount: 1,
        pinnedColumnCount: 1,
        columnBuilder: (index) {
          return TableSpan(
            foregroundDecoration: index == 0 ? decoration : null,
            extent: const FractionalTableSpanExtent(1 / 6),
          );
        },
        rowBuilder: (index) {
          return TableSpan(
            foregroundDecoration: index == 0 ? decoration : null,
            extent: const FixedTableSpanExtent(50),
          );
        },
        cellBuilder: (context, vicinity) {

          final isStickyHeader = vicinity.xIndex == 0 || vicinity.yIndex == 0;
          var label = '';

          final rowIndex = vicinity.yIndex; // ← important
          final columnIndex = vicinity.xIndex;


          if (vicinity.yIndex == 0) {
            switch (columnIndex) {
              case 0:
                label = 'ID';
              case 1:
                label = 'Nom';
              case 2:
                label = 'Email';
              case 3:
                label = 'Telephone';
              case 4:
                label = 'Arrondissement';
              case 5:
                label = 'Adresse';
            }
          } else {
            final user = listUsers[rowIndex-1];
            switch (columnIndex) {
              case 0:
                label = user.id.toString() ;
              case 1:
                label = user.email.toString();
              case 2:
                label = user.email.toString();
              case 3:
                label = user.email.toString();
              case 4:
                label = user.email.toString();
              case 5:
                label = user.email.toString();
            }
          }
          return TableViewCell(
            child: ColoredBox(
              color:
              isStickyHeader ? Colors.transparent : colorScheme.surface,
              child: Center(
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontWeight: isStickyHeader ? FontWeight.w600 : null,
                        color: isStickyHeader ? null : colorScheme.outline,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


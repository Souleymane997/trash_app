import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intersperse/intersperse.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:trash_app/web/menu/components/content_view.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';
import '../components/page_header.dart';
import '../components/summary_card.dart';





class DashbordPage extends StatefulWidget {
  const DashbordPage({super.key});

  @override
  State<DashbordPage> createState() => _DashbordPageState();
}

class _DashbordPageState extends State<DashbordPage> {
  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveBreakpoints.of(context);
    const summaryCards = [
      SummaryCard(title: "Nombre d'Utilisateurs ", value: '125'),
      SummaryCard(title: 'Nombre de Structure', value: '12'),
    ];


    return ContentView(
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           const PageHeader(
             title: 'Dashboard',
             description: "Vue d'ensemble sur votre projet",
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
           const Expanded(
             child: _TableView(),
           ),
         ],
       ),
     );
  }
}



class _TableView extends StatelessWidget {
  const _TableView();

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
        rowCount:20,
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
          if (vicinity.yIndex == 0) {
            switch (vicinity.xIndex) {
              case 0:
                label = 'ID';
              case 1:
                label = 'Category';
              case 2:
                label = 'Brand';
              case 3:
                label = 'Supplier';
              case 4:
                label = 'Minimum Stock';
              case 5:
                label = 'Update Date';
            }
          } else {
            switch (vicinity.xIndex) {
              case 0:
                label = "inventory.inventoryId";
              case 1:
                label = "inventory.category";
              case 2:
                label = 'inventory.brand';
              case 3:
                label = 'inventory.supplier';
              case 4:
                label = 'inventory';
              case 5:
                label = 'inventory.updateDate';
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



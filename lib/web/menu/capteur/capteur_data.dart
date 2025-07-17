import 'package:flutter/material.dart';

class MyBottomSheetContent extends StatelessWidget {
  const MyBottomSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width * 2,
      height: MediaQuery.of(context).size.height ,
      child: Column(
        children: [
          Text('Contenu personnalisé'),
          ElevatedButton(
            child: Text('Fermer'),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
}

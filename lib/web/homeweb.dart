import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trash_app/web/menu/home.dart';

import '../controllers/structures_controller.dart';
import '../controllers/user_controller.dart';
import '../models/structure_model.dart';
import '../models/users_model.dart';


class HomeWebView extends StatefulWidget {
  const HomeWebView({super.key, required this.idRole});
  final int idRole ;

  @override
  State<HomeWebView> createState() => _HomeWebViewState();
}

class _HomeWebViewState extends State<HomeWebView> {

  UserModel? user ;
  StructureModel? structure ;
  int idRole = 0 ;
  int id = 0 ;

  getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getInt('idRole') ?? 0;
    });


    UserModel? item = await UserController().getUserDetails();
    if(item != null){
      setState(() {
        user = item ;
        idRole = user!.role_id ;
      });
    }
    else{
      List<StructureModel> listItem = await StructureController().getStructureWithArrondissement() ;
      if(listItem.isNotEmpty){
        setState(() {
          structure = listItem.first ;
          idRole = structure!.role_id;
        });

      }
    }
  }


  @override
  initState(){
    super.initState();
    setState(() {
      idRole = widget.idRole ;
    });
    if (kDebugMode) {
      print('homeweb') ;
      print(widget.idRole) ;
    }

    getUserData() ;
  }


  @override
  Widget build(BuildContext context) {
    return ResponsiveBreakpoints.builder(
      breakpoints: [
        const Breakpoint(start: 0, end: 450, name: MOBILE),
        const Breakpoint(start: 451, end: 960, name: TABLET),
        const Breakpoint(start: 961, end: double.infinity, name: DESKTOP),
      ],
      child: AccueilPage(idRole: widget.idRole,)
        );
  }
}

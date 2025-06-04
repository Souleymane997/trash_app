import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trash_app/web/homeweb.dart';
import 'package:trash_app/web/signup/login.dart';
import 'dart:io' show Platform;
import 'mobilephone/widgets/splash.dart';



class PlatformPage extends StatefulWidget {
  const PlatformPage({super.key});

  @override
  State<PlatformPage> createState() => _PlatformPageState();
}

class _PlatformPageState extends State<PlatformPage> {

  int idRole  = 0 ;
  getIdRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      idRole = prefs.getInt('idRole') ?? 0;
    });
  }

  @override
  initState() {
    super.initState();
    getIdRole() ;
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    if (kIsWeb) {
      if (user != null && idRole !=  0) {
        // L'utilisateur est connecté
        return HomeWebView(idRole: idRole,); // ou Dashboard, HomePage, etc.
      } else {
        // Pas connecté
        return const LoginWeb();
      }
    } else if (Platform.isAndroid) {
      return const Splash(); // mobile
    } else {
      return const Scaffold(body: Center(child: Text("Unsupported platform")));
    }
  }
}

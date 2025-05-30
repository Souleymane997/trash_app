import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trash_app/web/homeweb.dart';
import 'package:trash_app/web/signup/login.dart';
import 'dart:io' show Platform;
import 'mobilephone/widgets/splash.dart';


class PlatformPage extends StatelessWidget {
  const PlatformPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    if (kIsWeb) {
      if (user != null) {
        // L'utilisateur est connecté
        return const HomeWebView(); // ou Dashboard, HomePage, etc.
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

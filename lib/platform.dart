import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

import 'package:trash_app/web/homeweb.dart';
import 'mobilephone/widgets/splash.dart';


class PlatformPage extends StatelessWidget {
  const PlatformPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const HomeWebView(); // web
    } else if (Platform.isAndroid) {
      return const Splash(); // mobile
    } else {
      return const Scaffold(body: Center(child: Text("Unsupported platform")));
    }
  }
}

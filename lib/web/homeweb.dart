import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'menu/home.dart';

class HomeWebView extends StatelessWidget {
  const HomeWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBreakpoints.builder(
      breakpoints: [
        const Breakpoint(start: 0, end: 450, name: MOBILE),
        const Breakpoint(start: 451, end: 960, name: TABLET),
        const Breakpoint(start: 961, end: double.infinity, name: DESKTOP),
      ],
      child:  AccueilPage()//LoginWeb() ;
        );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'colors.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: vert().withValues(alpha: 0.5),
      child: Center(
        child: SpinKitCircle(
          color: blanc(),
          size: 50.0,
        ),
      ),
    );
  }
}

class LoadingExtend extends StatelessWidget {
  const LoadingExtend({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: noir().withValues(alpha: 0.75),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: SpinKitCircle(
          color: blanc(),
          size: 50.0,
        ),
      ),
    );
  }
}

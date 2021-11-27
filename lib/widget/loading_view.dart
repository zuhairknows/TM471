import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        color: Colors.black.withAlpha(0x66),
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}

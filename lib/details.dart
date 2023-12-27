import 'package:flutter/material.dart';

class Details extends StatelessWidget {
  const Details({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          children: [
            Center(
                child: Text(
              'Made By Manoj Bhatta',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            )),
            Center(
                child: Text(
              'powered by google mlkit image labeling',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            )),
          ],
        ),
      ),
    );
  }
}

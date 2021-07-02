import 'package:flutter/material.dart';

class Page3 extends StatelessWidget {
  const  Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text('Page3'),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text('<- Back'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
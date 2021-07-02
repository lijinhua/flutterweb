import 'package:flutter/material.dart';

import './page3.dart' deferred as pag3;
class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: pag3.loadLibrary(),
        builder: (context, snapshot) {
          return Scaffold(
            body: Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text('Page2'),
                    GestureDetector(
                      onTap: () =>goPage3(context),
                      child: Text('go page3'),
                    ),
                    GestureDetector(
                      onTap: () =>Navigator.pop(context),
                      child: Text('go back'),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
  void goPage3(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return pag3.Page3();
        } ,
      ),
    );
  }
}
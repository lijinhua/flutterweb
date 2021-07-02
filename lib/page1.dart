import 'package:flutter/material.dart';
// import './page2.dart' deferred as pag2;
import './page2.dart' deferred as pag2;
// import './page2.dart';
class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return FutureBuilder(future: pag2.loadLibrary(),
       builder:(context, snapshot){
        return Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Text('Page1'),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return pag2.Page2();
                      } ,
                    ),
                  ),
                  child: Text('Go to page 2'),
                )
              ],
            ),
          ),
        );
       } ,);
  }

}
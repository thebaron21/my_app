import 'package:flutter/material.dart';

class CRoute {
  BuildContext context;
  CRoute(this.context);

  static CRoute of(context) {
    return CRoute(context);
  }

  to(Function() page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return page();
        },
      ),
    );
  }
  // Navigator.pushAndRemoveUntil(newRoute, (route)=>false);
  pushRemove(Function() page){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => page()),
        ModalRoute.withName('/')
    );
  }
  push(Function() page){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return page();
        },
      ),
    );
  }

  pop() {
    Navigator.pop(context);
  }
}

import 'package:flutter/material.dart';

snackBar(BuildContext context, String text, String lbl) {
  final scaffold = ScaffoldMessenger.of(context);
  return scaffold.showSnackBar(
    SnackBar(
      backgroundColor:Colors.orange,
      //duration: Duration(seconds: 1),
      content: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          color: Colors.black,
        ),
      ),
      action: SnackBarAction(
        label: lbl,
        onPressed: scaffold.hideCurrentSnackBar,
        textColor: Colors.black,
      ),
    ),
  );
}

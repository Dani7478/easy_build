import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// ignore: non_constant_identifier_names
Widget loader() {
    return Center(
      child: LoadingAnimationWidget.hexagonDots(
        color: Color.fromARGB(255, 194, 135, 59),
        size: 80,
      ),
    );
  }

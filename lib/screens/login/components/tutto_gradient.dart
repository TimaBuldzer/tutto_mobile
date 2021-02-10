import 'package:flutter/material.dart';

LinearGradient buildLinearGradient() {
  return LinearGradient(
      colors: [Colors.green, Colors.white, Colors.red],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter);
}
import 'package:flutter/material.dart';

class Validator{
  static String? notNullOrEmpty(value){
    if (value == null || value.isEmpty) {
      return 'Por favor insira algum valor';
    }
    return null;
  }
  static bool isPasswordsEqual(String? pass1, String? pass2){
    return pass1==pass2;
  }

}
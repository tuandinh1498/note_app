import 'package:flutter/material.dart';
class HideKeyBoard{
  static void hideKeyBoard(){
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
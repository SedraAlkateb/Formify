// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

enum LanguageType{
  ENGLISH,
ARABIC }

const String ARABIC="ar";
const String ENGLISH="en";
const String ASSET_PATH_LOCALISATION="assets/lang";

const Locale ARABIC_LOCALE=Locale("ar");
const Locale ENGLISH_LOCALE=Locale("en");
extension LanguageTypeExtension on LanguageType{
  String getValue(){
switch(this) {
  case LanguageType.ENGLISH:
  return ENGLISH;
  case LanguageType.ARABIC:
    return ARABIC;
}
}
}
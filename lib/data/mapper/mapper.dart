
import 'package:formify/app/constants.dart';
import 'package:formify/data/responses/responses.dart';
import 'package:formify/domain/models/models.dart';

extension LoginResponseMapper on LoginResponse? {
  LoginModel toDomain() {
    return LoginModel(
     9,
     9,
     9,
      "o",
      true,
    "9",
    );
  }
}



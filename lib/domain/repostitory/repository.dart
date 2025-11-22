
import 'package:dartz/dartz.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';

abstract class Repository {
  Future<Either<Failure, LoginModel>> login(int loginRequest);

}

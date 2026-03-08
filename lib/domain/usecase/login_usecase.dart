import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/request.dart';
import 'package:formify/domain/repostitory/repository.dart';
class LoginUsecase extends Equatable {
  final  Repository _repository;
  const LoginUsecase(this._repository);
  Future<Either<Failure, Null>> execute(LoginRequest loginRequest) async{
    return await _repository.login(loginRequest);
  }

  @override
  List<Object?> get props => [_repository];

}





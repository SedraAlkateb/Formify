import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/repostitory/repository.dart';
class CheckPasswordUsecase extends Equatable {
  final  Repository _repository;
  const CheckPasswordUsecase(this._repository);
  Future<Either<Failure, bool>> execute(String password) async{
    return await _repository.checkPassword(password);
  }

  @override
  List<Object?> get props => [_repository];

}





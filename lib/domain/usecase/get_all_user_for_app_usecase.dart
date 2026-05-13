import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository.dart';
class GetAllUserForAppUsecase extends Equatable {
  final  Repository _repository;
  const GetAllUserForAppUsecase(this._repository);
  Future<Either<Failure,  List<UserModel>>> execute() async{
    return await _repository.getAllUsers();
  }
  @override
  List<Object?> get props => [_repository];

}





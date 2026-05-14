import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository.dart';
class GetAllSpecUsecase extends Equatable {
  final  Repository _repository;
  const GetAllSpecUsecase(this._repository);
  Future<Either<Failure, List<SpecModel>>> execute() async{
    return await _repository.getAllSpecification();
  }

  @override
  List<Object?> get props => [_repository];

}





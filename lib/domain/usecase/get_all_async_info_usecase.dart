import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository.dart';
class GetAllAsyncInfoUsecase extends Equatable {
  final  Repository _repository;
  const GetAllAsyncInfoUsecase(this._repository);
  Future<Either<Failure, GetAsyncModel>> execute(int id) async{
    return await _repository.getAllInformationConference(id);
  }
  @override
  List<Object?> get props => [_repository];

}





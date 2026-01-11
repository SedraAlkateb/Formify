import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository.dart';
class GetConferenceByIdUsecase extends Equatable {
  final  Repository _repository;
  const GetConferenceByIdUsecase(this._repository);
  Future<Either<Failure,  GetAllConferenceByIdModel>> execute(int id) async{
    return await _repository.getConferenceById(id);
  }
  @override
  List<Object?> get props => [_repository];

}





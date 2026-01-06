import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/repostitory/repository.dart';
class DeleteConferenceUsecase extends Equatable {
  final  Repository _repository;
  const DeleteConferenceUsecase(this._repository);
  Future<Either<Failure, Null>> execute(int id) async{
    return await _repository.deleteConference(id);
  }

  @override
  List<Object?> get props => [_repository];

}





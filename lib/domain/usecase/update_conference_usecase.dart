import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository.dart';
class UpdateConferenceUsecase extends Equatable {
  final  Repository _repository;
  const UpdateConferenceUsecase(this._repository);
  Future<Either<Failure, Null>> execute(int id, ConferenceModel conference) async{
    return await _repository.updateConference(id,conference);
  }

  @override
  List<Object?> get props => [_repository];

}





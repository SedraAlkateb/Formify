import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository.dart';
class CreateConferenceUsecase extends Equatable {
  final  Repository _repository;
  const CreateConferenceUsecase(this._repository);
  Future<Either<Failure, int>> execute(ConferenceModel conference) async{
    return await _repository.createConference(conference);
  }

  @override
  List<Object?> get props => [_repository];

}





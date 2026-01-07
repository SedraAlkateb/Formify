import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository.dart';
class CreateUserWithConferenceId extends Equatable {
  final  Repository _repository;
  const CreateUserWithConferenceId(this._repository);
  Future<Either<Failure, int>> execute(UserInputModel userInputModel) async{
    return await _repository.createUserWithConferenceId(userInputModel);
  }

  @override
  List<Object?> get props => [_repository];

}





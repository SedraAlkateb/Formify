import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository.dart';
class SynchronizeUsersAnswersUsecase extends Equatable {
  final  Repository _repository;
  const SynchronizeUsersAnswersUsecase(this._repository);
  Future<Either<Failure, Null>> execute(AllUserModel user) async{
    return await _repository.synchronizeUsersAnswers(user);
  }

  @override
  List<Object?> get props => [_repository];

}





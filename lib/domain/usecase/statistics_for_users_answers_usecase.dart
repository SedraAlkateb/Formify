import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository.dart';
class StatisticsForUsersAnswersUsecase extends Equatable {
  final  Repository _repository;
  const StatisticsForUsersAnswersUsecase(this._repository);
  Future<Either<Failure, ExelModel>> execute(int surveyId) async{
    return await _repository.statisticsForUsersAnswers(surveyId);
  }

  @override
  List<Object?> get props => [_repository];

}





import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository.dart';
class StatisticsSurveyUsecase extends Equatable {
  final  Repository _repository;
  const StatisticsSurveyUsecase(this._repository);
  Future<Either<Failure, List<QuestionsStatisticsModel>>> execute(int surveyId, int conferenceId) async{
    return await _repository.getStatisticsForQuestionTypes(surveyId,conferenceId);
  }

  @override
  List<Object?> get props => [_repository];

}





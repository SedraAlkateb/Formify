import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository_sql.dart';

class GetQuestionAnswersUsecase extends Equatable {
  final RepositorySql _repository;
  const GetQuestionAnswersUsecase(this._repository);
  Future<Either<Failure,  List<QuestionModel>>> execute(int surveyId) async {
    return await _repository.getSurveyQuestionsWithAnswers(surveyId);
  }

  @override
  List<Object?> get props => [_repository];
}

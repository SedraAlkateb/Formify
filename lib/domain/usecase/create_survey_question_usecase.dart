import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository.dart';
class CreateSurveyQuestionUsecase extends Equatable {
  final  Repository _repository;
  const CreateSurveyQuestionUsecase(this._repository);
  Future<Either<Failure, Null>> execute(SurveyQuestionAndAnswersModel survey) async{
    return await _repository.createSurveyQuestionsAndAnswers(survey);
  }

  @override
  List<Object?> get props => [_repository];

}





import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/request.dart';
import 'package:formify/domain/repostitory/repository.dart';
class LinkSurveyConferenceUsecase extends Equatable {
  final  Repository _repository;
  const LinkSurveyConferenceUsecase(this._repository);
  Future<Either<Failure, Null>> execute(SurveyConference surveyConference) async{
    return await _repository.linkSurveyConference(surveyConference);
  }

  @override
  List<Object?> get props => [_repository];

}





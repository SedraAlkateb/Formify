import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/request.dart';
import 'package:formify/domain/repostitory/repository.dart';
class CreateSurveyUsecase extends Equatable {
  final  Repository _repository;
  const CreateSurveyUsecase(this._repository);
  Future<Either<Failure, CreateSurveyModel>> execute(SurveyRequest survey) async{
    return await _repository.createSurvey(survey);
  }

  @override
  List<Object?> get props => [_repository];

}





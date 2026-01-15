import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository.dart';
class GetSurveyQuestionIdUsecase extends Equatable {
  final  Repository _repository;
  const GetSurveyQuestionIdUsecase(this._repository);
  Future<Either<Failure,  SurveyModel>> execute(int id) async{
    return await _repository.getSurveyWithQuestionById(id);
  }
  @override
  List<Object?> get props => [_repository];

}





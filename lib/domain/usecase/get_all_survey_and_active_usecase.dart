import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository.dart';
class GetAllSurveyAndActiveUsecase extends Equatable {
  final  Repository _repository;
  const GetAllSurveyAndActiveUsecase(this._repository);
  Future<Either<Failure,  List<IsActiveMainSurveyModel>>> execute(int conferenceId) async{
    return await _repository.getAllSurveyAndActiveSurvey(conferenceId);
  }
  @override
  List<Object?> get props => [_repository];

}





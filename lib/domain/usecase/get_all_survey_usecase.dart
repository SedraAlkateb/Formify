import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository.dart';
class GetAllSurveyUsecase extends Equatable {
  final  Repository _repository;
  const GetAllSurveyUsecase(this._repository);
  Future<Either<Failure,  List<MainSurveyModel>>> execute() async{
    return await _repository.getAllSurvey();
  }
  @override
  List<Object?> get props => [_repository];

}





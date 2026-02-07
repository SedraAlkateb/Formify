import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository.dart';
class GetUserAnswersSurveyUsecase extends Equatable {
  final  Repository _repository;
  const GetUserAnswersSurveyUsecase(this._repository);
  Future<Either<Failure, SurveyUserModel>> execute(int id,int userId) async{
    return await _repository.getUserAnswersForSpecificSurvey(id,userId);
  }
  @override
  List<Object?> get props => [_repository];

}





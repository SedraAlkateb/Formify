import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/request.dart';
import 'package:formify/domain/repostitory/repository.dart';
class UpdateSurveyUsecase extends Equatable {
  final  Repository _repository;
  const UpdateSurveyUsecase(this._repository);
  Future<Either<Failure, Null>> execute(UpdateSurveyRequest update) async{
    return await _repository.updateSurvey(update);
  }

  @override
  List<Object?> get props => [_repository];

}





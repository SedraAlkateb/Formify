import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository_sql.dart';

class GetSurveysSqlUsecase extends Equatable {
  final RepositorySql _repository;
  const GetSurveysSqlUsecase(this._repository);
  Future<Either<Failure, List<MainSurveyModel>>> execute() async {
    return await _repository.getSurveys();
  }

  @override
  List<Object?> get props => [_repository];
}

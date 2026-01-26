import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository_sql.dart';

class GetUserAnswerSqlUsecase extends Equatable {
  final RepositorySql _repository;
  const GetUserAnswerSqlUsecase(this._repository);
  Future<Either<Failure, AllUserModel>> execute() async {
    return await _repository.getDataSql();
  }

  @override
  List<Object?> get props => [_repository];
}

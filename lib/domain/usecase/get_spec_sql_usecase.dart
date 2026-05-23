import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository_sql.dart';

class GetSpecSqlUsecase extends Equatable {
  final RepositorySql _repository;
  const GetSpecSqlUsecase(this._repository);
  Future<Either<Failure, List<SpecModel>>> execute() async {
    return await _repository.getSpec();
  }

  @override
  List<Object?> get props => [_repository];
}

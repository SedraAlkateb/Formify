import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository_sql.dart';

class GetDoctorsAsMapSqlUsecase extends Equatable {
  final RepositorySql _repository;
  const GetDoctorsAsMapSqlUsecase(this._repository);
  Future<Either<Failure, Map<String, DoctorsModel>>> execute() async {
    return await _repository.getDoctorsAsMap();
  }

  @override
  List<Object?> get props => [_repository];
}

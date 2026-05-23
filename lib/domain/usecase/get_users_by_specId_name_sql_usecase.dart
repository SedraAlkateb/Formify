import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository_sql.dart';

class GetUsersBySpecIdNameSqlUsecase extends Equatable {
  final RepositorySql _repository;
  const GetUsersBySpecIdNameSqlUsecase(this._repository);
  Future<Either<Failure, List<UserModel>>> execute(int specId, String name) async {
    return await _repository.getUsersBySpecIdAndName(specId,name);
  }

  @override
  List<Object?> get props => [_repository];
}

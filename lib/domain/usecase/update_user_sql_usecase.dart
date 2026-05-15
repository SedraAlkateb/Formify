import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository_sql.dart';

class UpdateUserSqlUsecase extends Equatable {
  final RepositorySql _repository;
  const UpdateUserSqlUsecase(this._repository);
  Future<Either<Failure, void>> execute(UserModel user) async {
    return await _repository.updateUser(user);
  }

  @override
  List<Object?> get props => [_repository];
}

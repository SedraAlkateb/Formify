import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/repostitory/repository_sql.dart';

class DeleteUserSqlUsecase extends Equatable {
  final RepositorySql _repository;
  const DeleteUserSqlUsecase(this._repository);
  Future<Either<Failure,void>> execute() async {
    return await _repository.deleteUser();
  }

  @override
  List<Object?> get props => [_repository];
}

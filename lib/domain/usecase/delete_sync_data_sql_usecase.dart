import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository_sql.dart';

class DeleteSyncDataSqlUsecase extends Equatable {
  final RepositorySql _repository;
  const DeleteSyncDataSqlUsecase(this._repository);
  Future<Either<Failure, void>> execute() async {
    return await _repository.deleteSyncData();
  }

  @override
  List<Object?> get props => [_repository];
}

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository_sql.dart';

class AddSyncDataSqlUsecase extends Equatable {
  final RepositorySql _repository;
  const AddSyncDataSqlUsecase(this._repository);
  Future<Either<Failure, void>> execute( SaveDataBaseModel baseData) async {
    return await _repository.addSyncData(baseData);
  }

  @override
  List<Object?> get props => [_repository];
}

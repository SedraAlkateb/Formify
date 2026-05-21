import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository_sql.dart';

class AddServerIdUserSqlUsecase extends Equatable {
  final RepositorySql _repository;
  const AddServerIdUserSqlUsecase(this._repository);
  Future<Either<Failure, void>> execute( List<AddModifyUser>syncedUsers) async {
    return await _repository.addServerIdToUser(syncedUsers);
  }

  @override
  List<Object?> get props => [_repository];
}

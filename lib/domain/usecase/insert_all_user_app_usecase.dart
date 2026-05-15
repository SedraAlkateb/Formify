import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository_sql.dart';

class InsertAllUserAppUsecase extends Equatable {
  final RepositorySql _repository;
  const InsertAllUserAppUsecase(this._repository);
  Future<Either<Failure, void>> execute(List<UserModel> users) async {
    return await _repository.insertAllUsers(users);
  }

  @override
  List<Object?> get props => [_repository];
}

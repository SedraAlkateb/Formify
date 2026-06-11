import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository_sql.dart';

class GetUsersBySpecIdsSqlUsecase extends Equatable {
  final RepositorySql _repository;
  const GetUsersBySpecIdsSqlUsecase(this._repository);
  Future<Either<Failure, ConferenceUserAtt>> execute() async {
    return await _repository.getUsersBySpecIds();
  }

  @override
  List<Object?> get props => [_repository];
}

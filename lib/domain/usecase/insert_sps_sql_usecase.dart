import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository_sql.dart';

class InsertSpsSqlUsecase extends Equatable {
  final RepositorySql _repository;
  const InsertSpsSqlUsecase(this._repository);
  Future<Either<Failure,void>> execute(List<SpecModel>specs) async {
    return await _repository.insertSpecs(specs);
  }

  @override
  List<Object?> get props => [_repository];
}

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository.dart';
class AddSpecUsecase extends Equatable {
  final Repository _repository;
  const AddSpecUsecase(this._repository);
  Future<Either<Failure, SpecModel>> execute(String title) async {
    return await _repository.addSpecification(title);
  }

  @override
  List<Object?> get props => [_repository];
}

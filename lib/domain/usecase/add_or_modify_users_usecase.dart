import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository.dart';
class AddOrModifyUsersUsecase extends Equatable {
  final Repository _repository;
  const AddOrModifyUsersUsecase(this._repository);
  Future<Either<Failure, List<AddModifyUser>>> execute(AddAndModifyUsersRequest users) async {
    return await _repository.addOrModifyUsers(users);
  }

  @override
  List<Object?> get props => [_repository];
}

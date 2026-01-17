import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository.dart';
class GetAllUserUsecase extends Equatable {
  final  Repository _repository;
  const GetAllUserUsecase(this._repository);
  Future<Either<Failure,  List<UserModel>>> execute(int conferenceId) async{
    return await _repository.getUsersByConferenceId(conferenceId);
  }
  @override
  List<Object?> get props => [_repository];

}





import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/repostitory/repository.dart';
class GetAllConferenceUsecase extends Equatable {
  final  Repository _repository;
  const GetAllConferenceUsecase(this._repository);
  Future<Either<Failure,  List<GetAllConferenceModel>>> execute(int isActive) async{
    return await _repository.getAllConference(isActive);
  }
  @override
  List<Object?> get props => [_repository];

}






import 'package:dartz/dartz.dart';
import 'package:formify/data/network/failure.dart';
import 'package:formify/domain/models/models.dart';

abstract class RepositorySql {
  Future<Either<Failure, String>> asyncData(GetAsyncModel asyncData);
  Future<Either<Failure, void>>  deleteData();
  Future<Either<Failure, List<UserSqlModel>>> getDataSql();
  Future<Either<Failure, GetAllConferenceModel?>>getConference();
  Future<Either<Failure, List<MainSurveyModel>>>getSurveys();
  Future<Either<Failure, List<QuestionModel>>>getSurveyQuestionsWithAnswers(int surveyId);
  Future<Either<Failure, void>>  insertUserWithAnswer(UserSqlModel user);
  Future<Either<Failure, InfoConference>>  getConferenceInfo();
  Future<Either<Failure, void>>  deleteUser();
  Future<Either<Failure, List<UserModel>>>  getDoctors();
  Future<Either<Failure,void>> insertDoctor(UserModel doctor);
  Future<Either<Failure,List<UserModel>>> getUserConference(int conferenceId);
  Future<Either<Failure,void>> updateUser(UserModel user);
  Future<Either<Failure,void>> insertAllUsers(List<UserModel> users);
  Future<Either<Failure,void>> insertAllUsersForNewConf();

  Future<Either<Failure,List<UserModel>>> getAllImportantDoctorNotCome(List<UserModel> users);
  Future<Either<Failure,List<DoctorMockItem>>> refreshAndSyncUsers();
  Future<Either<Failure,void>> updateIsDone(int isDone,int doctorId);
  Future<Either<Failure,AddAndModifyUsersRequest>> getUserAddAndModify();
  Future<Either<Failure,void>> addServerIdToUser(List<AddModifyUser>syncedUsers) ;
  Future<Either<Failure,SyncUsersRequest>>getConferenceAndAnswers(int conferenceId) ;
  Future<Either<Failure,void>>deleteSyncData() ;
  Future<Either<Failure,void>>addSyncData(SaveDataBaseModel baseData);
  Future<Either<Failure,List<SpecModel>>>getSpec();
  Future<Either<Failure,List<UserModel>>>getUsersBySpecIdAndName(int specId, String name);
  Future<Either<Failure,void>>insertSpecs(List<SpecModel> specs);
  Future<Either<Failure,ConferenceUserAtt>>getUsersBySpecIds();

}

import 'package:formify/app/constants.dart';
import 'package:formify/data/responses/responses.dart';
import 'package:formify/domain/models/models.dart';


extension GetMainSurveyModelMapper on GetSurveyResponse? {
  MainSurveyModel toDomain() {
    return MainSurveyModel(
      this?.id ?? Constants.zero,
      this?.title ?? Constants.empty,
      this?.description ?? Constants.empty,
      this?.color ?? Constants.empty,
    );
  }
}
extension GetAllMainSurveyModelMapper on GetAllSurveyBaseResponse? {
  List<MainSurveyModel> toDomain() {
    List<MainSurveyModel> allSurvey = (this?.data.map((response) => response.toDomain()) ??
        const Iterable.empty())
        .cast<MainSurveyModel>()
        .toList();
    return allSurvey;
  }
}


extension CreateSurveyModelMapper on CreateSurveyBaseResponse? {
  CreateSurveyModel toDomain() {
    return CreateSurveyModel(
      this?.data.id ?? Constants.zero,
      this?.data.title ?? Constants.empty,
    );
  }
}
extension GetConferenceMapper on GetAllConferenceResponse? {
  GetAllConferenceModel toDomain() {
    return GetAllConferenceModel(
      this?.id ?? Constants.zero,
      this?.name ?? Constants.empty,
      this?.description ?? Constants.empty,
      this?.address ?? Constants.empty,
      this?.start_date ?? Constants.empty,
      this?.end_date ?? Constants.empty,
      this?.is_active ??false,
    );
  }
}
extension GetAllConferenceMapper on GetAllConferenceBaseResponse? {
  List<GetAllConferenceModel> toDomain() {
    List<GetAllConferenceModel> allConference = (this?.data.map((response) => response.toDomain()) ??
        const Iterable.empty())
        .cast<GetAllConferenceModel>()
        .toList();
    return allConference;
  }
}

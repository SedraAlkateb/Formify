
class SurveyRequest {
  String title;
  String description;
  String color;
  String timer;

  SurveyRequest(this.title, this.description, this.color, this.timer);
}
class SurveyConference {
  int survey_id;
      int conference_id;
  int survey_order;
  bool is_active;
  SurveyConference(this.survey_id, this.conference_id, this.survey_order,this.is_active);
}

class LoginRequest{
  String password;
  String username;
  LoginRequest(this.username,this.password);
}
class SurveyRequest {
  String title;
  String description;
  String color;

  SurveyRequest(this.title, this.description, this.color);
}
class SurveyConference {
  int survey_id;
      int conference_id;
  int survey_order;
  SurveyConference(this.survey_id, this.conference_id, this.survey_order);
}

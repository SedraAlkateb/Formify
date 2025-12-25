import 'package:formify/domain/models/model_q.dart';

class LoginModel {
  int cityId;
  int repId;
  int samplesCount;
  String name;
  bool isLogin;
  String repType;

  LoginModel(
    this.cityId,
    this.repId,
    this.samplesCount,
    this.name,
    this.isLogin,
    this.repType,
  );
}

class SurveyModel {

  String title;
  String description;
  String color;

  List<QuestionModel> questions;

  SurveyModel({

    required this.title,
    required this.description,
    required this.color,
    required this.questions,
  });

  /// إنشاء Survey فارغ مع قائمة أسئلة جاهزة
  static SurveyModel create() {
    return SurveyModel(
      title: "",
      description: "",
      color: "",

      questions: [], // أصبحت قائمة أسئلة وليس سؤال واحد
    );
  }
}

class QuestionModel {
  String title;
  int order;
  bool isRequired;
  QuestionType type;
  List<String> answers;

  QuestionModel({
    required this.title,
    required this.order,
    required this.isRequired,
    required this.type,
    required this.answers,
  });

  /// إنشاء كائن فارغ جاهز للاستخدام
  static QuestionModel create() {
    return QuestionModel(
      title: "",
      order: 1,
      isRequired: false,
      type: QuestionType.text,
      answers: [],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'order': order,
      'isRequired': isRequired,
      'Type': type.name,
      'answer': answers,
    };
  }

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
     title:  map['title'],
      order:  map['order'],
      isRequired:   map['isRequired'],
      type:  map['Type'],
      answers:  map['answer'],
    );
  }
}

class SurveyQuestionAndAnswersModel {
  int id;
  List<QuestionModel> questionAndAnswers;
  SurveyQuestionAndAnswersModel(this.id,this.questionAndAnswers);
  Map<String, dynamic> toJson() {
    return {'id': this.id, 'qus': questionAndAnswers.map((e) => e.toMap()).toList()};
  }
}


class CreateSurveyModel{
  int id;
  String title;

  CreateSurveyModel(this.id, this.title);

}
class MainSurveyModel {
  int id;
  String title;
  String description;
  String color;

  MainSurveyModel(this.id, this.title, this.description, this.color);

}
class ConferenceModel {
  String name;
  String description;
  String address;
  String startDate;
  String endDate;
  int isActive;

  ConferenceModel(this.name, this.description, this.address, this.startDate,
      this.endDate, this.isActive);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'address': address,
      'start_date': startDate,
      'end_date': endDate,
      'is_active': isActive,
    };
  }
  factory ConferenceModel.fromMap(Map<String, dynamic> map) {
    return ConferenceModel(
        map['name'],
      map['description'],
        map['address'],
       map['start_date'],
       map['end_date'],
      map['is_active']
    );
  }

}

class GetAllConferenceModel{
  int id;
  String name;
  String description;
  String address;
  String startDate;
  String endDate;
  bool isActive;

  GetAllConferenceModel(this.id, this.name, this.description, this.address,
      this.startDate, this.endDate, this.isActive);
}
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

      questions: [],     // أصبحت قائمة أسئلة وليس سؤال واحد
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
}

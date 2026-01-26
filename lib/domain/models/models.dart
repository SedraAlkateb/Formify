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
  int? id;
  String title;
  String description;
  String color;

  List<QuestionModel> questions;

  SurveyModel({
    this.id,
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
///*
///class QuestionModel {
//   int? id;
//   String title;
//   int order;
//   bool isRequired;
//   QuestionType type;
//   List<AnswerModel> answers;
//
//   QuestionModel({
//     this.id,
//     required this.title,
//     required this.order,
//     required this.isRequired,
//     required this.type,
//     required this.answers,
//   });
//
//   factory QuestionModel.fromMap(
//     Map<String, dynamic> map,
//     List<AnswerModel> answers,
//   ) {
//     return QuestionModel(
//       id: map['question_id'],
//       title: map['question'],
//       order: map['question_order'],
//       isRequired: map['is_required'] == 1,
//       type: QuestionType.values.byName(map['type']),
//       answers: answers,
//     );
//   }
// }
///
class QuestionModel {
  int? id;
  String title;
  int order;
  bool isRequired;
  QuestionType type;
  List<AnswerModel> answers;

  QuestionModel({
    this.id,
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
      'id': id,
      'title': title,
      'order': order,
      'isRequired': isRequired,
      'Type': type.name,
      'answer': answers,
    };
  }

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['id'],
      title: map['title'],
      order: map['order'],
      isRequired: map['isRequired'],
      type: map['Type'],
      answers: map['answer'],
    );
  }
}

class SurveyQuestionAndAnswersModel {
  int id;
  List<QuestionModel> questionAndAnswers;
  SurveyQuestionAndAnswersModel(this.id, this.questionAndAnswers);
  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'qus': questionAndAnswers.map((e) => e.toMap()).toList(),
    };
  }
}

class CreateSurveyModel {
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'color': color,
    };
  }

  factory MainSurveyModel.fromMap(Map<String, dynamic> map) {
    return MainSurveyModel(
      map['id'],
      map['title'],
      map['description'],
      map['color'],
    );
  }
}

class IsActiveMainSurveyModel {
  int id;
  String title;
  String description;
  String color;
  bool isActive;
  IsActiveMainSurveyModel(
    this.id,
    this.title,
    this.description,
    this.color,
    this.isActive,
  );
}

class ConferenceModel {
  String name;
  String description;
  String address;
  String startDate;
  String endDate;
  int isActive;

  ConferenceModel(
    this.name,
    this.description,
    this.address,
    this.startDate,
    this.endDate,
    this.isActive,
  );

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
      map['is_active'],
    );
  }
}

class AnswerModel {
  int? answer_id;
  String content;

  AnswerModel(this.answer_id, this.content);

  Map<String, dynamic> toJson() {
    return {'answer_id': answer_id, 'content': content};
  }

  factory AnswerModel.fromMap(Map<String, dynamic> map) {
    return AnswerModel(map['answer_id'], map['content']);
  }
}

class UseAnswerModel {
  int user_id;
  List<AnswerModel> answersModel;
  UseAnswerModel(this.user_id, this.answersModel);
  Map<String, dynamic> toJson() {
    return {
      'user_id': this.user_id,
      'answers': answersModel.map((e) => e.toJson()).toList(),
    };
  }
}

class UserInputModel {
  String fullName;
  String email;
  String phone;
  String address;
  int conferenceId;
  UserInputModel(
    this.fullName,
    this.email,
    this.phone,
    this.address,
    this.conferenceId,
  );
}

class UserModel {
  int id; // المعرف
  String fullName; // الاسم الكامل
  String email; // البريد الإلكتروني
  String phone; // رقم الهاتف
  String address; // العنوان
  // List<AnswerSqlModel> answersModel; // قائمة الإجابات المرتبطة بالمستخدم

  // مُنشئ لتخزين البيانات
  UserModel(
    this.id,
    this.fullName,
    this.email,
    this.phone,
    this.address,
    //   required this.answersModel,
  );

  // تحويل البيانات إلى JSON (لاستخدامها مع قاعدة البيانات أو الواجهة)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      // 'answers': answersModel
      //     .map((answer) => answer.toJson())
      //     .toList(), // تحويل قائمة الإجابات
    };
  }

  // تحويل البيانات من قاعدة البيانات إلى كائن من UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      map['id'],
      map['full_name'],
      map['email'],
      map['phone'],
      map['address'],
      // answersModel: List<AnswerSqlModel>.from(
      //   map['answers'].map((answer) => AnswerSqlModel.fromMap(answer)),
      // ), // تحويل الإجابات المرتبطة
    );
  }
}

class AnswerSqlModel {
  int answer_id;
  int user_id;
  String content;

  AnswerSqlModel({
    required this.answer_id,
    required this.user_id,
    required this.content,
  });

  // تحويل الإجابة إلى JSON
  Map<String, dynamic> toJson() {
    return {'answer_id': answer_id, 'user_id': user_id, 'content': content};
  }

  // تحويل الإجابة من الخريطة
  factory AnswerSqlModel.fromMap(Map<String, dynamic> map) {
    return AnswerSqlModel(
      answer_id: map['answer_id'],
      user_id: map['user_id'],
      content: map['content'],
    );
  }
}

class GetAllConferenceModel {
  int id;
  String name;
  String description;
  String address;
  String startDate;
  String endDate;
  bool isActive;

  GetAllConferenceModel(
    this.id,
    this.name,
    this.description,
    this.address,
    this.startDate,
    this.endDate,
    this.isActive,
  );
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'start_date': startDate,
      'end_date': endDate,
      'is_active': isActive ? 1 : 0,
    };
  }

  factory GetAllConferenceModel.fromMap(Map<String, dynamic> map) {
    return GetAllConferenceModel(
      map['id'],
      map['name'],
      map['description'],
      map['address'],
      map['start_date'],
      map['end_date'],
      map['is_active']==1?true:false,
    );
  }
  static GetAllConferenceModel create(){
    return GetAllConferenceModel(0, "", "", "", "", "", false);
  }
}

class GetAllConferenceByIdModel {
  int id;
  String name;
  String description;
  String address;
  String startDate;
  String endDate;
  bool isActive;
  List<SurveyToConferenceModel> surveys;
  GetAllConferenceByIdModel(
    this.id,
    this.name,
    this.description,
    this.address,
    this.startDate,
    this.endDate,
    this.isActive,
    this.surveys,
  );
}

class SurveyToConferenceModel {
  int id;
  String title;
  String description;
  String color;
  int survey_order;
  SurveyToConferenceModel(
    this.id,
    this.title,
    this.description,
    this.color,
    this.survey_order,
  );
}

class GetAsyncModel {
  GetAllConferenceModel conferenceModel;
  List<MainSurveyModel> surveys;
  List<AsyncQuestionModel> questions;
  List<GetAsyncAnswerModel> answers;
  List<SurveyConferenceAsyncModel> surveyConference;

  GetAsyncModel(
    this.conferenceModel,
    this.surveys,
    this.questions,
    this.answers,
    this.surveyConference,
  );
static  GetAsyncModel create(){
    return GetAsyncModel(GetAllConferenceModel.create(), [], [], [], []);
  }
}

class AsyncQuestionModel {
  int? id;
  String title;
  int order;
  bool isRequired;
  QuestionType type;
  int survey_id;
  AsyncQuestionModel(
    this.id,
    this.title,
    this.order,
    this.isRequired,
    this.type,
    this.survey_id,
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'survey_id': survey_id,
      'question': title,
      'question_order': order,
      'is_required': isRequired ? 1 : 0,
      'type': type.name,
    };
  }

  factory AsyncQuestionModel.fromMap(Map<String, dynamic> map) {
    return AsyncQuestionModel(
      map['id'],
      map['question'],
      map['question_order'],
      map['is_required']==1?true:false,
      convertToQuestionType(map['type']),
      map['survey_id'],
    );
  }
}

class GetAsyncAnswerModel {
  int id;
  int questionId;
  String title;

  GetAsyncAnswerModel(this.id, this.questionId, this.title);
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'question_id': questionId};
  }

  factory GetAsyncAnswerModel.fromMap(Map<String, dynamic> map) {
    return GetAsyncAnswerModel(map['id'], map['question_id'], map['title']);
  }
}

class SurveyConferenceAsyncModel {
  int id;
  int survey_order;
  int survey_id;
  int conference_id;

  SurveyConferenceAsyncModel(
    this.id,
    this.survey_order,
    this.survey_id,
    this.conference_id,
  );
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'survey_id': survey_id,
      'conference_id': conference_id,
      'survey_order': survey_order,
    };
  }
  factory SurveyConferenceAsyncModel.fromMap(Map<String, dynamic> map) {
    return SurveyConferenceAsyncModel(
        map['id'],
        map['survey_order'],
        map['survey_id'],
        map['conference_id']

    );
  }
}

class UserSqlModel {
  String fullName; // الاسم الكامل
  String email; // البريد الإلكتروني
  String phone; // رقم الهاتف
  String address; // العنوان
  List<AnswerModel> answerModel;
  // مُنشئ لتخزين البيانات
  UserSqlModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.answerModel,
  });
  Map<String, dynamic> toJson() {
    return {
      'fullname': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'answers': answerModel.map((user) => user.toJson()).toList(),
    };
  }

  factory UserSqlModel.fromMap(Map<String, dynamic> map) {
    return UserSqlModel(
      fullName: map['fullname'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      answerModel: map['answers'],
    );
  }
}

//
class AllUserModel {
  List<UserSqlModel> users; // قائمة من المستخدمين (UserModel)

  AllUserModel(this.users); // المُنشئ الذي يأخذ قائمة المستخدمين

  Map<String, dynamic> toJson() {
    return {
      'users': users
          .map((user) => user.toJson())
          .toList(), // تحويل قائمة المستخدمين إلى JSON
    };
  }

  factory AllUserModel.fromJson(Map<String, dynamic> map) {
    return AllUserModel(
      List<UserSqlModel>.from(
        map['users'].map((userMap) => UserModel.fromMap(userMap)),
      ),
    );
  }
}

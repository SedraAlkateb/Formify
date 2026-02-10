import 'dart:io';

import 'package:formify/domain/models/model_q.dart';
import 'package:image_picker/image_picker.dart';

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

class SurveyUserModel {
  SurveyModel surveyModel;
  Map<int, List<String>> answerUser;
  SurveyUserModel({required this.surveyModel, required this.answerUser});
}

class AnswerUserSurveyModel {
  int id;
  int answer_id;
  String content;
  AnswerUserSurveyModel(this.id, this.answer_id, this.content);
}



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
  QuestionModel instanceQuestion() {
    return QuestionModel(
      title: title,
      order: order,
      isRequired: isRequired,
      type: type,
      answers: answers,
    );
  }

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
      'answer': answers.isEmpty
          ? [
              {"title": type.answer, "img": ""},
            ]
          : answers.map((e) => e.toJson()).toList(),
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
  factory QuestionModel.fromDbRow({
    required Map<String, dynamic> qRow,
    required List<AnswerModel> answers,
  }) {
    return QuestionModel(
      id: qRow['id'] as int?,
      title: qRow['question'] as String,
      order: (qRow['question_order'] as int?) ?? 0,
      isRequired: ((qRow['is_required'] as int?) ?? 0) == 1,
      type: convertToQuestionType((qRow['type'] as String?) ?? 'text'),
      answers: answers,
    );
  }
}

class CreateAnswer {}

////createSurveyQuestionsAndAnswers
class SurveyQuestionAndAnswersModel {
  int id;
  List<QuestionModel> questionAndAnswers;
  SurveyQuestionAndAnswersModel(this.id, this.questionAndAnswers);
  Map<String, dynamic> toJson() {
    return {'id': id, 'qus': questionAndAnswers.map((e) => e.toMap()).toList()};
  }
}

//  Future<Either<Failure, CreateSurveyModel>> createSurvey(SurveyRequest survey);
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

//////////////////////////////// for user
class AnswerUserModel {
  int? answer_id;
  String content;

  AnswerUserModel(this.answer_id, this.content);

  Map<String, dynamic> toJson() {
    return {'answer_id': answer_id, 'content': content};
  }

  Map<String, dynamic> toJsonSql(int userId) {
    return {'user_id': userId, 'answer_id': answer_id, 'content': content};
  }

  factory AnswerUserModel.fromMap(Map<String, dynamic> map) {
    return AnswerUserModel(map['answer_id'], map['content']);
  }
}

class UseAnswerModel {
  int user_id;
  List<AnswerUserModel> answersModel;
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
      map['is_active'] == 1 ? true : false,
    );
  }
  static GetAllConferenceModel create() {
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
  List<AnswerModel> answers;
  List<SurveyConferenceAsyncModel> surveyConference;

  GetAsyncModel(
    this.conferenceModel,
    this.surveys,
    this.questions,
    this.answers,
    this.surveyConference,
  );
  static GetAsyncModel create() {
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
      map['is_required'] == 1 ? true : false,
      convertToQuestionType(map['type']),
      map['survey_id'],
    );
  }
}

/////////AnswerForQuestion
class AnswerModel {
  int id;
  int? questionId;
  String title;
  String? imgName;
  XFile? img;
  AnswerModel(this.id, this.title, this.imgName, {this.questionId, this.img});
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'question_id': questionId};
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'img': imgName};
  }

  String toMapString() {
    return title;
  }

  factory AnswerModel.fromMap(Map<String, dynamic> map) {
    return AnswerModel(
      map['id'],
      map['title'],
      map['img'],
      questionId: map['question_id'],
    );
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
      map['conference_id'],
    );
  }
}

class UserSqlModel {
  String fullName; // الاسم الكامل
  String email; // البريد الإلكتروني
  String phone; // رقم الهاتف
  String address; // العنوان
  List<AnswerUserModel> answerModel;
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
  Map<String, dynamic> toJsonSql() {
    return {
      'fullname': fullName,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }
  // دالة لتحويل خريطة إلى كائن UserSqlModel
  factory UserSqlModel.fromMap(Map<String, dynamic> map) {
    return UserSqlModel(
      fullName: map['fullname'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      // تحويل الإجابات من الخريطة إلى قائمة من AnswerUserModel
      answerModel: _mapAnswers(map['answer_id'], map['content']),
    );
  }

  // دالة لتحويل الإجابات من الخريطة إلى قائمة من AnswerUserModel
  static List<AnswerUserModel> _mapAnswers(int answerId, String content) {
    // إذا كان يوجد إجابة مرتبطة بالمستخدم، نقوم بإنشاء كائن من AnswerUserModel
    return [AnswerUserModel(answerId, content)];
  }
}

//
class AllUserModel {
  List<UserSqlModel> users; // قائمة من المستخدمين (UserModel)
  int conference_id;
  AllUserModel(
    this.users,
    this.conference_id,
  ); // المُنشئ الذي يأخذ قائمة المستخدمين

  Map<String, dynamic> toJson() {
    return {
      "conference_id": conference_id,
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
      map['conference_id'],
    );
  }
}

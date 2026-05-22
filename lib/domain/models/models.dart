import 'package:formify/domain/models/model_q.dart';
import 'package:formify/domain/models/user_type.dart';
import 'package:image_picker/image_picker.dart';

class SurveyModel {
  int? id;
  String title;
  String description;
  String color;
  String? timer;

  List<QuestionModel> questions;

  SurveyModel({
    this.id,
    required this.title,
    required this.description,
    required this.color,
    required this.questions,
    required this.timer,
  });

  /// إنشاء Survey فارغ مع قائمة أسئلة جاهزة
  static SurveyModel create() {
    return SurveyModel(
      title: "",
      description: "",
      color: "",
      timer: "00:10",
      questions: [],
    );
  }
}

class SurveyUserModel {
  SurveyModel surveyModel;
  Map<int, List<AnswerUserSurveyModel>> answerUser;
  SurveyUserModel({required this.surveyModel, required this.answerUser});
}

class AnswerUserSurveyModel {
  int id;
  int answer_id;
  String content;
  int isCorrect;
  AnswerUserSurveyModel(this.id, this.answer_id, this.content, this.isCorrect);
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
              {"title": type.answer, "img": "", 'isCorrect': false},
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
  String? timer;

  MainSurveyModel(
    this.id,
    this.title,
    this.description,
    this.color,
    this.timer,
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'color': color,
      'timer': timer,
    };
  }

  factory MainSurveyModel.fromMap(Map<String, dynamic> map) {
    return MainSurveyModel(
      map['id'],
      map['title'],
      map['description'],
      map['color'],
      map['timer'],
    );
  }
}

class IsActiveMainSurveyModel {
  int id;
  String title;
  String description;
  String color;
  bool isActive;
  String? timer;
  IsActiveMainSurveyModel(
    this.id,
    this.title,
    this.description,
    this.color,
    this.isActive,
    this.timer,
  );
}

class ConferenceModel {
  String name;
  String description;
  String address;
  String startDate;
  String endDate;
  int isActive;
  List<int>? specification_ids;
  ConferenceModel(
    this.name,
    this.description,
    this.address,
    this.startDate,
    this.endDate,
    this.isActive,
      { this.specification_ids}
  );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'address': address,
      'start_date': startDate,
      'end_date': endDate,
      'is_active': isActive,
      'specification_ids':specification_ids
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
        specification_ids: map['specification_ids']
    );
  }
}

//////////////////////////////// for user
class AnswerUserModel {
  int? answer_id;
  String content;
  int isCorrect;

  AnswerUserModel(this.answer_id, this.content, this.isCorrect);

  Map<String, dynamic> toJson() {
    return {'answer_id': answer_id, 'content': content, 'isCorrect': isCorrect};
  }

  Map<String, dynamic> toJsonSql(int userId) {
    return {
      'user_id': userId,
      'answer_id': answer_id,
      'content': content,
      'isCorrect': isCorrect,
    };
  }

  factory AnswerUserModel.fromMap(Map<String, dynamic> map) {
    return AnswerUserModel(map['answer_id'], map['content'], map['isCorrect']);
  }
}
class DoctorMockItem {
  final int id;
  final String name;
   int isDone;

   DoctorMockItem({
    required this.id,
    required this.name,
    this.isDone = 0,
  });
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
  String? email;
  String phone;
  String? address;
  UserType userType;
  int conferenceId;
  UserInputModel(
    this.fullName,
    this.email,
    this.phone,
    this.address,
    this.userType,
    this.conferenceId,
  );
}

class UserModel {
  int? id;
  String fullName;
  String? email;
  String phone;
  String? address;
  String? notes;
  UserType userType;

  // جعل القيمة غير قابلة لـ null لضمان استقرار التطبيق
  int isUpload;
  int? userId;
  SpecModel? spec;

  UserModel(

      this.fullName,
      this.email,
      this.phone,
      this.address,
      this.userType,
      this.notes,
      { this.id,
        this.userId,
        this.isUpload = 0,
      this.spec} // القيمة الافتراضية 0
      );

  // وظيفة لإنشاء نسخة معدلة من الكائن
  UserModel copyWith({
    int? id,
    String? fullName,
    String? email,
    String? phone,
    String? address,
    String? notes,
    UserType? userType,
    int? isUpload,
    int? userId,
    SpecModel ? spec

  }) {
    return UserModel(

      fullName ?? this.fullName,
      email ?? this.email,
      phone ?? this.phone,
      address ?? this.address,
      userType ?? this.userType,
      notes ?? this.notes,
      isUpload: isUpload ?? this.isUpload,
      id:   id ?? this.id,
      userId: userId??this.userId,
        spec:spec?? this.spec
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullname': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'type_id': userType.id,
      'notes': notes,
      'isUpload': isUpload,
      'user_id':userId,
      'specId':spec?.id

    };
  }
  Map<String, dynamic> toJsonSql() {
    return {
      'id':id,
      'fullname': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'type_id': userType.id,
      'notes': notes,
    };
  }
  factory UserModel.fromMapSql(Map<String, dynamic> map) {
    return UserModel(
        id:  map['id'],
        map['fullname'],
        map['email'],
        map['phone'],
        map['address'],
        userTypeFromId(map['type_id']),
        map['notes'],
    spec: map['spec'],
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
    id:  map['id'],
      map['fullname'],
      map['email'],
      map['phone'],
      map['address'],
      userTypeFromId(map['type_id']),
      map['notes'],
      // التأكد من عدم وجود قيمة null عند القراءة
      isUpload: map['isUpload'] ?? 0,
        userId:map['userId'],
      spec: map['spec'],
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
  List<SpecModel> spec; // قائمة الاختصاصات المضافة للمؤتمر

  GetAllConferenceModel(
      this.id,
      this.name,
      this.description,
      this.address,
      this.startDate,
      this.endDate,
      this.isActive,
      this.spec,
      );

  // تحويل الكائن إلى Map لإرساله للسيرفر أو لحفظه في قاعدة البيانات
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'start_date': startDate,
      'end_date': endDate,
      'is_active': isActive ? 1 : 0,
      // تحويل كل كائن اختصاص داخل القائمة إلى Map أيضاً
     // 'spec': spec.map((e) => e.toJson()).toList(),
    };
  }

  // بناء الكائن من الـ Map القادم من الـ API أو الـ SQLite
  factory GetAllConferenceModel.fromMap(Map<String, dynamic> map) {
    return GetAllConferenceModel(
      map['id'] ?? 0,
      map['name'] ?? "",
      map['description'] ?? "",
      map['address'] ?? "",
      map['start_date'] ?? "",
      map['end_date'] ?? "",
      map['is_active'] == 1, // سيُعيد true إذا كان 1، وغير ذلك سيعيد false
      // معالجة القائمة بشكل آمن وفحص الـ null
      map['spec'] != null
          ? List<SpecModel>.from(
        (map['spec'] as List).map((specMap) => SpecModel.fromMap(specMap)),
      )
          : [], // إذا كانت القائمة فارغة أو نل، نضع قائمة فارغة افتراضية
    );
  }

  // دالة لإنشاء كائن فارغ افتراضي (تُستخدم غالباً في التهيئة بالـ Bloc)
  static GetAllConferenceModel create() {
    return GetAllConferenceModel(0, "", "", "", "", "", false, []);
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
  List<SpecModel> spec;
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
      this.spec
  );
}

class SurveyToConferenceModel {
  int id;
  String title;
  String description;
  String color;
  String? timer;

  int survey_order;

  SurveyToConferenceModel(
    this.id,
    this.title,
    this.description,
    this.color,
    this.timer,
    this.survey_order,
  );
}
class SpecModel{
  int id;
  String title;
  SpecModel(this.id,this.title);
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
  factory SpecModel.fromMap(Map<String, dynamic> map) {
    return SpecModel(
         map['id'],
        map['title'],

    );
  }
}
class GetAsyncModel {
  GetAllConferenceModel conferenceModel;
  List<MainSurveyModel> surveys;
  List<AsyncQuestionModel> questions;
  List<AnswerModel> answers;
  List<SurveyConferenceAsyncModel> surveyConference;
  List<UserModel> users;
  List<SpecModel> spec;

  GetAsyncModel(
    this.conferenceModel,
    this.surveys,
    this.questions,
    this.answers,
    this.surveyConference,
      this.users,
      this.spec
  );
  static GetAsyncModel create() {
    return GetAsyncModel(GetAllConferenceModel.create(), [], [], [], [],[],[]);
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
  int isCorrect;
  AnswerModel(
    this.id,
    this.title, {
    this.questionId,
    this.img,
    this.imgName,
    this.isCorrect = 0,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'question_id': questionId,
      'img': imgName,
      'isCorrect': isCorrect,
    };
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'img': imgName, 'isCorrect': isCorrect};
  }

  String toMapString() {
    return title;
  }

  factory AnswerModel.fromMap(Map<String, dynamic> map) {
    return AnswerModel(
      map['id'],
      map['title'],
      imgName: map['img'],
      questionId: map['question_id'],
      isCorrect: map['isCorrect'],
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
  String fullName;
  String? email;
  String phone;
  String? address;
  String? notes;
  UserType userType;
  List<AnswerUserModel> answerModel;
  int isUpload; // قيمة صحيحة ثابتة
  int? userId;
  UserSqlModel({
    required this.fullName,
    this.userId,
    this.email,
    required this.phone,
    this.address,
    this.notes,
    required this.userType,
    required this.answerModel,
    this.isUpload = 0, // القيمة المبدأية 0
  });

  Map<String, dynamic> toJson() {
    return {
      'fullname': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'notes': notes,
      'type_id': userType.id,
      'answers': answerModel.map((user) => user.toJson()).toList(),
      'isUpload': isUpload,
      'user_id':userId ?? -1
    };
  }

  Map<String, dynamic> toJsonSql() {
    return {
      'fullname': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'notes': notes,
      'type_id': userType.id,
      'isUpload': isUpload,
      'user_id':userId
    };
  }

  factory UserSqlModel.fromMap(Map<String, dynamic> map) {
    return UserSqlModel(
      fullName: map['fullname'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      notes: map['notes'],
      userType: userTypeFromId(map['type_id']),
      isUpload: map['isUpload'] ?? 0,
      answerModel: _mapAnswers(
        map['answer_id'],
        map['content'],
        map['isCorrect'],
      ),
    );
  }

  static List<AnswerUserModel> _mapAnswers(
      int answerId,
      String content,
      int isCorrect,
      ) {
    return [AnswerUserModel(answerId, content, isCorrect)];
  }
}//
class AllUserModel {
  List<UserSqlModel> users; // قائمة من المستخدمين (UserModel)
  int conference_id;
  int is_active;
  AllUserModel(
    this.users,
    this.conference_id,
    this.is_active,
  ); // المُنشئ الذي يأخذ قائمة المستخدمين

  Map<String, dynamic> toJson() {
    return {
      "conference_id": conference_id,
      "is_active": is_active,
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
      map['is_active'],
    );
  }
}

class InfoConference {
  int totalUser;
  int totalSurvey;
  int totalCompletedSurvey;

  InfoConference(this.totalUser, this.totalSurvey, this.totalCompletedSurvey);
}

class SurveyQuestionModel {
  int id;
  String question;
  String type;
  SurveyQuestionModel(this.id, this.question, this.type);
}

///////UserModel
class UserAnswerForStatModel {
  int questionId;
  String question;
  String content;
  UserAnswerForStatModel(this.questionId, this.question, this.content);
}

class UserAndAnswersModel {
  UserModel userModel;
  List<UserAnswerForStatModel> userAnswerForStatModel;

  UserAndAnswersModel(this.userModel, this.userAnswerForStatModel);
}

class ExelModel {
  List<SurveyQuestionModel> surveyQuestionModel;
  List<UserAndAnswersModel> userAndAnswersModel;

  ExelModel(this.surveyQuestionModel, this.userAndAnswersModel);
}

//////////////////////Stat
class UserAnswerStatModel {
  int userAnswerId;
  String content;
  String fullName;
  UserAnswerStatModel(this.userAnswerId, this.content, this.fullName);
}

class StatisticStatModel {
  int answerId;
  String title;
  int count;
  int total;

  StatisticStatModel(this.answerId, this.title, this.count, this.total);
}

class CountModel {
  int typeId;
  String typeName;
  int count;

  CountModel(this.typeId, this.typeName, this.count);
}

class QuestionsStatisticsModel {
  QuestionForStatModel question;
  List<UserAnswerStatModel> userAnswers;
  List<StatisticStatModel> statistics;
  String? desc;
  QuestionsStatisticsModel(this.question, this.userAnswers, this.statistics);
  bool get hasTextAnswers => userAnswers.isNotEmpty;
}
class StatisticsModel{
  List<QuestionsStatisticsModel> questions;
  List<CountModel>counts;

  StatisticsModel(this.questions, this.counts);
}
class QuestionForStatModel {
  int? id;
  String title;
  int order;
  int isRequired;
  QuestionType type;
  int survey_id;
  int groupType;
  String ?descAi;
  QuestionForStatModel(
    this.id,
    this.title,
    this.order,
    this.isRequired,
    this.type,
    this.survey_id,
    this.groupType,
      { this.descAi}
  );
}

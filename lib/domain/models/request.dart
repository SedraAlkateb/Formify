import 'package:formify/domain/models/models.dart';

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
  bool is_active;
  SurveyConference(this.survey_id, this.conference_id, this.survey_order,this.is_active);
}
class UserRequest {
  String fullName; // الاسم الكامل
  String email; // البريد الإلكتروني
  String phone; // رقم الهاتف
  String address; // العنوان
  List<AnswerModel> answers; // قائمة الإجابات المرتبطة بالمستخدم

  // مُنشئ لتخزين البيانات
  UserRequest(
      this.fullName,
      this.email,
      this.phone,
      this.address,
      this.answers,
      );
  Map<String, dynamic> toJson() {
    return {
      'fullname': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'answers': answers
          .map((answer) => answer.toJson())
          .toList(), // تحويل قائمة الإجابات
    };
  }

  // تحويل البيانات من قاعدة البيانات إلى كائن من UserModel
  factory UserRequest.fromMap(Map<String, dynamic> map) {
    return UserRequest(
      map['fullname'],
      map['email'],
      map['phone'],
      map['address'],
       List<AnswerModel>.from(
        map['users_answers'].map((answer) => AnswerModel.fromMap(answer)),
      ), // تحويل الإجابات المرتبطة
    );
  }
}

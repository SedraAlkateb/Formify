import 'package:flutter/material.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';

enum QuestionType {
  text,
  email,
  password,
  phone,
  number,

  // Selection
  dropdown,
  multipleChoice,
  checkbox,
  autocomplete,

  // Date & Time
  date,
  time,
  dateTime ,

  // Boolean
  switchField,

  // Range
  slider,
  rating,
  generic,
}

extension QuestionTypeX on QuestionType {
  // ✅ Arabic titles only
  String get title {
    switch (this) {
      case QuestionType.text:
        return "نص";
      case QuestionType.email:
        return "بريد إلكتروني";
      case QuestionType.password:
        return "كلمة مرور";
      case QuestionType.phone:
        return "رقم هاتف";
      case QuestionType.number:
        return "رقم";

      case QuestionType.dropdown:
        return "قائمة منسدلة";
      case QuestionType.multipleChoice:
        return "اختيار واحد";
      case QuestionType.checkbox:
        return "اختيارات متعددة";
      case QuestionType.autocomplete:
        return "إكمال تلقائي";

      case QuestionType.date:
        return "تاريخ";
      case QuestionType.time:
        return "وقت";
      case QuestionType.dateTime:
        return "تاريخ ووقت";

      case QuestionType.switchField:
        return "مفتاح تشغيل";

      case QuestionType.slider:
        return "منزلق";
      case QuestionType.rating:
        return "تقييم";
      case QuestionType.generic:
        return "حقل عام";
    }
  }

  IconData get icon {
    switch (this) {
      case QuestionType.text:
        return Icons.text_fields;
      case QuestionType.email:
        return Icons.email_outlined;
      case QuestionType.password:
        return Icons.lock_outline;
      case QuestionType.phone:
        return Icons.phone_outlined;
      case QuestionType.number:
        return Icons.numbers;

      case QuestionType.dropdown:
        return Icons.arrow_drop_down_circle_outlined;
      case QuestionType.multipleChoice:
        return Icons.radio_button_checked;
      case QuestionType.checkbox:
        return Icons.check_box_outlined;
      case QuestionType.autocomplete:
        return Icons.auto_awesome;

      case QuestionType.date:
        return Icons.calendar_today;
      case QuestionType.time:
        return Icons.access_time;
      case QuestionType.dateTime:
        return Icons.event;

      case QuestionType.switchField:
        return Icons.toggle_on_outlined;

      case QuestionType.slider:
        return Icons.linear_scale;
      case QuestionType.rating:
        return Icons.star_border;
      case QuestionType.generic:
        return Icons.extension;
    }
  }

  // ✅ Keep same API, but return Arabic chip
  Widget get typeAnswerArabic {
    switch (this) {
      case QuestionType.text:
        return _typeChip(icon: Icons.text_fields, text: "نص");
      case QuestionType.email:
        return _typeChip(icon: Icons.email_outlined, text: "بريد إلكتروني");
      case QuestionType.password:
        return _typeChip(icon: Icons.lock_outline, text: "كلمة مرور");
      case QuestionType.phone:
        return _typeChip(icon: Icons.phone_outlined, text: "رقم هاتف");
      case QuestionType.number:
        return _typeChip(icon: Icons.numbers, text: "رقم");
      case QuestionType.dropdown:
        return _typeChip(
          icon: Icons.arrow_drop_down_circle_outlined,
          text: "قائمة منسدلة",
        );
      case QuestionType.multipleChoice:
        return _typeChip(icon: Icons.radio_button_checked, text: "اختيار واحد");
      case QuestionType.checkbox:
        return _typeChip(icon: Icons.check_box_outlined, text: "اختيارات متعددة");
      case QuestionType.autocomplete:
        return _typeChip(icon: Icons.auto_awesome, text: "إكمال تلقائي");
      case QuestionType.date:
        return _typeChip(icon: Icons.calendar_today, text: "تاريخ");
      case QuestionType.time:
        return _typeChip(icon: Icons.access_time, text: "وقت");
      case QuestionType.dateTime:
        return _typeChip(icon: Icons.event, text: "تاريخ ووقت");
      case QuestionType.switchField:
        return _typeChip(icon: Icons.toggle_on_outlined, text: "مفتاح تشغيل");
      case QuestionType.slider:
        return _typeChip(icon: Icons.linear_scale, text: "منزلق");
      case QuestionType.rating:
        return _typeChip(icon: Icons.star_border, text: "تقييم");
      case QuestionType.generic:
        return _typeChip(icon: Icons.extension, text: "حقل عام");
    }
  }

  // ✅ Keep the getter, but make it Arabic too (so "Arabic only")
  Widget get typeAnswerEnglish {
    return _typeChip(icon: icon, text: title);
  }

  // ✅ Arabic placeholders only
  String get answer {
    switch (this) {
      case QuestionType.text:
        return "أدخل النص...";
      case QuestionType.email:
        return "example@gmail.com";
      case QuestionType.password:
        return "أدخل كلمة المرور...";
      case QuestionType.phone:
        return "أدخل رقم الهاتف...";
      case QuestionType.number:
        return "أدخل الرقم...";

      case QuestionType.dropdown:
        return "اختر من القائمة";
      case QuestionType.multipleChoice:
        return "اختر إجابة واحدة";
      case QuestionType.checkbox:
        return "اختر إجابة أو أكثر";
      case QuestionType.autocomplete:
        return "ابدأ بالكتابة للاقتراحات";

      case QuestionType.date:
        return "اختر التاريخ";
      case QuestionType.time:
        return "اختر الوقت";
      case QuestionType.dateTime:
        return "اختر التاريخ والوقت";

      case QuestionType.switchField:
        return "تشغيل / إيقاف";

      case QuestionType.slider:
        return "اختر قيمة";
      case QuestionType.rating:
        return "اختر التقييم";
      case QuestionType.generic:
        return "أدخل القيمة";
    }
  }

  String get route {
    switch (this) {
      case QuestionType.text:
        return Routes.textQuestion;
      case QuestionType.dropdown:
        return Routes.multiAnswer;
      case QuestionType.multipleChoice:
        return Routes.multiAnswer;
      case QuestionType.checkbox:
        return Routes.multiAnswer;
      case QuestionType.switchField:
        return Routes.textQuestion;
      case QuestionType.autocomplete:
        return Routes.multiAnswer;
      case QuestionType.date:
        return Routes.textQuestion;
      case QuestionType.time:
        return Routes.textQuestion;
      case QuestionType.dateTime:
        return Routes.textQuestion;
      case QuestionType.slider:
        return Routes.textQuestion;
      default:
        return Routes.textQuestion;
    }
  }

  Object? buildInitialValue({
    required QuestionModel question,
    required List<AnswerUserModel>? savedAnswers,
  }) {
    if (savedAnswers == null || savedAnswers.isEmpty) return null;

    if (question.type
    case QuestionType.text ||
    QuestionType.email ||
    QuestionType.phone ||
    QuestionType.password ||
    QuestionType.number ||
    QuestionType.autocomplete) {
      return savedAnswers.first.content;
    } else if (question.type case QuestionType.dropdown || QuestionType.multipleChoice) {
      final id = savedAnswers.first.answer_id;
      return question.answers.firstWhere((a) => a.id == id);
    } else if (question.type case QuestionType.checkbox) {
      final ids = savedAnswers
          .map((e) => AnswerModel(e.answer_id ?? 0, e.content))
          .toSet();
      return question.answers.where((a) => ids.contains(a.id)).toList();
    } else if (question.type case QuestionType.switchField) {
      return savedAnswers.first.content == "1" ? true : false;
    } else if (question.type case QuestionType.slider || QuestionType.rating) {
      return double.tryParse(savedAnswers.first.content);
    } else if (question.type case QuestionType.date || QuestionType.time || QuestionType.dateTime) {
      return DateTime.tryParse(savedAnswers.first.content);
    } else if (question.type case QuestionType.generic) {
      return null;
    }
    return null;
  }
}

Widget _typeChip({required IconData icon, required String text}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 8),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: ColorManager.darkTextSecondary,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: ColorManager.black),
        const SizedBox(width: 6),
        Text(text),
      ],
    ),
  );
}

final List<QuestionType> questionTypes = QuestionType.values;

QuestionType convertToQuestionType(String value) {
  return QuestionType.values.firstWhere(
        (e) => e.toString().split('.').last == value,
    orElse: () => QuestionType.text,
  );
}
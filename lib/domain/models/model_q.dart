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
  // searchableList,
  multipleChoice,
  checkbox,
  //chips,
  autocomplete,

  // Date & Time
  date,
  time,
  dateTime,

  // Boolean
  switchField,

  // Range
  slider,
  rating,
  generic,
}

extension QuestionTypeX on QuestionType {
  String get title {
    switch (this) {
      case QuestionType.text:
        return "Text";
      case QuestionType.email:
        return "Email";
      case QuestionType.password:
        return "Password";
      case QuestionType.phone:
        return "Phone Number";
      case QuestionType.number:
        return "Number";

      case QuestionType.dropdown:
        return "Drop Down";
      // case QuestionType.searchableList:
      //   return "Searchable List";
      case QuestionType.multipleChoice:
        return "Multiple Choice";
      case QuestionType.checkbox:
        return "Checkbox";
      // case QuestionType.chips:
      //   return "Choice Chips";
      case QuestionType.autocomplete:
        return "Autocomplete";

      case QuestionType.date:
        return "Date";
      case QuestionType.time:
        return "Time";
      case QuestionType.dateTime:
        return "Date & Time";

      case QuestionType.switchField:
        return "Switch";

      case QuestionType.slider:
        return "Slider";
      case QuestionType.rating:
        return "Rating";
      case QuestionType.generic:
        return "Generic Field";
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
      // case QuestionType.searchableList:
      //   return Icons.search;
      case QuestionType.multipleChoice:
        return Icons.radio_button_checked;
      case QuestionType.checkbox:
        return Icons.check_box_outlined;
      // case QuestionType.chips:
      //   return Icons.label_outline;
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

  Widget get typeAnswerArabic {
    switch (this) {
      case QuestionType.text:
        return _typeChip(icon: Icons.text_fields, text: "نص");

      case QuestionType.email:
        return _typeChip(icon: Icons.email_outlined, text: "إيميل");

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
        return _typeChip(
          icon: Icons.check_box_outlined,
          text: "اختيارات متعددة",
        );

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
  Widget get typeAnswerEnglish {
    switch (this) {
      case QuestionType.text:
        return _typeChip(icon: Icons.text_fields, text: title);

      case QuestionType.email:
        return _typeChip(icon: Icons.email_outlined, text: title);

      case QuestionType.password:
        return _typeChip(icon: Icons.lock_outline, text: title);

      case QuestionType.phone:
        return _typeChip(icon: Icons.phone_outlined, text: title);

      case QuestionType.number:
        return _typeChip(icon: Icons.numbers, text: title);

      case QuestionType.dropdown:
        return _typeChip(
          icon: Icons.arrow_drop_down_circle_outlined,
          text: title,
        );

      case QuestionType.multipleChoice:
        return _typeChip(icon: Icons.radio_button_checked, text: title);

      case QuestionType.checkbox:
        return _typeChip(
          icon: Icons.check_box_outlined,
          text:title,
        );

      case QuestionType.autocomplete:
        return _typeChip(icon: Icons.auto_awesome, text: title);

      case QuestionType.date:
        return _typeChip(icon: Icons.calendar_today, text: title);

      case QuestionType.time:
        return _typeChip(icon: Icons.access_time, text: title);

      case QuestionType.dateTime:
        return _typeChip(icon: Icons.event, text: title);

      case QuestionType.switchField:
        return _typeChip(icon: Icons.toggle_on_outlined, text: title);

      case QuestionType.slider:
        return _typeChip(icon: Icons.linear_scale, text: title);

      case QuestionType.rating:
        return _typeChip(icon: Icons.star_border, text: title);

      case QuestionType.generic:
        return _typeChip(icon: Icons.extension, text: title);
    }
  }

  String get answer {
    switch (this) {
      case QuestionType.text:
        return "ادخل النص التالي";
      case QuestionType.email:
        return "example@gmail.com";
      case QuestionType.password:
        return "Password";
      case QuestionType.phone:
        return "Phone Number";
      case QuestionType.number:
        return "0xxxxxxxx";

      case QuestionType.dropdown:
        return "Drop Down";
      // case QuestionType.searchableList:
      //   return "Searchable List";
      case QuestionType.multipleChoice:
        return "Multiple Choice";
      case QuestionType.checkbox:
        return "Checkbox";
      // case QuestionType.chips:
      //   return "Choice Chips";
      case QuestionType.autocomplete:
        return "Autocomplete";

      case QuestionType.date:
        return "Date";
      case QuestionType.time:
        return "Time";
      case QuestionType.dateTime:
        return "Date & Time";

      case QuestionType.switchField:
        return "Switch";

      case QuestionType.slider:
        return "Slider";
      case QuestionType.rating:
        return "Rating";
      case QuestionType.generic:
        return "Generic Field";
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
      // case QuestionType.searchableList:
      //   return Routes.multiAnswer;
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
    } else if (question.type
    case QuestionType.dropdown || QuestionType.multipleChoice) {
      final id = savedAnswers.first.answer_id;
      return question.answers.firstWhere((a) => a.id == id);
    } else if (question.type case QuestionType.checkbox) {
      final ids = savedAnswers.map((e) => e.answer_id).toSet();
      return question.answers.where((a) => ids.contains(a.id)).toList();
    } else if (question.type case QuestionType.switchField) {
      return savedAnswers.first.content == "1" ?true:false;
    } else if (question.type case QuestionType.slider || QuestionType.rating) {
      return double.tryParse(savedAnswers.first.content);
    } else if (question.type
    case QuestionType.date || QuestionType.time || QuestionType.dateTime) {
      return DateTime.tryParse(savedAnswers.first.content);
    } else if (question.type case QuestionType.generic) {
      return null;
    }
    return null;
  }

}


Widget _typeChip({required IconData icon, required String text}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 8),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: ColorManager.darkTextSecondary,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [Icon(icon, size: 20,color: ColorManager.black,), const SizedBox(width: 6), Text(text,style: TextStyle(),)],
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

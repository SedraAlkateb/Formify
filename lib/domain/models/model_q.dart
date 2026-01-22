import 'package:flutter/material.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
//
// enum QuestionTyspe {
//   text,
//   dropdown,
//   multipleChoice,
//   checkbox,
//   switchField,
//   dateTime,
//   slider,
//   fileUpload,
//   signature,
//   colorPicker,
//  // searchableList,
//   stepperNumber,
//   multiPageStepper,
//   generic,
// }
enum QuestionType {
  // Text
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
  chips,
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
      case QuestionType.chips:
        return "Choice Chips";
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
      case QuestionType.chips:
        return Icons.label_outline;
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


  /// route اختياري (null = Coming soon)
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

}
final List<QuestionType> questionTypes = QuestionType.values;
QuestionType convertToQuestionType(String value){
  return       QuestionType.values.firstWhere(
        (e) => e.toString().split('.').last == value,
    orElse: () => QuestionType.text,
  );
}

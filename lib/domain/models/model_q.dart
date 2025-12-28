import 'package:flutter/material.dart';
import 'package:formify/presentation/resources/routes_manager.dart';

enum QuestionTyspe {
  text,
  dropdown,
  multipleChoice,
  checkbox,
  switchField,
  dateTime,
  slider,
  rangeSlider,
  fileUpload,
  signature,
  colorPicker,
  searchableList,
  stepperNumber,
  multiPageStepper,
  generic,
}
enum QuestionType {
  // Text
  text,
  email,
  password,
  phone,
  number,

  // Selection
  dropdown,
  searchableList,
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
  rangeSlider,
  rating,
  stepperNumber,
  // Structure
  sectionHeader,
  htmlContent,
  hidden,
  multiPageStepper,
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
        return "Dropdown";
      case QuestionType.searchableList:
        return "Searchable List";
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
      case QuestionType.rangeSlider:
        return "Range Slider";
      case QuestionType.rating:
        return "Rating";
      case QuestionType.stepperNumber:
        return "Stepper Number";

      case QuestionType.sectionHeader:
        return "Section Header";
      case QuestionType.htmlContent:
        return "HTML Content";
      case QuestionType.hidden:
        return "Hidden Field";
      case QuestionType.multiPageStepper:
        return "Multi-Page Form";
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
      case QuestionType.searchableList:
        return Icons.search;
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
      case QuestionType.rangeSlider:
        return Icons.tune;
      case QuestionType.rating:
        return Icons.star_border;
      case QuestionType.stepperNumber:
        return Icons.exposure_plus_1;

      case QuestionType.sectionHeader:
        return Icons.view_headline;
      case QuestionType.htmlContent:
        return Icons.code;
      case QuestionType.hidden:
        return Icons.visibility_off;
      case QuestionType.multiPageStepper:
        return Icons.view_week;
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
        return Routes.dropDownQuestion;
      case QuestionType.multipleChoice:
        return Routes.multipleChoiceQuestion;
      case QuestionType.checkbox:
        return Routes.checkboxQuestion;
      case QuestionType.switchField:

        return Routes.switchQuestion;
      default:
        return Routes.textQuestion;
    }
  }

}
final List<QuestionType> questionTypes = QuestionType.values;

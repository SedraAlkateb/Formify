import 'package:flutter/material.dart';
import 'package:formify/presentation/resources/routes_manager.dart';

enum QuestionType {
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
extension QuestionTypeX on QuestionType {
  String get title {
    switch (this) {
      case QuestionType.text:
        return "Text";
      case QuestionType.dropdown:
        return "Dropdown";
      case QuestionType.multipleChoice:
        return "Multiple Choice";
      case QuestionType.checkbox:
        return "Checkbox";
      case QuestionType.switchField:
        return "Switch";
      case QuestionType.dateTime:
        return "Date & Time";
      case QuestionType.slider:
        return "Slider";
      case QuestionType.rangeSlider:
        return "Range Slider";
      case QuestionType.fileUpload:
        return "File Upload";
      case QuestionType.signature:
        return "Signature";
      case QuestionType.colorPicker:
        return "Color Picker";
      case QuestionType.searchableList:
        return "Searchable List";
      case QuestionType.stepperNumber:
        return "Stepper Number Field";
      case QuestionType.multiPageStepper:
        return "Multi-Page Form (Stepper)";
      case QuestionType.generic:
        return "Generic Field";
    }
  }

  IconData get icon {
    switch (this) {
      case QuestionType.text:
        return Icons.text_fields;
      case QuestionType.dropdown:
        return Icons.arrow_drop_down_circle;
      case QuestionType.multipleChoice:
        return Icons.check_circle_outline;
      case QuestionType.checkbox:
        return Icons.check_box_outlined;
      case QuestionType.switchField:
        return Icons.toggle_on_outlined;
      case QuestionType.dateTime:
        return Icons.date_range;
      case QuestionType.slider:
        return Icons.linear_scale;
      case QuestionType.rangeSlider:
        return Icons.track_changes_rounded;
      case QuestionType.fileUpload:
        return Icons.upload_file;
      case QuestionType.signature:
        return Icons.edit_document;
      case QuestionType.colorPicker:
        return Icons.color_lens_outlined;
      case QuestionType.searchableList:
        return Icons.search;
      case QuestionType.stepperNumber:
        return Icons.exposure_plus_1;
      case QuestionType.multiPageStepper:
        return Icons.view_week_rounded;
      case QuestionType.generic:
        return Icons.edit_note_rounded;
    }
  }

  /// route اختياري (null = Coming soon)
  String get route {
    switch (this) {
      case QuestionType.text:
        return Routes.textQuestion;
      case QuestionType.dropdown:
        return Routes.dropDownQuestion;
      default:
        return Routes.textQuestion;
    }
  }
}
final List<QuestionType> questionTypes = QuestionType.values;

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/model_q.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:formify/presentation/question/widgets/image_answer.dart';
import 'package:formify/presentation/resources/color_manager.dart';

class QuestionAnswerPreviewBuilder extends StatelessWidget {
  final QuestionModel question;
  final List<AnswerUserSurveyModel>? initValue;
  const QuestionAnswerPreviewBuilder({
    super.key,
    required this.question,
    this.initValue,
  });

  String get _name => "q_${question.order}";

  @override
  Widget build(BuildContext context) {
    switch (question.type) {
      case QuestionType.text:
        return FormBuilderTextField(
          initialValue: initValue != null ? initValue![0].content : null,
          name: _name,
          maxLines: 5,
          minLines: 1,
          enabled: false,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
          ),
        );

      case QuestionType.email:
        return FormBuilderTextField(
          initialValue: initValue != null ? initValue![0].content : null,
          name: _name,
          maxLines: 5,
          minLines: 1,

          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),

          enabled: false,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
          ),
        );

      case QuestionType.password:
        return FormBuilderTextField(
          initialValue: initValue != null ? initValue![0].content : null,
          name: _name,
          enabled: false,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),

          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
          ),
        );

      case QuestionType.phone:
        return FormBuilderTextField(
          name: _name,
          initialValue: initValue != null ? initValue![0].content : null,
          enabled: false,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),

          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
          ),
        );

      case QuestionType.number:
        return FormBuilderTextField(
          enabled: false,
          initialValue: initValue != null ? initValue![0].content : null,
          name: _name,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),

          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
          ),
        );

      case QuestionType.dropdown:
        AnswerModel? selectedAnswer = question.answers
            .where((a) => a.isCorrect == 1)
            .cast<AnswerModel?>()
            .firstOrNull;
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormBuilderTextField(
              name: _name,
              enabled: false,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),

              initialValue: initValue![0].content,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ),
            SizedBox(height: 10),
            initValue![0].isCorrect == 1
                ? Row(
                    children: [
                      Icon(Icons.check_circle, color: ColorManager.success),
                      SizedBox(width: 12),
                      Text(
                        "اجابتك صحيحة",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.block_outlined,
                            color: ColorManager.success,
                          ),
                          SizedBox(width: 12),
                          Text(
                            "اجابتك خاطئة الاجابة الصحيحة هي",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        initialValue: selectedAnswer!.title,
                        name: _name,
                        maxLines: 5,
                        minLines: 1,
                        enabled: false,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        );

      case QuestionType.multipleChoice:
        AnswerModel? selectedAnswer = question.answers
            .where((a) => a.isCorrect == 1)
            .cast<AnswerModel?>()
            .firstOrNull;
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormBuilderTextField(
              enabled: false,
              initialValue: initValue != null ? initValue![0].content : null,
              name: _name,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),

              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ),
            SizedBox(height: 10),
            initValue![0].isCorrect == 1
                ? Row(
                    children: [
                      Icon(Icons.check_circle, color: ColorManager.success),
                      SizedBox(width: 12),
                      Text(
                        "اجابتك صحيحة",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Icon(Icons.block_outlined, color: ColorManager.success),
                      SizedBox(width: 12),
                      Text(
                        "اجابتك خاطئة الاجابة الصحيحة هي",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
            SizedBox(height: 20),
            FormBuilderRadioGroup<AnswerModel>(
              initialValue: selectedAnswer,
              orientation: OptionsOrientation.vertical,
              name: "${_name}multi",
              enabled: false,
              options: question.answers
                  .map(
                    (a) => FormBuilderFieldOption(
                      value: a,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [imageAnswerNetwork(a), Text(a.title)],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      case QuestionType.checkbox:
        List<AnswerModel> selectedAnswer = question.answers
            .where((a) => a.isCorrect == 1)
            .toList();
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: initValue!.length,
              itemBuilder: (context, index) =>
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormBuilderTextField(
                        enabled: false,
                        initialValue: initValue != null ? initValue![index].content : null,
                        name: "${_name}${index}",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),

                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      initValue![index].isCorrect == 1
                          ? Row(
                        children: [
                          Icon(Icons.check_circle, color: ColorManager.success),
                          SizedBox(width: 12),
                          Text(
                            "اجابتك صحيحة",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                          : Row(
                        children: [
                          Icon(Icons.block_outlined, color: ColorManager.success),
                          SizedBox(width: 12),
                          Text(
                            "اجابتك خاطئة ",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
            ),
            Text(
              "الاجابات الصحيحة هي :",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            FormBuilderCheckboxGroup<AnswerModel>(
              name: _name,
              enabled: false,
              orientation: OptionsOrientation.vertical,
              initialValue: selectedAnswer,
              options: question.answers
                  .map(
                    (a) => FormBuilderFieldOption(
                      value: a,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [imageAnswerNetwork(a), Text("${a.title}")],
                      ),
                    ),
                  )
                  .toList(),

            ),

          ],
        );

      case QuestionType.autocomplete:
        return FormBuilderTextField(
          initialValue: initValue != null ? initValue![0].content : null,
          name: _name,
          maxLines: 5,
          minLines: 1,
          enabled: false,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
          decoration: InputDecoration(
            hintText: "Answer...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
          ),
        );

      case QuestionType.switchField:
        return FormBuilderSwitch(
          name: _name,
          enabled: false,

          initialValue: initValue != null
              ? (initValue?[0] == "0" ? false : true)
              : null,
          title: Text(
            question.title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
        );

      case QuestionType.date:
        return FormBuilderTextField(
          initialValue: initValue != null ? initValue![0].content : null,
          name: _name,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
          maxLines: 5,
          minLines: 1,
          enabled: false,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
          ),
        );

      case QuestionType.time:
        return FormBuilderTextField(
          initialValue: initValue != null ? initValue![0].content : null,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
          name: _name,
          maxLines: 5,
          minLines: 1,
          enabled: false,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
          ),
        );
      case QuestionType.dateTime:
        return FormBuilderTextField(
          initialValue: initValue != null ? initValue![0].content : null,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
          name: _name,
          maxLines: 5,
          minLines: 1,
          enabled: false,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
          ),
        );

      case QuestionType.slider:
        return FormBuilderSlider(
          name: _name,
          enabled: false,
          min: 0,
          max: 100,
          initialValue: double.parse(initValue?[0].content ?? "0"),
          divisions: 50,
        );

      case QuestionType.rating:
        return FormBuilderRatingBar(
          enabled: false,
          name: _name,
          initialValue: double.parse(initValue?[0].content ?? "0"),
          maxRating: 5,
          allowHalfRating: true,

          unratedColor: const Color(0xFFFFD54F),
          // const Color(0xFFFFC107), // أصفر ذهبي
          glow: true,
          glowColor: ColorManager.textHint,
          glowRadius: 2,
          itemSize: 36,
          ratingWidget: RatingWidget(
            full: Icon(
              Icons.star,
              size: 36,
              color: const Color(0xFFFAC115), // أصفر ذهبي
              shadows: [
                Shadow(
                  color: Color(0xFFFFC107).withOpacity(0.6),
                  blurRadius: 6,
                  offset: Offset(0, 1),
                ),
              ],
            ),

            half: Icon(
              Icons.star_half_outlined,
              size: 36,
              color: const Color(0xFFFFC107),
              shadows: [
                Shadow(
                  color: Color(0xFFFFC107).withOpacity(0.5),
                  blurRadius: 5,
                  offset: Offset(0, 1),
                ),
              ],
            ),

            empty: Icon(
              Icons.star_border_outlined,
              size: 36,
              color: const Color(0xFF837659),
            ),
          ),
          validator: question.isRequired == true
              ? (value) => (value == null || value == 0)
                    ? "This question is required"
                    : null
              : null,
        );

      case QuestionType.generic:
        return const SizedBox.shrink();
    }
  }
}

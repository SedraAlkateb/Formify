import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/question/page/view_Question.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';
import 'package:formify/presentation/sync/widget/answer_card_widget.dart';

class SurveyQuestion {
  final String title;
  final String hint;
  const SurveyQuestion({required this.title, required this.hint});
}

class SurveyInputPage extends StatefulWidget {
  const SurveyInputPage({super.key});

  @override
  State<SurveyInputPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyInputPage> {
  final _pageController = PageController();
  int _index = 0;
  late final TextEditingController answer = TextEditingController();
  @override
  void dispose() {
    _pageController.dispose();
    answer.dispose();
    super.dispose();
  }

   void goNext(int length) {
    if (_index < length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      _submit();
    }
  }

  void _goPrev() {
    if (_index > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  void _submit() {
    final data = <String, String>{};
    // for (int i = 0; i < _questions.length; i++) {
    //   data[_questions[i].title] = _answers[i].text.trim();
    // }
    // هنا ترسل البيانات للسيرفر أو تخزنها محلياً
    // debugPrint("SUBMIT: $data");
    // ScaffoldMessenger.of(
    //   context,
    // ).showSnackBar(const SnackBar(content: Text("تم إرسال الإجابات")));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F7FF),
        body: SafeArea(
          child: BlocBuilder<SyncBloc, SyncState>(
            builder: (context, state) {
              if (state is GetQuestionAnswersState) {
                List<QuestionModel> questionModel = state.questions;
                final total = questionModel.length;
                final progress = (total == 0) ? 0.0 : (_index + 1) / total;
                return Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          TextButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 16,
                            ),
                            label: const Text("العودة"),
                          ),
                          const Spacer(),
                          Text(
                            state.surveyName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(flex: 2),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 8,
                              backgroundColor: Colors.black.withOpacity(0.06),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "السؤال ${_index + 1} من $total",
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Pages
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        physics:
                            const NeverScrollableScrollPhysics(), // تنقل بالأزرار فقط
                        itemCount: total,
                        onPageChanged: (i) => setState(() => _index = i),
                        itemBuilder: (context, i) {
                          final q = questionModel[i];
                          if ((BlocProvider.of<SyncBloc>(
                                    context,
                                  ).userSqlModel !=
                                  null) &&
                              (BlocProvider.of<SyncBloc>(
                                context,
                              ).userSqlModel!.answerModel.isNotEmpty)) {
                            answer.text = BlocProvider.of<SyncBloc>(
                              context,
                            ).userSqlModel!.answerModel[i].content;
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            child:
                            QuestionCard(
                              number: i + 1,
                              total: total,
                              questionModel: q,
                              controller: answer,
                              isLast: i == total - 1,
                              onPrev: _goPrev,
                              onNext:()=> goNext(questionModel.length),
                            ),
                          );
                        },
                      ),
                    ),

                  ],
                );
              }
              return SizedBox();
            },
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/question/page/view_Question.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';
import 'package:formify/presentation/sync/widget/answer_card_widget.dart';


class SurveyInputPage extends StatefulWidget {
  const SurveyInputPage({super.key});

  @override
  State<SurveyInputPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyInputPage> {
  final _pageController = PageController();
  int _index = 0;
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void goNext(int length,int index) {
    BlocProvider.of<SyncBloc>(context).answer=BlocProvider.of<SyncBloc>(context).answers[index+1]??[];
    if (_index < length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );

    } else {
      _submit();
    }
    BlocProvider.of<SyncBloc>(context).addUserAnswer(index);
  }

  void goPrev(int index) {
    BlocProvider.of<SyncBloc>(context).answer=BlocProvider.of<SyncBloc>(context).answers[index+1]??[];

    if (_index > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
    BlocProvider.of<SyncBloc>(context).addUserAnswer( index);

  }

  void _submit() {
    BlocProvider.of<SyncBloc>(context).answers.forEach((key, value) {
      // إذا كان value هو قائمة من AnswerUserModel
      value.forEach((answer) {
        print("Key: $key, Answer ID: ${answer.answer_id}, Answer Title: ${answer.content}");
      });
    });


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

                          Expanded(
                            child: Text(
                              textAlign: TextAlign.end,
                              state.surveyName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 18,
                      ),
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
                          // if ((BlocProvider.of<SyncBloc>(
                          //           context,
                          //         ).userSqlModel !=
                          //         null) &&
                          //     (BlocProvider.of<SyncBloc>(
                          //       context,
                          //     ).userSqlModel!.answerModel.isNotEmpty)) {
                          //   answer.text = BlocProvider.of<SyncBloc>(
                          //     context,
                          //   ).userSqlModel!.answerModel[i].content;
                          // }

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            child: QuestionCard(
                              number: i + 1,
                              total: total,
                              questionModel: q,
                              isLast: i == total - 1,
                              onPrev:() =>  goPrev(i),
                              onNext: () => goNext(questionModel.length,i),
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

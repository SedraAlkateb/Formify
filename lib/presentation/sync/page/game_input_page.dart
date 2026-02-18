import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:formify/domain/models/model_q.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';
import 'package:formify/presentation/sync/widget/answer_card_widget.dart';
import 'package:formify/presentation/sync/widget/timer_widget.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';

class GameInputPage extends StatefulWidget {
  const GameInputPage({super.key});

  @override
  State<GameInputPage> createState() => _GameInputPageState();
}

class _GameInputPageState extends State<GameInputPage> {
  final _pageController = PageController();
  List<GlobalKey<FormBuilderState>> _formKeys = [];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _ensureKeys(int length) {
    if (_formKeys.length == length) return;
    _formKeys = List.generate(length, (_) => GlobalKey<FormBuilderState>());
  }

  dynamic _readRawValue(int index, SurveyReadyState s) {
    final formState = _formKeys[index].currentState;
    if (formState == null) return null;
    final q = s.questions[index];

    return formState.value["q_${q.order}"];
  }

  bool _saveAndValidate(int index) {
    final fs = _formKeys[index].currentState;
    if (fs == null) return true;
    return fs.saveAndValidate();
  }

  void _saveOnly(int index) {
    _formKeys[index].currentState?.save();
  }

  void _sendAnswerToBloc(int index, SurveyReadyState s) {
    final q = s.questions[index];
    final raw = _readRawValue(index, s);
    context.read<SyncBloc>().add(
      SurveySaveAnswerEvent(index: index, question: q, rawValue: raw),
    );
  }

  void _next(SurveyReadyState s, int index) {
    final ok = _saveAndValidate(index);
    if (!ok) return;

    _sendAnswerToBloc(index, s);

    final isLast = index == s.questions.length - 1;
    if (isLast) {
      //
      context.read<SyncBloc>().add(const SurveySubmitEvent());
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
    context.read<SyncBloc>().add(SurveyPageChangedEvent(index + 1));
  }

  void _prev(SurveyReadyState s, int index) {
    _saveOnly(index);
    _sendAnswerToBloc(index, s);

    if (index <= 0) return;

    _pageController.previousPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
    context.read<SyncBloc>().add(SurveyPageChangedEvent(index - 1));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F7FF),
        body: SafeArea(
          child: BlocConsumer<SyncBloc, SyncState>(
            listener: (context, state) {
              if (state is SurveySubmitSuccessState) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("تم إرسال الإجابات بنجاح")),
                );
              }
              if (state is SurveySubmitErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("فشل الإرسال: ${state.failure}")),
                );
              }
            },
            builder: (context, state) {
              if (state is SurveyLoadingState ||
                  state is SurveySubmittingState) {
                return loadingFullScreen(context);
              }
              if (state is SurveyErrorState) {
                return errorFullScreen(context);
              }

              if (state is SurveyReadyState) {

                final total = state.questions.length;
                _ensureKeys(total);
                final idx = state.currentIndex;
                final progress = total == 0 ? 0.0 : (idx + 1) / total;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 16,
                            ),
                            label: const Text("العودة"),
                          ),
                          (state.time != null) && (state.time!.isNotEmpty)
                              ? Expanded(
                                  child: CountdownTimerWidget(
                                    time: state.time ?? "00:00",
                                    onFinished: () {
                                      context.read<SyncBloc>().add(
                                        const SurveySubmitEvent(),
                                      );
                                    },
                                  ),
                                )
                              : SizedBox(),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Text(
                                state.surveyName,
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
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
                            "السؤال ${idx + 1} من $total",
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: total,
                        onPageChanged: (i) => context.read<SyncBloc>().add(
                          SurveyPageChangedEvent(i),
                        ),
                        itemBuilder: (context, i) {
                          final q = state.questions[i];
                          final initValue = q.type.buildInitialValue(
                            question: q,
                            savedAnswers: state.answers[i],
                          );
                          //   final savedAnswer = state.answers[i]?.first.content;

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            child: QuestionCard(
                             // correctValue: ,
                              number: i + 1,
                              total: total,
                              questionModel: q,
                              isLast: i == total - 1,
                              formKey: _formKeys[i],
                              initialValue:
                                  initValue, // passing saved answer as initial value
                              onPrev: () => _prev(state, i),
                              onNext: () => _next(state, i),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
